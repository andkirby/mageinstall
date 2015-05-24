#!/bin/sh
# (POSIX shell syntax)

while :
do
    case $1 in
        -h | --help)
            # Show some help
            out=$(cat ../../doc/shell/logo)"\n"$(cat doc/shell/help)"\n"
            echo -e "$out"
            exit 0 # This is not an error, User asked help. Don't do "exit 1"
            ;;
        -p | --project)
            PROJECT="$2"
            shift 2
            ;;
        -t | --path)
            PROJECT_DIR="$2"
            shift 2
            ;;
        -H | --db-host)
            DB_HOST="$2"
            shift 2
            ;;
        -u | --db-user)
            DB_USER="$2"
            shift 2
            ;;
        -P | --db-password)
            DB_PASSWORD="$2"
            shift 2
            ;;
        -n | --db-name)
            DB_NAME="$2"
            shift 2
            ;;
        -d | --domain)
            PROJECT_DOMAIN="$2"
            shift 2
            ;;
        -s | --secured-protocol)
            case "$2" in
                https | HTTPS | http | HTTP) PROTOCOL_SECURED="$2" ;;
                *) echo "Err: Unknown value \"$2\"" 1>&2; exit 1 ;;
            esac
            shift 2
            ;;
        -r | --use-rewrites)
            case "$2" in
                "no" | "yes") USE_REWRITES="$2" ;;
                *) echo "Err: Unknown value \"$2\"" 1>&2; exit 1 ;;
            esac
            shift 2
            ;;
        --admin-username)
            ADMIN_USERNAME="$2"
            shift 2
            ;;
        --admin-password)
            ADMIN_PASSWORD="$2"
            shift 2
            ;;
        -e | --admin-email)
            ADMIN_EMAIL="$2"
            shift 2
            ;;
        -S | --skip-all-run)
            INSTALL_RUN=false
            IMPORT_RUN=false
            SAMPLE_DATA_CONFIG_RUN=false
            SAMPLE_DATA_SQL_RUN=false
            SAMPLE_DATA_MEDIA_RUN=false
            shift 1
            ;;
        -i | --install-run)
            setBoolean INSTALL_RUN "$2"
            shift 2
            ;;
        -I | --import-run)
            setBoolean IMPORT_RUN "$2"
            shift 2
            ;;
        -c | --config-run)
            setBoolean SAMPLE_DATA_CONFIG_RUN "$2"
            shift 2
            ;;
        -q | --sample-data-sql-run)
            setBoolean SAMPLE_DATA_SQL_RUN "$2"
            shift 2
            ;;
        -m | --sample-data-media-run)
            setBoolean SAMPLE_DATA_MEDIA_RUN "$2"
            shift 2
            ;;
        -x | --media-dir-permissions)
            MEDIA_DIR_PERMISSIONS="$2"
            shift 2
            ;;
        -X | --media-dir-owner)
            MEDIA_DIR_OWNER="$2"
            shift 2
            ;;
        -*)
            printf >&2 'WARN: Unknown option (ignored): %s\n' "$1"
            shift
            ;;
        *)  # no more options. Stop while loop
            break
            ;;
        --) # End of all options
        echo "End of all options"
            shift
            break
            ;;
    esac
done
