#!/bin/bash

rm -vf ./sisel.keytab

kadmin addprinc -randkey HTTP/sisel.caa.cz@SISEL.CAA.CZ

kadmin ktadd -k ./sisel.keytab HTTP/sisel.caa.cz@SISEL.CAA.CZ
