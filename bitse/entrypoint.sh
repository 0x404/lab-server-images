#!/bin/bash

# 容器在被启动时需要给定环境变量SSH_PORT，用于指定该容器所使用的SSH端口
# 使用该端口覆盖原来/etc/ssh/sshd_config中的端口
if grep -q "^Port " /etc/ssh/sshd_config; then
    sed -i'.bak' -e "s/^Port .*/Port $SSH_PORT/" /etc/ssh/sshd_config
else
    echo "Port $SSH_PORT" >> /etc/ssh/sshd_config
fi

# 为了方便每次连接容器时显示该容器的详细信息，需要将环境变量自动导出到zsh环境
# SSH_PORT: 容器SSH端口
# CUDA_VERSION: 容器CUDA版本
# VOLUME_MNT: 容器所挂载的持久化保存目录
declare -A vars_defaults=( [SSH_PORT]=$SSH_PORT [CUDA_VERSION]=$CUDA_VERSION [VOLUME_MNT]=$VOLUME_MNT [SE_USER_NAME]=$SE_USER_NAME )
zshrc_file="${HOME}/.zshrc"

for var in "${!vars_defaults[@]}"; do
  if ! grep -q "export $var=" $zshrc_file; then
    echo "export $var='${vars_defaults[$var]}'" >> $zshrc_file
  fi
done

# 将hello脚本插入到zsh中，每次zsh初始化的时候都会显示当前系统信息
if ! grep -qF -- "/root/.bitse/bitsehello.sh" "$zshrc_file"; then
  echo "/root/.bitse/bitsehello.sh" >> "$zshrc_file"
fi

# 将miniconda添加到环境变量中
MINICONDA_PATH="/root/miniconda3/bin"
PATH_CODE="if [[ \":\$PATH:\" != *\":$MINICONDA_PATH:\"* ]]; then
  export PATH=\"$MINICONDA_PATH:\$PATH\"
fi"
ZSHRC="${HOME}/.zshrc"
if ! grep -qF -- "$MINICONDA_PATH" "$ZSHRC"; then
  echo "$PATH_CODE" >> "$ZSHRC"
fi

# 启动SSH服务
service ssh start

exec zsh
