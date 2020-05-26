FROM surenkid/ktsee-php:7.2-fpm
LABEL maintainer="surenkids@gmail.com"

# Change alpine repo for China network
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# Install rsync
RUN apk add --no-cache rsync

# Create mountable directory
RUN mkdir -p /root/web

# Define mountable directories
VOLUME ["/root/web"]

# First sync 
CMD ["/docker-entrypoint.sh"]