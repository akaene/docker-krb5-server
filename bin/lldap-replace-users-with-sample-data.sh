#!/bin/bash

# start services
docker-compose up lldap -d

# replace users
LDAP_CONTAINER=$(docker-compose ps -q lldap)
docker cp users.db ${LDAP_CONTAINER}:/data/users.db

# restart lldap service
docker-compose restart lldap
