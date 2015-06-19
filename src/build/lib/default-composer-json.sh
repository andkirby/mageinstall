#!/usr/bin/env bash
# set default minimum-stability
echo ""
echo "Set your parameters..."
params=(\
"PACKAGE_MINIMUM_STABILITY:Minimum Stability:stable|RC|beta|alpha|dev:stable" \
"PACKAGE_DEPLOY_STRATEGY:Deploy strategy:copy|symlink:copy" \
#"PACKAGE_COMPOSER_URL:URL to your composer repository (if you have)" \
"MAGENTO_DIR:Pure Magento files directory (if empty set as a parameter)" \
"INSTALL_PARAMS:Extra installation parameters. Help: 'mageshell install --help'." \
#"PROJECT_DIR:Path to your Magento directory" \
)

filledParams=()
for item in "${params[@]}"; do

    IFS=':' read -ra ADDR <<< "$item"
    key=${ADDR[0]}
    comment=${ADDR[1]}
    values=${ADDR[2]}
    default=${!key}

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
        export "$key"="$answer"
    fi
    filledParams+=("$key=\"$answer\"")
done

# Write ~/.mageinstall/build/composer.json
echo "Writing parameters into ~/.mageinstall/build/composer.json..."
if [ ! -d ~/.mageinstall/build ] ; then
    mkdir ~/.mageinstall/build
    if [ ! -d ~/.mageinstall/build ] ; then
        echo "Directory ~/.mageinstall/build cannot be created."
    fi
fi

#set repository URLs
repositories=""
for i in "${PACKAGE_COMPOSER_URL[@]}"
do
    repositories="$repositories -c$i "
done
json=$($PHP_BIN "$SRC_DIR"/build/lib/generate-composer-json.php \
    -s$PACKAGE_MINIMUM_STABILITY \
    -d$PACKAGE_DEPLOY_STRATEGY \
    $repositories)

hasError=$(echo $json | grep "Error:" 2>&1);
if [ "$hasError" ] ; then
    echo "$json"
    exit 1
fi

echo "$json" > ~/.mageinstall/build/composer.json

# Write ~/.mageinstall/build/composer.json
echo "Writing parameters into ~/.mageinstall/build/params.sh..."
( IFS=$'\n'; echo "${filledParams[*]}" ) > ~/.mageinstall/build/params.sh
