#!/bin/bash
#https://docs.docker.com/engine/reference/commandline/build/
DATE=$(date +%Y-%m-%d_%H:%M:%S)
VERSION=2.0
#if [ -z $CURRENT ]; then
#	CURRENT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#fi
docker build --build-arg BUILD_DATE=$DATE --build-arg BUILD_VERSION=$VERSION --no-cache=true --rm -f Dockerfile -t ess-hpecp-mofed-centos7.6-image:1.0 .
docker tag ess-hpecp-mofed-centos7.6-image:$VERSION ess-hpecp-mofed-centos7.6-image:latest
docker tag ess-hpecp-mofed-centos7.6-image:latest csmykay/ess-hpecp-mofed-centos7.6-image:latest
docker login
docker push csmykay/ess-hpecp-mofed-centos7.6-image:latest