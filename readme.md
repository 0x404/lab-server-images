# 实验室GPU服务器镜像

## 镜像功能
- 零成本切换`cuda`版本。（目前支持[cu11.1](https://hub.docker.com/layers/nvidia/cuda/11.1.1-devel-ubuntu18.04/images/sha256-80a131efb4f449346a12ab47ef338a0f51c31baf31da3afbe9b0e46154b797b5?context=explore), [cu11.7](https://hub.docker.com/layers/nvidia/cuda/11.7.1-devel-ubuntu22.04/images/sha256-b22e45ba3de3b62e181930d34740e4b8a63e0d6b400562b1210aec5367736a6b?context=explore), [cu11.8](https://hub.docker.com/layers/nvidia/cuda/11.8.0-devel-ubuntu22.04/images/sha256-53ee1674b6bb23591439709ee61a5dd2566c010f10d75f6b33210050100213a1?context=explore)）
- 内置默认使用[`zsh`](https://www.zsh.org/)，安装[`oh-my-zsh`](https://ohmyz.sh/)，默认安装[`spaceship`](https://github.com/spaceship-prompt/spaceship-prompt)主题，自动安装常用插件，如[命令推荐](https://github.com/zsh-users/zsh-autosuggestions)，[语法高亮](https://github.com/zsh-users/zsh-syntax-highlighting)等等。
- 内置安装[`miniconda`](https://docs.conda.io/projects/miniconda/en/latest/)，并预先安装好对应cuda版本的`pytorch`等软件包，无需重复安装。
- 通过与宿主机使用同一网络环境，无需做任何操作即可实现透明代理，访问`GitHub`等资源。
- 可以灵活配置`SSH`端口。


## 创建镜像
选择需要的`cuda`版本，通过如下命令创建镜像
- `-f`指定`Dockerfile`的位置，根据`cuda`版本指定即可
- `-t`指定创建镜像的`tag`
- `.`以当前所在目录作为`docker build`的`context`

```shell
cd lab-server-images
docker build --network host -f cuda11.8/Dockerfile -t 0x404/cuda:11.8-beta .
```

也可以直接从[Docker Hub](https://hub.docker.com/repository/docker/0x404/cuda)上拉取镜像，使用如下命令拉取`cuda 11.8`镜像

```shell
docker pull 0x404/cuda:cu11.8-beta
```

## 创建容器
根据所需要的镜像创建容器，通过如下命令创建容器
- `--restart always`宿主机重启容器自动重启
- `--network host`所有容器都直接使用宿主机的网络，方便统一开启代理
- `--gpus all`指定创建容器所使用的GPU，按需指定即可
- `-v test_container_data:/root/workspace`，将`test_container_data`这个`volume`挂载到容器的`/root/workspace`，持久化存储
- `-e SSH_PORT=2333`，使用本仓库提供的镜像必须指定SSH的端口号，才能正确开启SSH服务，该
- `-e SE_USER_NAME=test`，使用该容器的用户用户名
- `-e VOLUME_MNT=workspace`，使用本仓库提供的镜像，如果挂载`volume`，需要设置该环境变量为挂载的位置（默认前缀为`/root/`，所以这里只需要填`workspace`即可）

```shell
docker run --restart always \
           --network host \
           --gpus all \
           -itd \
           --name test \
           -v test_container_data:/root/workspace \
           -e SSH_PORT=2333 \
           -e SE_USER_NAME=test \
           -e VOLUME_MNT=workspace \
           0x404/cuda:11.7-beta
```

## 管理

- [portainer](https://github.com/portainer/portainer)