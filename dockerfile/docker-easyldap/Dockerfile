FROM python:2.7.18-alpine3.11
LABEL maintainer="surenkids@gmail.com"

# Change alpine repo for China network
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# copy app files
RUN mkdir /app
COPY app/ /app/
RUN chmod +x /app/entrypoint.sh

# set workdir to app
WORKDIR /app

# install requirtments
RUN apk --update add --virtual build-dependencies libldap gcc libc-dev python-dev openldap-dev \
  && pip install --upgrade pip \
  && pip install -r requirements.txt \
  && apk del build-dependencies

# install openldap
RUN apk add openldap

# Start cron
CMD ["/app/entrypoint.sh"]