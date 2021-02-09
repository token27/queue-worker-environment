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
clear
echo "#################################"
echo "### Cleaning all docker images"
echo "### "
echo "### Warning: "
echo "### All containers and images "
echo "### created in docker will be removed."
echo "### Use only in development environments,"
echo "### like an AWS instance."
echo "#################################"
echo 'Press [Any Key] to continue...'
pause 'or [Ctrl + C] keys to cancel.'
sudo docker stop $(docker ps -aq)
sudo docker rm $(docker ps -aq)
sudo docker rmi $(docker images -q)
sudo docker system prune -a --force
clear
echo "#################################"
echo "### Done"
echo "#################################"