FROM jenkins/jenkins:lts-alpine
LABEL maintainer="surenkids@gmail.com"

USER root

# Install git-ftp client
COPY git-ftp /usr/bin/
RUN chmod +x /usr/bin/git-ftp

# Install lftp client
RUN apk add --no-cache lftp

USER jenkins
