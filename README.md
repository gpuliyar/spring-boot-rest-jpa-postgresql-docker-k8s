# spring-boot-rest-jpa-postgresql-docker-k8s
Project shows a sample REST application built using Spring Boot, JPA, and PostgreSQL and deployed in Kubernetes Cluster

## First, let's understand what the project uses
* The Project uses Spring Boot, JPA, and REST to build a simple service
* The Project relies on PostgreSQL as the backend RDBMS

## Note to remember
> The article will not explain what Container, Docker, Dockerfile, Docker-Compose, Kubernetes, etc. is. You should know what it is all about. The article intends to create a simple Spring Boot REST API that connects to a PostgreSQL database using JPA. That's it!

## Pre-requisite
Git clone the project

## Second, let's start the DB
Now let us try to start the PostgreSQL database. In this step, I will follow a bit more secured approach by setting up a default account password, a new username and password as part of the initialization. Why am I doing this? To avoid exposing the database with the default password. Is it very secure? Nope. It is still better than using the default username with an empty password approach. To understand how the default admin password set and a new username and password created with full read/write access to a database file, refer the script in the path: `psql/init/01-init-db.sh`. Understand the input parameters in the script. The article will not explain more about the Dockerfile or the init scripts. Hopefully, you know how PostgreSQL works and what is the significance of the init scripts and how it consumes it.

#### Let's build the container image and run it
##### Change the directory and navigate to the PostgreSQL folder
```
cd spring-boot-rest-jpa-postgresql-docker-k8s/psql/
```

##### Let's build the image
```
sudo docker build -t postgresql .
```

##### Let's create a database volume where the data file resides
```
docker volume create psql_db_volume
```

##### Now, let's run the database
> As you already know, the init script needs the following input parameters to run the database. 
```
1. PSQL_DB_USER
2. PSQL_DB_PASSWORD
3. PSQL_DB_DATABASE
4. POSTGRES_PASSWORD
```
> So, we will pass the input parameters when running the Container. Before that, we need to create an environment file which we will provide as an input parameter for the Container Run. Let's create the file.

```
cat <<EOT >> postgresql.env
PSQL_DB_USER=psql_db_user
PSQL_DB_PASSWORD=x8TTj4hnfA8T4Fm
PSQL_DB_DATABASE=psql_db
POSTGRES_PASSWORD=H7n5GZTpAz5aN8a
EOT
```

> Let's now run the Container
```
sudo docker run --rm --name <container name> --env-file <environment file name> -d -p <port id>:<port id> -v <volume name>:/var/lib/postgresql/data <container image name>
```
> The command will look like:
```
sudo docker run --rm --name postgresql_container --env-file postgresql.env -d -p 5432:5432 -v psql_db_volume:/var/lib/postgresql/data postgresql
```

##### Check the Container Logs to ensure the Container started successfully
```
sudo docker container logs postgresql_container
```

> Sample log will look like:
```
PostgreSQL init process complete; ready for start up.

2019-03-21 03:54:57.088 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2019-03-21 03:54:57.088 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2019-03-21 03:54:57.103 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2019-03-21 03:54:57.128 UTC [44] LOG:  database system was shut down at 2019-03-21 03:54:57 UTC
2019-03-21 03:54:57.137 UTC [1] LOG:  database system is ready to accept connections
```

## Third, let's understand the App project
The article won't explain the Sprint Boot project. Let's focus on the `application.properties` file. As you can see the properties file relies on the following environment variables to run successfully. The properties file found at `app\src\main\resources\application.properties`
```
1. PSQL_DB_HOST
2. PSQL_DB_PORT
3. PSQL_DB_NAME
4. PSQL_DB_USER
5. PSQL_DB_PASSWORD
```
> If you would like, configure these input parameters in your local machine using any IDE. I use IntelliJ to test and run the project.
> Sample input will look like:

```
1. PSQL_DB_HOST=172.20.50.167 # (that is the IP address of the machine where I deployed the PostgreSQL container)
2. PSQL_DB_PORT=5432
3. PSQL_DB_NAME=psql_db
4. PSQL_DB_USER=psql_db_user
5. PSQL_DB_PASSWORD=x8TTj4hnfA8T4Fm
```
> Remember, the username, password, and the DB name are the same info that we used in the previous setup of the PostgreSQL container. You can ignore testing the functionality in your local installation. It is not a mandate. In case if you are interested in running the application and checking the feature locally, then feel free to try it.

> Before we go to the next stage, let's first clean up DB container and the related volume in order to avoid conflicts

##### Find the container id of the PostgreSQL
```
sudo docker ps
```
> In my case, the ID was f232b752dd44. I will use the same ID to stop and remove it. In your case, use your relevant ID.

##### Stop and remove the PostgreSQL Container
```
sudo docker stop <container id>
sudo docker rm <container id>
```

##### Remove the PostgreSQL volume
```
sudo docker volume rm psql_db_volume
```

## Fourth, let's understand the `app` Dockerfile
> Note: we will not test the App Dockerfile the way we verified the DB Dockerfile. 
As you would have noticed, the app Dockerfile has two stages in it. The first stage involves building the application jar. The second stage consists in building a container image using the JAR file built as part of the first stage.

##### Why do we have two stages in the `app` Dockerfile
To avoid setting up additional build system to test the functionality. For instance, as you know, the project uses Gradle as it's build system. And obviously, it needs JDK to compile the code. So if you want to test the feature, then your system should already have Gradle and JDK in it. Now that's not the end of it. There is multiple version of Gradle and JDK. You need to ensure that the JDK version and Gradle that you use in your setup works with this code. OK, so in short, it is a lot of setup work to test this project. OK, that kind of beats of the purpose of calling it a simple plan to test functionality. So what can we do? Well, I shipped the build system as part of one stage in the Dockerfile, so you don't need to worry about what version of JDK or Gradle to use. Just run the Dockerfile; it will take care of compiling and packaging the project.

