<?php

/*
 * Controller Registros
 */

namespace App\Controllers;

use HTR\System\ControllerAbstract as Controller;
use HTR\Interfaces\ControllerInterface as CtrlInterface;
use HTR\Helpers\Access\Access;
use App\Models\OmModel as Om;
use App\Models\StatusModel as Status;
use App\Config\Configurations as cfg;
use App\Models\CnaeModel;
use App\Models\CreditoModel;
use App\Models\FornecedorModel;
use App\Models\HistoricoAcaoModel;
use App\Models\ItemModel;
use App\Models\LicitacaoModel;
use App\Models\ModalityModel;
use App\Models\NatureExpenseModel;
use App\Models\OmModel;
use App\Models\ProcessTypeModel;
use App\Models\RegistrosItemModel;
use App\Models\RegistrosModel;

class RegistrosController extends Controller implements CtrlInterface
{
    // Model padrão usado para este Controller
    private $modelPath = 'App\\Models\\RegistrosModel';
    // Recebe a instância do Helper Access
    private $access;

    /*
     * Inicia os atributos usados na View
     */
    public function __construct($bootstrap)
    {
        parent::__construct($bootstrap);
        $this->view->controller = cfg::DEFAULT_URI . 'registros/';
        // instancia o helper Access
        $this->access = new Access;
        // inicia a proteção da página
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
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
        // título da página
        $this->view->title = 'Registros de Documentos';
        // instancia o Model Om
        $omModel = new Om;
        // inicia a paginação da página
        $omModel->paginator($this->getParam('pagina'));
        // alimenta os dados de Om na camada de View
        $this->view->result = $omModel->getResultPaginator();
        $this->view->btn = $omModel->getNavePaginator();

        // Renderiza a página 'home.phtml'
        $this->render('home');
    }

    /**
     * Action novo
     * Usado para renderizar o formulário de cadastro
     */
    public function novoAction()
    {
        // título da página
        $this->view->title = 'Formulário de Cadastro de Documentos';
        // instancia de models
        $omModel = new Om;
        $statusModel = new Status;
        $cnaeModel = new CnaeModel;
        $fornecedorModel = new FornecedorModel;
        $modalityModel = new ModalityModel;
        $natureExpenseModel = new NatureExpenseModel;
        $processTypeModel = new ProcessTypeModel;
        $creditoModel = new CreditoModel;
        // alimenta os dados na camada de View
        $this->view->resultOm = $omModel->findActive();
        $this->view->resultStatus = $statusModel->findActive();
        $this->view->resultCnae = $cnaeModel->findActive();
        $this->view->resultModality = $modalityModel->findActive();
        $this->view->resultFornecedor = $fornecedorModel->findActive();
        $this->view->resultNatureExpense = $natureExpenseModel->findActive();
        $this->view->processType = $processTypeModel->findActive();
        $this->view->credito = $creditoModel->findByOmId($this->view->userLoggedIn['oms_id']);
        // renderiza a página do formulário
        $this->render('form_novo');
    }

    public function pregaoAction()
    {
        $licitacao = new LicitacaoModel();
        $this->view->title = ' Licitações';
        $licitacao->paginator($this->getParam('pagina'), date("Y-m-d", time()), $this->view->userLoggedIn['oms_id']);
        $this->view->result = $licitacao->getResultadoPaginator();
        $this->view->btn = $licitacao->getNavePaginator();
        $this->render('mostra_licitacao_disponivel');
    }

    public function itemAction()
    {
        $this->view->userLoggedIn = $this->access->setRedirect('solicitacao/')
            ->clearAccessList()
            ->authenticAccess([1,2]);

        $this->view->title = 'Lista dos Itens da Licitação';
        $item = new ItemModel();
        $this->view->result = $item->findByIdlista($this->getParam('idlista'), $this->view->userLoggedIn['oms_id']);
        $licitacao = new LicitacaoModel();
        $fornecedorModel = new FornecedorModel;
        $this->view->resultFornecedor = $fornecedorModel->findActive();
        $this->view->resultLicitacao = $licitacao->findById($this->getParam('idlista'));
        $this->view->resultStatus = (new Status())->findActive();
        $this->view->resultOm = (new OmModel())->findById($this->view->userLoggedIn['oms_id']);
        $this->render('mostra_item');
    }

    public function detalharAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1,2]);
        $model = new RegistrosModel();
        $licitacao = new LicitacaoModel();
        $solicitacaoItem = new RegistrosItemModel();
        $this->view->title = 'Itens da Solicitação';
        $this->view->resultSolicitacao = $model->findByIdlista($this->getParam('idlista'));
        $this->view->resultLicitacao = $licitacao->findById($this->view->resultSolicitacao['biddings_id']);
        $solicitacaoItem->paginator($this->getParam('pagina'), $this->getParam('idlista'));
        $this->view->result = $solicitacaoItem->getResultadoPaginator();
        $this->view->btn = $solicitacaoItem->getNavePaginator();

        $this->render('mostra_item_solicitacao');
    }

    /**
     * Action registra
     * Usado para efetuar novos registros no banco de dados
     */
    public function registraAction()
    {
        // instancia o Model Default deste controller
        $defaultModel = new $this->modelPath;
        // requisita a inserção dos dados
        $defaultModel->novoRegistro($this->view->userLoggedIn);
    }

    /**
     * Action editar
     * Usado para renderizar o formulário de edição de registro
     */
    public function editarAction()
    {
        // titulo da página
        $this->view->title = 'Edição de Registro';
        // instancia o Model Om
        $omModel = new Om;
        // alimenta os dados de Om na camada de View
        $this->view->resultOm = $omModel->findActive();
        // instancia o Model Status
        $statusModel = new Status;
        // alimenta os dados de Status na camada de View
        $this->view->resultStatus = $statusModel->findActive();
        // instancia o Model Default deste controller
        $defaultModel = new $this->modelPath;
        // realiza a busca dos dados no banco de acordo com o id informado
        $this->view->result = $defaultModel->findById($this->getParam('id'));
        // renderiza a página do formulário
        $this->render('form_editar');
    }

    /**
     * Action altera
     * Usado para efetuar a alteração dos registros no banco de dados
     */
    public function alteraAction()
    {
        // instancia o Model Default deste controller
        $defaultModel = new $this->modelPath;
        // requisita a edição dos dados
        $defaultModel->editarRegistro($this->view->userLoggedIn);
    }

    /**
     * Action eliminar
     * Usado para alterar o status da lixeira ( 0 = normal, 1 = excluido)
     */
    public function eliminarAction()
    {
        // instancia o Model Default deste controller
        $defaultModel = new $this->modelPath;
        // requisia a edição dos dados
        $defaultModel->remover($this->getParam('id'));
    }

    /**
     * Action eliminar status
     */
    public function eliminarStatusAction()
    {
        (new HistoricoAcaoModel())->removerStatus($this->getParam('id'));
    }

    /**
     * Action protocolados
     * Usado para listar a lista de documentos cadastrados por OM
     */
    public function protocoladoAction()
    {
        // titulo da página
        $this->view->title = 'Lista de Documentos Protocolados por OM';
        // instancia o Model Default deste controller
        $defaultModel = new $this->modelPath;
        // inicia a paginação
        $defaultModel->paginator($this->getParam('pagina'), $this->getParam('om'));
        // alimenta a camada de Views com os dados de Documentos
        $this->view->result = $defaultModel->getResultPaginator();
        // alimenta a camada de Views com os links usados na paginação
        $this->view->btn = $defaultModel->getNavePaginator();

        // renderiza a página de lista de registros protocolados
        $this->render('lista_protocolados');
    }

    /**
     * Action historico
     * Usado para demonstrar o histórico dos registros, bem como os respectivos status
     */
    public function historicoAction()
    {
        // titulo da página
        $this->view->title = 'Histórico de documentos';
        // instancia o Model Default deste controller
        $defaultModel = new HistoricoAcaoModel();

        // alimenta a camada de Views com os dados de Documentos
        $this->view->result = $defaultModel->allHistoricByRequestId($this->getParam('id'));

        // renderiza a página de lista de registros protocolados
        $this->render('historico');
    }

    /**
     * Action novo
     * Usado para renderizar o formulário de cadastro
     */
    public function statusAction()
    {
        // título da página
        $this->view->title = 'Formulário de Inclusão de Status';
        // instancia o Model Om
        $omModel = new Om;
        // alimenta os dados de Om na camada de View
        $this->view->resultOm = $omModel->findActive();
        // instancia o Model Status
        $statusModel = new Status;
        // alimenta os dados de Status na camada de View
        $this->view->resultStatus = $statusModel->findActive();
        // instancia o Model Default deste controller
        $defaultModel = new $this->modelPath;
        // realiza a busca dos dados no banco de acordo com o id informado
        $this->view->result = $defaultModel->findById($this->getParam('id'));
        // renderiza a página do formulário
        $this->render('form_novo_status');
    }

    /**
     * Action incluirStatus
     * Usado para incluir os registros com o status modificado
     */
    public function incluiStatusAction()
    {
        // instancia o Model Default deste controller
        $defaultModel = new $this->modelPath;
        // requisita a inserção dos dados
        $defaultModel->incluiStatus($this->view->userLoggedIn);
    }
}
