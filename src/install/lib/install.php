<?php
if (empty($_SERVER['argv'][1])) {
    throw new Exception('Project directory is not set.');
}
$magentoPath = $_SERVER['argv'][1];
unset($_SERVER['argv'][1]);

//region copy-pasted from Magento/install.php
if (version_compare(phpversion(), '5.2.0', '<')===true) {
    die('ERROR: Whoops, it looks like you have an invalid PHP version. Magento supports PHP 5.2.0 or newer.');
}
//endregion

require_once $magentoPath . '/app/Mage.php';
Mage::setIsDeveloperMode(true);

//region copy-pasted from Magento/install.php
try {
    $app = Mage::app('default');

    $installer = Mage::getSingleton('install/installer_console');
    /* @var $installer Mage_Install_Model_Installer_Console */

    if ($installer->init($app)          // initialize installer
        && $installer->checkConsole()   // check if the script is run in shell, otherwise redirect to web-installer
        && $installer->setArgs()        // set and validate script arguments
        && $installer->install())       // do install
    {
        echo 'SUCCESS: ' . $installer->getEncryptionKey() . "\n";
        exit;
    }

} catch (Exception $e) {
    Mage::printException($e);
}

// print all errors if there were any
if ($installer instanceof Mage_Install_Model_Installer_Console) {
    if ($installer->getErrors()) {
        echo "\nFAILED\n";
        foreach ($installer->getErrors() as $error) {
            echo $error . "\n";
        }
    }
}
exit(1); // don't delete this as this should notify about failed installation
//endregion
