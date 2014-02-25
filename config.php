<?php
require 'app/Mage.php';

if (!Mage::isInstalled()) {
    echo "Application is not installed yet, please complete install wizard first.";
    exit;
}

// Only for urls
// Don't remove this
$_SERVER['SCRIPT_NAME'] = str_replace(basename(__FILE__), 'index.php', $_SERVER['SCRIPT_NAME']);
$_SERVER['SCRIPT_FILENAME'] = str_replace(basename(__FILE__), 'index.php', $_SERVER['SCRIPT_FILENAME']);

Mage::app('admin')->setUseSessionInUrl(false);

umask(0);

try {
    $setup = new Mage_Core_Model_Resource_Setup('write');
    $csv = new Varien_File_Csv();
    $file = __DIR__  . DS . 'config.ini';
    if (!file_exists($file)) {
        exit(1);
    }
    $data = $csv->getData($file);
    foreach ($data as $row) {
        if (isset($row[0]) && isset($row[1])) {
            $setup->setConfigData($row[0], trim($row[1]));
        }
    }
} catch (Exception $e) {
    Mage::printException($e);
    exit(1);
}
