# my-scotchbox
Install plugins to improve vagrant performances

    vagrant plugin install vagrant-bindfs
    vagrant plugin install vagrant-faster
    vagrant plugin install vagrant-share
    vagrant plugin install vagrant-winnfsd
    vagrant plugin install vagrant-disksize

To configure the box for the first time use, clone [my-scotchbox](https://github.com/welcominh/my-scotchbox) project to workspace root (vagrantfile file should be there).

Once `vagrant up` done for the first time :

    cp /var/www/my-scotchbox/bootstrap.sh .
    chmod 755 bootstrap.sh
    ./bootstrap.sh

And follow steps !
