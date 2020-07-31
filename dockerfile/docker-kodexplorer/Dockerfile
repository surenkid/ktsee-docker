FROM surenkid/ktsee-php:7.2-fpm
LABEL maintainer="surenkids@gmail.com"

RUN mkdir -p /var/www/html
WORKDIR /var/www/html

COPY ktsee.sh /ktsee.sh
RUN chmod +x /ktsee.sh

# Add application
COPY kodexplorer/ /var/www/html/
RUN chmod -R 777 /var/www/html/

USER www-data

EXPOSE 8000

ENTRYPOINT ["/ktsee.sh"]