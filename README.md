### How to build the Docker image
```
docker build -t fromscratch .
docker run -p 8000:8000 -p 7070:7070 --name fromscratch -it fromscratch /bin/bash
docker stop fromscratch; docker rm fromscratch
```


### Manual steps after run (inside Docker image):
```
pio-start-all
pio status
cd /UR
pio build
pio app new recommenderApp
export ACCESS_KEY=...
```

Insert events
Look at ./examples.sh for inspiration

```
python data/import_eventserver.py --access_key $ACCESS_KEY
pio train -- --driver-memory 4g --executor-memory 4g
pio deploy
```
