<?php

/*
 * Controller Buscar
 */

namespace App\Controllers;

use HTR\System\ControllerAbstract as Controller;
use HTR\Interfaces\ControllerInterface as CtrlInterface;
use HTR\Helpers\Session\Session;
use App\Config\Configurations as cfg;

class BuscarController extends Controller implements CtrlInterface
{
    // Model padrão usado para este Controller
    private $modelPath = 'App\\Models\\BuscarModel';

    /*
     * Inicia os atributos usados na View
     */
    public function __construct($bootstrap)
    {
        parent::__construct($bootstrap);
        $this->view->controller = cfg::DEFAULT_URI . 'buscar/';
    }

    /*
     * Action DEFAULT
     * Atenção: Todo Controller deve conter uma Action 'indexAction'
     */
    public function indexAction()
    {
        // usa o metodo 'verAction' como default
        $this->visualizarAction();
    }

    /**
     * Action ver
     * Usado para visualizar os registros no sistema
     */
    public function visualizarAction()
    {
        $session = new Session();
        $session->startSession();

        $this->view->routeIndex = cfg::DEFAULT_URI . 'registros/';

        if (!isset($_SESSION['token'])) {
            $session->stopSession();
            $this->view->routeIndex = cfg::DEFAULT_URI . 'index/';
        }
        // título da página
        $this->view->title = 'Busca por';
        // valor a ser buscado
        $this->view->busca = strtoupper($this->getParam('busca'));

        $modelDefault = new $this->modelPath;
        $modelDefault->paginator($this->getParam('pagina'), $this->view->busca);
        $this->view->result = $modelDefault->getResultPaginator();
        $this->view->btn = $modelDefault->getNavePaginator();

        // Renderiza a página 'home.phtml'
        $this->render('home');
    }

    /**
     * método usado para destacar a pesquisa
     */
    public function valueLight($value, $busca)
    {
        return str_replace($busca, '<span class="valueLight">' . $busca . '</span>', $value);
    }
}
