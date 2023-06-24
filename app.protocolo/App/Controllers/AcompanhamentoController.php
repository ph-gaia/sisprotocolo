<?php

namespace App\Controllers;

use HTR\System\ControllerAbstract as Controller;
use HTR\Interfaces\ControllerInterface as CtrlInterface;
use HTR\Helpers\Access\Access;
use App\Models\OmModel as Om;
use App\Models\StatusModel as Status;
use App\Config\Configurations as cfg;
use App\Models\HistoricoAcompanhamentoAcaoModel;
use App\Models\ModalityModel;
use App\Models\OmModel;
use App\Models\AcompanhamentoModel;


class AcompanhamentoController extends Controller implements CtrlInterface
{
    private $modelPath = 'App\\Models\\AcompanhamentoModel';
    private $access;

    public function __construct($bootstrap)
    {
        parent::__construct($bootstrap);
        $this->view->controller = cfg::DEFAULT_URI . 'acompanhamento/';
        $this->access = new Access;
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
    }

    public function indexAction()
    {
        $this->visualizarAction();
    }

    public function visualizarAction()
    {
        /*$this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new AcompanhamentoModel();
        $this->view->title = 'Registros de Documentos (Acompanhamento)';
        $model->paginator($this->getParam('pagina'));
        $this->view->result = $model->getResultPaginator();
        $this->view->btn = $model->getNavePaginator();
        $this->render('home_acompanhamento');*/

        /*$this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);*/
        $this->view->title = 'Registros de Documentos (Acompanhamento)';
        $omModel = new Om;
        $omModel->paginator($this->getParam('pagina'), $this->view->userLoggedIn);
        $this->view->result = $omModel->getResultPaginator();
        $this->view->btn = $omModel->getNavePaginator();
        $this->render('home_acompanhamento');
    }

    public function novoAction()
    {
        /*$this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);*/
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

    public function detalharAction()
    {
        $this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);
        $model = new AcompanhamentoModel();
        $solicitacaoItem = new RegistrosItemModel();
        $this->view->title = 'Itens da Solicitação';
        $this->view->resultSolicitacao = $model->findByIdlista($this->getParam('idlista'));
        $solicitacaoItem->paginator($this->getParam('pagina'), $this->getParam('idlista'));
        $this->view->result = $solicitacaoItem->getResultadoPaginator();
        $this->view->btn = $solicitacaoItem->getNavePaginator();

        $this->render('mostra_item_acompanhamento');
    }

    public function registraAction()
    {
        /*$this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);*/
        // instancia o Model Default deste controller
        $defaultModel = new $this->modelPath;
        // requisita a inserção dos dados
        $defaultModel->novoRegistro($this->view->userLoggedIn);
    }

    public function editarAction()
    {
        /*$this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $omModel = new Om;
        $this->view->resultOm = $omModel->findActive();
        $statusModel = new Status;
        $this->view->resultStatus = $statusModel->findActive();
        $model = new AcompanhamentoModel();
        $this->view->title = 'Edição de Registro (Acompanhamento)';
        $this->view->result = $model->findById($this->getParam('id'));
        $this->render('form_editar_acompanhamento');*/

        /*$this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);*/
        $this->view->title = 'Edição de Registro (Acompanhamento)';
        $omModel = new Om;
        $this->view->resultOm = $omModel->findActive();
        $statusModel = new Status;
        $this->view->resultStatus = $statusModel->findActive();
        $modalityModel = new ModalityModel;
        $this->view->resultModality = $modalityModel->findActive();
        $defaultModel = new $this->modelPath;
        $this->view->result = $defaultModel->findById($this->getParam('id'));
        $this->render('form_editar_acompanhamento');

    }

    public function alteraAction()
    {
        /*$this->view->userLoggedIn = $this->access->authenticAccess([1]);
        $model = new AcompanhamentoModel();
        $model->editarRegistro();*/
        /*$this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);*/
        // instancia o Model Default deste controller
        $defaultModel = new $this->modelPath;
        // requisita a edição dos dados
        $defaultModel->editarRegistro($this->view->userLoggedIn);
    }

    public function eliminarAction()
    {
        /*$this->view->userLoggedIn = $this->access->authenticAccess([1,2]);
        $model = new AcompanhamentoModel();
        $model->remover($this->getParam('id'));*/

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
        (new HistoricoAcompanhamentoAcaoModel())->removerStatus($this->getParam('id'));
    }

    /**
     * Action protocolados
     * Usado para listar a lista de documentos cadastrados por OM
     */
    public function protocoladoAction()
    {
        /*$this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);*/
        // titulo da página
        $this->view->title = 'Lista de Documentos Protocolados por OM (Acompanhamento)';
        // instancia o Model Default deste controller
        $defaultModel = new $this->modelPath;
        // inicia a paginação
        $defaultModel->paginator($this->getParam('pagina'), $this->getParam('om'));
        // alimenta a camada de Views com os dados de Documentos
        $this->view->result = $defaultModel->getResultPaginator();
        // alimenta a camada de Views com os links usados na paginação
        $this->view->btn = $defaultModel->getNavePaginator();

        // renderiza a página de lista de registros protocolados
        $this->render('lista_protocolados_acompanhamento');
    }

    /**
     * Action historico
     * Usado para demonstrar o histórico dos registros, bem como os respectivos status
     */
    public function historicoAction()
    {
        /*$this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);*/
        // titulo da página
        $this->view->title = 'Histórico de documentos (Acompanhamento)';
        // instancia o Model Default deste controller
        $defaultModel = new HistoricoAcompanhamentoAcaoModel();

        // alimenta a camada de Views com os dados de Documentos
        $this->view->result = $defaultModel->allHistoricByRequestId($this->getParam('id'));
        
        // renderiza a página de lista de registros protocolados
        $this->render('historico_acompanhamento');
    }

    /**
     * Action novo
     * Usado para renderizar o formulário de cadastro
     */
    public function statusAction()
    {
        /*$this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);*/
        // título da página
        $this->view->title = 'Formulário de Inclusão de Status (Acompanhamento)';
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
        $this->render('form_novo_status_acompanhamento');
    }

    /**
     * Action incluirStatus
     * Usado para incluir os registros com o status modificado
     */
    public function incluiStatusAction()
    {
        /*$this->view->userLoggedIn = $this->access->authenticAccess([1, 2]);*/
        // instancia o Model Default deste controller
        $defaultModel = new $this->modelPath;
        // requisita a inserção dos dados
        $defaultModel->incluiStatus($this->view->userLoggedIn);
    }

}
