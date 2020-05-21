FROM alpine:3.11.6
LABEL maintainer="surenkids@gmail.com"

ARG USER_ID=82
ARG GROUP_ID=82

RUN apk add --no-cache vsftpd

RUN addgroup -g ${GROUP_ID} -S ktsee && \
  adduser -h /home -u ${USER_ID} -S ktsee -G ktsee

RUN echo "local_enable=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "chroot_local_user=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "allow_writeable_chroot=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "write_enable=YES" >> /etc/vsftpd/vsftpd.conf \
  && echo "local_umask=022" >> /etc/vsftpd/vsftpd.conf \
  && echo "passwd_chroot_enable=yes" >> /etc/vsftpd/vsftpd.conf \
  && echo 'seccomp_sandbox=NO' >> /etc/vsftpd/vsftpd.conf \
  && echo 'pasv_enable=YES' >> /etc/vsftpd/vsftpd.conf \
  && echo 'pasv_max_port=10100' >> /etc/vsftpd/vsftpd.conf \
  && echo 'pasv_min_port=10090' >> /etc/vsftpd/vsftpd.conf \
  && echo 'chown_uploads=NO' >> /etc/vsftpd/vsftpd.conf \
  && echo 'local_root=/home/share' >> /etc/vsftpd/vsftpd.conf \
  && sed -i "s/anonymous_enable=YES/anonymous_enable=NO/" /etc/vsftpd/vsftpd.conf

ADD docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

VOLUME /home

EXPOSE 20 21 10090-10100

CMD ["/docker-entrypoint.sh"]