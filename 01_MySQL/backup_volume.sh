#!/bin/bash
set -eu
BACKUP_TAR_NAME=$1

docker run \
    --rm \
    --volumes-from mysql1 \
    --volume $PWD:/backup \
    busybox tar cvf /backup/${BACKUP_TAR_NAME}.tar /var/lib/mysql
