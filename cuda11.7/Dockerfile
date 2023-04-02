FROM nvidia/cuda:11.7.0-runtime-ubuntu20.04
LABEL MAINTAINER="zengqunhong <zengqunhong@gmail.com>"

ENV ROOT_PASSWD 123456
ENV PATH /root/miniconda3/bin:$PATH

# install necessary packages
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
  apt-utils \
  vim \
  openssh-server \
  net-tools \
  iputils-ping \
  wget \
  curl \
  git \
  iptables \
  bzip2 \
  g++ \
  gcc \
  make \
  tmux \
  command-not-found

# download & install miniconda
RUN  wget -q https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh \
	&& bash Miniconda3-latest-Linux-x86_64.sh -b \
	&& rm Miniconda3-latest-Linux-x86_64.sh \
	&& /root/miniconda3/bin/conda init

# create py39 envirnoment and install torch
RUN /root/miniconda3/bin/conda create --name py39 python=3.9 -y \
  && /root/miniconda3/envs/py39/bin/pip install pip -U \
  && /root/miniconda3/envs/py39/bin/pip install torch==1.8.0+cu111 torchvision==0.9.0+cu111 torchaudio==0.8.0 -f https://download.pytorch.org/whl/torch_stable.html


# enable root ssh connet and change root's passwd
RUN sed -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config \
	&& echo "root:${ROOT_PASSWD}" | chpasswd

# change ssh port and start ssh service
RUN echo "#!/bin/bash\n\
sed -i 's/\(^Port\)/#\1/' /etc/ssh/sshd_config && echo "Port \$SSH_PORT" >> /etc/ssh/sshd_config\n\
service ssh start\n\
sed -i \"1iexport SSH_PORT=\$SSH_PORT\" /root/.bashrc\n\
sed -i \"1iexport CUDA_VERSION=\$CUDA_VERSION\" /root/.bashrc\n\
sed -i \"1iexport VOLUME_MNT=\$VOLUME_MNT\" /root/.bashrc\n\
/bin/bash\
" > /root/startup.sh && chmod 777 /root/startup.sh

# cleanup
RUN rm -rf /var/lib/apt/lists/* /tmp/*

# ssh welcome message
RUN echo '#!/bin/bash\n\
printf "*****************************************************************\\n"\n\
printf "Welcome to [BITSE GPU Server]!\\n"\n\
printf "System information as of [$(date +"%Y-%m-%d %H:%M:%S")]:\\n"\n\
printf " - Host IP: $(hostname -I | cut -d " " -f1 )\\n"\n\
printf " - SSH Command: ssh -p $SSH_PORT root@$(hostname -I | cut -d " " -f1 )\\n"\n\
printf " - Operating System: $(lsb_release -ds)\\n"\n\
printf " - Kernel Version: $(uname -r)\\n"\n\
printf " - CUDA Version: $CUDA_VERSION\\n"\n\
printf " - CONDA Version: $(conda --version)\\n\\n"\n\
printf "Use \`conda activate py39\` to activate pre-installed envs.\\n"\n\
if [ -n "$VOLUME_MNT" ]; then\n\
printf "\\nNOTE: The container you are in does not permanently store all data.\\n"\n\
printf "Please place your important code and data in $VOLUME_MNT, as this directory will be persisted.\\n"\n\
fi\n\
printf "*****************************************************************\\n"\n\
' >> /root/.bitsehello\
    && chmod 777 /root/.bitsehello \
    && echo "/root/.bitsehello" >> /root/.bashrc

# install bitsrun
RUN python3 -m pip install --user pipx && python3 -m pipx ensurepath && /root/.local/bin/pipx install bitsrun

ENTRYPOINT /root/startup.sh
