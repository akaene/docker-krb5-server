# Kerberos with LLDAP for SISel

This is a configuration of Kerberos and LLDAP for simulating the environment in which SISel runs at CAA.


It uses the gcavalcante8808/krb5-server image with MIT Kerberos v5 installed with Alpine as base image.


Just clone the repository and use docker compose to bring it up quickly:

```
    git clone https://github.com/akaene/docker-krb5-server.git
    cd docker-krb5-server
    docker compose up -d
```
 
`docker-compose.yml` contains configuration of passwords and realms to use. The Kerberos realm is called `SISEL.CAA.CZ` and this file assumes this name in the remainder.


## Prerequisites

Install the following package(s):

- `krb5-user` - see [usage section](#usage) how to configure `/etc/krb5.conf` during installation process
- `ldap-utils` - useful when you want to test querying the LDAP


## Usage

Kerberos authentication does not work very nicely when using localhost, so we need to update `/etc/hosts` so that our Kerberos acts like it is running on a domain. Add the following lines to the top of `/etc/hosts`:

```
127.0.0.1	sisel.caa.cz
127.0.0.1	kerberos.caa.cz
```

The first line is for SISel, the second line is for Kerberos authentication.


To acquire a ticket from the new domain, add to `/etc/krb5.conf` the following config into respective sections:

```
[libdefaults]
 dns_lookup_kdc = false
 dns_lookup_realm = false
 default_realm = SISEL.CAA.CZ
 
[realms]
 SISEL.CAA.CZ = {
    kdc = kerberos.caa.cz
    admin_server = kerberos.caa.cz
 }

```

After that changes you can successfully run `kinit` command mentioned below.

By Default just the user admin/admin@REALM is created; to test the setup, try to acquire the ticket with the following commands:

```
    kinit admin/admin@SISEL.CAA.CZ # Will prompt for the password provided (see KRB5_PASS in docker-compose.yml)
    klist
```


## Sample Data

This repository also contains sample users for the configuration. To import them, shut down the orchestration (`docker compose down`). Copy file `users.db` into the LLDAP service volume (by default in `/var/lib/docker/volumes/docker-krb5-server_lldap_data/_data`). Adding users to Kerberos is fairly simple:

1. Start the orchestration so that Kerberos is available (`docker compose up -d`)
1. Log in as admin (`kinit admin/admin@SISEL.CAA.CZ`)
2. Add users using the `kadmin` command, for example: `kadmin addprinc -pw pass patton` adds a user with username `patton` and password `pass`
3. You can list Kerberos users (principals) using `kadmin listprincs`

