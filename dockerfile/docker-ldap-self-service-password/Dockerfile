FROM alpine:3.12.0
LABEL maintainer="surenkids@gmail.com"

# Install packages
RUN apk --no-cache add php7 php7-fpm php7-ldap php7-mbstring php7-openssl php7-curl php7-session nginx

# Configure nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Add application
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
COPY self-service-password/ /var/www/html/

EXPOSE 80

COPY ktsee.sh /ktsee.sh
RUN chmod +x /ktsee.sh
ENTRYPOINT ["/ktsee.sh"]