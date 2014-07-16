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

## Remove existing /var/www and link /web directory to it for ease of use
RUN mkdir /var/www
RUN ln -s /var/www /web

## Link sites-available and conf.d to the /config directory for ability to edit config files
RUN mkdir /config
RUN ln -s /etc/nginx/sites-available /config/sites-available 
RUN ln -s /etc/nginx/nginx.conf /config/nginx.conf

## Move existing default sites-available config and put in mine
RUN mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.orig
ADD default /etc/nginx/sites-available/default 

## Make changes to config files
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

## Create default index.php for localhost:80
RUN echo "<?php phpinfo(); ?>" > /var/www/index.php

EXPOSE 80

# Create the ability to access the nginx config directory and to the /var/www directory from outside the container
VOLUME /config
VOLUME /web

# Add nginx and php5-fpm to runit
RUN mkdir /etc/service/nginx-php5
ADD nginx-php5.sh /etc/service/nginx-php5/run
RUN chmod +x /etc/service/nginx-php5/run
