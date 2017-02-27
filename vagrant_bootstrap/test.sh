#!/usr/bin/env bash
cd /var/www/public/ && wget https://github.com/phpmyadmin/phpmyadmin/archive/master.zip
unzip -q master.zip && mv phpmyadmin-master phpmyadmin && cd phpmyadmin
composer install