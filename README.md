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
To manually start the recommender engine and start a database for it, here are some examples of what you can do.  
First lets start a database
```
docker run -d \
   -e POSTGRES_DB=pio \
   -e POSTGRES_USER=admin \
   -e POSTGRES_PASSWORD=1234 \
   --name piodb postgres:9.6
```
It can of course also be started with aditional parameters to for example preserve files, by mounting a directory on the host machine.
```bash
docker volume create pgdata
```

This will run the "boot.sh" setup script. Which will build + train + deploy
PredictionIO with the Similar Product engine. You should note the Access key
in the terminal output.


### How to remove your Docker image
```
docker stop piorecommend
docker rm piorecommend
```
