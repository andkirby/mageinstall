# Mageinstall tool

## Start
1. Create params.sh from example below and fill up your values.
2. Copy params-protected.sh.dist to params-protected.sh and fill up you params.
3. Run similar command:

        install_full.sh -p projectname -e email@example.com

where

* "projectname" is a directory and DB name and DB user,
* "email@example.com" is Magento default admin email.

Also you set up as you wish params.sh file within you local environment.
Just copy of params.sh.dist to params.sh and update it.

To apply only configuration file you can use -S param to reject all "run" scripts and enable configuration running.

    install_full.sh -p projectname -e email@example.com -S -c 1

## Parameters examples
Let's consider some example how to use it within some environment.

### Unix
#### Several projects

    #!/bin/sh
    # DB_USER="root"
    # DB_PASSWORD=""
    ROOT="/usr/local/www/apache22/data"
    SAMPLE_DATA_DIR="$ROOT/sample_data/$PROJECT"
    PROJECT_DOMAIN_MASK="__PROJECT__.cc"
    ADMIN_PASSWORD="project123"
    ADMIN_EMAIL="yourname@example.com"


#### Single project for several servers
In example param will show one params file for QA, Staging and Dev servers.

    DB_NAME="projname"
    DB_USER="projname"
    DB_PASSWORD="paSSworD1"
    ROOT="/srv/www/htdocs"
    SAMPLE_DATA_DIR="/srv/www/sample_data"
    PROJECT_DOMAIN_MASK="projname-__PROJECT__.example.com"
    ADMIN_USERNAME="admin"
    ADMIN_PASSWORD="pasSs3v"
    ADMIN_EMAIL="projname-__PROJECT__@example.com"
    PROJECT_DIR="__DOCROOT__"
    IMPORT_DIR="__SAMPLE_DIR__/import"

"projname" is static.

Commands to install

    # sh install_full.sh dev
    # sh install_full.sh qa
    # sh install_full.sh stage

### Windows
params.sh work with set up XAMPP:

    #!/bin/sh
    DB_USER="root"
    DB_PASSWORD="yourpassword"
    ROOT="/c/xampp/htdocs"
    PROJECT_DOMAIN_MASK="__PROJECT__.site"
    ADMIN_USERNAME="admin"
    ADMIN_PASSWORD="project123"
    ADMIN_EMAIL="yourname@example.com"
    MYSQL_BIN="/c/xampp/mysql/bin/mysql.exe"
    PHP_BIN="/c/xampp/php/php.exe"

======================== Tool for install Magento from console. ========================

Features:

- base Magento install
- import products
- import configuration
- add sample data SQL files
- add sample data media files
- clean up var directory and product media files before installation

You should make following files structure:

       /yourdocroot
          /projectname        - project directory
          /sample_data        - sample data dir
              /projectname    - project sample data dir
                  /media      - media directory with media files
                  /import     - import directory
                      /*.csv  - import CSV files
                  /*.csv      - config CSV files
                  /*.sql      - sample data SQL files

Would you like make some fixes? Ask me - andkirby@gmail.com.

## Console parameters

       -h, --help, -?
           Get this help.

       -p, --project [REQUIRED]
           Param PROJECT.
           REQUIRED

       -H, --db-host
           Param DB_HOST.

       -u, --db-user
           Param DB_USER

       -P, --db-password
           DB_PASSWORD

       -n, --db-name
           Param DB_NAME

       -d, --domain
           Param PROJECT_DOMAIN

       -s, --secured-protocol)
           Param PROTOCOL_SECURED = https|http

       -r, --use-rewrites
           Param USE_REWRITES = yes|no

       --admin-username
           Param ADMIN_USERNAME

       --admin-password
           Param ADMIN_PASSWORD

       -e, --admin-email [REQUIRED]
           Param ADMIN_EMAIL
           Required if it is not set in params.sh file.

       -S, --skip-all-run
           Reset run params.
           INSTALL_RUN=false
           IMPORT_RUN=false
           SAMPLE_DATA_CONFIG_RUN=false
           SAMPLE_DATA_SQL_RUN=false
           SAMPLE_DATA_MEDIA_RUN=false

       -i, --install-run
           Param INSTALL_RUN = yes|no|true|false|1|0

       -I, --import-run)
           Param IMPORT_RUN = yes|no|true|false|1|0

       -c, --config-run
           Param SAMPLE_DATA_CONFIG_RUN = yes|no|true|false|1|0

       -q, --sample-data-sql-run)
           Param SAMPLE_DATA_SQL_RUN = yes|no|true|false|1|0

       -m, --sample-data-media-run
           Param SAMPLE_DATA_MEDIA_RUN = yes|no|true|false|1|0
