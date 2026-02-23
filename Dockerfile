FROM --platform=linux/amd64 ubuntu:22.04

# Use Aliyun mirror for faster apt downloads in China
RUN sed -i 's|http://archive.ubuntu.com|http://mirrors.aliyun.com|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com|http://mirrors.aliyun.com|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y \
    ca-certificates \
    build-essential \
    gcc-multilib \
    ccache \
    git curl wget unzip zip \
    python3 python3-pip \
    libffi-dev \
    vim \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

# Node.js (CI uses node v14)
RUN curl -fsSL https://nodejs.org/dist/v14.19.1/node-v14.19.1-linux-x64.tar.xz \
    | tar -xJ -C /opt \
    && ln -s /opt/node-v14.19.1-linux-x64/bin/node /usr/local/bin/node \
    && ln -s /opt/node-v14.19.1-linux-x64/bin/npm /usr/local/bin/npm

    # Install repo tool and requests
RUN mkdir -p /root/bin && \
    curl https://raw.gitcode.com/gitcode-dev/repo/raw/main/repo-py3 -o /root/bin/repo && \
    chmod a+x /root/bin/repo && \
    pip3 install -i https://repo.huaweicloud.com/repository/pypi/simple requests
ENV PATH="/opt/node-v14.19.1-linux-x64/bin:/root/bin:/root/.local/bin:${PATH}"

# Git configuration (can be overridden at runtime)
ENV GIT_NAME="Docker User"
ENV GIT_EMAIL="docker@local"
RUN git config --global user.name "${GIT_NAME}" && \
    git config --global user.email "${GIT_EMAIL}" && \
    git config --global credential.helper store

WORKDIR /home/oh
# Create python symlink for repo tool
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN repo init -u https://gitcode.com/openharmony/manifest.git -b master --no-repo-verify && \
    repo sync -c build
# Install hb from local build directory
RUN python3 -m pip install --user build/hb && \
    python3 -m pip install --user jinja2

RUN curl -fsSL https://claude.ai/install.sh | bash
