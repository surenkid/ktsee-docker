FROM surenkid/ktsee-php:7.2-fpm
LABEL maintainer="surenkids@gmail.com"

# Add application
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
COPY kodexplorer/ /var/www/html/

EXPOSE 8000

COPY ktsee.sh /ktsee.sh
RUN chmod +x /ktsee.sh

USER www-data

ENTRYPOINT ["/ktsee.sh"]