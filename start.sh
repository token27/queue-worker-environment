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

# Start
echo "#################################"
echo "### Enviroments"
echo "#################################"
echo " "
cd ./docker
cat .env
echo " "
echo " "
echo "#################################"
echo "### Starting Docker Containers"
echo "#################################"
echo 'Press [Any Key] to continue...'
pause 'or [Ctrl + C] keys to cancel.'
docker-compose up -d mysql
docker-compose up -d redis
docker-compose up -d phpmyadmin
docker-compose up -d apache
docker-compose bulid worker-tasker
sleep 7
docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache cake migrations migrate --plugin Queued
docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache chown -R www-data:www-data .
docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache chmod 755 -R .
docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache chmod 777 -R ./tmp
docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache chmod 777 -R ./src/Shell/Task
docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache chmod 777 -R ./vendor/token27/cakephp-queued-plugin/src/Shell/Task
sleep 2
sudo chown -R www-data:www-data ./docker/bash
sudo chown -R www-data:www-data ./docker/config
sudo chown -R www-data:www-data ./docker/mysql
sudo chown -R www-data:www-data ./docker/tasks
sleep 7
alias worker-cake="docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache cake"
alias worker-folders="docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache ls -la"
alias worker-folder-owner="docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache chown -R www-data:www-data ."
alias worker-folder-permissions="docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache chmod 755 -R ."
alias worker-folder-permissions-tmp="docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache chmod 777 -R ./tmp"
alias worker-folder-permissions-tasks="docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache chmod 777 -R ./src/Shell/Task"
#alias worker-folder-permissions-tasks="docker-compose exec -u $(id -u ${USER}):$(id -g ${USER}) apache chmod 777 -R ./vendor/token27/cakephp-queued-plugin/src/Shell/Task"
clear
echo " "
echo " "
echo " "
docker ps
echo "#################################"
echo "### Done"
echo "### "
echo "### - Start the worker tasker"
echo "### cd ./docker"
echo "### "
echo "### docker-compose up worker-tasker"
echo "### "
echo "### "
echo "### - Execute cake shell"
echo "### cd ./docker"
echo "### "
echo "### worker-cake --help"
echo "### worker-cake Queued --help"
echo "### worker-cake QueuedWorker --help"
echo "### "
echo "### - Enter in a running container"
echo "### docker exec -it [container-id] bash"
echo "#################################"