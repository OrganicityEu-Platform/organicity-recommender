### How to build the Docker image
```
docker build -t piorecommend .
```

### How to access your new Docker image
```
docker run -p 8000:8000 -p 7070:7070 --name piorecommend -it piorecommend /bin/bash
```


### Manual steps after run (inside Docker image):
Start PredictionIO and create a new app.
Look for the app ID in the terminal output.
```
pio-start-all
pio status
cd /UR
pio build
pio app new recommenderApp
export ACCESS_KEY=...
```

Insert events
```
python import_eventserver.py --access_key $ACCESS_KEY
```

Train and deploy
```
pio train -- --driver-memory 4g --executor-memory 4g
pio deploy
```


### How to remove your Docker image
```
docker stop piorecommend; docker rm piorecommend
```
