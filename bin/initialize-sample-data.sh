#!/bin/bash

echo
echo Replacing lldap users from sample data ...
./bin/lldap-replace-users-with-sample-data.sh

echo
echo Adding KDC users ...
./bin/kdc-addusers.sh

echo
echo Adding sisel.keytab ...
./bin/create-sisel-keytab.sh
