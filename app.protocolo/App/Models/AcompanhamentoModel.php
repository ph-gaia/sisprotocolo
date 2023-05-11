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
    protected $entidade = 'registers';

    private $resultPaginator;
    private $navePaginator;

    /**
     * @return array Todos os resultados exceto os da lixeira
     */
    public function findActive()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} "
            . "WHERE isActive = :isActive ORDER BY nup ASC;");
        $stmt->bindValue(':isActive', 1);
        $stmt->execute();
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

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

    public function paginator($pagina)
    {
        /*
         * Preparando as diretrizes da consulta
         */
        $dados = [
            'pdo' => $this->pdo,
            'entidade' => $this->entidade,
            'pagina' => $pagina,
            'maxResult' => 20,
            // USAR QUANDO FOR PARA DEMONSTRAR O RESULTADO DE UMA PESQUISA
            'orderBy' => 'number ASC',
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
    public function novoRegistro()
    {
        // Valida dados
        $this->validateAll();
        // Verifica se há registro igual e evita a duplicação
        $this->notDuplicate();

        $dados = [
            'suppliers_id' => null,
            'nup' => $this->getNup(),
            'modality_id' => $this->getModality(),
            'document_number' => $this->getNumber(),
            'oms_id' => $this->getUasg(),
            'summary_object' => $this->getObjeto(),
            'document_value' => $this->getValorestimado(),
            'status_id' => $this->getStatus(),
            'observation' => $this->getObservation(),
            'created_at' => date('Y-m-d H:i:s'),
            'isActive' => 1,
        ];

        if (parent::novo($dados)) {
            msg::showMsg('111', 'success');
        }
    }

    /*
     * Método responsável por alterar os registros
     */
    public function editarRegistro()
    {
        // Valida dados
        $this->validateAll();
        // Verifica se há registro igual e evita a duplicação
        $this->notDuplicate();

        $dados = [
            'suppliers_id' => null,
            'nup' => $this->getNup(),
            'modality_id' => $this->getModality(),
            'document_number' => $this->getNumber(),
            'oms_id' => $this->getUasg(),
            'summary_object' => $this->getObjeto(),
            'document_value' => $this->getValorestimado(),
            'status_id' => $this->getStatus(),
            'observation' => $this->getObservation()
        ];

        if (parent::editar($dados, $this->getId())) {
            msg::showMsg('001', 'success');
        }
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
            header('Location: ' . cfg::DEFAULT_URI . 'acompanhamento/ver/');
        }
    }

    /*
     * Evita a duplicidade de registros no sistema
     */
    private function notDuplicate()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND nup = ? AND isActive = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getNup());
        $stmt->bindValue(3, '1');
        $stmt->execute();
        if ($stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('Já existe um registro com este(s) caractere(s) no campo '
                . '<strong>Sigla</strong>.'
                . '<script>focusOn("initials")</script>', 'warning');
        }
    }

    /*
     * Validação dos Dados enviados pelo formulário
     */
    private function validateAll()
    {
        // Seta todos os valores
        $this->setId(filter_input(INPUT_POST, 'id'));
        $this->setNup(filter_input(INPUT_POST, 'nup'));
        $this->setModality(filter_input(INPUT_POST, 'modality_id'));
        $this->setNumber(filter_input(INPUT_POST, 'number'));
        $this->setUasg(filter_input(INPUT_POST, 'uasg_id'));
        $this->setObjeto(filter_input(INPUT_POST, 'objeto'));
        $this->setValorestimado(filter_input(INPUT_POST, 'valor_estimado'));
        $this->setStatus(filter_input(INPUT_POST, 'status_id'));
        $this->setObservation(filter_input(INPUT_POST, 'observation'));

        $this->setValorestimado(filter_input(INPUT_POST, 'valor_estimado', FILTER_SANITIZE_SPECIAL_CHARS));
        $this->setValorestimado(Utils::moneyToFloat($this->getValorestimado(), false));

        // Inicia a Validação dos dados
        $this->validateId();
        $this->validateNup();
        $this->validateModality();
        $this->validateNumber();
        $this->validateUasg();
        $this->validateObjeto();
        $this->validateValorestimado();
        $this->validateStatus();
        $this->validateObservation();
    }

    private function setId($value)
    {
        $this->id = $value ?: time();
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


    private function validateNup()
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
                . '<script>focusOn("number");</script>', 'danger');
        }
        return $this;
    }

    private function validateUasg()
    {
        $value = v::intVal()->validate($this->getUasg());
        if (!$value) {
            msg::showMsg('O campo UASG deve ser preenchido corretamente.'
                . '<script>focusOn("uasg_id");</script>', 'danger');
        }
        return $this;
    }

    private function validateObjeto()
    {
        $value = v::stringType()->notEmpty()->length(1, 150)->validate($this->getObjeto());
        if (!$value) {
            msg::showMsg('O campo objeto deve ser preenchido corretamente.'
                . '<script>focusOn("objeto");</script>', 'danger');
        }
        return $this;
    }

    private function validateValorestimado()
    {
        $value = v::floatVal()->notEmpty()->validate($this->getValorestimado());
        if (!$value) {
            msg::showMsg('O campo valor estimado deve ser preenchido corretamente.'
                . '<script>focusOn("valor_estimado");</script>', 'danger');
        }
        return $this;
    }

    private function validateStatus()
    {
        $value = v::stringType()->notEmpty()->length(1, 20)->validate($this->getStatus());
        if (!$value) {
            msg::showMsg('O campo Status deve ser preenchido corretamente.'
                . '<script>focusOn("status_id");</script>', 'danger');
        }
        return $this;
    }

    private function validateObservation()
    {
        $value = v::stringType()->notEmpty()->length(1, 150)->validate($this->getObservation());
        if (!$value) {
            msg::showMsg('O campo observação deve ser preenchido corretamente.'
                . '<script>focusOn("observation");</script>', 'danger');
        }
        return $this;
    }
}
