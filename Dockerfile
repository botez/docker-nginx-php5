FROM phusion/baseimage:0.9.11
MAINTAINER botez <troyolson1@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

RUN echo "deb http://archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install dialog net-tools lynx nano wget
RUN apt-get -y install python-software-properties
RUN apt-get -y install nginx php5-fpm php5-mysql php-apc php5-imagick php5-imap php5-mcrypt

RUN ln -s /web /var/www
RUN ln -s /config /etc/nginx

#ADD default /etc/nginx/sites-available/default 
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN echo "<?php phpinfo(); ?>" > /var/www/index.php

EXPOSE 80

# Create the ability to access the nginx config directory and to the /var/www directory from outside the container
VOLUME /config
VOLUME /web

CMD service php5-fpm start && nginx
