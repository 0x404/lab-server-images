[中文版](README.zh.md)

# Lab GPU Server Docker Images

This repository provides Docker images for a GPU server environment, designed for convenience and rapid setup in a lab setting.

## Table of Contents

- [Features](#features)
- [Build Image](#build-image)
- [Create Container](#create-container)
- [Management](#management)

## Features

- **Seamless CUDA Version Switching**: Easily switch between different CUDA versions. Currently supported versions include:
  - [cu11.1](https://hub.docker.com/r/nvidia/cuda/tags?page=1&name=11.1)
  - [cu11.7](https://hub.docker.com/r/nvidia/cuda/tags?page=1&name=11.7)
  - [cu11.8](https://hub.docker.com/r/nvidia/cuda/tags?page=1&name=11.8)
  - [cu12.6](https://hub.docker.com/r/nvidia/cuda/tags?page=1&name=12.6)
- **Enhanced Shell Experience**: Uses `zsh` with `oh-my-zsh` by default. Comes with the `spaceship` theme and popular plugins like `zsh-autosuggestions` and `zsh-syntax-highlighting`.
- **Pre-installed Conda Environment**: `Miniconda` is pre-installed with a `pytorch` environment configured for the corresponding CUDA version, saving you setup time.
- **Transparent Proxy**: Containers share the host's network, allowing seamless access to resources like GitHub without extra proxy configuration.
- **Flexible SSH Configuration**: Easily configure the SSH port for container access.

## Build Image

Choose your desired CUDA version and build the image using the following command.

- `-f`: Specifies the path to the Dockerfile for the chosen CUDA version.
- `-t`: Sets the tag for the new image.
- `--build-arg ROOT_PASSWD=your_secure_password`: Sets the root password for the container. **Remember to change `your_secure_password`**.
- `.`: Uses the current directory as the Docker build context.

```shell
cd lab-server-images
docker build --network host \
  -f dockerfile/cuda12.6/Dockerfile \
  -t 0x404/cuda:12.6 \
  --build-arg ROOT_PASSWD=your_secure_password .
```

Alternatively, you can pull a pre-built image from [Docker Hub](https://hub.docker.com/repository/docker/0x404/cuda). For example, to pull the `cuda 12.6` image:

```shell
docker pull 0x404/cuda:12.6
```

## Create Container

Create a container from the image you built or pulled.

- `--restart always`: Ensures the container restarts automatically if the host machine reboots.
- `--network host`: The container shares the host's network stack.
- `--gpus all`: Grants the container access to all available GPUs. Adjust as needed.
- `-v test_container_data:/root/workspace`: Mounts a volume named `test_container_data` to `/root/workspace` for persistent storage.
- `-e SSH_PORT=2333`: **Required**. Sets the SSH port for the container.
- `-e SE_USER_NAME=test`: Specifies the username for the container user.
- `-e VOLUME_MNT=workspace`: **Required if mounting a volume**. Specifies the mount point directory name under `/root/`.

```shell
docker run --name test_container \
           -itd \
           --restart always \
           --network host \
           --gpus all \
           -v test_container_data:/root/workspace \
           -e SSH_PORT=2333 \
           -e SE_USER_NAME=test \
           -e VOLUME_MNT=workspace \
           0x404/cuda:12.6
```

## Management

You can use tools like [Portainer](https://github.com/portainer/portainer) for easy management of your Docker containers. 