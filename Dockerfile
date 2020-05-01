#Kernel I need
#Linux hsl0013 3.10.0-957.27.2.el7.x86_64 #1 SMP CentOS Linux release 7.6.1810 (Core)
#Nvidia driver I need
#418.87.01 
#OFED driver I need
#4.6-1.0.1.1
FROM centos:centos7.6.1810
#FROM nvidia/cuda:10.2-base-centos7
LABEL maintainer=chad.smykay@hpe.com
# Runtime enviroment variables.
ARG BUILD_DATE
ARG BUILD_VERSION
#Labels
LABEL   org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.name="ess-hpecp-mofed-centos7.6-image:latest" \
        org.label-schema.description="Mellanox drive enabled docker image for a customer's installed packages" \
        org.label-schema.url="https:/github.hpe.com" \
        org.label-schema.vcs-url="https://github.hpe.com/chad-smykay/ess-hpecp-mofed-centos7.6-image" \
        org.label-schema.vendor="HPE" \
        org.label-schema.version=$BUILD_VERSION \
        org.label-schema.docker.cmd="docker run -v csmykay/ess-hpecp-mofed-centos7.6-image:latest -d ess-hpecp-mofed-centos7.6-image:latest"

#Install Nvidia Cuda Driver
#From https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/centos7/10.2/base/Dockerfile
RUN NVIDIA_GPGKEY_SUM=d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5 && \
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/7fa2af80.pub | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA && \
    echo "$NVIDIA_GPGKEY_SUM  /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict -

COPY cuda.repo /etc/yum.repos.d/cuda.repo

ENV CUDA_VERSION 10.2.89

ENV CUDA_PKG_VERSION 10-2-$CUDA_VERSION-1
# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN yum install -y \
cuda-cudart-$CUDA_PKG_VERSION \
cuda-compat-10-2 \
&& \
    ln -s cuda-10.2 /usr/local/cuda && \
    rm -rf /var/cache/yum/*

# nvidia-docker 1.0
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.2 brand=tesla,driver>=418,driver<419"

# Set MOFED version, OS version and platform
ENV MOFED_VERS=4.6-1.0.1.1
ENV OS_VER=rhel7.6
ENV PLATFORM=x86_64
#Here if you need a user to do work
#groupadd group &&
#useradd -g user -s /bin/bash user &&   
#echo -e "$5$VZ3KNRVQS3g$NPM9hwldIY5qL27oL3y/VVCwPjKeBFaxBiUeYE2pWi3\n$5$VZ3KNRVQS3g$NPM9hwldIY5qL27oL3y/VVCwPjKeBFaxBiUeYE2pWi3" | passwd user &&     
#Install MOFED package dependencies
RUN yum install -y perl numactl-libs gtk2 atk cairo gcc-gfortran tcsh libnl3 tcl tk python-devel pciutils make lsof redhat-rpm-config rpm-build libxml2-python ethtool iproute net-tools openssh-clients git openssh-server wget iperf3
#Set a working directory to download and intall the MOFED driver
WORKDIR /tmp/

#Example file MLNX_OFED_LINUX-4.6-1.0.1.1-rhel7.6-x86_64.tgz
#Example http://content.mellanox.com/ofed/MLNX_OFED-4.6-1.0.1.1/MLNX_OFED_LINUX-4.6-1.0.1.1-rhel7.6-x86_64.tgz      

RUN wget http://content.mellanox.com/ofed/MLNX_OFED-${MOFED_VERS}/MLNX_OFED_LINUX-${MOFED_VERS}-${OS_VER}-${PLATFORM}.tgz && \
        tar -xvf MLNX_OFED_LINUX-${MOFED_VERS}-${OS_VER}-${PLATFORM}.tgz && \
        /tmp/MLNX_OFED_LINUX-${MOFED_VERS}-${OS_VER}-${PLATFORM}/mlnxofedinstall --skip-distro-check --user-space-only --without-fw-update --all --force && \
        rm -rf MLNX_OFED_LINUX-${MOFED_VERS}-${OS_VER}-${PLATFORM}
#Copy files into place 
#COPY build.sh entrypoint.sh scripts/ $MAPR_CONTAINER_DIR/
#EXPOSE $MAPR_PORTS\
#ENTRYPOINT ["./entrypoint.sh"]
#CMD ["/opt/mapr/docker/start-mapr.sh"]
