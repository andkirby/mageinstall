#!/usr/bin/env bash
#install a package
echo "Installing the package '$PACKAGE'..."
RESULT=$(cd "$PACKAGE_DIR" && composer require "$PACKAGE" 2>&1)
# show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error|Exception)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    die "Package requiring failed."
fi

# Installing
if [ -f $PACKAGE_DIR/composer.lock ] ; then
    rm -f $PACKAGE_DIR/composer.lock
fi

RESULT=$(cd "$PACKAGE_DIR" && composer install 2>&1)
# show result
echo "$RESULT"

hasError=$(echo "$RESULT" | grep -E "(failed|fatal|Error|Exception)" 2>&1)
if [ "$hasError" ] ; then
    # stop if error
    die "Package installation failed."
fi
