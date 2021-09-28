FROM python:3.9.7-slim
LABEL maintainer="surenkids@gmail.com"

# ensure www-data user exists
RUN userdel www-data \
	&& groupdel www-data \
	&& groupadd -g 82 -o www-data \
	&& useradd -m -u 82 -g 82 -o -s /sbin/nologin www-data

USER www-data

# Change pip repo for China network
RUN pip install -U pip \
    && pip config set global.index-url http://mirrors.tencentyun.com/pypi/simple \
    && pip config set install.trusted-host mirrors.tencentyun.com

# Change timezone to Asia/Shanghai
RUN apt update \
    && apt install -y tzdata \
    && ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

