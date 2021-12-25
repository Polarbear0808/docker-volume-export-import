#!/bin/bash
docker run \
    --detach \
    --interactive \
    --tty \
    --name  mysql1 \
    --volume myvol1:/var/lib/mysql \
    --env   MYSQL_ROOT_PASSWORD=pass \
    mysql:8.0.26