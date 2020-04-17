#!/bin/bash
#https://docs.docker.com/engine/reference/commandline/build/
if [ -z $CURRENT ]; then
	CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
fi

docker build --no-cache=true --rm -f "Dockerfile.centos7" -t mapr-core-centos7:6.0.1_5.0.1-1 mapr_core
docker tag mapr-core-centos7:6.0.1_5.0.1-1 registry.se.corp.maprtech.com:5000/mapr-core-centos7:6.0.1_5.0.1-1