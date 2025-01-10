#!/bin/bash

USERNAMES=$(cat <<EOF
bradley
demarco
eisenhower
halsey
hood
lasky
montgomery
palmer
patton
sisel
thorne
EOF
)


docker-compose up kdc -d
sleep 3

for USERNAME in $USERNAMES; do
  echo Adding username $USERNAME ...
  kadmin addprinc -pw a $USERNAME
done
