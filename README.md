mageinstall
===========
h3. Start
# Create params.sh from example below and fill up your values.
# Copy params-protected.sh.dist to params-protected.sh and fill up you params.
# Run
{code}# install_full.sh -p projectname -e email@example.com{code}
where
   - "projectname" is a directory and DB name and DB user,
   - "email@example.com" is Magento default admin email.

Also you set up as you wish params.sh file within you local environment.
Just copy of params.sh.dist to params.sh and update it.

To apply only configuration file you can use -S param to reject all "run" scripts and enable configuration running.
{code}# install_full.sh -p projectname -e email@example.com -S -c 1{code}

h3. Parameters examples
Let's consider some example how to use it within some environment.

h4. Unix
h5. Several projects
{code}
#!/bin/sh
# DB_HOST="localhost"
# DB_USER="root"
# DB_PASSWORD=""
# DB_NAME=$(echo $PROJECT | tr . _)
ROOT="/usr/local/www/apache22/data"
SAMPLE_DATA_DIR="$ROOT/sample_data/$PROJECT"
# PROTOCOL_SECURED="https"
PROJECT_DOMAIN_MASK="%HOST%.cc"
# ADMIN_USERNAME="admin"
ADMIN_PASSWORD="project123"
ADMIN_EMAIL="yourname@example.com"
# USE_REWRITES="yes"
# PROJECT_DIR="$ROOT/$PROJECT"
# INSTALL_RUN=1
# IMPORT_RUN=1
# IMPORT_DIR="$SAMPLE_DATA_DIR/import"
{code}

h5. Single project for several servers
In example param will show one params file for QA, Staging and Dev servers.
{code}
DB_NAME="projname"
DB_USER="projname"
DB_PASSWORD="paSSworD1"
ROOT="/srv/www/htdocs"
SAMPLE_DATA_DIR="/srv/www/sample_data"
PROJECT_DOMAIN_MASK="projname-%HOST%.example.com"
ADMIN_USERNAME="admin"
ADMIN_PASSWORD="pasSs3v"
ADMIN_EMAIL="projname-%HOST%@example.com"
PROJECT_DIR="/srv/www/htdocs"
IMPORT_DIR="$SAMPLE_DATA_DIR/import"
{code}
"projname" is static.

Commands to install
{code}
# sh install_full.sh dev
# sh install_full.sh qa
# sh install_full.sh stage
{code}

h4. Windows
params.sh work with set up XAMPP:
{code}
#!/bin/sh
# DB_HOST="localhost"
# DB_USER="root"
# DB_PASSWORD="yourpassword"
# DB_NAME=$(echo $PROJECT | tr . _)
ROOT="/c/xampp/htdocs"
# SAMPLE_DATA_DIR="$ROOT/sample_data/$PROJECT"
# PROTOCOL_SECURED="https"
PROJECT_DOMAIN_MASK="%HOST%.site"
# ADMIN_USERNAME="admin"
ADMIN_PASSWORD="project123"
ADMIN_EMAIL="yourname@example.com"
# USE_REWRITES="yes"
# PROJECT_DIR="$ROOT/$PROJECT"
# INSTALL_RUN=1
# IMPORT_RUN=1
# IMPORT_DIR="$SAMPLE_DATA_DIR/import"
MYSQL_BIN="/c/xampp/mysql/bin/mysql.exe"
PHP_BIN="/c/xampp/php/php.exe"
{code}

