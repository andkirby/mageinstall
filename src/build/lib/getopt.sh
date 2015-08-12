#!/bin/sh
# (POSIX shell syntax)
PACKAGE_COMPOSER_URL=()
VERBOSITY=false
VERBOSITY_VERY=false
VERBOSITY_VERY_VERY=false
VERBOSITY_PARAM=''
INTERACTION_PARAM=''

while :
do
    case $1 in
        -h | --help | -\?)
            # Show some help
            out=$(cat "$SRC_DIR"/doc/shell/logo)"\n"$(cat "$SRC_DIR"/build/doc/shell/help)
            echo -e "$out"
            exit 0 # This is not an error, User asked help. Don't do "exit 1"
            ;;
        -p | --project)
            PROJECT="$2"
            shift 2
            ;;
        -m | --magento-source-dir)
            MAGENTO_DIR="$2"
            shift 2
            ;;
        -R | --clear-all)
            setBoolean REFRESH_ALL "$2"
            shift 2
            ;;
        -k | --package-dir)
            PACKAGE_DIR="$2"
            shift 2
            ;;
        -d | --package-deploy-strategy)
            PACKAGE_DEPLOY_STRATEGY="$2"
            shift 2
            ;;
        -t | --package-prefer-stable)
            PACKAGE_PREFER_STABLE="$2"
            shift 2
            ;;
        -s | --package-minimal-stability)
            PACKAGE_MINIMAL_STABILITY="$2"
            shift 2
            ;;
        -g | --package)
            PACKAGE="$2"
            shift 2
            ;;
        -c | --composer-repository-url)
            PACKAGE_COMPOSER_URL+=("$2")
            shift 2
            ;;
        -i | --install-run)
            setBoolean PACKAGE_INSTALL_RUN "$2"
            shift 2
            ;;
        -n | --composer-no-interaction)
            COMPOSER_NO_INTERACTION=true
            INTERACTION_PARAM='-n'
            shift 1
            ;;
        -v)
            VERBOSITY=true
            VERBOSITY_PARAM="-v"
            shift 1
            ;;
        -vv)
            VERBOSITY=true
            VERBOSITY_VERY=true
            VERBOSITY_PARAM="-vv"
            shift 1
            ;;
        -vvv)
            VERBOSITY=true
            VERBOSITY_VERY=true
            VERBOSITY_VERY_VERY=true
            VERBOSITY_PARAM="-vvv"
            shift 1
            ;;
        -*)
            printf >&2 'WARN: Unknown build option (ignored): %s\n' "$1"
            shift
            ;;
        *)  # no more options. Stop while loop
            break
            ;;
        --) # End of all options
        echo "End of all build options"
            shift
            break
            ;;
    esac
done
