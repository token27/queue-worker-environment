# Queued Worker App in CakePHP 4.x

## Ports

| PORT | EXPOSED | PROTOCOL | Description |
| ------ | ------ | -------- | --- |
| **80** | **8080** | TCP |  CakePHP |
| **80** | **8081** | TCP |  PhpMyAdmin |
| **3306** | **3306** | TCP |  Mysql |

## Installation

The recommended way to install this app as git:
````
    git clone https://github.com/token27/cakephp-queued-worker-app.git
    cd ./cakephp-queued-worker-app
````

### - Install dependencies and folder permissions:

#### Script
```    
    chmod +x ./setup.sh
    ./setup.sh
```

### Configuration requeriments (file `/docker/.env`):

```        
    nano ./docker/.env
```

### - Start this app as docker:

Start all services
``` 
    ./start.sh
```

or start service required
``` 
    cd ./docker
    docker-compose up -d mysql      
    docker-compose up -d redis
    docker-compose up -d phpmyadmin
    docker-compose up -d apache
    docker-compose up worker-tasker
```
### - Easy way to execute cake shell 
- Go to folder `/docker` and execute
```    
    worker-cake --help
    worker-cake Queued --help
    worker-cake QueuedWorkers --help
```
---

## List docker containers:
```
    docker ps
```

## This allows you to enter a running container:
```
    docker exec -it [container-id] bash
```
---

## Folders & Files :

| FOLDER / FILE | Description |
| ------ | ------  |
| **/docker/.env** | This file contain your enviroment vars for the container |
| **/config/app_queued.php** |  The CakePHP Queued Plugin configuration file |
| **/config/app_local.php** | The CakePHP 4.x configuration file |
| **/config/000-default.conf** | The apache vhost site |
| **/docker/mysql/database** | The mysql data |
| **/docker/tasks** | The worker tasks files |


## Docker Tips 

See [Docker Tips](DOCKER.md).