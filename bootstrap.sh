#!/usr/bin/env bash

echo "=========================================================="
echo "Update all expired keys from Ubuntu key server"
echo "=========================================================="
sudo apt-key list | \
 grep "expired: " | \
 sed -ne 's|pub .*/\([^ ]*\) .*|\1|gp' | \
 xargs -n1 sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
sudo rm /etc/apt/sources.list.d/mongodb*.list
sudo apt-get update
sudo apt-get -y upgrade

echo "=========================================================="
echo "Installing utils libs."
echo "=========================================================="
sudo timedatectl set-timezone Europe/Paris
sudo apt-get install -y bindfs ntp tree default-jre
sudo service ntp restart

echo "=========================================================="
echo "Apache installation"
echo "=========================================================="
sudo apt-get install -y apache2 libapache2-mod-fastcgi

echo "=========================================================="
echo "PHP Installation"
echo "=========================================================="
sudo apt-get install -y python-software-properties
sudo add-apt-repository ppa:ondrej/php

sudo apt-get update
sudo apt-get install -y php7.4 php7.4-fpm

echo "=========================================================="
echo "Installing PHP missing libs"
echo "=========================================================="

sudo apt-get install -y php7.4-dom php7.4-xml php7.4-mysql php7.4-gd php7.4-mbstring php7.4-curl php7.4-bcmath php7.4-intl php7.4-zip php7.4-igbinary

echo "=========================================================="
echo "Apache config"
echo "=========================================================="
sudo a2enmod actions fastcgi alias proxy_fcgi
sudo service apache2 restart

echo "=========================================================="
echo "MySQL config"
echo "=========================================================="
echo "ft_min_word_len = 1" >> /etc/mysql/mysql.conf.d/mysqld.cnf
echo "ft_stopword_file = ''" >> /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart

echo "=========================================================="
echo "Aliases."
echo "=========================================================="
# replace original alias "l" by classical one
sed -i -e "s/alias l='ls -CF'/alias l='ls -al'/g" ~/.bashrc
echo "alias sf='php bin/console'" >> ~/.bashrc

echo "=========================================================="
echo "Git configs."
echo "=========================================================="
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global core.excludesfile ~/.gitignore
echo ".idea" >> ~/.gitignore

echo "=========================================================="
echo "Git prompt branch."
echo "=========================================================="
mkdir ~/.bash && cd ~/.bash && git clone git://github.com/jimeh/git-aware-prompt.git
# en début de fichier
sed -i '1iexport GITAWAREPROMPT=~/.bash/git-aware-prompt' ~/.bashrc
sed -i '2isource "${GITAWAREPROMPT}/main.sh"' ~/.bashrc
sed -i '3i\
' ~/.bashrc
# En fin de fichier
echo '' >> ~/.bashrc
echo '# Git prompt branch name' >> ~/.bashrc
echo 'export PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "' >> ~/.bashrc
source ~/.bashrc

echo "=========================================================="
echo "Update composer."
echo "=========================================================="
sudo rm -f /usr/local/bin/composer
sudo curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "=========================================================="
echo "Install phpMyAdmin."
echo "=========================================================="
if [ ! -d "/var/www/public/phpmyadmin" ]; then
	cd /var/www/public/ && wget -q https://github.com/phpmyadmin/phpmyadmin/archive/master.zip
	unzip -q master.zip && mv phpmyadmin-master phpmyadmin && cd phpmyadmin
	composer install
fi

echo "=========================================================="
echo "Installing Capistrano."
echo "=========================================================="
gem install capistrano


echo "=========================================================="
echo "Install vhosts and enable sites"
echo "=========================================================="
sudo cp /var/www/my-scotchbox/backup_vhosts/* /etc/apache2/sites-available/
sudo a2ensite ost-center
sudo a2ensite direct-download
sudo a2ensite webcam-mirror
sudo service apache2 reload

