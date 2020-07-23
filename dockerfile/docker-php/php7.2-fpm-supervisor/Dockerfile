FROM surenkid/ktsee-php:7.2-fpm
LABEL maintainer="surenkids@gmail.com"

# Change alpine repo for China network
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# Install supervisor & rsync, config php-fpm startup config
RUN apk add --no-cache supervisor rsync \
      && apk add --no-cache wget bash \
      && mkdir /etc/supervisor.d \
      && wget --no-check-certificate -O /etc/supervisor.d/php-fpm.ini https://static.ktsee.com/s1/2019/11/28/5de08a0cc20a2.txt

# Add rsync & readiness prode script
COPY scripts/*.sh /root/
RUN chmod +x /root/*.sh

# Change timezone to Asia/Shanghai
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# Start supervisor service
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisor.d/supervisord.conf"]