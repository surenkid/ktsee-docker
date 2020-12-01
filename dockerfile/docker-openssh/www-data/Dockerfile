FROM alpine:3.12.0
LABEL maintainer="surenkids@gmail.com"

# Init ENV
ENV SSH_PASSWORD="ktsee"

# Change alpine repo for China network
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# ARG USER_ID=82
# ARG GROUP_ID=82

# RUN addgroup -g ${GROUP_ID} -S ktsee && \
#  adduser -h /home -u ${USER_ID} -s /bin/false -S ktsee -G ktsee

# RUN apk add --no-cache bash busybox-extras

# Install openssh-server and bash
RUN apk add --no-cache bash openssh \
    && sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config \
    && ssh-keygen -t dsa -P "" -f /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key \
    && ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key \
    && ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key \
    && echo "root:${SSH_PASSWORD}" | chpasswd

# Change timezone to Asia/Shanghai
RUN apk add tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata

# Add www-data user and group
RUN addgroup -g 82 -S www-data \
    && adduser -h /home -u 82 -s /bin/ash -S www-data -G www-data \
    && echo "www-data:www-data" | chpasswd

# Open ssh port
EXPOSE 22

# Start openssh server
CMD ["/usr/sbin/sshd", "-D"]