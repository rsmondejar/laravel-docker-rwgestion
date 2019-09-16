FROM hitalos/laravel:latest

RUN apk update && apk add -U --no-cache \
    libxml2-dev \
    php7-bcmath \
    libgcc libstdc++ libx11 glib libxrender libxext libintl \
    ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family fontconfig ttf-freefont \
    openrc \
    && pear install -a SOAP-0.13.0 \
    && docker-php-ext-install \
        soap \
        bcmath;

# wkhtmltopdf
COPY files/wkhtmltopdf /usr/local/bin/wkhtmltopdf
RUN chmod +x /usr/local/bin/wkhtmltopdf

# Cronjobs
RUN mkdir /etc/periodic/everymin
COPY files/schedule.sh /etc/periodic/everymin/schedule
RUN chmod a+x /etc/periodic/everymin/schedule
RUN echo '* * * * * run-parts /etc/periodic/everymin' >> /etc/crontabs/root

CMD composer install \
    && crond -b \
    && php ./artisan serve --port=80 --host=0.0.0.0
