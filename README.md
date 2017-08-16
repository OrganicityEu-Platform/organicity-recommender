### How to build and setup the Docker image
```
docker build -t piorecommend .
```

### Running with docker compose and nginx frontend which can create SSL certificates with LE
```
docker-compose up -d
```

### How to run and access your new Docker container
```
docker run -p 8000:8000 -p 7070:7070 -v /path/to/hbasedata:/hbasedata -v /path/to/elasticdata:/elasticdata --name piorecommend -it piorecommend
```

This will run the "boot.sh" setup script. Which will build + train + deploy
PredictionIO with the Similar Product engine. You should note the Access key
in the terminal output.


### How to remove your Docker image
```
docker stop piorecommend
docker rm piorecommend
```
