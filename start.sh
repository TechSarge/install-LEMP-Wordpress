#!/bin/bash

#Disclamer: please install with a non root user with sudo privleges.
#
#

#this asks for the root password to use
read -e -p "Enter the root password you want to use for MySql and then press [ENTER]:" SqlPass

#this asks for the databse name that you want to use
read -e -p "Enter the database name for wordpress and then press [ENTER]:" -i "wordpress" DBname

#this aks for the username that you want wordpress to use to acces the database
read -e -p "Enter the username that you want to use to access the wordpress database and then press [ENTER]:" -i "wordpressuser" DBuser

#this asks for the passowrd for the wordpress databse
read -e -p "Enter the password that you wnat to use for the wordpress database and then press [ENTER]:" DBpass

user=$(whoami)

sed -i "s/enterusername/$user/g" LEMP-install.sh

#this changes the root password in the install file
sed -i "s/EnterSQLPass/$SqlPass/g" LEMP-install.sh

#htis changes all the database names
sed -i "s/EnterDBname/$DBname/g" LEMP-install.sh

#this changes all the databse usernames
sed -i "s/EnterDBuser/$DBuser/g" LEMP-install.sh

#this changes all the databas passwords
sed -i "s/EnterDBpass/$DBpass/g" LEMP-install.sh

