FROM alpine:3.12.0
LABEL maintainer="surenkids@gmail.com"

ARG USER_ID=82
ARG GROUP_ID=82

RUN addgroup -g ${GROUP_ID} -S ktsee && \
  adduser -h /home -u ${USER_ID} -s /bin/false -S ktsee -G ktsee

RUN apk add --no-cache bash busybox-extras

# Change timezone to Asia/Shanghai
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]