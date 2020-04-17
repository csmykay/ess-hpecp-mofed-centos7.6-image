#!/bin/bash
#https://docs.docker.com/engine/reference/commandline/build/
DATE=$(date +%Y-%m-%d_%H:%M:%S)
VERSION=1.0
if [ -z $CURRENT ]; then
	CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
fi
docker build --build-arg BUILD_DATE=$DATE --build-arg BUILD_VERSION=$VERSION --no-cache=true --rm -f Dockerfile -t ess-hpecp-mofed-centos7.6-image:1.0 .
docker tag ess-hpecp-mofed-centos7.6-image:$VERSION ess-hpecp-mofed-centos7.6-image:latest
ducker push ess-hpecp-mofed-centos7.6-image:latest