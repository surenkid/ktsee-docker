FROM alpine:3.11.6
LABEL maintainer="surenkids@gmail.com"

ARG USER_ID=82
ARG GROUP_ID=82
ENV PASV_ENABLE YES
ENV PASV_ADDRESS **IPv4**
ENV PASV_ADDR_RESOLVE NO
ENV PASV_MIN_PORT 21100
ENV PASV_MAX_PORT 21110

RUN apk add --no-cache vsftpd

RUN addgroup -g ${GROUP_ID} -S ktsee && \
  adduser -h /home -u ${USER_ID} -s /bin/false -S ktsee -G ktsee

RUN echo "local_enable=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "write_enable=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "local_umask=022" >> /etc/vsftpd/vsftpd.conf \
  && echo "chroot_local_user=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo 'seccomp_sandbox=NO' >> /etc/vsftpd/vsftpd.conf \
  && echo "allow_writeable_chroot=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "passwd_chroot_enable=yes" >> /etc/vsftpd/vsftpd.conf \
  && echo 'chown_uploads=NO' >> /etc/vsftpd/vsftpd.conf \
  && echo 'local_root=/home' >> /etc/vsftpd/vsftpd.conf \
  && sed -i "s/anonymous_enable=YES/anonymous_enable=NO/" /etc/vsftpd/vsftpd.conf

ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

VOLUME /home

EXPOSE 20 21 21100-21110

# Change timezone to Asia/Shanghai
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# Add bash to alpine
RUN apk add --no-cache bash

CMD ["/docker-entrypoint.sh"]