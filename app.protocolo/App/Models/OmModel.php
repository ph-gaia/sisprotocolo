<?php

/**
 * @Model Om
 * @Version 0.1
 */

namespace App\Models;

use HTR\System\ModelCRUD as CRUD;
use HTR\Helpers\Mensagem\Mensagem as msg;
use HTR\Helpers\Paginator\Paginator;
use Respect\Validation\Validator as v;
use App\Config\Configurations as cfg;

class OmModel extends CRUD
{
    /*
     * Nome da entidade (tabela) usada neste Model.
     * Por padrão, é preciso fornecer o nome da entidade como string
     */
    protected $entidade = 'oms';

    private $resultPaginator;
    private $navePaginator;

    /**
     * @return array Todos os resultados exceto os da lixeira
     */
    public function findActive()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade}"
            . " WHERE isActive = :isActive ORDER BY naval_indicative;");
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

    public function paginator($pagina, $user = null, $busca = null)
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
            'orderBy' => 'naval_indicative ASC',
            'where' => 'isActive = :active',
            'bindValue' => [':active' => 1]
        ];

        if (isset($user) && $user['level'] == 2) {
            $dados['where'] = "id = :omsId and isActive = :active";
            $dados['bindValue'] = [
                ':omsId' => $user['oms_id'],
                ':active' => 1
            ];
        }

        if ($busca) {
            $dados['where'] = " "
                . " oms.name LIKE :seach "
                . " OR oms.naval_indicative LIKE :seach ";
            $dados['bindValue'][':seach'] = '%' . $busca . '%';
        }

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
            'name' => $this->getNome(),
            'naval_indicative' => $this->getIndicativoNaval(),
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
            'name' => $this->getNome(),
            'naval_indicative' => $this->getIndicativoNaval(),
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
            header('Location: ' . cfg::DEFAULT_URI . 'om/visualizar/');
        }
    }

    /*
     * Evita a duplicidade de registros no sistema
     */
    private function notDuplicate()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND naval_indicative = ? AND isActive = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getIndicativoNaval());
        $stmt->bindValue(3, '1');
        $stmt->execute();
        if ($stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('Já existe um registro com este(s) caractere(s) no campo '
                . '<strong>Indicativo Naval</strong>.'
                . '<script>focusOn("initials")</script>', 'warning');
        }
    }

    /*
     * Validação dos Dados enviados pelo formulário
     */
    private function validateAll()
    {
        // Seta todos os valores
        $this->setId(filter_input(INPUT_POST, 'id'))
            ->setNome(filter_input(INPUT_POST, 'name', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setIndicativoNaval(filter_input(INPUT_POST, 'naval_indicative'));

        // Inicia a Validação dos dados
        $this->validateId();
        $this->validaNome();
        $this->validaIndicativoNaval();
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

    private function validaNome()
    {
        $value = v::stringType()->notEmpty()->length(1, 60)->validate($this->getNome());
        if (!$value) {
            msg::showMsg('O campo Nome deve ser deve ser preenchido corretamente.'
                . '<script>focusOn("name");</script>', 'danger');
        }
        return $this;
    }

    private function validaIndicativoNaval()
    {
        $value = v::stringType()->notEmpty()->length(1, 6)->validate($this->getIndicativoNaval());
        if (!$value) {
            msg::showMsg('O campo Indicativo Naval deve ser preenchido '
                . 'corretamente <strong>com 6 caracteres</strong>.'
                . '<script>focusOn("naval_indicative");</script>', 'danger');
        }
        return $this;
    }
}
