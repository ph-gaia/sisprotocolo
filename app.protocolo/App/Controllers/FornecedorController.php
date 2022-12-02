<?php

namespace App\Controllers;

use HTR\System\ControllerAbstract as Controller;
use HTR\Interfaces\ControllerInterface as CtrlInterface;
use HTR\Helpers\Access\Access;
use App\Models\FornecedorModel;
use App\Config\Configurations as cfg;

class FornecedorController extends Controller implements CtrlInterface
{

    private $access;

    public function __construct($bootstrap)
    {
        parent::__construct($bootstrap);

        $this->view->controller = cfg::DEFAULT_URI . 'fornecedor/';
        $this->access = new Access();
    }

    public function indexAction()
    {
        $this->verAction();
    }

    public function novoAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $this->view->title = 'Novo Registro';
        $this->render('form_novo');
    }

    public function editarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1,2]);
        $model = new FornecedorModel();
        $this->view->title = 'Editando Registro';
        $this->view->result = $model->findById($this->getParam('id'));
        $this->render('form_editar');
    }

    public function eliminarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $model = new FornecedorModel();
        $model->removerRegistro($this->getParam('id'));
    }

    public function verAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new FornecedorModel();
        $this->view->title = 'Lista de Todos os Fornecedores';
        $this->view->busca = $this->getParam('busca');
        $model->paginator($this->getParam('pagina'), $this->view->busca);
        $this->view->result = $model->getResultadoPaginator();
        $this->view->btn = $model->getNavePaginator();
        $this->render('index');
    }

    public function registraAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $model = new FornecedorModel();
        $model->novoRegistro();
    }

    public function alteraAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $model = new FornecedorModel();
        $model->editarRegistro();
    }

    public function findByCnpjAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new FornecedorModel();
        $result = $model->findByCnpj($this->getParam('cnpj'));

        echo json_encode($result);
    }

    public function findByIdAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new FornecedorModel();
        $result = $model->findById($this->getParam('id'));

        echo json_encode($result);
    }
}
