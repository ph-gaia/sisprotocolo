<?php

/**
 * @Model Registros
 * @Version 0.1
 */

namespace App\Models;

use HTR\System\ModelCRUD as CRUD;
use HTR\Helpers\Mensagem\Mensagem as msg;
use App\Models\SolicitacaoItemModel as Itens;
use HTR\Helpers\Paginator\Paginator;
use Respect\Validation\Validator as v;
use App\Config\Configurations as cfg;
use App\Helpers\Utils;
use App\Helpers\View;

class RegistrosModel extends CRUD
{
    /*
     * Nome da entidade (tabela) usada neste Model.
     * Por padrão, é preciso fornecer o nome da entidade como string
     */
    protected $entidade = 'registers';

    private $resultPaginator;
    private $navePaginator;

    /*
     * Método uaso para retornar todos os dados da tabela.
     */
    public function returnAll()
    {
        /*
         * Método padrão do sistema usado para retornar todos os dados da tabela
         */
        return $this->findAll();
    }

    /**
     * Select by Id Lista Field
     * @param int $requestId
     * @return array
     */
    public function findByIdlista($requestId)
    {
        $query = ""
            . " SELECT "
            . " sol.*, "
            . " supp.name AS suppliers_name, "
            . " supp.cnpj AS suppliers_cnpj, "
            . " supp.details AS suppliers_details, "
            . " oms.naval_indicative, "
            . " modality.name AS modality, "
            . " nature_expense.name AS natureExpense, "
            . " credit.credit_note AS credit "
            . " FROM {$this->entidade} AS sol "
            . " INNER JOIN suppliers AS supp ON supp.id = sol.suppliers_id "
            . " INNER JOIN oms ON oms.id = sol.oms_id "
            . " INNER JOIN modality ON modality.id = sol.modality_id"
            . " LEFT JOIN nature_expense ON nature_expense.id = sol.nature_expense_id"
            . " LEFT JOIN credit ON credit.id = sol.credit_id"
            . " WHERE sol.id = :requestId ";
        $stmt = $this->pdo->prepare($query);
        $stmt->execute([':requestId' => $requestId]);
        return $stmt->fetch(\PDO::FETCH_ASSOC);
    }

    public function consultaMultiplosParametros($omId, $modalidade, $enquadramento, $naturezaDespesa, $subItem)
    {
        $stmt = $this->pdo->prepare(""
            . " SELECT "
            . "     registers.*, "
            . "     IFNULL(SUM(registers.document_value), 0) as registers_value, "
            . "     IFNULL(credit.value, (SELECT credit.value FROM credit WHERE id = :creditId and oms_id = :omId)) as credit_value,  "
            . "     oms.naval_indicative "
            . " FROM registers "
            . " INNER JOIN credit ON credit.id = registers.credit_id "
            . " INNER JOIN oms ON oms.id = registers.oms_id "
            . " WHERE "
            . "     registers.oms_id = :omId "
            . "     OR registers.modality_id = :modalityId "
            . "     OR registers.credit_id = :creditId "
            . "     OR registers.nature_expense_id = :natureExpense "
            . "     OR registers.sub_item = :subItem; ");

        $stmt->execute([
            ':omId' => $omId,
            ':modalityId' => $modalidade,
            ':creditId' => $enquadramento,
            ':natureExpense' => $naturezaDespesa,
            ':subItem' => $subItem,
        ]);

        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    public function paginator($pagina, $om)
    {
        $innerJoin = " INNER JOIN modality ON modality.id = registers.modality_id";
        $innerJoin .= " INNER JOIN oms ON oms.id = registers.oms_id";

        $dados = [
            'select' => 'registers.*, modality.name as modality, oms.naval_indicative',
            'pdo' => $this->pdo,
            'entidade' => $this->entidade . $innerJoin,
            'pagina' => $pagina,
            'maxResult' => 10,
            // USAR QUANDO FOR PARA DEMONSTRAR O RESULTADO DE UMA PESQUISA
            'orderBy' => 'registers.document_number DESC',
            'where' => 'registers.isActive = ? AND registers.oms_id = ? ',
            'bindValue' => [0 => 1, 1 => $om]
        ];

        // Instacia o Helper que auxilia na paginação de páginas
        $paginator = new Paginator($dados);
        // Resultado da consulta
        $this->resultPaginator =  $paginator->getResultado();
        // Links para criação do menu de navegação da paginação @return array
        $this->navePaginator = $paginator->getNaveBtn();
    }

    public function paginatorHistorico($pagina, $connect)
    {
        /*
         * Preparando as diretrizes da consulta
         */
        $dados = [
            'pdo' => $this->pdo,
            'entidade' => $this->entidade,
            'pagina' => $pagina,
            'maxResult' => 10,
            'orderBy' => 'document_number ASC',
            'where' => 'isActive = ?',
            'bindValue' => [0 => 1]
        ];

        // Instacia o Helper que auxilia na paginação de páginas
        $paginator = new Paginator($dados);
        // Resultado da consulta
        $this->resultPaginator =  $paginator->getResultado();
        // Links para criação do menu de navegação da paginação @return array
        $this->navePaginator = $paginator->getNaveBtn();
    }

    // Acessivel para o Controller coletar os resultados
    public function getResultPaginator()
    {
        return $this->resultPaginator;
    }
    // Acessivel para o Controller coletar os links da paginação
    public function getNavePaginator()
    {
        return $this->navePaginator;
    }

    /*
     * Método responsável por salvar os registros
     */
    public function novoRegistro($user)
    {
        // Valida dados
        $this->validateAll($user);
        // Verifica se há registro igual e evita a duplicação
        $this->notDuplicate();

        if ($this->getModality() == 1) {
            // valida regras de enquadramento
            $this->validaCredito();

            $dados = [
                'oms_id' => $this->getOm(),
                'cnpj' => $this->getCnpj(),
                'nature_expense_id' => $this->getNatureExpense(),
                'suppliers_id' => $this->getSupplier(),
                'modality_id' => $this->getModality(),
                'cnae' => $this->getCnae(),
                'credit_id' => null,
                'article' => null,
                'sub_item' => null,
                'number_arp' => null,
                'item_arp' => null,
                'incisive' => null,
                'summary_object' => null,
                'credit_id' => $this->getCredit(),
                'article' => $this->getArticle(),
                'sub_item' => $this->getSubItem(),
                'incisive' => $this->getIncisive(),
                'observation' => $this->getObservation(),
                'document_number' => $this->getDocNumber(),
                'document_value' => $this->getDocumentValue(),
                'status_id' => $this->getStatus(),
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s'),
                'isActive' => 1,
            ];
        }

        if ($this->getModality() == 2) {
            $dados = [
                'oms_id' => $this->getOm(),
                'cnpj' => $this->getCnpj(),
                'nature_expense_id' => null,
                'suppliers_id' => $this->getSupplier(),
                'biddings_id' => $this->getBiddingsId(),
                'modality_id' => $this->getModality(),
                'cnae' => null,
                'credit_id' => null,
                'article' => null,
                'sub_item' => null,
                'number_arp' => null,
                'item_arp' => null,
                'incisive' => null,
                'observation' => $this->getObservation(),
                'summary_object' => $this->getSummaryObject(),
                'bidding_process_number' => null,
                'document_number' => $this->getDocNumber(),
                'document_value' => $this->getDocumentValue(),
                'status_id' => $this->getStatus(),
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s'),
                'isActive' => 1,
            ];
        }

        if (parent::novo($dados)) {
            $lastId = $this->pdo->lastInsertId();

            if ($this->getModality() == 2) {
                (new RegistrosItemModel())->novoRegistro($this->getItemsList(), $lastId, $this->getOm());
            }

            if ($this->getModality() == 1) {
                (new HistoricoCreditoModel())->novaTransacao(
                    $this->getCredit(),
                    $this->getDocumentValue(),
                    'DEBITO',
                    "DÉBITO DE " . View::floatToMoney($this->getDocumentValue()) . "; REFERENTE AO DOCUMENTO " . $this->getDocNumber()
                );
            }

            (new HistoricoAcaoModel())->novoRegistro(
                $lastId,
                $this->getUserId(),
                $this->getStatus(),
                null,
                $this->getDocNumber()
            );

            msg::showMsg('111', 'success');
        }
    }

    /*
     * Método responsável por alterar os registros
     */
    public function editarRegistro($user)
    {
        // Valida dados
        $this->validateAll($user);
        // Verifica se há registro igual e evita a duplicação
        $this->notDuplicate();

        $dados = [
            'oms_id' => $this->getOm(),
            'cnpj' => $this->getCnpj(),
            'nature_expense' => $this->getNatureExpense(),
            'subitem' => $this->getSubItem(),
            'process_type' => $this->getProcessType(),
            'suppliers_id' => $this->getSupplier(),
            'cnae' => $this->getCnae(),
            'number_arp' => $this->getNumerArp(),
            'document_number' => $this->getDocNumber(),
            'docresult' => $this->getDocResult(),
            'article' => $this->getArticle(),
            'item_arp' => $this->getItemArp(),
            'modality' => $this->getModality(),
            'document_value' => $this->getDocumentValue(),
            'incisive' => $this->getIncisive(),
            'status' => $this->getStatus(),
        ];
        if (parent::editar($dados, $this->getId())) {
            msg::showMsg('001', 'success');
        }
    }

    public function validaCredito()
    {
        if ($this->getCredit() == 1) {
            $credito = (new CreditoModel())->saldoComprometidoLei1(
                $this->getOm(),
                $this->getModality(),
                $this->getCredit(),
                $this->getNatureExpense(),
                $this->getSubItem()
            );
        }

        if ($this->getCredit() == 2) {
            $credito = (new CreditoModel())->saldoComprometidoLei2(
                $this->getOm(),
                $this->getModality(),
                $this->getCredit(),
                $this->getCnpj(),
                $this->getCnae()
            );
        }

        if ($this->getDocumentValue() > ($credito['credit_value'] - $credito['registers_value'])) {
            msg::showMsg("O Documento " . $this->getDocNumber() . " possui o valor superior ao saldo disponível no crédito para essa configuração", "danger");
        }
    }

    /*
     * Método responsável por alterar os registros
     */
    public function incluiStatus($user)
    {
        // Valida dados
        $this->setId(filter_input(INPUT_POST, 'registerId'));
        $this->setUserId(filter_var($user['id']));
        $this->setStatus(filter_input(INPUT_POST, 'status'));
        $this->setObservartion(filter_input(INPUT_POST, 'observation'));
        $this->setResultingDocument(filter_input(INPUT_POST, 'resultingDocument'));

        // Verifica se há registro igual e evita a duplicação
        $this->notDuplicateStatus();

        (new HistoricoAcaoModel())->novoRegistro(
            $this->getId(),
            $this->getUserId(),
            $this->getStatus(),
            $this->getObservartion(),
            $this->getResultingDocument()
        );

        msg::showMsg('111', 'success');
    }

    /*
     * Método responsável por remover os registros do sistema
     */
    public function remover($id)
    {
        $dados = [
            'isActive' => 0
        ];

        if (parent::editar($dados, $id)) {
            header('Location: ' . cfg::DEFAULT_URI . 'registros/historico/id/' . $id);
        }
    }

    /*
     * Evita a duplicidade de registros no sistema
     */
    private function notDuplicate()
    {
        return true;
    }

    private function notDuplicateStatus()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM historic_status_registers "
            . "WHERE registers_id != ? AND status_id = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getStatus());
        $stmt->execute();
        if (!$stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('Já existe um registro com esse status', 'warning');
        }
    }

    /**
     * Make the itens of Biggings requests
     * @param array $values The input values
     * @return array
     */
    private function buildItemsBiddings(array $values): array
    {
        $result = [];
        if (isset($values['quantity']) && is_array($values['quantity'])) {
            foreach ($values['quantity'] as $index => $value) {
                $id = filter_var($values['ids'][$index], FILTER_VALIDATE_INT);
                $result[$id] = [
                    'quantity' => $this->validaQuantity($value),
                    'value' => $this->validaValue($values['valueItem'][$index]),
                ];
            }
        }

        return $result;
    }

    /*
     * Validação dos Dados enviados pelo formulário
     */
    private function validateAll($user)
    {
        $value = filter_input_array(INPUT_POST);
        // Seta todos os valores
        $this->setId(filter_input(INPUT_POST, 'id'));
        $this->setOm(filter_input(INPUT_POST, 'om'));
        $this->setNatureExpense(filter_input(INPUT_POST, 'natureExpense'));
        $this->setSubItem(filter_input(INPUT_POST, 'subItem'));
        $this->setSupplier(filter_input(INPUT_POST, 'supplier'));
        $this->setCnpj(filter_input(INPUT_POST, 'cnpj'));
        $this->setCnae(filter_input(INPUT_POST, 'cnae'));
        $this->setUserId(filter_var($user['id']));
        $this->setCredit(filter_input(INPUT_POST, 'enquadramento'));
        $this->setDocNumber(filter_input(INPUT_POST, 'document_number'));
        $this->setSummaryObject(filter_input(INPUT_POST, 'summary_object'));
        $this->setBiddingProcessNumber(filter_input(INPUT_POST, 'bidding_process_number'));
        $this->setArticle(filter_input(INPUT_POST, 'article'));
        $this->setModality(filter_input(INPUT_POST, 'modality'));
        $this->setIncisive(filter_input(INPUT_POST, 'incisive'));
        $this->setStatus(filter_input(INPUT_POST, 'status'));
        $this->setObservation(filter_input(INPUT_POST, 'observation'));
        $this->setItemsList($this->buildItemsBiddings($value));
        $this->setBiddingsId(filter_input(INPUT_POST, 'biddings_id'));

        // Inicia a Validação dos dados
        if ($this->getModality() == 1) {
            $this->setDocumentValue(filter_input(INPUT_POST, 'document_value', FILTER_SANITIZE_SPECIAL_CHARS));
            $this->setDocumentValue(Utils::moneyToFloat($this->getDocumentValue()));
        }
        if ($this->getModality() == 2) {
            $this->validaItemsList();
            $this->validaValorPedido();
        }
        $this->validateId();
        $this->validateNumber();
        $this->validateOm();
        $this->validaFornecedor();
    }

    private function setId($value)
    {
        $this->id = $value ?: time();
        return $this;
    }

    private function validaQuantity($value)
    {
        $value = str_replace(",", ".", $value);
        $value = intval($value);
        $validate = v::intVal()->validate($value);

        if (!$validate) {
            msg::showMsg('O(s) valor(es)  do(s) campo(s) QUANTIDADE deve(m) ser'
                . ' número INTEIRO não negativo e maior que zero', 'danger');
        }
        return $value;
    }

    private function validaValue($value)
    {
        $validate = v::floatVal()->notEmpty()->validate($value);
        if (!$validate) {
            msg::showMsg('O(s) valor(es)  do(s) campo(s) VALOR deve(m) ser'
                . ' preenchido corretamente', 'danger');
        }
        return $value;
    }

    public function validaValorPedido()
    {
        $total = 0;
        foreach ($this->getItemsList() as $value) {
            $total += $value['quantity'] * floatval($value['value']);
        }
        $this->setDocumentValue($total);
        return $this;
    }

    private function validaItemsList()
    {
        if (empty($this->getItemsList())) {
            msg::showMsg('Para realizar uma solicitação, é imprescindível'
                . ' fornecer a quantidade de no mínimo um Item.', 'danger');
        }
        return $this;
    }

    private function validateId()
    {
        $value = v::intVal()->validate($this->getId());
        if (!$value) {
            msg::showMsg('O campo id deve ser preenchido corretamente.'
                . '<script>focusOn("id");</script>', 'danger');
        }
        return $this;
    }

    private function validateConnect()
    {
        $value = v::intVal()->validate($this->getConnect());
        if (!$value) {
            msg::showMsg('O campo connect deve ser preenchido corretamente.'
                . '<script>focusOn("connect");</script>', 'danger');
        }
        return $this;
    }

    private function validateNumber()
    {
        $value = v::stringType()->notEmpty()->length(1, 10)->validate($this->getDocNumber());
        if (!$value) {
            msg::showMsg('O campo Número deve ser preenchido corretamente.'
                . '<script>focusOn("number");</script>', 'danger');
        }
        return $this;
    }

    private function validateOm()
    {
        $value = v::intVal()->validate($this->getOm());
        if (!$value) {
            msg::showMsg('O campo OM deve ser preenchido corretamente.'
                . '<script>focusOn("om");</script>', 'danger');
        }
        return $this;
    }

    private function validaFornecedor()
    {
        $value = v::intVal()->validate($this->getSupplier());
        if (!$value) {
            msg::showMsg('É necessário informar um Fornecedor', 'danger');
        }
        return $this;
    }

    private function validateTime()
    {
        $value = v::intVal()->validate($this->getTime());
        if (!$value) {
            msg::showMsg('O campo Data/Hora deve ser preenchido corretamente.'
                . '<script>focusOn("time");</script>', 'danger');
        }
        return $this;
    }

    private function validateType()
    {
        $value = v::stringType()->notEmpty()->length(1, 20)->validate($this->getType());
        if (!$value) {
            msg::showMsg('O campo Tipo deve ser preenchido corretamente.'
                . '<script>focusOn("type");</script>', 'danger');
        }
        return $this;
    }

    private function validateDocresult()
    {
        $value = v::stringType()->notEmpty()->length(1, 15)->validate($this->getStatus());
        if (!$value) {
            msg::showMsg('O campo Documento Resultante deve ser preenchido corretamente.'
                . '<script>focusOn("docresult");</script>', 'danger');
        }
        return $this;
    }

    private function validateStatus()
    {
        $value = v::stringType()->notEmpty()->length(1, 20)->validate($this->getStatus());
        if (!$value) {
            msg::showMsg('O campo Status deve ser preenchido corretamente.'
                . '<script>focusOn("status");</script>', 'danger');
        }
        return $this;
    }
}
