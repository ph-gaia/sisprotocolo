<?php

namespace App\Controllers;

use HTR\System\ControllerAbstract as Controller;
use HTR\Interfaces\ControllerInterface as CtrlInterface;
use HTR\Helpers\Access\Access;
use App\Models\AcompanhamentoModel;
use App\Config\Configurations as cfg;

class AcompanhamentoController extends Controller implements CtrlInterface
{

    private $access;

    public function __construct($bootstrap)
    {
        parent::__construct($bootstrap);
        $this->view->controller = cfg::DEFAULT_URI . 'acompanhamento/';
        $this->access = new Access();
    }

    public function indexAction()
    {
        $this->verAction();
    }

    public function novoAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $this->view->title = 'Formulário de Cadastro de Documentos (Acompanhamento)';
        $this->render('form_novo');
    }

    public function editarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1,2]);
        $model = new AcompanhamentoModel();
        $this->view->title = 'Editando Registro';
        $this->view->result = $model->findById($this->getParam('id'));
        $this->render('form_editar');
    }

    public function eliminarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $model = new AcompanhamentoModel();
        $model->removerRegistro($this->getParam('id'));
    }

    public function verAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new AcompanhamentoModel();
        $this->view->title = 'Lista de Todos os Documentos (Acompanhamento)';
        $this->view->busca = $this->getParam('busca');
        $model->paginator($this->getParam('pagina'), $this->view->busca);
        $this->view->result = $model->getResultadoPaginator();
        $this->view->btn = $model->getNavePaginator();
        $this->render('index');
    }

    public function registraAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $model = new AcompanhamentoModel();
        $model->novoRegistro();
    }

    public function alteraAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $model = new AcompanhamentoModel();
        $model->editarRegistro();
    }

    public function findByIdAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new AcompanhamentoModel();
        $result = $model->findById($this->getParam('id'));

        echo json_encode($result);
    }
}
