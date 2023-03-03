<?php

namespace App\Models;

use HTR\System\ModelCRUD as CRUD;
use HTR\Helpers\Mensagem\Mensagem as msg;
use HTR\Helpers\Paginator\Paginator;
use Respect\Validation\Validator as v;
use App\Config\Configurations as cfg;
use App\Models\HistoricoCreditoModel;
use App\Helpers\Utils;

class CreditoModel extends CRUD
{

    protected $entidade = 'credit';
    protected $id;
    protected $nome;
    protected $uasg;
    protected $indicativoNaval;
    protected $time;
    protected $resultadoPaginator;
    protected $navPaginator;

    /*
     * Método uaso para retornar todos os dados da tabela.
     */

    public function returnAll()
    {
        return $this->findAll();
    }

    public function paginator($pagina, $user, $busca = null)
    {
        $dados = [
            'select' => 'credit.*',
            'entidade' => $this->entidade,
            'pagina' => $pagina,
            'maxResult' => 10,
            'orderBy' => ''
        ];

        if ($busca) {
            $dados['bindValue'][':seach'] = '%' . $busca . '%';
        }
        $paginator = new Paginator($dados);
        $this->resultadoPaginator = $paginator->getResultado();
        $this->navPaginator = $paginator->getNaveBtn();
    }

    public function getResultadoPaginator()
    {
        return $this->resultadoPaginator;
    }

    public function getNavePaginator()
    {
        return $this->navPaginator;
    }

    /**
     * @return array Todos os resultados exceto os da lixeira
     */
    public function findActive()
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} "
            . "WHERE isActive = :isActive;");
        $stmt->bindValue(':isActive', 1);
        $stmt->execute();
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    public function findById($id)
    {
        $query = "" .
            " SELECT * FROM {$this->entidade} AS credit " .
            " WHERE credit.id = :id ";

        $stmt = $this->pdo->prepare($query);
        $stmt->execute([':id' => $id]);

        return $stmt->fetch(\PDO::FETCH_ASSOC);
    }

    public function saldoComprometidoLei2($omId, $enquadramento, $cnae)
    {
        $stmt = $this->pdo->prepare(""
            . " SELECT "
            . "     IFNULL(SUM(registers.document_value), 0) as registers_value, "
            . "     IFNULL(credit.value, (SELECT credit.value FROM credit WHERE id = :creditId)) as credit_value  "
            . " FROM registers "
            . " INNER JOIN credit ON credit.id = registers.credit_id "
            . " WHERE "
            . "     registers.oms_id = :omId "
            . "     AND registers.credit_id = :creditId "
            . "     AND registers.cnae = :cnae; ");

        $stmt->execute([
            ':omId' => $omId,
            ':creditId' => $enquadramento,
            ':cnae' => $cnae,
        ]);

        return $stmt->fetch(\PDO::FETCH_ASSOC);
    }

    public function saldoComprometido($omId, $id)
    {
        $stmt = $this->pdo->prepare(""
            . " SELECT IFNULL(SUM(credit_historic.value), 0) as sum_value, credit.value "
            . " FROM credit "
            . " LEFT JOIN credit_historic ON credit_historic.credit_id = credit.id AND operation_type = 'DEBITO'"
            . " WHERE credit.oms_id = :omId AND credit.id = :id;");

        $stmt->execute([
            ':omId' => $omId,
            ':id' => $id,
        ]);

        return $stmt->fetch(\PDO::FETCH_ASSOC);
    }

    public function novoRegistro($user)
    {
        // Valida dados
        $this->validaAll($user);
        // Verifica se há registro igual
        $this->evitarDuplicidade();

        $dados = [
            'credit_note' => $this->getCreditNote(),
            'value' => $this->getValue(),
            'created_at' => date('Y-m-d'),
            'updated_at' => date('Y-m-d')
        ];
        if (parent::novo($dados)) {
            $lastId = $this->pdo->lastInsertId();
            (new HistoricoCreditoModel())->novaTransacao($lastId, $this->getValue(), 'CREDITO', 'NOTA DE CREDITO INSERIDA');

            msg::showMsg('111', 'success');
        }
    }

    public function removerRegistro($id)
    {
        $query = "DELETE FROM credit_historic WHERE credit_id = :id";
        $stmt = $this->pdo->prepare($query);
        $stmt->execute([':id' => $id]);

        if (parent::remover($id)) {
            header('Location: ' . cfg::DEFAULT_URI . 'credito/ver/');
        }
    }

    private function evitarDuplicidade()
    {
        /// Evita a duplicidade de registros
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND credit_note = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getCreditNote());
        $stmt->execute();
        if ($stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('Já existe um registro com este Nome.<script>focusOn("credit_note")</script>', 'warning');
        }
    }

    private function validaAll($user)
    {
        // Seta todos os valores
        $this->setTime(time())
            ->setId(filter_input(INPUT_POST, 'id') ?? time())
            ->setCreditNote(filter_input(INPUT_POST, 'credit_note', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setValue(filter_input(INPUT_POST, 'value', FILTER_SANITIZE_SPECIAL_CHARS));

        $value = str_replace(".", "", $this->getValue());
        $value = str_replace(",", ".", $value);
        $this->setValue($value);

        // Inicia a Validação dos dados
        $this->validaId()
            ->validaCreditNote()
            ->validaValue();
    }

    private function validaId()
    {
        $value = v::intVal()->validate($this->getId());
        if (!$value) {
            msg::showMsg('O campo ID deve ser um número inteiro válido.', 'danger');
        }
        return $this;
    }

    private function validaCreditNote()
    {
        $value = v::stringType()->notEmpty()->validate($this->getCreditNote());
        if (!$value || !Utils::checkLength($this->getCreditNote(), 1, 30)) {
            msg::showMsg('O campo nota de crédito deve ser deve ser preenchido corretamente.'
                . '<script>focusOn("credit_note");</script>', 'danger');
        }
        return $this;
    }

    private function validaValue()
    {
        $value = str_replace(".", "", $this->getValue());
        $value = str_replace(",", ".", $value);

        $validate = v::floatVal()->notEmpty()->validate($value);
        if (!$validate) {
            msg::showMsg('O valor do campo VALOR deve ser preenchido corretamente', 'danger');
        }
        return $value;
    }
}
