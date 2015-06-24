# MageInstall tool

## Intro

Tool for install/build Magento/Magento package from console.

## Features

### Package Building
Build Magento package. It takes your pure Magento copy and selected package and build them together.

### Installing

- base Magento install
- import products
- import system configuration
- add sample data SQL files
- add sample data media files
- clean up var directory and product media files cache before installation

# Building
## Using
Initializing.

`mageshell build init -d symlink -s stable -m /path/to/magento -c http://your-composer-satis.com/`

Building.

`mageshell build -p projectname -g somevendor/packagename:1.0.5 -i 1`

Package directory will be created automatically (if it's not set) by mask `%project_directory%-package`.

More info: `mageshell build --help`.

## Structure
Usually you may have following files structure:
```
  /any/path/to/magento                      - Pure Magento directory
  /yourdocroot
      /project.com-package                  - package files dir (will be created automatically)
      /project.com                          - project HTTP dir
  ~/.mageinstall/build/composer.json        - composer.json distributive file
```
### CLI Parameters

    -h, --help, -?
        Get this help.

    -p, --project-http-dir
        Path to project HTTP directory.

    -m, --magento-source-dir
        Path to Magento directory.

    -k, --package-source-dir
        Path to package directory.

    -d, --package-deploy-strategy
        Composer package deploy strategy.
        Default:

    -s, --package-minimal-stability
        Composer package minimal stability.

    -g, --package
        Composer package (with version optionally).

    -c, --composer-repository-url
        Custom Composer repository URL.

    -i, --install-run
        Run Magento (re-)installing.
        It will use default installation approach which was initialized before.
        To prevent installation please use "false" parameter.
        It will use "-S" parameter of "mageshell install".
        Boolean value.


# Install
## Using
### Composer installation
```shell
$ composer require andkirby/mageinstall:@beta
```
### Initialization
If you haven't initialized **MageInstall** it will suggest you to initialize by command `mageshell install`.<br>
Anyway if what to make reinitialization follow the command: 
```shell
$ mageshell install init
```
It will create the ~/.mageinstall/params.sh with your custom parameters.

### Install Magento
To run an installation of Magento instance you can make simple command:
```shell
$ mageshell install -p projectname
```
where

* "projectname" is a directory and DB name and DB user.

But it depends on your settings.

Also you may set up as you wish ~/.mageinstall/params.sh file within you local environment.
Just copy of params.sh.dist to ~/.mageinstall/params.sh and update it.

## Configuration

Usually, you should make following files structure:

       /htdocs
          /projectname        - project directory
          /sample_data        - sample data dir
              /projectname    - project sample data dir
                  /sample
                      /media      - some "sample" dir which will be
                                    copied into target Magento dir
                      /*.sql      - sample data SQL files
                  /import     - import directory
                      /*.csv  - import CSV files
                  /*.csv      - config CSV files

`sample_data` inner directories structure cannot be changed.

### Config files in project
Also you may put your configuration files within project by path:
`PROJECT_DIR/shell/mageshell/config`.
There are should be CSV files. You may make any directories structure within this directory.

If you would you like to make some fixes feel free to make it and add pull request. Or add an issue.

## Console parameters

```
        -h, --help, -?
            Get this help.

        -p, --project [REQUIRED]
            Project name.
            Param PROJECT.

        -t, --path
            Path to project directory.
            Param PROJECT_DIR.

        -H, --db-host
            Database connection hostname.
            Param DB_HOST.

        -u, --db-user
            Database connection username.
            Param DB_USER

        -P, --db-password
            Database connection password.
            DB_PASSWORD

        -n, --db-name
            Database name.
            Param DB_NAME

        -d, --domain
            Web domain.
            Param PROJECT_DOMAIN

        -s, --secured-protocol)
            Secured protocol string.
            Param PROTOCOL_SECURED = https|http

        -r, --use-rewrites
            Use Apache rewrites.
            Param USE_REWRITES = yes|no

        --admin-username
            Administrator username in Admin Panel.
            Param ADMIN_USERNAME

        --admin-password
            Administrator password in Admin Panel.
            Param ADMIN_PASSWORD

        -e, --admin-email [REQUIRED]
            Administrator email in Admin Panel.
            Param ADMIN_EMAIL
            Required if it is not set in ~/.mageinstall/params.sh file.

        -S, --skip-all-run
            Reset run params.
            INSTALL_RUN=false
            IMPORT_RUN=false
            SAMPLE_DATA_CONFIG_RUN=false
            SAMPLE_DATA_SQL_RUN=false
            SAMPLE_DATA_MEDIA_RUN=false

        -i, --install-run
            Run installation.
            Param INSTALL_RUN = yes|no|true|false|1|0

        -I, --import-run)
            Run importing.
            Param IMPORT_RUN = yes|no|true|false|1|0

        -c, --config-run
            Run setting configuration from a file.
            Param SAMPLE_DATA_CONFIG_RUN = yes|no|true|false|1|0

        -C, --project-config-run
            Run setting configuration from a file withing project directory/es.
            PROJECT_DIR/shell/mageshell/config
            Param PROJECT_CONFIG_RUN = yes|no|true|false|1|0

        -q, --sample-data-sql-run)
            Run importing sample data SQL files.
            Param SAMPLE_DATA_SQL_RUN = yes|no|true|false|1|0

        -m, --sample-data-media-run
            Run copying sample data files.
            Param SAMPLE_DATA_MEDIA_RUN = yes|no|true|false|1|0

        -x, --media-dir-permissions
            "media", "var", "app/etc" directories permissions.
            Param MEDIA_DIR_PERMISSIONS.

        -X, --media-dir-owner
            "media", "var", "app/etc" directories owner username.
            Param MEDIA_DIR_OWNER.

Boolean means any value of yes, no, true, false, 1, 0.
```

## Quick set up examples
Let's consider some configurations how to use it within some environment.
There are examples of `~/.mageinstall/params.sh` file.

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
    PROJECT_DOMAIN_MASK="cool-domain-__PROJECT__.example.com"
    ADMIN_USERNAME="admin"
    ADMIN_PASSWORD="pasSs3v"
    ADMIN_EMAIL="projname-__PROJECT__@example.com"
    PROJECT_DIR="__DOCROOT__"
    IMPORT_DIR="__SAMPLE_DIR__/import"

"projname" is static.

Commands to install

    $ mageinstall -p dev
    $ mageinstall -p qa
    $ mageinstall -p stage

### Windows

`~/.mageinstall/params.sh` for XAMPP with usual paths:

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
