<?php

namespace App\Controllers;

use HTR\System\ControllerAbstract as Controller;
use HTR\Interfaces\ControllerInterface as CtrlInterface;
use HTR\Helpers\Access\Access;
use App\Models\CreditoModel;
use App\Models\HistoricoCreditoModel;
use App\Models\OmModel;
use App\Config\Configurations as cfg;

class CreditoController extends Controller implements CtrlInterface
{

    private $access;

    public function __construct($bootstrap)
    {
        parent::__construct($bootstrap);
        $this->view->controller = cfg::DEFAULT_URI . 'credito/';
        $this->access = new Access();
    }

    public function indexAction()
    {
        $this->verAction();
    }

    public function novoAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $this->view->title = 'Novo Registro';
        $om = new OmModel();
        $this->view->resultOm = $om->findAll();
        $this->render('form_novo');
    }

    public function detalharAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new CreditoModel();
        $this->view->title = 'Editando Registro';
        $this->view->result = $model->findById($this->getParam('id'));

        $historicoModel = new HistoricoCreditoModel();
        $historicoModel->paginator($this->getParam('pagina'), $this->getParam('id'));
        $this->view->historico = $historicoModel->getResultadoPaginator();
        $this->view->btn = $historicoModel->getNavePaginator();

        $this->render('form_editar');
    }

    public function eliminarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new CreditoModel();
        $model->removerRegistro($this->getParam('id'));
    }

    public function verAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new CreditoModel();
        $this->view->title = 'Lista de Todos os Créditos';
        $this->view->busca = $this->getParam('busca');
        $model->paginator($this->getParam('pagina'), $this->view->userLoggedIn, $this->view->busca);
        $this->view->result = $model->getResultadoPaginator();
        foreach ($this->view->result as $key => $value) {
            $this->view->result[$key]['credito_comprometido'] = $model->saldoComprometido($value['oms_id'], $value['id'])['sum_value'];
        }
        $this->view->btn = $model->getNavePaginator();
        $this->render('index');
    }

    public function registraAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new CreditoModel();
        $model->novoRegistro($this->view->userLoggedIn);
    }

    public function registraOperacaoAction()
    {
        $model = new HistoricoCreditoModel();
        $model->novoRegistro();
    }

    public function alteraAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new CreditoModel();
        $model->editarRegistro();
    }

    public function findSaldoComprometidoAction()
    {
        $enquadramento = $this->getParam('enquadramento');
        $cnae = $this->getParam('cnae');
        $om = $this->getParam('om');

        $obj = new \stdClass();
        $obj->credit_value = 0;
        $obj->registers_value = 0;
        $result = $obj;

        if ($enquadramento == 2) {
            $result = (new CreditoModel())->saldoComprometidoLei2(
                $om,
                $enquadramento,
                $cnae
            );
        }

        echo json_encode($result);
    }
}
