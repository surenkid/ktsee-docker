FROM alpine:3.8
MAINTAINER https://github.com/surenkid/

# Install packages
RUN apk --no-cache add php7 php7-fpm php7-ldap php7-mbstring php7-openssl php7-curl nginx

# Configure nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Add application
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
COPY self-service-password/ /var/www/html/

EXPOSE 80 443

COPY ktsee.sh /ktsee.sh
RUN chmod +x /ktsee.sh
ENTRYPOINT ["/ktsee.sh"]