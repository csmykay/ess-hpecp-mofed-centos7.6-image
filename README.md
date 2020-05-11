# ess-hpecp-mofed-centos7.6-image

# Please note this docker image requires you to have a base host OS of CentOS to build.
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
11.  Configure a docker volume for persistent storage to use in the POC containers:  https://docs.docker.com/storage/volumes
  11a. docker volume create poc-host1
  11b. docker volume create poc-host2
12.  Start 2 containers, each with their own access to 4 GPU's each an 1 Mellanox card each

docker run -it --runtime=nvidia --mount source=poc-host1,target=/app --device=/dev/infiniband/uverbs0 -e NVIDIA_VISIBLE_DEVICES=0,1,2,3 -e NVIDIA_DRIVER_CAPABILITIES=compute,utility --rm csmykay/ess-hpecp-mofed-centos7.6-image:latest
docker run -it --runtime=nvidia --mount source=poc-host2,target=/app --device=/dev/infiniband/uverbs1 -e NVIDIA_VISIBLE_DEVICES=4,5,6,7 -e NVIDIA_DRIVER_CAPABILITIES=compute,utility --rm csmykay/ess-hpecp-mofed-centos7.6-image:latest

If you want to change your mount path then change the directory /app to something else (e.g. --mount source=poc-host1,target=/app to --mount source=poc-host1,target=/target)

Without mounts
docker run -it --runtime=nvidia --device=/dev/infiniband/uverbs0 -e NVIDIA_VISIBLE_DEVICES=0,1,2,3 -e NVIDIA_DRIVER_CAPABILITIES=compute,utility --rm csmykay/ess-hpecp-mofed-centos7.6-image:latest
docker run -it --runtime=nvidia --device=/dev/infiniband/uverbs1 -e NVIDIA_VISIBLE_DEVICES=4,5,6,7 -e NVIDIA_DRIVER_CAPABILITIES=compute,utility --rm csmykay/ess-hpecp-mofed-centos7.6-image:latest

Tested on HPE Apollo 6500 with 8 GPU's and 2 Mellanox cards:

[root@3a470b1b855c tmp]# nvidia-smi
Fri May  8 16:00:32 2020
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 418.87.01    Driver Version: 418.87.01    CUDA Version: 10.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Tesla P100-PCIE...  On   | 00000000:05:00.0 Off |                  Off |
| N/A   28C    P0    28W / 250W |      0MiB / 16280MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   1  Tesla P100-PCIE...  On   | 00000000:08:00.0 Off |                  Off |
| N/A   33C    P0    27W / 250W |      0MiB / 16280MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   2  Tesla P100-PCIE...  On   | 00000000:0D:00.0 Off |                  Off |
| N/A   29C    P0    26W / 250W |      0MiB / 16280MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   3  Tesla P100-PCIE...  On   | 00000000:13:00.0 Off |                  Off |
| N/A   27C    P0    26W / 250W |      0MiB / 16280MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
[root@3a470b1b855c tmp]# ./cuda-stream
BabelStream
Version: 3.3
Implementation: CUDA
Running kernels 100 times
Precision: double
Array size: 5319.0 MB (=5.3 GB)
Total size: 15956.9 MB (=16.0 GB)
Create Host Vectors
Create CUDAStream
Using CUDA device Tesla P100-PCIE-16GB
Driver: 10020
here 1
here 2
here 3
here 4
here 5
Error: no kernel image is available for execution on the device
[root@3a470b1b855c tmp]# ofed_info -s
MLNX_OFED_LINUX-4.6-1.0.1.1:
[root@3a470b1b855c tmp]# ib_write_bw -a -d mlx5_0 &
[1] 73
[root@3a470b1b855c tmp]#
************************************
* Waiting for client to connect... *
************************************
