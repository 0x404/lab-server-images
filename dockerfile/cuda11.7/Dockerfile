FROM nvidia/cuda:11.7.1-devel-ubuntu22.04
LABEL MAINTAINER="zengqunhong <zengqunhong@gmail.com>"

ENV ROOT_PASSWD bitse@123456

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

# set time zone to Asia/Shanghai
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install -y tzdata

# download and install miniconda
RUN  wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
	&& bash Miniconda3-latest-Linux-x86_64.sh -b \
	&& rm Miniconda3-latest-Linux-x86_64.sh \
	&& /root/miniconda3/bin/conda init zsh

# install pytorch environmnets for cuda11.7
RUN /root/miniconda3/bin/conda create --name torch python=3.9 -y \
  && /root/miniconda3/envs/torch/bin/pip install pip -U \
  && /root/miniconda3/envs/torch/bin/pip install install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu117

# install oh-my-zsh and spaceship theme
RUN apt-get update && apt-get install zsh -y && chsh -s /bin/zsh \
  && sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
        -t https://github.com/denysdovhan/spaceship-prompt \
        -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
        -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
        -p git \
        -p https://github.com/zsh-users/zsh-autosuggestions \
        -p https://github.com/zsh-users/zsh-completions \
        -p https://github.com/zsh-users/zsh-syntax-highlighting

# enable root ssh connet and change root's passwd
RUN sed -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config \
	&& echo "root:${ROOT_PASSWD}" | chpasswd

# download and store dotefiels (tmux.conf, ...)
RUN cd /root \
  && git clone https://github.com/0x404/lab-server-images.git \
  && for file in lab-server-images/dotfiles/*; do mv "$file" "/root/.$(basename "$file")"; done \
  && rm -rf lab-server-images

# entrypoint scripts
COPY bitse /root/.bitse
RUN find /root/.bitse -type f -exec chmod +x {} \;

# cleanup
RUN rm -rf /var/lib/apt/lists/* /tmp/*

ENTRYPOINT /root/.bitse/entrypoint.sh