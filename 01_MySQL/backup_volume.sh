#!/bin/bash
docker run \
    --rm \
    --volumes-from mysql1 \
    --volume $PWD:/backup \
    busybox tar cvf /backup/backup.tar /var/lib/mysql
