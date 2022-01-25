#!/bin/bash

# Stop and remove containers, networks, images, and volumes
docker-compose rm -fs postgres
{
  docker volume rm admin_manager_db-data
} &> /dev/null


# Read remote database name & password from user
echo "Remote database host:"
read REMOTE_DB_HOST

echo "Remote database user:"
read REMOTE_DB_USER

REMOTE_DB_NAME="metabase"

echo "Remote database password:"
read -s REMOTE_DB_PW
# REMOTE_DB_PW="2JoGCygryFmb0fuG"

# Start progrecess
echo -e "On processing ..."

echo -e "Up postgres"
docker-compose up -d postgres

echo -e "Dump database from remote DB"
docker-compose run postgres \
	pg_dump postgres://$REMOTE_DB_USER:$REMOTE_DB_PW@$REMOTE_DB_HOST:5432/$REMOTE_DB_NAME \
	> $REMOTE_DB_NAME.sql

echo -e "Done ..."
docker-compose down -v
