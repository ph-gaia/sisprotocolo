<?php

/*
 * @file DatabaseConfig.php
 * @version 0.1
 * - Class que configura as diretrizes para conexão com o Banco de Dados
 */

namespace App\Config;

class DatabaseConfig
{
    public $db = [
        // base64_encode;
        'servidor' => 'db_mil',
        'banco' => 'sisprotocolo',
        'usuario' => 'root',
        'senha' => 'root',
        'opcoes' => [\PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES 'utf8'"],
        // Altere este campo apenas se for usar a Base de Dados Sqlite
        // Default Value : null
        'sqlite' => null
    ];
}
