#!/usr/bin/env bash

echo "=========================================================="
echo "Update all expired keys from Ubuntu key server"
echo "=========================================================="
sudo apt-key list | \
 grep "expired: " | \
 sed -ne 's|pub .*/\([^ ]*\) .*|\1|gp' | \
 xargs -n1 sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get upgrade

echo "=========================================================="
echo "Installing utils libs."
echo "=========================================================="
sudo timedatectl set-timezone Europe/Paris
sudo apt-get install bindfs ntp tree default-jre
sudo service ntp restart

echo "=========================================================="
echo "Apache installation"
echo "=========================================================="
sudo apt-get install apache2 libapache2-mod-fastcgi

echo "=========================================================="
echo "PHP Installation"
echo "=========================================================="
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:ondrej/php

sudo apt-get update
sudo apt-get install php5.6 php5.6-fpm
sudo apt-get install php7.2 php7.2-fpm

echo "=========================================================="
echo "Installing PHP missing libs"
echo "=========================================================="

sudo apt-get install php5.6-dom php5.6-xml php5.6-mysql php5.6-gd php5.6-mbstring php5.6-curl php5.6-bcmath php5.6-intl
sudo apt-get install php7.2-dom php7.2-xml php7.2-mysql php7.2-gd php7.2-mbstring php7.2-curl php7.2-bcmath php7.2-intl php7.2-zip
sudo apt-get install rabbitmq-server

echo "=========================================================="
echo "Apache config"
echo "=========================================================="
sudo a2enmod actions fastcgi alias proxy_fcgi
sudo service apache2 restart

echo "=========================================================="
echo "Aliases."
echo "=========================================================="
# replace original alias "l" by classical one
sed -i -e "s/alias l='ls -CF'/alias l='ls -al'/g" ~/.bashrc
echo "alias sf='php bin/console'" >> ~/.bashrc

echo "=========================================================="
echo "Git configs."
echo "=========================================================="
git config --global alias.st status
git config --global alias.co checkout
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
echo "Install phpMyAdmin."
echo "=========================================================="
if [ ! -d "/var/www/public/phpmyadmin" ]; then
	cd /var/www/public/ && wget -q https://github.com/phpmyadmin/phpmyadmin/archive/master.zip
	unzip -q master.zip && mv phpmyadmin-master phpmyadmin && cd phpmyadmin
	sudo composer self-update
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

