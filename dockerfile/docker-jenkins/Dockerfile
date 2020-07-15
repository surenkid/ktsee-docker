FROM jenkins/jenkins:lts-alpine
LABEL maintainer="surenkids@gmail.com"

USER root

# Copy git-ftp client to container
COPY git-ftp /home/
RUN chmod +x /home/git-ftp

# Install lftp client
RUN apk add --no-cache lftp

USER jenkins
