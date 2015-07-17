<?php
require_once realpath(__DIR__ . '/../../lib') . '/autoload-init.php';

use webignition\JsonPrettyPrinter\JsonPrettyPrinter;

try {
    //region collect params
    $options = getopt(
        'p:f:d:F:c:s:',
        array(
            'magento-root-dir',
            'magento-force',
            'magento-deploystrategy',
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
        'd' => array(
            'long'     => 'magento-deploystrategy',
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
        $data = (array)json_decode(file_get_contents($options['json-file']), true, 100, JSON_OBJECT_AS_ARRAY);
    } else {
        $data = array();
    }
    if ($options['composer-repository-url']) {
        if (!is_array($options['composer-repository-url'])) {
            $options['composer-repository-url'] = array($options['composer-repository-url']);
        }

        //collect exists composer repository URLs
        $repositoryUrls = array();
        if (isset($data['repositories'])) {
            foreach ($data['repositories'] as $repository) {
                if (isset($repository['type']) && 'composer' == $repository['type']) {
                    $repositoryUrls[] = $repository['url'];
                }
            }
        }

        //add new composer repository URLs
        foreach ($options['composer-repository-url'] as $url) {
            if (!$repositoryUrls || !in_array($url, $repositoryUrls)) {
                if (!strpos($url, '://')) {
                    throw new Exception("Composer URL '$url' is not valid.");
                }
                $data['repositories'][] = array(
                    'type' => 'composer',
                    'url'  => $url,
                );
            }
        }
    }
    if ($options['minimum-stability'] || empty($data['minimum-stability'])) {
        $data['minimum-stability'] = (string)$options['minimum-stability'] ?: 'stable';
    }
    $data['extra']['magento-force']          = (bool)$options['magento-force'];
    $data['extra']['magento-deploystrategy'] = (string)$options['magento-deploystrategy'] ?: 'symlink';
    if ($options['magento-root-dir']) {
        $data['extra']['magento-root-dir'] = $options['magento-root-dir'];
    }

    /**
     * Ignore updating Varien_Autoload class because the issue
     * @link https://github.com/ajbonner/magento-composer-autoload/issues/4
     */
    if (!isset($data['extra']['magento-deploystrategy-overwrite'])) {
        $data['extra']['magento-deploystrategy-overwrite']['ajbonner/magento-composer-autoload'] = 'none';
    }

    //write json
    $composerJson = json_encode($data);
    $formatter    = new JsonPrettyPrinter();
    echo $formatter->format($composerJson);
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . PHP_EOL;
}
