FROM jenkins/jenkins:lts-alpine
LABEL maintainer="surenkids@gmail.com"

# Copy git-ftp client to container
COPY git-ftp /home/
# RUN chmod +x /home/git-ftp

# Install lftp client
RUN apk add --no-cache lftp


