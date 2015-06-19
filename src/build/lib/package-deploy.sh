#!/usr/bin/env bash
#install a package

echo "Deploying package/s..."
# redeploy package if it wasn't updated
cd $PACKAGE_DIR && $PHP_BIN ./vendor/bin/composerCommandIntegrator.php magento-module-deploy
