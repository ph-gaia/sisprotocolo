<?php
/*
 * @file index.php
 * @version 0.2
 * - Arquivo responsável por iniciar o aplicatico
 */
// composer autoload
require_once '/var/www/html/app.protocolo/vendor/autoload.php';

try {
    // Inicia a Aplicação
    new \App\Init();
} catch (\Exception $e) {

    echo 'Código: <strong>'
        . $e->getCode() . '</strong> - Erro em <strong>'
        . $e->getFile() . '</strong>:<strong>'
        . $e->getLine() . '</strong><br>Erro informado: <strong>'
        . $e->getMessage() . '</strong><br><pre>';
    echo $e->getTraceAsString();
    echo '</pre>';
}
