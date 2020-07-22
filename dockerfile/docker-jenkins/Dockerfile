FROM jenkins/jenkins:lts-alpine
LABEL maintainer="surenkids@gmail.com"

USER root

# Install git-ftp client
COPY git-ftp /usr/bin/
RUN chmod +x /usr/bin/git-ftp

# Install lftp client
RUN apk add --no-cache lftp

USER jenkins

# Change timezone to Asia/Shanghai
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata
