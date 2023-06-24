<?php

namespace App\Models;

use HTR\System\ModelCRUD as CRUD;
use HTR\Helpers\Mensagem\Mensagem as msg;
use HTR\Helpers\Paginator\Paginator;
use Respect\Validation\Validator as v;
use App\Config\Configurations as cfg;

class NatureExpenseModel extends CRUD
{
    protected $entidade = 'nature_expense';
    protected $id;
    protected $codigo;
    protected $descricao;

    private $resultPaginator;
    private $navePaginator;

    /**
     * @return array Todos os resultados exceto os da lixeira
     */
    public function findActive()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} "
            . "WHERE isActive = :isActive ORDER BY codigo ASC;");
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
            'orderBy' => 'codigo ASC',
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
            'id' => $this->getId(),
            'codigo' => $this->getCodigo(),
            'descricao' => $this->getDescricao(),
            'isActive' => 1
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
            'codigo' => $this->getCodigo(),
            'descricao' => $this->getDescricao(),
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
            header('Location: ' . cfg::DEFAULT_URI . 'naturezaDespesa/ver/');
        }
    }

    /*
     * Evita a duplicidade de registros no sistema
     */
    private function notDuplicate()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND codigo = ? AND isActive = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getCodigo());
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
        $this->setCodigo(filter_input(INPUT_POST, 'codigo'));
        $this->setDescricao(filter_input(INPUT_POST, 'descricao'));

        // Inicia a Validação dos dados
        $this->validateId();
        $this->validateCodigo();
        $this->validateDescricao();
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

    private function validateCodigo()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getCodigo());
        if (!$value) {
            msg::showMsg('O campo código deve ser preenchido corretamente.'
                . '<script>focusOn("codigo");</script>', 'danger');
        }
        return $this;
    }

    private function validateDescricao()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getDescricao());
        if (!$value) {
            msg::showMsg('O campo descrição deve ser preenchido corretamente.'
                . '<script>focusOn("descricao");</script>', 'danger');
        }
        return $this;
    }
}
