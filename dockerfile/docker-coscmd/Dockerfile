FROM python:3.9.0-alpine3.12
LABEL maintainer="surenkids@gmail.com"

# Change alpine repo for China network
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# Change timezone to Asia/Shanghai
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && apk del tzdata

# Install mysql-clinet for mysqldump backup database
RUN apk add --no-cache mysql-client bash

# Install coscmd
RUN pip install coscmd

# Add coscmd script to crontab
RUN echo '0       2       *       *       *       sh /root/coscmd.sh' | tee -a /etc/crontabs/root

VOLUME [ "/root" ]

# Start cron
CMD ["crond","-f"]