# 实验室GPU服务器镜像

## 镜像功能
- 方便切换`cuda`版本
- 内置安装`oh-my-zsh`，默认使用`spaceship`主题，自动安装常用插件
- 内置安装`miniconda`，并预先下载好`torch`等
- 内置安装`bitsrun`，方便从命令后登陆校园网
- 可以灵活配置`SSH`端口


## 创建镜像
选择需要的`cuda`版本，通过如下命令创建镜像
- `--network host`指定在创建镜像时使用宿主机的网络，方便使用代理安装一些所需要的包
- `-f`指定`Dockerfile`的位置，根据`cuda`版本指定即可
- `-t`指定创建镜像的`tag`

```shell
docker build --network host -f cuda11.7/Dockerfile -t 0x404/cuda:cu11.7 .
```

也可以直接从[Docker Hub](https://hub.docker.com/repository/docker/0x404/cuda/tags?page=1&ordering=last_updated)上拉取镜像，使用如下命令拉取`cuda 11.7`镜像

```shell
docker pull 0x404/cuda:cu11.7
```

## 创建容器
根据所需要的镜像创建容器，通过如下命令创建容器
- `--restart always`宿主机重启容器自动重启
- `--network host`所有容器都直接使用宿主机的网络，方便统一开启代理
- `--gpus 1`指定GPU，按需指定即可
- `-v test_container_data:/root/workspace`，将`test_container_data`这个`volume`挂载到容器的`/root/workspace`，持久化存储
- `-e SSH_PORT=2233`，使用本仓库提供的镜像必须指定SSH的端口号，才能正确开启SSH服务
- `-e VOLUME_MNT=/root/workspace`，使用本仓库提供的镜像，如果挂载`volume`，需要设置该环境变量为挂载的位置

```shell
docker run --restart always \
           --network host \
           --gpus 1 \
           -itd \
           --name test \
           -v test_container_data:/root/workspace \
           -e SSH_PORT=2233 \
           -e VOLUME_MNT=/root/workspace \
           0x404/cuda:cu11.7
```


## 后续使用

- 使用[portainer](https://github.com/portainer/portainer)来管理`Docker`，每个人一个账号，可以管理自己的容器和数据卷
- 翻墙代理和校园网连接，由于所有容器都直接连上宿主机的网络，所以只要宿主机连接上校园网，并设置好代理即可
- 数据卷备份(todo)
