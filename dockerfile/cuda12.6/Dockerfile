FROM nvidia/cuda:12.6.0-devel-ubuntu22.04
LABEL MAINTAINER="zengqunhong <zengqunhong@gmail.com>"

ARG ROOT_PASSWD=bitse@123456
ENV TZ=Asia/Shanghai

# install necessary packages in a single layer
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
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
    command-not-found \
    zsh \
    tzdata \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# install oh-my-zsh and spaceship theme
RUN chsh -s /bin/zsh \
  && sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
        -t https://github.com/denysdovhan/spaceship-prompt \
        -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
        -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
        -p git \
        -p https://github.com/zsh-users/zsh-autosuggestions \
        -p https://github.com/zsh-users/zsh-completions \
        -p https://github.com/zsh-users/zsh-syntax-highlighting

# download and install miniconda, create torch env and cleanup
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
	&& bash Miniconda3-latest-Linux-x86_64.sh -b \
	&& rm Miniconda3-latest-Linux-x86_64.sh \
	&& /root/miniconda3/bin/conda init zsh \
  && /root/miniconda3/bin/conda create --name torch python=3.11 -y \
  && /root/miniconda3/envs/torch/bin/pip install pip -U \
  && /root/miniconda3/envs/torch/bin/pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu126 \
  && /root/miniconda3/bin/conda clean -a -y

# enable root ssh connet and change root's passwd
RUN sed -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config \
	&& echo "root:${ROOT_PASSWD}" | chpasswd

# copy dotfiles from build context
COPY dotfiles/ /tmp/dotfiles/
RUN for file in /tmp/dotfiles/*; do mv "$file" "/root/.$(basename "$file")"; done \
  && rm -rf /tmp/dotfiles

# entrypoint scripts
COPY bitse /root/.bitse
RUN find /root/.bitse -type f -exec chmod +x {} \;

# cleanup
RUN rm -rf /tmp/*

ENTRYPOINT /root/.bitse/entrypoint.sh