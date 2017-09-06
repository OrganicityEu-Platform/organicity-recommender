### How to build and setup the Docker image
If you wish, you can choose to build the docker image yourself instead of pulling it from docker hub. This will take some time.
```
docker build -t your-organiztion-here/your-tag-here:your-version-here .
```

### Running with docker-compose including PostgreSQL and SSL termination
A docker-compose file has been created so you can easily get started. It will create a PostgresSQL database, SSL proxy and the recommender engine with a template Similar Product engine pre-instaled.
*This is not the recommended way to run the docker container, but it is an easy way to get started.* Use it as an example when you want to test the recommender engine.
```
docker-compose -f docker-compose.yml -f docker-compose.withssl.yml -p organicity up -d
```
You can run it without SSL termination and lets encrypt
```bash
docker-compose -f docker-compose.yml -p organicity
```

### How to run and access your new Docker container
To manually start the recommender engine and start a database for it, here are some examples of what you can do. This is the recommended way of staring your containers.
#### First we need a common network
This network will be used for inter service communication.
```
docker network create organicity_backend
```
#### First lets start a database
```
docker run -d \
   -e POSTGRES_DB=pio \
   -e POSTGRES_USER=admin \
   -e POSTGRES_PASSWORD=1234 \
   --network organicity_backend \
   --name piodb postgres:9.6
```
It can of course also be started with additional parameters to for example preserve files, by mounting a directory on the host machine or using a data volume.
```
docker run -d \
   -v ~/piodb:/var/lib/postgresql/data \
   -e POSTGRES_DB=pio \
   -e POSTGRES_USER=admin \
   -e POSTGRES_PASSWORD=1234 \
   --network organicity_backend \
   --name piodb postgres:9.6
```
or
```
docker volume create piodb
docker run -d \
   -v piodb:/var/lib/postgresql/data \
   -e POSTGRES_DB=pio \
   -e POSTGRES_USER=admin \
   -e POSTGRES_PASSWORD=1234 \
   --network organicity_backend \
   --name piodb postgres:9.6
```

#### Then start the recommender engine
The docker image has already a built version of the Similar Product engine built it. On the first run of the image, it will import data from OrganiCity by running a updated version of the *import_eventserver.py* script. Note that this will take some time forst time the container is started. Progress can be followed by issuing the following command.
```
docker logs -f pioengine
```
**PLEASE NOTE** that this is an example. Passwords should be changed for real world deployments, and if for example you are using SSL proxying with lets encrypt - then you should not expose the ports.
```
docker run -d \
   -p 8000:8000 -p 7070:7070 \
   -e PIO_STORAGE_SOURCES_PGSQL_URL=jdbc:postgresql://piodb/pio \
   -e PIO_STORAGE_SOURCES_PGSQL_USERNAME=admin \
   -e PIO_STORAGE_SOURCES_PGSQL_PASSWORD=1234 \
   -v /dev/urandom:/dev/random \
   --network organicity_backend \
   --name pioengine \
   synchronicityiot/recommender:latest
```
you may have to add the following on some machines. The problem is the random generator on some hosts. Either feed the container your own access key like in the example, or mount the hosts urandom in the container.
```
-e INITIAL_ACCESS_KEY=GILr_2yCYe5vZSio0NXkUzkmZvVTNuzOe__PhXgzxn9Bc0VHm5_4VICMNkIclubn \
or
-v /dev/urandom:/dev/random \
```
#### Optional SSL reverse proxy with lets encrypt
There are of course a ton of settings, but something like this works.
```
docker volume create piossl
docker run -d \
   -v piossl:/var/lib/https-portal \
   -p 80:80 -p 443:443 \
   -e STAGE=production \
   -e DOMAINS='recommender.organicity.eu -> http://pioengine:7070, recommenderq.organicity.eu -> http://pioengine:8000' \
   --network organicity_backend \
   --name piossl \
   steveltn/https-portal:1
```
#### How to get the access key
You can always run a command in a docker container, and retreive for example the access token.
```
docker exec -it pioengine pio app list
```

### How to remove your Docker image
```
docker stop pioengine
docker rm pioengine
```
### Check stats for docker
```
docker stats $(docker ps --format={{.Names}})
```
