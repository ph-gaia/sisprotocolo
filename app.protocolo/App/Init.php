<?php
namespace App;

use HTR\Init\Bootstrap;
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
class Init extends Bootstrap
{

    public function __construct()
    {
        self::setUpHeaders();
        parent::__construct();
        // Roda a aplicação
        $this->run();
    }

    private static function setUpHeaders()
    {
        header('Content-type: text/html; charset=UTF-8');
    }
}
