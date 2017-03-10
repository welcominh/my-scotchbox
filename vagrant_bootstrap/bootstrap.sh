#!/usr/bin/env bash

echo "=========================================================="
echo "Installing bindfs."
echo "=========================================================="
sudo apt-get install bindfs

echo "=========================================================="
echo "Disabling obsolete PPA and reverting to official packages."
echo "=========================================================="
sudo apt-get install ppa-purge
yes | sudo ppa-purge ppa:ondrej/php5-5.6

# Update to current PPA
echo "=========================================================="
echo "Adding current PPA and updating packages."
echo "=========================================================="
yes | sudo add-apt-repository ppa:ondrej/php
yes | sudo apt-get update
sudo apt-get autoremove
sudo a2dismod php5
#sudo chmod 777 /var/lib/php5

echo "=========================================================="
echo "Installing Xdebug."
echo "=========================================================="
yes | sudo apt-get install php php-mysql php-xml php-xdebug
sudo service apache2 restart


echo "=========================================================="
echo "Aliases."
echo "=========================================================="
# replace original alias "l" by classical one
sed -i -e "s/alias l='ls -CF'/alias l='ls -al'/g" ~/.bashrc
echo "alias sf='php bin/console'" >> ~/.bashrc
git config --global alias.st status
git config --global alias.co checkout

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

echo "=========================================================="
echo "Install phpMyAdmin."
echo "=========================================================="
if [ ! -d "/var/www/public/phpmyadmin" ]; then
	cd /var/www/public/ && wget -q https://github.com/phpmyadmin/phpmyadmin/archive/master.zip
	unzip -q master.zip && mv phpmyadmin-master phpmyadmin && cd phpmyadmin
	sudo composer self-update
	composer install
fi
