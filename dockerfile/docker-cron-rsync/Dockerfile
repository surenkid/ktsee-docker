FROM alpine:3.11.6
LABEL maintainer="surenkids@gmail.com"

# Change alpine repo for China network
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# Change timezone to Asia/Shanghai
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && apk del tzdata

# Install rsync
RUN apk add --no-cache rsync

# Add coscmd script to crontab
RUN echo "*       *       *       *       *       /usr/bin/flock -xn /root/cron-rsync.lock -c 'sh /root/cron-rsync.sh'" | tee -a /etc/crontabs/root

# Add readiness prode script
COPY scripts/*.sh /root/
RUN chmod +x /root/*.sh

# Define mountable directories
VOLUME ["/root/rsync", "/root/remote"]

# Start cron
CMD nohup sh -c 'crond -f && sh /root/inotify-rsync-push.sh'