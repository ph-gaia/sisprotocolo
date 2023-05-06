<?php

namespace App\Controllers;

use HTR\System\ControllerAbstract as Controller;
use HTR\Interfaces\ControllerInterface as CtrlInterface;
use HTR\Helpers\Access\Access;
use App\Models\OmModel as Om;
use App\Models\StatusModel as Status;
use App\Models\ModalityModel;
use App\Models\AcompanhamentoModel;
use App\Config\Configurations as cfg;

class AcompanhamentoController extends Controller implements CtrlInterface
{
    private $modelPath = 'App\\Models\\AcompanhamentoModel';
    private $access;

    public function __construct($bootstrap)
    {
        parent::__construct($bootstrap);
        $this->view->controller = cfg::DEFAULT_URI . 'acompanhamento/';
        $this->access = new Access();
    }

    public function indexAction()
    {
        $this->visualizarAction();
    }

    public function visualizarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new AcompanhamentoModel();
        $this->view->title = 'Registros de Documentos (Acompanhamento)';
        $model->paginator($this->getParam('pagina'));
        $this->view->result = $model->getResultPaginator();
        $this->view->btn = $model->getNavePaginator();
        $this->render('home_acompanhamento');
    }

    public function novoAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $this->view->title = 'Formulário de Cadastro de Documentos (Acompanhamento)';

        $omModel = new Om;
        $statusModel = new Status;
        $modalityModel = new ModalityModel;
        
        // alimenta os dados na camada de View
        $this->view->resultOm = $omModel->findActive();
        $this->view->resultStatus = $statusModel->findActive();
        $this->view->resultModality = $modalityModel->findActive();
        $this->render('form_novo_acompanhamento');
    }

    public function editarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $omModel = new Om;
        $this->view->resultOm = $omModel->findActive();
        $statusModel = new Status;
        $this->view->resultStatus = $statusModel->findActive();
        $model = new AcompanhamentoModel();
        $this->view->title = 'Edição de Registro (Acompanhamento)';
        $this->view->result = $model->findById($this->getParam('id'));
        $this->render('form_editar_acompanhamento');

    }

    public function eliminarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1,2]);
        $model = new AcompanhamentoModel();
        $model->remover($this->getParam('id'));
    }

    public function registraAction()
    {
        // instancia o Model Default deste controller
        $defaultModel = new $this->modelPath;
        // requisita a inserção dos dados
        $defaultModel->novoRegistro($this->view->userLoggedIn);
    }

    public function alteraAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $model = new AcompanhamentoModel();
        $model->editarRegistro();
    }
}
