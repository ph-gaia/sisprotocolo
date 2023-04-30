<?php

namespace App\Models;

use HTR\System\ModelCRUD as CRUD;
use HTR\Helpers\Mensagem\Mensagem as msg;
use HTR\Helpers\Paginator\Paginator;
use Respect\Validation\Validator as v;
use App\Config\Configurations as cfg;

class AcompanhamentoModel extends CRUD
{

    protected $entidade = 'acompanhamento';

    /**
     * @var \HTR\Helpers\Paginator\Paginator
     */
    protected $paginator;

    public function findActive()
    {
        return $this->findAll();
    }

    /*public function findByCnpj($cnpj)
    {
        $query = "SELECT * FROM {$this->entidade} WHERE cnpj LIKE '%$cnpj%'";
        $stmt = $this->pdo->prepare($query);
        $stmt->execute();

        return $stmt->fetch(\PDO::FETCH_ASSOC);
    }*/

    public function paginator($pagina, $busca = null)
    {
        $dados = [
            'entidade' => $this->entidade,
            'pagina' => $pagina,
            'maxResult' => 100,
            'orderBy' => 'nup ASC'
        ];

        if ($busca) {
            $dados['where'] = " "
                . " acompanhamento.nup LIKE :seach"
                . " OR acompanhamento.number LIKE :seach";
            $dados['bindValue'][':seach'] = '%' . $busca . '%';
        }

        $this->paginator = new Paginator($dados);
    }

    public function getResultadoPaginator()
    {
        return $this->paginator->getResultado();
    }

    public function getNavePaginator()
    {
        return $this->paginator->getNaveBtn();
    }

    public function novoRegistro()
    {
        // Valida dados
        $this->validaAll();
        // Verifica se há registro igual
        $this->evitarDuplicidade();

        $dados = [
            'nup' => $this->getNup(),
            'modality_id' => $this->getModality(),
            'number' => $this->getNumber(),
            'uasg_id' => $this->getUasg(),
            'objeto' => $this->getObjeto(),
            'valor_estimado' => $this->getValorestimado(),
            'status-id' => $this->getStatus(),
            'observation' => $this->getObservation(),
            'created_at' => date('Y-m-d H:i:s')
        ];
        if (parent::novo($dados)) {
            msg::showMsg('111', 'success');
        }
    }

    public function editarRegistro()
    {
        // Valida dados
        $this->validaAll();
        // Verifica se há registro igual
        $this->evitarDuplicidade();

        $dados = [
            'nup' => $this->getNup(),
            'modality_id' => $this->getModality(),
            'number' => $this->getNumber(),
            'uasg_id' => $this->getUasg(),
            'objeto' => $this->getObjeto(),
            'valor_estimado' => $this->getValorestimado(),
            'status_id' => $this->getStatus(),
            'observation' => $this->getObservation()
        ];

        if (parent::editar($dados, $this->getId())) {
            msg::showMsg('001', 'success');
        }
    }

    public function removerRegistro($id)
    {
        if (parent::remover($id)) {
            header('Location: ' . cfg::DEFAULT_URI . 'acompanhamento/ver/');
        }
    }

    private function evitarDuplicidade()
    {
        /// Evita a duplicidade de registros
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND nup = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getNup());
        $stmt->execute();
        if ($stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('Já existe um registro com este NUP.<script>focusOn("nup")</script>', 'warning');
        }

        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND objeto = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getObjeto());
        $stmt->execute();
        if ($stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('Já existe um registro com este objeto.<script>focusOn("objeto")</script>', 'warning');
        }
    }

    private function validaAll()
    {
        // Seta todos os valores
        $this->setId(filter_input(INPUT_POST, 'id') ?? time())
            ->setNup(filter_input(INPUT_POST, 'nup', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setModality(filter_input(INPUT_POST, 'modality_id', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setNumber(filter_input(INPUT_POST, 'number', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setUasg(filter_input(INPUT_POST, 'uasg_id', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setObjeto(filter_input(INPUT_POST, 'objeto', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setValorestimado(filter_input(INPUT_POST, 'valor_estimado', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setStatus(filter_input(INPUT_POST, 'status_id', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setObservation(filter_input(INPUT_POST, 'observation', FILTER_SANITIZE_SPECIAL_CHARS));

        // Inicia a Validação dos dados
        $this->validaId()
            ->validaNup()
            ->validaModality()
            ->validaNumber()
            ->validaUasg()
            ->validaObjeto()
            ->validaValorestimado()
            ->validaStatus()
            ->validaObservation();
    }

    // Validação
    private function validaId()
    {
        $value = v::intVal()->validate($this->getId());
        if (!$value) {
            msg::showMsg('O campo ID deve ser um número inteiro válido.', 'danger');
        }
        return $this;
    }

    private function validaNup()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getNup());
        if (!$value) {
            msg::showMsg('O campo NUP deve ser preenchido corretamente.'
                . '<script>focusOn("nup");</script>', 'danger');
        }
        return $this;
    }

    private function validaModality()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getModality());
        if (!$value) {
            msg::showMsg('O campo modalidade deve ser preenchido corretamente.'
                . '<script>focusOn("modality_id");</script>', 'danger');
        }
        return $this;
    }

    private function validaNumber()
    {
        $value = v::stringType()->notEmpty()->validate($this->getNumber());
        if (!$value) {
            msg::showMsg('O campo número deve ser preenchido corretamente.'
                . '<script>focusOn("number");</script>', 'danger');
        }
        return $this;
    }

    private function validaUasg()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getUasg());
        if (!$value) {
            msg::showMsg('O campo UASG deve ser preenchido corretamente.'
                . '<script>focusOn("uasg_id");</script>', 'danger');
        }
        return $this;
    }

    private function validaObjeto()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getObjeto());
        if (!$value) {
            msg::showMsg('O campo objeto deve ser preenchido corretamente.'
                . '<script>focusOn("objeto");</script>', 'danger');
        }
        return $this;
    }

    private function validaValorestimado()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getValorestimado());
        if (!$value) {
            msg::showMsg('O campo valor estimado deve ser preenchido corretamente.'
                . '<script>focusOn("valor_estimado");</script>', 'danger');
        }
        return $this;
    }

    private function validaStatus()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getStatus());
        if (!$value) {
            msg::showMsg('O campo status deve ser preenchido corretamente.'
                . '<script>focusOn("status_id");</script>', 'danger');
        }
        return $this;
    }

    private function validaObservation()
    {
        $value = v::stringType()->notEmpty()->length(1, 90)->validate($this->getObservation());
        if (!$value) {
            msg::showMsg('O campo observação deve ser preenchido corretamente.'
                . '<script>focusOn("observation");</script>', 'danger');
        }
        return $this;
    }
}
