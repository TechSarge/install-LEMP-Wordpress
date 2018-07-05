#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password EnterSQLPass"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password EnterSQLPass"

#this installs mysql
sudo apt install -y mysql-server 

#this installs everything eccept mysql
sudo apt install -y nginx php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc wget tar

echo "if there were no errors then everything has been installed correctly"
read -e -p "please go install and setup lets encrypt if you have a domain name, or a self signed ssl certificate if you do not have a domain. When you finish please press [ENTER] or if you need to close the script and come bask press [CTRL-C] and rerun the script when you are ready."
# this is the beginning of the setup of wordpress now that everything has been installed


# this sets up sql for wordpress
if [ $MYSQL_PASS ]
then
    mysql -u "root" -p "EnterSQLPass" -e "CREATE DATABASE $DB DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"

    mysql -u "root" -p "EnterSQLPass" -e "GRANT ALL ON EnterDBname.* TO 'EndterDBuser'@'localhost' IDENTIFIED BY 'EnterDBpass';"

    mysql -u "root" -p "EnterSQLPass" -e "FLUSH PRIVILEGES; EXIT;"
else
    mysql -u "root" -e "CREATE DATABASE $DB DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"

    mysql -u "root" -e "GRANT ALL ON EnterDBname.* TO 'EndterDBuser'@'localhost' IDENTIFIED BY 'EnterDBpass';"

    mysql -u "root" -e "FLUSH PRIVILEGES; EXIT;"

fi
#this changes error 404 in the location settings
sed -i 's|=404|try_files $uri $uri/ /index.php$is_args$args|g' # nginx file 


#this restarts nginx after the config file was changes
sudo systemctl reload nginx
#restart the php fpm procces
sudo systemctl restart php7.0-fpm

#download wordpress
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
# extract wordpress 
tar xzvf latest.tar.gz
# create the config file
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php

# make a upgrade folder to prevent further issues
mkdir /tmp/wordpress/wp-content/upgrade

# copy wordpress files to the web location
sudo cp -a /tmp/wordpress/. /var/www/html

# change ownership
sudo chown -R enterusername:www-data /var/www/html
sudo find /var/www/html -type d -exec chmod g+s {} \;
sudo chmod g+w /var/www/html/wp-content
sudo chmod -R g+w /var/www/html/wp-content/themes
sudo chmod -R g+w /var/www/html/wp-content/plugins

#this adds the salt
wget -O wp.keys https://api.wordpress.org/secret-key/1.1/salt/
  sed -i '/#@-/r wp.keys' wordpress/wp-config-sample.php
  sed -i "/#@+/,/#@-/d" wordpress/wp-config-sample.php
#this chagnes the config file
  sed -i "s/database_name_here/EnterDBname/1" /var/www/html/wp-config.php
  sed -i "s/username_here/EndterDBuser/1" /var/www/html/wp-config.php
  sed -i "s/passowrd_here/EnterDBpass/1" /var/www/html/wp-config.php
  sed -i "\$adefine('FS_METHOD', 'direct');"
