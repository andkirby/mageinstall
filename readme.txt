======================== Tool for install Magento from console. ========================
. Features:
. - base install
. - import products
. - import configuration
. - add sample data SQL files
. - add sample data media files
. - clean up var directory and product media files before installation
.
. You should make following files structure:
.   /yourdocroot
.       /projectname        - project directory
.       /sample_data        - sample data dir
.           /projectname    - project sample data dir
.               /media      - media directory with media files
.               /import     - import directory
.                   /*.csv  - import CSV files
.               /*.csv      - config CSV files
.               /*.sql      - sample data SQL files
.
. Would you like make some fixes? Ask me - andkirby@gmail.com.
.
.        -h, --help, -?
.            Get this help.
.
.        -p, --project [REQUIRED]
.            Param PROJECT.
.            REQUIRED
.
.        -H, --db-host
.            Param DB_HOST.
.
.        -u, --db-user
.            Param DB_USER
.
.        -P, --db-password
.            DB_PASSWORD
.
.        -n, --db-name
.            Param DB_NAME
.
.        -d, --domain
.            Param PROJECT_DOMAIN
.
.        -s, --secured-protocol)
.            Param PROTOCOL_SECURED = https|http
.
.        -r, --use-rewrites
.            Param USE_REWRITES = yes|no
.
.        --admin-username
.            Param ADMIN_USERNAME
.
.        --admin-password
.            Param ADMIN_PASSWORD
.
.        -e, --admin-email [REQUIRED]
.            Param ADMIN_EMAIL
.            Required if it is not set in params.sh file.
.
.        -S, --skip-all-run
.            Reset run params.
.            INSTALL_RUN=false
.            IMPORT_RUN=false
.            SAMPLE_DATA_CONFIG_RUN=false
.            SAMPLE_DATA_SQL_RUN=false
.            SAMPLE_DATA_MEDIA_RUN=false
.
.        -i, --install-run
.            Param INSTALL_RUN = yes|no|true|false|1|0
.
.        -I, --import-run)
.            Param IMPORT_RUN = yes|no|true|false|1|0
.
.        -c, --config-run
.            Param SAMPLE_DATA_CONFIG_RUN = yes|no|true|false|1|0
.
.        -q, --sample-data-sql-run)
.            Param SAMPLE_DATA_SQL_RUN = yes|no|true|false|1|0
.
.        -m, --sample-data-media-run
.            Param SAMPLE_DATA_MEDIA_RUN = yes|no|true|false|1|0
