<?php
namespace App\Controllers;

use HTR\System\ControllerAbstract as Controller;
use HTR\Interfaces\ControllerInterface as CtrlInterface;
use HTR\Helpers\Access\Access;
use App\Models\FornecedorModel as Fornecedor;
use App\Models\LicitacaoModel as Licitacao;
use App\Models\ItemModel;
use App\Config\Configurations as cfg;
use App\Models\LicitacaoModel;
use App\Models\OmModel;

class ItemController extends Controller implements CtrlInterface
{

    private $access;

    public function __construct($bootstrap)
    {
        parent::__construct($bootstrap);
        $this->view->controller = cfg::DEFAULT_URI . 'item/';
        $this->access = new Access();
        $this->view->idlista = $this->getParam('idlista');
        if (!$this->view->idlista) {
            header("Location:" . cfg::DEFAULT_URI . "licitacao/");
        }
    }

    public function indexAction()
    {
        $this->listarAction();
    }

    public function novoAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1,2]);
        $this->view->title = 'Novo Registro';
        $fornecedor = new Fornecedor();
        $this->view->resultFornecedor = $fornecedor->findAll();
        $this->view->resultOms = (new OmModel())->findAll();
        $this->render('form_novo');
    }

    public function editarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1,2]);
        $model = new ItemModel();
        $this->view->title = 'Editando Registro';
        $fornecedor = new Fornecedor();
        $this->view->resultFornecedor = $fornecedor->findAll();
        $result = $model->fetchDataToEdit((int) $this->getParam('id'));
        $this->view->result = $result['result'];
        $this->view->resultOms = $result['oms'];
        $this->render('form_editar');
    }

    public function eliminarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1,2]);
        $model = new ItemModel();
        $model->removerRegistro($this->getParam('id'), $this->view->idlista);
    }

    public function listarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1,2]);
        $model = new ItemModel();
        $this->view->title = 'Lista de Itens da Licitação';
        $model->paginator($this->getParam('pagina'), $this->view->idlista);
        $this->view->result = $model->getResultadoPaginator();
        $this->view->btn = $model->getNavePaginator();
        $licitacao = new Licitacao();
        $this->view->resultLicitacao = $licitacao->findById($this->view->idlista);
        $this->render('index');
    }

    public function registraAction()
    {
        $model = new ItemModel();
        $model->novoRegistro();
    }

    public function alteraAction()
    {
        $model = new ItemModel();
        $model->editarRegistro();
    }

    public function remanejarAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1,2]);
        $model = new ItemModel();
        $fornecedor = new Fornecedor();
        $this->view->resultFornecedor = $fornecedor->findAll();
        $this->view->resultOms = (new OmModel())->findAll();
        $this->view->resultLicitacao = (new LicitacaoModel())->findAll();
        $this->view->result = $model->findById($this->getParam('id'));
        $this->view->title = 'Remanjar ' . $this->view->result['name'];
        $this->render('form_remanejar');
    }

    public function remanejaAction()
    {
        $model = new ItemModel();
        $model->remanejar();
    }

    public function eliminaromAction()
    {
        $id = $this->getParam('id');
        $avisoId = $this->getParam('avisoid');
        if ($id && $avisoId) {
            (new LicitacaoModel())->eliminarOm((int) $id, (int) $avisoId);
        } else {
            header('Location: ' . $this->view->controller);
        }
    }

    public function adicionaromAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1,2]);
        $idlista = $this->getParam('idlista');
        $id = $this->getParam('id');
        if ($id) {
            $result = (new LicitacaoModel())->fetchOmOut((int) $idlista, (int) $id);
            if (count($result)) {
                $this->view->title = 'Adicionar nova OM';
                $this->view->result = $result;

                $this->render('form_adicionar_om');
            } else {
                header('Location: ' . $this->view->controller . 'editar/id/' . $id);
            }
        } else {
            header('Location: ' . $this->view->controller);
        }
    }

    public function registrarnovaomAction()
    {
        (new LicitacaoModel())->adicionarNovaOM();
    }
}
