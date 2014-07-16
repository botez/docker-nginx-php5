#!/bin/bash

## Copy over config files if they aren't already there
if [ ! -d /config/conf.d ]; then
  cp -rf /etc/nginx/conf.d /config
fi;
ln -s 

if [ ! -d /config/sites-available ]; then
  cp -rf /etc/nginx/sites-available /config
fi;

if [ ! -d /config/sites-enabled ]; then
  cp -rf /etc/nginx/sites-enabled /config
fi;

if [ ! -f /config/nginx.conf ]; then
  cp -rf /etc/nginx/nginx.conf /config
fi;

if [ ! -f /web/index.php ]; then
  cp -rf /var/www/index.php /web
fi;

## Now, remove files in /etc/nginx and /var/www and instead link to files in  /config and /web areas
rm -rf /etc/nginx/conf.d /etc/nginx/sites-available /etc/nginx/sites-enabled /etc/nginx/nginx.conf /var/www
ln -s /config/conf.d /etc/nginx/conf.d 
ln -s /config/sites-available /etc/nginx/sites-available
ln -s /config/sites-enabled /etc/nginx/sites-enabled
ln -s /config/nginx.conf /etc/nginx/nginx.conf
ln -s /web /var/www

service php5-fpm start
nginx &
