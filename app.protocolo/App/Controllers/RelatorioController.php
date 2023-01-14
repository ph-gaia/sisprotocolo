<?php

/*
 * Controller Om
 */

namespace App\Controllers;

use HTR\System\ControllerAbstract as Controller;
use HTR\Interfaces\ControllerInterface as CtrlInterface;
use HTR\Helpers\Access\Access;
use App\Config\Configurations as cfg;
use App\Models\CnaeModel;
use App\Models\CreditoModel;
use App\Models\FornecedorModel;
use App\Models\ModalityModel;
use App\Models\NatureExpenseModel;
use App\Models\OmModel;
use App\Models\ProcessTypeModel;
use App\Models\RegistrosModel;
use App\Models\StatusModel;

class RelatorioController extends Controller implements CtrlInterface
{
    // Recebe a instância do Helper Access
    private $access;

    /*
     * Inicia os atributos usados na View
     */
    public function __construct($bootstrap)
    {
        parent::__construct($bootstrap);
        $this->view->controller = cfg::DEFAULT_URI . 'om/';
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
        $this->controleAction();
    }

    /**
     * Action visualizar
     * Usado para visualizar os registros no sistema
     */
    public function controleAction()
    {
        // título da página
        $this->view->title = 'Registros';

        $omModel = new OmModel();
        $statusModel = new StatusModel();
        $cnaeModel = new CnaeModel();
        $fornecedorModel = new FornecedorModel();
        $modalityModel = new ModalityModel();
        $natureExpenseModel = new NatureExpenseModel();
        $processTypeModel = new ProcessTypeModel();
        $creditoModel = new CreditoModel();

        // alimenta os dados na camada de View
        $this->view->resultOms = $omModel->findActive();
        $this->view->resultStatus = $statusModel->findActive();
        $this->view->resultCnae = $cnaeModel->findActive();
        $this->view->resultModality = $modalityModel->findActive();
        $this->view->resultFornecedor = $fornecedorModel->findActive();
        $this->view->resultNatureExpense = $natureExpenseModel->findActive();
        $this->view->processType = $processTypeModel->findActive();
        $this->view->credito = $creditoModel->findByOmId($this->view->userLoggedIn['oms_id']);
        $this->view->result = [];

        $om = $this->getParam('om');
        $subItem = $this->getParam('subItem');
        $empresa = $this->getParam('supplier');
        $incisivo = $this->getParam('incisive');
        $modalidade = $this->getParam('modality');
        $enquadramento = $this->getParam('enquadramento');
        $naturezaDespesa = $this->getParam('natureExpense');
        $cnae = $this->getParam('cnae');

        if ($modalidade == 1 && $enquadramento == 2) {
            $this->view->result = (new RegistrosModel())->consultaMultiplosParametros(
                $om,
                $modalidade,
                $enquadramento,
                $naturezaDespesa,
                $subItem,
                $cnae
            );
        }

        $this->render('subelemento');
    }
}
