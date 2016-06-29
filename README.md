# MariaDB Docker Container

This service creates a MariaDB installation on a Centos 7 base image. It allows you to set the root password and
(optionally) an additional user/password/database to initialize. 
 
# Installation

Docker and Docker-Compose are required to run this application, which are packaged 
together for Mac and Windows users into [Docker Toolbox](https://www.docker.com/products/docker-toolbox),
for Linux users, follow the instructions for installing  the 
[Docker Engine](https://docs.docker.com/engine/installation/) and [Docker Compose](https://docs.docker.com/compose/install/).

# Building the MariaDB service

After installing the Docker dependencies, run the following from the command line 
at the root of this directory :

```
make docker
```

That command will build an image (using the `Dockerfile` "recipe" in this project folder)
from which containers can be created.

# Running the Container

This container can be run from the command line like this:

```bash
docker run --name=centosmariadb-data -v /var/lib/mysql arizonatribe/centosmariadb /bin/bash
docker run --name=centosmariadb -d --volumes-from=mariadb-data -e MYSQL_ROOT_PASSWORD=<password> arizonatribe/centosmariadb
```

Those commands build a data container (to persist the data in a docker volume) 
as well as the mariadb containerized service. It is linked to the data container (which was exposed as a 
docker volume). The service also has a root password passed in as an environment
variable (see below for additional variables that can be set).

The `mysqld` service has many additional command-line options to fine-tune the service
and due to the way this docker image is configured, you can pass any of those options
to this container as if you were passing them to the `mysqld` CLI directly. Just
pass a command to override the default "optionless" `mysqld_safe` command, placing
them at the end of the `docker run` command listed above, for example:

```bash
docker run --name=centosmariadb -d --build-arg MARIA_VERSION=10.1.13 --volumes-from=mariadb-data -e MYSQL_ROOT_PASSWORD=<password> centosmariadb mysqld_safe --log-error=/var/log/mysql.err --pid-file=/var/run/mysqld.pid
```
These options are more easily committed to a `docker-compose.yml` file if they become this lengthy.
The settings from the previous commands would appear in a `docker-compose.yml` file like this:

```yaml
version: '2'
services:
  mariadb-data:
    build: 
      context: ./
      args:
        - MARIA_VERSION=10.1.13
    image: arizonatribe/centosmariadb:latest
    volumes:
      - /var/lib/mysql
    entrypoint: /bin/bash
  mariadb:
    build: 
      context: ./
      args:
        - MARIA_VERSION=10.1.13
    image: arizonatribe/centosmariadb:latest
    container_name: centosmariadb
    volumes_from:
      - mariadb-data
    environment:
      - MYSQL_ROOT_PASSWORD=<password>
```

This file (if placed in the same directory as the Dockerfile, as indicated by the `build: ./` line)
would be executed from the command line from the project root directory:

```bash
docker-compose up --build
```

This builds the image(s) first, and then instantiates the two containers together. If you wish to
separate building and running into different commands, you can do so too:

```bash
docker-compose build
docker-compose up
```

# Environment variables

* __MYSQL_ROOT_PASSWORD__ - The (required) root user password.
* __MYSQL_ALLOW_EMPTY_PASSWORD__ - An boolean value that must be set to `true` if the root password is not being provided to the container. 
* __MYSQL_DATABASE__ - A database to create.
* __MYSQL_USER__ - A non-root user to set up (must also include a password).
* __MYSQL_PASSWORD__ - A password for the non-root user being set up.
* __MARIA_VERSION__ - When _building_ the image, you can set a version corresponding with those found at http://yum.mariadb.org (defaults to 10.1)