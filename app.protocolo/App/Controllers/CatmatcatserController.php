<?php

namespace App\Controllers;

use HTR\System\ControllerAbstract as Controller;
use HTR\Interfaces\ControllerInterface as CtrlInterface;
use HTR\Helpers\Access\Access;
use App\Models\CatmatcatserModel;
use App\Config\Configurations as cfg;

class CatmatcatserController extends Controller implements CtrlInterface
{

    private $access;

    public function __construct($bootstrap)
    {
        parent::__construct($bootstrap);
        $this->view->controller = cfg::DEFAULT_URI . 'catmatcatser/';
        $this->access = new Access();
    }

    public function indexAction()
    {
        $this->verAction();
    }

    public function verAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new CatmatcatserModel();
        $this->view->title = 'Lista de todas as CATMAT/CATSER';
        $model->paginator($this->getParam('pagina'));
        $this->view->result = $model->getResultPaginator();
        $this->view->btn = $model->getNavePaginator();
        $this->render('home');
    }

    public function novoAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $this->view->title = 'Novo Registro';
        $this->render('form_novo');
    }

    public function editarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $model = new CatmatcatserModel();
        $this->view->title = 'Editando Registro';
        $this->view->result = $model->findById($this->getParam('id'));
        $this->render('form_editar');
    }

    public function eliminarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1,2]);
        $model = new CatmatcatserModel();
        $model->remover($this->getParam('id'));
    }

    public function registraAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $model = new CatmatcatserModel();
        $model->novoRegistro();
    }

    public function alteraAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $model = new CatmatcatserModel();
        $model->editarRegistro();
    }

    public function findByIdAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new CatmatcatserModel();
        $result = $model->findInformById($this->getParam('id'), $this->getParam('om'));

        echo json_encode($result);
    }
}
