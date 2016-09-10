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

If you would you like to make some fixes feel free to make it and add pull request or add an issue.

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
