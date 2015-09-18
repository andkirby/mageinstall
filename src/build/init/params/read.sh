#!/usr/bin/env bash
# set default minimum-stability
echo ""
user_message "Set your parameters..." 0
params=(\
"PACKAGE_MINIMUM_STABILITY:Minimum Stability:stable|RC|beta|alpha|dev:stable" \
"PACKAGE_PREFER_STABLE:Composer package prefer-stable value:boolean:false" \
"PACKAGE_DEPLOY_STRATEGY:Deploy strategy:copy|symlink:copy" \
"PACKAGE_DEPLOY_FORCE:Force deploying when the same file exists:boolean:true" \
"MAGENTO_DIR:Pure Magento files directory (if empty set as a parameter)" \
)

filledParams=()
for item in "${params[@]}"; do

    IFS=':' read -ra ADDR <<< "$item"
    key=${ADDR[0]}
    comment=${ADDR[1]}
    values=${ADDR[2]}
    suggest=${ADDR[3]}
    default=${!key}

    if [ -z "$default" ] ; then
        default=${suggest}
    fi

    if [ "$values" = "boolean" ] ; then
        VALUES="|yes|no|YES|NO|true|false|TRUE|FALSE|1|0|"
    elif [ "$values" ] ; then
        VALUES="|$values|"
    fi

    while true; do

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
user_message "Writing parameters into ~/.mageinstall/build/composer.json..." 1
if [ ! -d ~/.mageinstall/build ] ; then
    mkdir ~/.mageinstall/build
    if [ ! -d ~/.mageinstall/build ] ; then
        die "Directory ~/.mageinstall/build cannot be created."
    fi
fi

#set repository URLs
repositories=""
for i in "${PACKAGE_COMPOSER_URL[@]}"; do
    repositories="$repositories -c$i "
    user_message "Extra composer URL: $i" 2
done
json=$($PHP_BIN "$SRC_DIR"/build/lib/generate-composer-json.php \
    -s$PACKAGE_MINIMUM_STABILITY \
    -d$PACKAGE_DEPLOY_STRATEGY \
    -f$PACKAGE_DEPLOY_FORCE \
    -t$PACKAGE_PREFER_STABLE \
    $repositories)

hasError=$(echo $json | grep "Error:" 2>&1);
if [ "$hasError" ] ; then
    die "$json"
fi



