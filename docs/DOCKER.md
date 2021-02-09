
## Docker Tips

### This allows you to enter a running container:
```
    docker exec -it [container-id] bash
```

### Stop and Clean all docker containers/images with script
```
    cd ./cakephp-queued-worker-app
    chmod +x ./bash/clean_all_images.sh    
    ./bash/clean_all_images.sh
```

### Stop `all` docker `containers`:
```
    docker stop $(docker ps -aq)
```

### Remove `all` docker `containers`:
```
    docker rm $(docker ps -aq)
```

### Remove `all` docker `images`:
```
    docker rmi $(docker images -q)
```

### Clean `all` docker `images` cache:
```
    docker system prune -a
```
