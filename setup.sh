#!/bin/bash
# init
function pause(){
   read -p "$*"
}
# Run script as root (higher privileges)
if [ "$EUID" -ne 0 ]
then echo "Please run as root"
  exit 1
else
  clear
  echo
  echo "Script is running with higher privileges as: $SUDO_USER -> $(whoami)"
  echo
fi

# Update & Upgrade
sudo apt-get update
sudo apt-get upgrade -y
clear
echo "#################################"
echo "### Starting Install Dependencies"
echo "#################################"
echo 'Press [Any Key] to continue...'
pause 'or [Ctrl + C] keys to cancel.'
# Install
 sudo apt-get install -y zip unzip git curl ca-certificates apt-utils
# Install PHP
sudo apt-get install -y php php-dev php-common php-cgi php-redis php-http-request php-mysql php-curl php-fpm php-pgsql php-imagick php-phpseclib php-imap php-bz2 php-intl php-gmp php-zip php-readline php-mbstring php-xml php-gd php-json php-cli php-ssh2
# Install Docker & Docker Compose
sudo apt-get install -y docker.io docker-compose
sudo chmod +x ./clean.sh
sudo chmod +x ./start.sh
sudo chmod 777 -R ./docker/bash
sudo chmod 777 -R ./docker/config
sudo chmod 777 -R ./docker/mysql
sudo chmod 777 -R ./docker/tasks
sudo chown -R www-data:www-data ./docker/bash
sudo chown -R www-data:www-data ./docker/config
sudo chown -R www-data:www-data ./docker/mysql
sudo chown -R www-data:www-data ./docker/tasks
clear
echo "#################################"
echo "### Done"
echo "### "
echo "### Clean all docker containers and images"
echo "### ./clean.sh"
echo "### "
echo "### Start the docker containers"
echo "### ./start.sh"
echo "#################################"
