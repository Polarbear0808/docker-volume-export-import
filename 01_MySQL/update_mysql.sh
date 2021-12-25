#!/bin/bash
docker exec mysql1 \
    mysql -u root -ppass -e 'create database sample;'