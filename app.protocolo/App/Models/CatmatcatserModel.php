<?php

namespace App\Models;

use HTR\System\ModelCRUD as CRUD;
use HTR\Helpers\Mensagem\Mensagem as msg;
use HTR\Helpers\Paginator\Paginator;
use Respect\Validation\Validator as v;
use App\Config\Configurations as cfg;

class CatmatcatserModel extends CRUD
{
    protected $entidade = 'cat_material_service';
    protected $id;
    protected $tipo;
    protected $codgrupo;
    protected $descgrupo;
    protected $codclasse;
    protected $descclasse;
    protected $codpdm;
    protected $descpdm;
    protected $coditem;
    protected $descitem;
    protected $sitatual;
    protected $sitsustentavel;

    private $resultPaginator;
    private $navePaginator;

    /**
     * @return array Todos os resultados exceto os da lixeira
     */
    public function findActive()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} "
            . "WHERE isActive = :isActive ORDER BY group_id ASC;");
        $stmt->bindValue(':isActive', 1);
        $stmt->execute();
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /**
     * @return array
     */
    public function findMaterialActive()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} "
            . "WHERE isActive = :isActive AND TYPE = 'MATERIAL' ORDER BY group_id ASC;");
        $stmt->bindValue(':isActive', 1);
        $stmt->execute();
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    /**
     * @return array
     */
    public function findServiceActive()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} "
            . "WHERE isActive = :isActive AND TYPE = 'SERVICO' ORDER BY group_id ASC;");
        $stmt->bindValue(':isActive', 1);
        $stmt->execute();
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    public function findInformById($catId, $omId)
    {
        $query = "";
        $query .= " SELECT ";
        $query .= "     IFNULL(SUM(registers_items_cat.value), 0) as registers_value, ";
        $query .= "     IFNULL(credit.value, (SELECT credit.value FROM credit WHERE id = 2)) as credit_value, ";
        $query .= "     IFNULL(cat_material_service.item_description, (SELECT matserv.item_description FROM cat_material_service as matserv WHERE id = :catId)) as item_desc ";
        $query .= " FROM registers_items_cat ";
        $query .= "     INNER JOIN cat_material_service ON cat_material_service.id = registers_items_cat.cat_id ";
        $query .= "     INNER JOIN registers ON registers.id = registers_items_cat.registers_id ";
        $query .= "     INNER JOIN credit ON credit.id = registers.credit_id ";
        $query .= " WHERE registers.oms_id = :omId ";
        $query .= " AND registers_items_cat.cat_id = :catId ";
        $query .= " AND registers.credit_id = 2; ";

        $stmt = $this->pdo->prepare($query);
        $stmt->bindValue(':catId', $catId);
        $stmt->bindValue(':omId', $omId);
        $stmt->execute();

        return $stmt->fetch(\PDO::FETCH_ASSOC);
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
            'orderBy' => 'group_id ASC',
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
            'type' => $this->getTipo(),
            'group_id' => $this->getCodgrupo(),
            'group_description' => $this->getDescgrupo(),
            'class_id' => $this->getCodclasse(),
            'class_description' => $this->getDescclasse(),
            'pdm_id' => $this->getCodpdm(),
            'pdm_description' => $this->getDescpdm(),
            'item_id' => $this->getCoditem(),
            'item_description' => $this->getDescitem(),
            'sustainable' => $this->getSitsustentavel(),
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
            'type' => $this->getTipo(),
            'group_id' => $this->getCodgrupo(),
            'group_description' => $this->getDescgrupo(),
            'class_id' => $this->getCodclasse(),
            'class_description' => $this->getDescclasse(),
            'pdm_id' => $this->getCodpdm(),
            'pdm_description' => $this->getDescpdm(),
            'item_id' => $this->getCoditem(),
            'item_description' => $this->getDescitem(),
            'sustainable' => $this->getSitsustentavel()
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
            header('Location: ' . cfg::DEFAULT_URI . 'catmatcatser/ver/');
        }
    }

    /*
     * Evita a duplicidade de registros no sistema
     */
    private function notDuplicate()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND item_id = ? AND item_description = ? AND isActive = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getCoditem());
        $stmt->bindValue(3, $this->getDescitem());
        $stmt->bindValue(4, '1');
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
        $this->setTipo(filter_input(INPUT_POST, 'tipo'));
        $this->setCodgrupo(filter_input(INPUT_POST, 'codgrupo'));
        $this->setDescgrupo(filter_input(INPUT_POST, 'descgrupo'));
        $this->setCodclasse(filter_input(INPUT_POST, 'codclasse'));
        $this->setDescclasse(filter_input(INPUT_POST, 'descclasse'));
        $this->setCodpdm(filter_input(INPUT_POST, 'codpdm'));
        $this->setDescpdm(filter_input(INPUT_POST, 'descpdm'));
        $this->setCoditem(filter_input(INPUT_POST, 'coditem'));
        $this->setDescitem(filter_input(INPUT_POST, 'descitem'));
        $this->setSitatual(filter_input(INPUT_POST, 'sitatual'));
        $this->setSitsustentavel(filter_input(INPUT_POST, 'sitsustentavel'));

        // Inicia a Validação dos dados
        // $this->validateId();
        $this->validateTipo();
        $this->validateCodgrupo();
        $this->validateDescgrupo();
        $this->validateCodclasse();
        $this->validateDescclasse();
        $this->validateCodpdm();
        $this->validateDescpdm();
        $this->validateCoditem();
        $this->validateDescitem();
        $this->validateSitatual();
        $this->validateSitsustentavel();
    }

    public function setId($value)
    {
        $this->id = $value ?: time();
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


    private function validateTipo()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getTipo());
        if (!$value) {
            msg::showMsg('O campo tipo deve ser preenchido corretamente.'
                . '<script>focusOn("tipo");</script>', 'danger');
        }
        return $this;
    }

    private function validateCodgrupo()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getCodgrupo());
        if (!$value) {
            msg::showMsg('O campo código do grupo deve ser preenchido corretamente.'
                . '<script>focusOn("codgrupo");</script>', 'danger');
        }
        return $this;
    }

    private function validateDescgrupo()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getDescgrupo());
        if (!$value) {
            msg::showMsg('O campo descrição do grupo deve ser preenchido corretamente.'
                . '<script>focusOn("descgrupo");</script>', 'danger');
        }
        return $this;
    }

    private function validateCodclasse()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getCodclasse());
        if (!$value) {
            msg::showMsg('O campo código da classe deve ser preenchido corretamente.'
                . '<script>focusOn("codclasse");</script>', 'danger');
        }
        return $this;
    }

    private function validateDescclasse()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getDescclasse());
        if (!$value) {
            msg::showMsg('O campo descrição da classe deve ser preenchido corretamente.'
                . '<script>focusOn("descclasse");</script>', 'danger');
        }
        return $this;
    }

    private function validateCodpdm()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getCodpdm());
        if (!$value) {
            msg::showMsg('O campo código do PDM deve ser preenchido corretamente.'
                . '<script>focusOn("codpdm");</script>', 'danger');
        }
        return $this;
    }

    private function validateDescpdm()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getDescpdm());
        if (!$value) {
            msg::showMsg('O campo descrição do PDM deve ser preenchido corretamente.'
                . '<script>focusOn("descpdm");</script>', 'danger');
        }
        return $this;
    }

    private function validateCoditem()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getCoditem());
        if (!$value) {
            msg::showMsg('O campo código do item deve ser preenchido corretamente.'
                . '<script>focusOn("coditem");</script>', 'danger');
        }
        return $this;
    }

    private function validateDescitem()
    {
        $value = v::stringType()->notEmpty()->length(1, 1000)->validate($this->getDescitem());
        if (!$value) {
            msg::showMsg('O campo descrição do item deve ser preenchido corretamente.'
                . '<script>focusOn("descitem");</script>', 'danger');
        }
        return $this;
    }

    private function validateSitatual()
    {
        $value = v::stringType()->notEmpty()->length(1, 10)->validate($this->getSitatual());
        if (!$value) {
            msg::showMsg('O campo situação atual do item deve ser preenchido corretamente.'
                . '<script>focusOn("sitatual");</script>', 'danger');
        }
        return $this;
    }

    private function validateSitsustentavel()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getSitsustentavel());
        if (!$value) {
            msg::showMsg('O campo sustentabilidade deve ser preenchido corretamente.'
                . '<script>focusOn("sitsustentavel");</script>', 'danger');
        }
        return $this;
    }
}
