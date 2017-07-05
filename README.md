### How to build and setup the Docker image
```
docker build -t piorecommend .
```

### How to run and access your new Docker container
```
docker run -p 8000:8000 -p 7070:7070 --name piorecommend -it piorecommend /bin/bash
```

### Manual steps after run (inside Docker container):
```
cd /UR
./boot.sh
```

### How to remove your Docker image
```
docker stop piorecommend; docker rm piorecommend
```
