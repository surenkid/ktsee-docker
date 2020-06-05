FROM python:2.7.18-alpine3.11
LABEL maintainer="surenkids@gmail.com"

# Change alpine repo for China network
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# copy app files
COPY app/ /app/
RUN chomod +x /app/entrypoint.sh

# set workdir to app
WORKDIR /app

# install requirtments
RUN pip install -r requirements.txt

# Start cron
CMD ["/app/entrypoint.sh"]