FROM python:3.9.7-slim
LABEL maintainer="surenkids@gmail.com"



# install ps & top
RUN apt-get update && apt-get install procps

# Change pip repo for China network
RUN pip install -U pip \
    && pip config set global.index-url http://mirrors.tencentyun.com/pypi/simple \
    && pip config set install.trusted-host mirrors.tencentyun.com

# Change timezone to Asia/Shanghai
RUN apt update \
    && apt install -y tzdata \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

