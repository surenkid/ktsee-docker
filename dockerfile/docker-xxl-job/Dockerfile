FROM openjdk:16-jdk-alpine3.12
LABEL maintainer="surenkids@gmail.com"

ENV PARAMS=""

# ENV TZ=PRC
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Change timezone to Asia/Shanghai
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# Add depends extensions to alpine
RUN apk add --no-cache bash curl php7 php7-curl php7-pdo_mysql

ADD xxl-job-executor-sample-springboot-*.jar /app.jar

ENTRYPOINT ["sh","-c","java -jar $JAVA_OPTS /app.jar $PARAMS"]