<?php
require_once realpath(__DIR__ . '/../../lib') . '/autoload-init.php';

use webignition\JsonPrettyPrinter\JsonPrettyPrinter;

try {
    //region collect params
    $options = getopt(
        'p:f:F:c:s:',
        array(
            'magento-root-dir',
            'magento-force',
            'json-file',
            'composer-repository-url',
            'minimum-stability',
        )
    );
    $keys    = array(
        'p' => array(
            'long'     => 'magento-root-dir',
            'required' => false,
        ),
        'f' => array(
            'long' => 'magento-force',
        ),
        'F' => array(
            'long' => 'json-file',
        ),
        'c' => array(
            'long' => 'composer-repository-url',
        ),
        's' => array(
            'long' => 'minimum-stability',
        ),
    );
    //migrate short key to long one
    foreach ($keys as $short => $settings) {
        $long     = $settings['long'];
        $required = (bool)@$settings['required'];

        if (isset($options[$short])) {
            $options[$long] = $options[$short];
            unset($options[$short]);
        } else {
            $options[$long] = null;
        }

        if ($required && !isset($options[$long])) {
            throw new Exception("Parameter --$long|-$short is required.");
        }
    }

    if ($options['magento-root-dir'] && !is_dir((string)$options['magento-root-dir'])) {
        throw new Exception("Project path '{$options['magento-root-dir']}' not found.");
    }
    if ($options['json-file'] && !is_file((string)$options['json-file'])) {
        throw new Exception("JSON file '{$options['json-file']}' not found.");
    }
    //endregion

    //set data
    if ($options['json-file']) {
        $data = (array)json_decode(file_get_contents($options['json-file']));
    } else {
        $data = array();
    }
    if ($options['composer-repository-url']) {
        if (!is_array($options['composer-repository-url'])) {
            $options['composer-repository-url'] = array($options['composer-repository-url']);
        }
        foreach ($options['composer-repository-url'] as $url) {
            $data['repositories'][] = array(
                'type' => 'composer',
                'url'  => $url,
            );
        }
    }
    $data['minimum-stability']         = (string)$options['minimum-stability'] ?: 'stable';
    $data['extra']['magento-force']    = (bool)$options['magento-force'];
    if ($options['magento-root-dir']) {
        $data['extra']['magento-root-dir'] = $options['magento-root-dir'];
    }

    //write json
    $composerJson = json_encode($data);
    $formatter    = new JsonPrettyPrinter();
    echo $formatter->format($composerJson);
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . PHP_EOL;
}