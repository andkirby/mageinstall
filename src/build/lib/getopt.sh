#!/bin/sh
# (POSIX shell syntax)

while :
do
    case $1 in
        -h | --help | -\?)
            # Show some help
            out=$(cat doc/shell/readme)
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
        -R | --refresh-magento-files)
            setBoolean MAGENTO_REFRESH "$2"
            shift 2
            ;;
        -k | --package-dir)
            PACKAGE_DIR="$2"
            shift 2
            ;;
        -g | --package)
            PACKAGE="$2"
            shift 2
            ;;
        -i | --install-run)
            setBoolean INSTALL_RUN "$2"
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
