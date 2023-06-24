<?php

namespace App\Models;

use HTR\System\ModelCRUD as CRUD;
use HTR\Helpers\Mensagem\Mensagem as msg;
use HTR\Helpers\Paginator\Paginator;
use Respect\Validation\Validator as v;
use App\Config\Configurations as cfg;
use App\Helpers\Utils;
use App\Helpers\View;

class AcompanhamentoModel extends CRUD
{
    protected $entidade = 'acompanhamento';

    private $resultPaginator;
    private $navePaginator;

    /**
     * @return array Todos os resultados exceto os da lixeira
     */
    
    public function returnAll()
    {
        /*
         * Método padrão do sistema usado para retornar todos os dados da tabela
         */
        return $this->findAll();
    }

    /*public function findActive()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} "
            . "WHERE isActive = :isActive ORDER BY nup ASC;");
        $stmt->bindValue(':isActive', 1);
        $stmt->execute();
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }*/

    public function findByIdlista($requestId)
    {
        $query = ""
            . " SELECT "
            . " sol.*, "
            . " oms.naval_indicative, "
            . " modality.name AS modality, "
            . " FROM {$this->entidade} AS sol "
            . " INNER JOIN oms ON oms.id = sol.oms_id "
            . " INNER JOIN modality ON modality.id = sol.modality_id"
            . " WHERE sol.id = :requestId ";
        $stmt = $this->pdo->prepare($query);
        $stmt->execute([':requestId' => $requestId]);
        return $stmt->fetch(\PDO::FETCH_ASSOC);
    }

    /*
     * Método uaso para retornar todos os dados da tabela.
     */
    
    public function paginator($pagina, $om)
    {
        $innerJoin = " INNER JOIN modality ON modality.id = acompanhamento.modality_id";
        $innerJoin .= " INNER JOIN oms ON oms.id = acompanhamento.oms_id";

        $dados = [
            'select' => 'acompanhamento.*, modality.name as modality, oms.naval_indicative',
            'pdo' => $this->pdo,
            'entidade' => $this->entidade . $innerJoin,
            'pagina' => $pagina,
            'maxResult' => 10,
            // USAR QUANDO FOR PARA DEMONSTRAR O RESULTADO DE UMA PESQUISA
            'orderBy' => 'acompanhamento.document_number DESC',
            'where' => 'acompanhamento.isActive = ? AND acompanhamento.oms_id = ? ',
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

        /*if ($this->getModality() == 1) {
            // valida se estiver usando a Lei nº 14.133/2021*/
            $dados = [
                'oms_id' => $this->getOm(),
                'modality_id' => $this->getModality(),
                'nup' => $this->getNup(),
                'document_number' => $this->getDocNumber(),
                'summary_object' => $this->getSummaryObject(),
                'document_value' => $this->getDocumentValue(),
                'observation' => $this->getObservation(),
                'status_id' => $this->getStatus(),
                'created_at' => date('Y-m-d H:i:s'),
                'updated_at' => date('Y-m-d H:i:s'),
                'isActive' => 1,
            ];
        /*}*/

        if (parent::novo($dados)) {
            $lastId = $this->pdo->lastInsertId();

            (new HistoricoAcompanhamentoAcaoModel())->novoRegistro(
                $lastId,
                $this->getUserId(),
                $this->getStatus(),
                $this->getObservation(),                
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
            'modality_id' => $this->getModality(),
            'nup' => $this->getNup(),
            'document_number' => $this->getDocNumber(),
            /*'docresult' => $this->getDocResult(),*/
            'summary_object' => $this->getSummaryObject(),
            'document_value' => $this->getDocumentValue(),
            'status_id' => $this->getStatus(),
        ];

        if (parent::editar($dados, $this->getId())) {
            msg::showMsg('001', 'success');
        }
    }

    public function incluiStatus($user)
    {
        // Valida dados
        $this->setId(filter_input(INPUT_POST, 'registerId'));
        $this->setUserId(filter_var($user['id']));
        $this->setStatus(filter_input(INPUT_POST, 'status_id'));
        $this->setObservation(filter_input(INPUT_POST, 'observation'));
        $this->setResultingDocument(filter_input(INPUT_POST, 'resultingDocument'));

        // Verifica se há registro igual e evita a duplicação
        $this->notDuplicateStatus();

        (new HistoricoAcompanhamentoAcaoModel())->novoRegistro(
            $this->getId(),
            $this->getUserId(),
            $this->getStatus(),
            $this->getObservation(),
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
            header('Location: ' . cfg::DEFAULT_URI . 'acompanhamento/historico/id/' . $id);
        }
    }

    /*
     * Evita a duplicidade de registros no sistema
     */
    private function notDuplicate()
    {
        /*$stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND nup = ? AND isActive = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getNup());
        $stmt->bindValue(3, '1');
        $stmt->execute();
        if ($stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('Já existe um registro com este(s) caractere(s) no campo '
                . '<strong>Sigla</strong>.'
                . '<script>focusOn("initials")</script>', 'warning');
        }*/
        return true;
    }

    private function notDuplicateStatus()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM historic_status_acompanhamento "
            . "WHERE acompanhamento_id = ? AND status_id = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getStatus());
        $stmt->execute();
        if ($stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('Já existe um registro com esse status', 'warning');
        }
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
        $this->setNup(filter_input(INPUT_POST, 'nup'));
        $this->setUserId(filter_var($user['id']));
        $this->setModality(filter_input(INPUT_POST, 'modality'));
        $this->setDocNumber(filter_input(INPUT_POST, 'document_number'));
        $this->setSummaryObject(filter_input(INPUT_POST, 'summary_object'));
        $this->setStatus(filter_input(INPUT_POST, 'status_id'));
        $this->setObservation(filter_input(INPUT_POST, 'observation'));

        $this->setDocumentValue(filter_input(INPUT_POST, 'document_value', FILTER_SANITIZE_SPECIAL_CHARS));
        $this->setDocumentValue(Utils::moneyToFloat($this->getDocumentValue(), false));
        
        // Inicia a Validação dos dados
        // $this->validateId();
        $this->validateNumber();
        $this->validateOm();
        
        /*$this->validateId();
        $this->validateNup();
        $this->validateModality();
        $this->validateNumber();
        $this->validateUasg();
        $this->validateObjeto();
        $this->validateValorestimado();
        $this->validateStatus();
        $this->validateObservation();*/
    }

    /*private function setId($value)
    {
        $this->id = $value ?: time();
        return $this;
    }*/

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
        $value = v::stringType()->notEmpty()->length(1, 50)->validate($this->getDocNumber());
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

    private function validateTime()
    {
        $value = v::intVal()->validate($this->getTime());
        if (!$value) {
            msg::showMsg('O campo Data/Hora deve ser preenchido corretamente.'
                . '<script>focusOn("time");</script>', 'danger');
        }
        return $this;
    }

    private function validateDocresult()
    {
        $value = v::stringType()->notEmpty()->length(1, 15)->validate($this->getDocResult());
        if (!$value) {
            msg::showMsg('O campo Documento Resultante deve ser preenchido corretamente.'
                . '<script>focusOn("docresult");</script>', 'danger');
        }
        return $this;
    }

    /*private function validateNup()
    {
        $value = v::stringType()->notEmpty()->length(1, 20)->validate($this->getNup());
        if (!$value) {
            msg::showMsg('O campo NUP deve ser preenchido corretamente.'
                . '<script>focusOn("nup");</script>', 'danger');
        }
        return $this;
    }

    private function validateModality()
    {
        $value = v::intVal()->validate($this->getModality());
        if (!$value) {
            msg::showMsg('O campo modalidade deve ser preenchido corretamente.'
                . '<script>focusOn("modality_id");</script>', 'danger');
        }
        return $this;
    }

    private function validateNumber()
    {
        $value = v::stringType()->notEmpty()->length(1, 20)->validate($this->getNumber());
        if (!$value) {
            msg::showMsg('O campo número deve ser preenchido corretamente.'
                . '<script>focusOn("document_number");</script>', 'danger');
        }
        return $this;
    }

    private function validateUasg()
    {
        $value = v::intVal()->validate($this->getUasg());
        if (!$value) {
            msg::showMsg('O campo UASG deve ser preenchido corretamente.'
                . '<script>focusOn("oms_id");</script>', 'danger');
        }
        return $this;
    }

    private function validateObjeto()
    {
        $value = v::stringType()->notEmpty()->length(1, 150)->validate($this->getObjeto());
        if (!$value) {
            msg::showMsg('O campo objeto deve ser preenchido corretamente.'
                . '<script>focusOn("summary_object");</script>', 'danger');
        }
        return $this;
    }

    private function validateValorestimado()
    {
        $value = v::floatVal()->notEmpty()->validate($this->getValorestimado());
        if (!$value) {
            msg::showMsg('O campo valor estimado deve ser preenchido corretamente.'
                . '<script>focusOn("document_value");</script>', 'danger');
        }
        return $this;
    }*/

    private function validateStatus()
    {
        $value = v::stringType()->notEmpty()->length(1, 20)->validate($this->getStatus());
        if (!$value) {
            msg::showMsg('O campo Status deve ser preenchido corretamente.'
                . '<script>focusOn("status_id");</script>', 'danger');
        }
        return $this;
    }

    /*private function validateObservation()
    {
        $value = v::stringType()->notEmpty()->length(1, 150)->validate($this->getObservation());
        if (!$value) {
            msg::showMsg('O campo observação deve ser preenchido corretamente.'
                . '<script>focusOn("observation");</script>', 'danger');
        }
        return $this;
    }*/
}
