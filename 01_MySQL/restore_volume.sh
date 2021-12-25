#!/bin/bash
set -eux
BACKUP_TAR_NAME=$1

docker run \
    --rm \
    --volumes-from mysql1 \
    --volume $PWD/backup:/backup \
    busybox tar xvf /backup/${BACKUP_TAR_NAME}.tar
