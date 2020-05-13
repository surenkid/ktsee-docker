FROM python:3.6.10-alpine3.11
LABEL maintainer="surenkids@gmail.com"

# Change alpine repo for China network
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# Install coscmd
RUN pip install coscmd

# Add coscmd script to crontab
RUN echo '0       2       *       *       *       sh /root/coscmd.sh' | tee -a /etc/crontabs/root

VOLUME [ "/root" ]

# Start cron
CMD ["crond","-f"]