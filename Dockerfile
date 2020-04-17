#Pull from latest centos 7
FROM centos:centos7.6.1810
LABEL maintainer=chad.smykay@hpe.com
# Runtime enviroment variables.
ARG BUILD_DATE
ARG BUILD_VERSION
#ARG MOFED_VERS=4.5-1.0.1.0
#ARG OS_VER=rhel7.6
#ARG PLATFORM=x86_64
#Labels
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="ess-hpecp-docker-inifiband-image/latest"
LABEL org.label-schema.description="Mellanox drive enabled docker image"
LABEL org.label-schema.url="https:/github.hpe.com"
LABEL org.label-schema.vcs-url="https://github.hpe.com/chad-smykay/ess-hpecp-docker-inifiband-image"
LABEL org.label-schema.vendor="HPE"
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run -v ess-hpecp-docker-inifiband-image/latest -d ess-hpecp-docker-inifiband-image/latest#"
# Set MOFED version, OS version and platform
ENV MOFED_VERS=4.5-1.0.1.0
ENV OS_VER=rhel7.6
ENV PLATFORM=x86_64
#Here if you need a user to do work
#groupadd group &&
#useradd -g user -s /bin/bash user &&
#echo -e "$5$VZ3KNRVQS3g$NPM9hwldIY5qL27oL3y/VVCwPjKeBFaxBiUeYE2pWi3\n$5$VZ3KNRVQS3g$NPM9hwldIY5qL27oL3y/VVCwPjKeBFaxBiUeYE2pWi3" | passwd user &&     
#Update yum repos
RUN yum update -y
#Install MOFED package dependencies
RUN yum install -y perl numactl-libs gtk2 atk cairo gcc-gfortran tcsh libnl3 tcl tk python-devel pciutils make lsof redhat-rpm-config rpm-build libxml2-python ethtool iproute net-tools openssh-clients git openssh-server wget iperf3
#Set a working directory to download and intall the MOFED driver
WORKDIR /tmp/

ENV MOFED_VER=5.0-2.1.8.0
ENV OS_VER=rhel7.6
ENV PLATFORM=x86_64

RUN wget http://content.mellanox.com/ofed/MLNX_OFED-${MOFED_VER}/MLNX_OFED_LINUX-${MOFED_VER}-${OS_VER}-${PLATFORM}.tgz && \
        tar -xvf MLNX_OFED_LINUX-${MOFED_VER}-${OS_VER}-${PLATFORM}.tgz && \
        MLNX_OFED_LINUX-${MOFED_VER}-${OS_VER}-${PLATFORM}/mlnxofedinstall  --skip-distro-check --user-space-only --without-fw-update --all --force

#Copy files into place 
#COPY build.sh entrypoint.sh scripts/ $MAPR_CONTAINER_DIR/
#COPY lib/ $MAPR_CONTAINER_DIR/lib
#RUN chmod +x *.sh

#WORKDIR $MAPR_CONTAINER_DIR

#Install mapr packages
#RUN ./build.sh

#EXPOSE $MAPR_PORTS

#ENTRYPOINT ["./entrypoint.sh"]

#CMD ["/opt/mapr/docker/start-mapr.sh"]
