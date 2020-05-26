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
RUN echo '0/5       *       *       *       *       echo "rsync start" && rsync -avzhu --progress /root/remote/ /root/local/ && rsync -avzhu --progress /root/local/ /root/remote/ && echo "rsync end" ' | tee -a /etc/crontabs/root

# Create mountable directory
RUN mkdir -p /root/folder1 \ 
  && mkdir -p /root/folder2

# Define mountable directories
VOLUME ["/root/local", "/root/remote"]

# Start cron
CMD ["crond","-f"]
