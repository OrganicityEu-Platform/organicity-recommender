### How to build and setup the Docker image
If you wish, you can choose to build the docker image yourself instead of pulling it from docker hub. This will take some time.
```
docker build -t your-organiztion-here/your-tag-here:your-version-here .
```

### Running with docker-compose including PostgreSQL and SSL termination
A docker-compose file has been created so you can easily get started. It will create a PostgresSQL database, SSL proxy and the recommender engine with a template Similar Product engine pre-instaled.
*This is not the recommended way to run the docker container, but it is an easy way to get started.* Use it as an example when you want to test the recommender engine.
```
docker-compose -f docker-compose.yml -f docker-compose.withssl.yml -p organicity
```
You can run it without SSL termination and lets encrypt
```bash
docker-compose -f docker-compose.yml -p organicity
```

### How to run and access your new Docker container
To manually start the recommender engine and start a database for it, here are some examples of what you can do. This is the recommended way of staring your containers. 
#### First lets start a database
```
docker run -d \
   -e POSTGRES_DB=pio \
   -e POSTGRES_USER=admin \
   -e POSTGRES_PASSWORD=1234 \
   --name piodb postgres:9.6
```
It can of course also be started with additional parameters to for example preserve files, by mounting a directory on the host machine or using a data volume.
```
docker run -d \
   -e POSTGRES_DB=pio \
   -e POSTGRES_USER=admin \
   -e POSTGRES_PASSWORD=1234 \
   -v ./postgres-data:/var/lib/postgresql/data
   --name piodb postgres:9.6
```
#### Then start the recommender engine
The docker image has already a built version of the Similar Product engine built it. On the first run of the image, it will import data from OrganiCity by running a updated version of the *import_eventserver.py* script.
```
docker run -d \
   -e PIO_STORAGE_SOURCES_PGSQL_URL=jdbc:postgresql://db/pio \
   -e PIO_STORAGE_SOURCES_PGSQL_USERNAME=admin \
   -e PIO_STORAGE_SOURCES_PGSQL_PASSWORD=1234
   --name pioengine \
   synchronicityiot/recommender:latest
```

#### How to get the access key
You can always run a command in a docker container, and retreive for example the access token.
```
docker exec -it piorecommend pio app list
```

### How to remove your Docker image
```
docker stop pioengine
docker rm pioengine
```
