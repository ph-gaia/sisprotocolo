<?php
namespace App\Config;

use HTR\System\InternalConfigurations;

class Configurations extends InternalConfigurations
{

    const DS = DIRECTORY_SEPARATOR;
    const STR_SALT = 'H6ac1aabfab23f42ba14dab52cae88e101a77a6f7';
    const DOMAIN = 'localhost';
    const ADMIN_CONTACT = 'E-mail: bruno.monteirodg@gmail.com';
    const PATH_CORE = '/var/www/html/app.protocolo/';
    const DIR_DATABASE = self::PATH_CORE . 'App/Database/DbRepository/';
    const DEFAULT_URI = '/app/protocolo/';
    const TIMEZONE = 'America/Belem';

    /**
     * Returns the configurations of htr.json files
     * @return \stdClass
     */
    public static function htrFileConfigs(): \stdClass
    {
        $projectDirectory = str_replace('App' . self::DS . 'Config', '', __DIR__);
        $file = $projectDirectory . self::DS . 'htr.json';

        if (file_exists($file)) {
            $fileContent = file_get_contents($file);
            $object = json_decode($fileContent);
            if (is_object($object)) {
                return $object;
            }
        }

        return new \stdClass();
    }
}
