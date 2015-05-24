#!/usr/bin/env bash
# set default minimum-stability
MINIMUM_STABILITY="stable"

echo "Set your parameters..."
echo ""
params=(\
"MINIMUM_STABILITY:Minimum Stability:stable|RC|beta|alpha|dev" \
"EXTRA_COMPOSER_URL:URL to your composer repository (if you have)" \
#"PROJECT_DIR:Path to your Magento directory" \
)
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
done

# Write ~/.mageinstall/params.sh
echo "Writing parameters into ~/.mageinstall/build/composer.json..."
if [ ! -d ~/.mageinstall/build ] ; then
    mkdir ~/.mageinstall/build
    if [ ! -d ~/.mageinstall/build ] ; then
        echo "Directory ~/.mageinstall/build cannot be created."
    fi
fi
json=$($PHP_BIN "$SRC_DIR"/build/lib/generate-composer-json.php -p$PROJECT_DIR -s$MINIMUM_STABILITY -c$EXTRA_COMPOSER_URL)
hasError=$(echo $json | grep "Error:" 2>&1);
if [ "$hasError" ] ; then
    echo "$json"
    exit 1
fi

echo "$json" #> ~/.mageinstall/build/composer.json
exit
