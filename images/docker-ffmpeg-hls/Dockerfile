FROM alpine:latest
MAINTAINER https://github.com/surenkid/

ENV MP4_VIDEO_DIR=/root/input \
    TS_VIDEO_DIR=/root/output \
    FTP_SERVER=ftp.fffffft.win \
    FTP_USER=ffff_username \
    FTP_PASSWORD=ffff_password \
    FTP_UPLOAD_DIR=/htdocs \
    FTP_UPLOAD_PARALLEL=10 \
    VIDEO_SEGMENT_TIME=30

RUN apk update \
        && apk add lftp ffmpeg bash \
        && rm -rf /var/cache/apk/*

RUN mkdir -p $MP4_VIDEO_DIR \
        && mkdir -p $TS_VIDEO_DIR

COPY static/ /root/

WORKDIR /root

ENTRYPOINT ["bash","convert.sh"]
