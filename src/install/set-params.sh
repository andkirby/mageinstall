#!/bin/sh

. "$SRC_DIR/install/params.sh.dist"

. "$SRC_DIR/lib/function.sh"

function getUserParam() {
    local PROJECT DB_HOST DB_USER DB_PASSWORD DB_NAME PROJECT_DOMAIN_MASK PROTOCOL_SECURED USE_REWRITES ADMIN_USERNAME ADMIN_PASSWORD ADMIN_EMAIL INSTALL_RUN IMPORT_RUN SAMPLE_DATA_SQL_RUN SAMPLE_DATA_MEDIA_RUN SAMPLE_DATA_CONFIG_RUN ROOT SAMPLE_DATA_DIR IMPORT_DIR PROJECT_DIR MYSQL_BIN PHP_BIN
    if [ -f $(cd ~; pwd)"/.mageinstall/params.sh" ] ; then
        . ~/.mageinstall/params.sh
    fi
    echo "${!1}"
}

echo "Set your parameters..."
echo "Variables:"
echo "__PROJECT__    - Project parameter. It should be passed from command line."
echo "__DOCROOT__    - Document root directory."
echo "__SAMPLE_DIR__ - Sample data directory."
echo ""

params=(\
"DB_HOST:DB hostname" \
"DB_USER:DB username" \
"DB_PASSWORD:Database password" \
"PROJECT_DOMAIN_MASK:Domain pattern. Use __PROJECT__ to put project name automatically" \
"PROTOCOL_SECURED:Secured protocol. Use 'http' if you do not have HTTPS:http|https" \
"USE_REWRITES:Use Apache URL rewrites:yes|no" \
"ADMIN_USERNAME:Admin username" \
"ADMIN_PASSWORD:Admin password" \
"ADMIN_EMAIL:Admin email" \
"INSTALL_RUN:Run Magento installation:boolean" \
"IMPORT_RUN:Run Magento importing products:boolean" \
"SAMPLE_DATA_CONFIG_RUN:Run importing configuration files:boolean" \
"PROJECT_CONFIG_RUN:Run importing project configuration files:boolean" \
"SAMPLE_DATA_SQL_RUN:Run importing sample data SQL files:boolean" \
"SAMPLE_DATA_MEDIA_RUN:Run importing sample data media files:boolean" \
"ROOT:Document Root" \
"SAMPLE_DATA_DIR:Sample data directory" \
"IMPORT_DIR:Product import files directory" \
"PROJECT_DIR:Project directory" \
"MYSQL_BIN:Path to MySQL client binary file" \
"PHP_BIN:Path to PHP binary file" \
)

nonDefault=()
while true :
do
    printf "Do you have several Magento projects? (yes|no) [yes] : "
    read answer
    case "$answer" in
        no)
            while [[ -z "$DB_NAME" ]] ; do
                userParam=$(getUserParam $DB_NAME)
                printf "Database name [$DB_NAME] : "
                read DB_NAME
            done
            nonDefault+=("DB_NAME=\"$DB_NAME\"")
            PROJECT_DOMAIN_MASK="project-__PROJECT__.localhost"
            break
            ;;
        yes | "") break ;;
    esac
done

for item in "${params[@]}"; do

    IFS=':' read -ra ADDR <<< "$item"
    key=${ADDR[0]}
    comment=${ADDR[1]}
    values=${ADDR[2]}
    default=${!key}

    userParam=$(getUserParam $key)
    if [ "$userParam" ] ; then
        default="$userParam"
    fi

    if [ "$values" = "boolean" ] ; then
        VALUES="|yes|no|YES|NO|true|false|TRUE|FALSE|1|0|"
    elif [ "$values" ] ; then
        VALUES="|$values|"
    fi

    while true
    do
        if [ "$values" ] ; then
            printf "$comment ($values) [$default] : "
        else
            printf "$comment [$default] : "
        fi

        read answer

        if [ -z "$answer" ] ; then
            answer="$default"
        fi
        if [ "$values" ] ; then
            f=`echo "$VALUES" | grep "|$answer|"`;
            if [ "$f" = "$VALUES" ] ; then
                # value matched
                break
            fi
            # value not matched
            continue
        fi
        break
    done

    if [ "${!key}" != "$answer" ] ; then
        nonDefault+=("$key=\"$answer\"")

        export "$key"="$answer"
    fi

done

# Write ~/.mageinstall/params.sh
echo "Writing parameters into ~/.mageinstall/params.sh..."
if [ ! -d ~/.mageinstall ] ; then
    mkdir ~/.mageinstall
    if [ ! -d ~/.mageinstall ] ; then
        echo "Directory ~/.mageinstall cannot be created."
    fi
fi
( IFS=$'\n'; echo "${nonDefault[*]}" ) > ~/.mageinstall/params.sh

echo "Finish!"
