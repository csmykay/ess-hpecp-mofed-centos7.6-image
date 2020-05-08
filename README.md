# ess-hpecp-mofed-centos7.6-image
A base docker image to support Mellanox Infiniband cards within the container.  Update for CentOS 7.6.
Future builds can then be used as a base off of this image.
See:
https://docs.mellanox.com/pages/releaseview.action?pageId=15049758
And:
https://docs.mellanox.com/pages/releaseview.action?pageId=15049758

This image currently does not have all of the custom customer packages due to thier custom updated onsite repository configuration.
We need to verify your network setup before we can recommend how to setup the docker images best for your TCP/IP network access.  In general Docker uses "Bridge" mode which would could work for the POC.

We will have to build the image onsite to point to their repo's.


1.  Setup and load your Linux server as your normally do in your enviroment
2.  Install docker for CentOS:  https://docs.docker.com/engine/install/centos/
3.  And the docker CUDA runtime:  https://github.com/NVIDIA/nvidia-container-runtime
4.  Install git: yum install git
5.  Clone the repo from public github.com:  git clone https://github.com/csmykay/ess-hpecp-mofed-customer-image.git
6.  cd ess-hpecp-mofed-customer-image
7.  bash build-images.sh
8.  Clone the repo from public github.com:  git clone https://github.com/csmykay/ess-hpecp-mofed-centos7.6-image.git
9.  cd ess-hpecp-mofed-centos7.6-image
10. bash build-images.sh
11.  Configure a docker volume for persistent storage to use in the POC containers:  https://docs.docker.com/storage/volumes/
    docker volume create poc-host1
    docker volume create poc-host2
12.  Start 2 containers, each with their own access to 4 GPU's each an 1 Mellanox card each

docker run -it --runtime=nvidia --mount source=poc-host1,target=/app --device=/dev/infiniband/uverbs0 -e NVIDIA_VISIBLE_DEVICES=0,1,2,3 -e NVIDIA_DRIVER_CAPABILITIES=compute,utility --rm csmykay/ess-hpecp-mofed-centos7.6-image:latest
docker run -it --runtime=nvidia --mount source=poc-host2,target=/app --device=/dev/infiniband/uverbs1 -e NVIDIA_VISIBLE_DEVICES=4,5,6,7 -e NVIDIA_DRIVER_CAPABILITIES=compute,utility --rm csmykay/ess-hpecp-mofed-centos7.6-image:latest

If you want to change your mount path then change the directory /app to something else (e.g. --mount source=poc-host1,target=/app to --mount source=poc-host1,target=/target)
