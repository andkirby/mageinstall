<?php
$magentoRoot = trim(@$_SERVER['argv'][1], '"\'');
$magentoRoot = rtrim($magentoRoot, '\\/');
if (!is_dir($magentoRoot)) {
    echo 'Please set path to filename. php shell/import.php /path/to/magento /path/to/filename.csv';
    exit(1);
}


require_once $magentoRoot . '/app/Mage.php';

if (!Mage::isInstalled()) {
    echo "Application is not installed yet, please complete install wizard first.";
    exit;
}

// Only for urls
// Don't remove this
$_SERVER['SCRIPT_NAME'] = $magentoRoot . DIRECTORY_SEPARATOR . 'index.php';
$_SERVER['SCRIPT_FILENAME'] = $magentoRoot . DIRECTORY_SEPARATOR . 'index.php';

Mage::app('admin')->setUseSessionInUrl(false);

umask(0);

Mage::setIsDeveloperMode(true);

try {
    var_dump($_SERVER['argv']);

    if (!isset($_SERVER['argv'][2])) {
        echo 'Please set path to filename. php shell/import.php /path/to/magento /path/to/filename.csv';
        exit(1);
    }
    $file = trim($_SERVER['argv'][2], ' "\'');
    $execDir = str_replace($_SERVER['argv'][0], '', __FILE__);
    if ($file[0] != '/' || $file[1] != ':') {
        //relative path to file, making it absolute
        $file = realpath($execDir . $file);
    }
    if (!file_exists($file)) {
        echo "File '$file' doesn't exist.";
        exit(1);
    }
    //copy file into var/importexport dir
    $filename = pathinfo($file, PATHINFO_BASENAME);
//    $mageDir = realpath(__DIR__ . DS . '..');
    $importDir = $magentoRoot . DS .'var' . DS . 'importexport';
    if (!is_dir($importDir) && is_writeable($magentoRoot . DS .'var') && !mkdir($importDir)) {
        echo "Unable to create dir '$importDir'.";
        exit(1);
    }
    $tmpFile = $importDir . DS . $filename;
    if ($file != $tmpFile && !copy($file, $tmpFile)) {
        echo 'Could not copy file to "var" dir. Destination file: ' . $tmpFile;
        exit(1);
    }
    $file = $tmpFile;

    //Import script
    $actions = array('append', 'replace', 'delete');
    if (isset($_SERVER['args'][3])) {
        $action = $_SERVER['args'][3];
    } else {
        $action = 'append';
    }
    if (!in_array($action, $actions)) {
        echo "Invalid action '{$_SERVER['args'][2]}'.";
        exit(1);
    }

    $data = array(
        'entity'   => 'catalog_product',
        'behavior' => $action,
    );

    /** @var $import Mage_ImportExport_Model_Import */
    $import = Mage::getModel('importexport/import');
    $import->setData($data);
    $validationResult = $import->validateSource($file);
    $messages = array();
    $importStart = false;
    if (!$import->getProcessedRowsCount()) {
        $messages[] = 'File does not contain data. Please upload another one';
    } else {
        if (!$validationResult) {
            if ($import->getProcessedRowsCount() == $import->getInvalidRowsCount()) {
                $messages[] = 'File is totally invalid. Please fix errors and re-upload file';
            } elseif ($import->getErrorsCount() >= $import->getErrorsLimit()) {
                echo sprintf('Errors limit (%d) reached. Please fix errors and re-upload file', $import->getErrorsLimit());
            } else {
                if ($import->isImportAllowed()) {
                    $messages[] = 'Please fix errors and re-upload file or simply press "Import" button to skip rows with errors';
                } else {
                    $messages[] = 'File is partially valid, but import is not possible';
                }
            }
            // errors info
            foreach ($import->getErrors() as $errorCode => $rows) {
                $messages[] = $errorCode . ' ' . 'in rows:' . ' ' . implode(', ', $rows);
            }
        } else {
            if ($import->isImportAllowed()) {
                $importStart = true;
            } else {
                $messages[] = 'File is valid, but import is not possible';
            }
        }
        // errors info
        foreach ($import->getNotices() as $errorCode => $message) {
            $messages[] = $message;
        }
        $messages[] = sprintf(
            'Checked rows: %d, checked entities: %d, invalid rows: %d, total errors: %d',
            $import->getProcessedRowsCount(), $import->getProcessedEntitiesCount(),
            $import->getInvalidRowsCount(), $import->getErrorsCount()
        );

        foreach ($messages as $message) {
            echo "$message\n";
        }

        if (!$import->getErrorsCount() && $importStart) {
            echo "Start importing...\n";
            $import = Mage::getModel('importexport/import');
            $import->importSource();
            $import->invalidateIndex();
            echo "Import file has been processed.\n";
        }
    }
} catch (Exception $e) {
    Mage::printException($e);
    exit(1);
}
