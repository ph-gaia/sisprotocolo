<?php

namespace App\Models;

use HTR\System\ModelCRUD as CRUD;
use HTR\Helpers\Mensagem\Mensagem as msg;
use HTR\Helpers\Paginator\Paginator;
use Respect\Validation\Validator as v;
use App\Config\Configurations as cfg;
use App\Helpers\Utils;

class HistoricoCreditoModel extends CRUD
{

    protected $entidade = 'credit_historic';
    protected $resultadoPaginator;
    protected $navPaginator;

    /*
     * Método uaso para retornar todos os dados da tabela.
     */

    public function returnAll()
    {
        return $this->findAll();
    }

    public function paginator($pagina, $id)
    {
        $dados = [
            'entidade' => $this->entidade,
            'pagina' => $pagina,
            'maxResult' => 10,
            'where' => 'credit_id = :id',
            'bindValue' => [':id' => $id],
            'orderBy' => 'id DESC',
        ];

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

    public function novoRegistro()
    {
        // Valida dados
        $this->validaAll();

        $dados = [
            'operation_type' => $this->getOperationType(),
            'value' => $this->getValue(),
            'observation' => $this->getObservation(),
            'credit_id' => $this->getProvisionedCredits(),
            'created_at' => date('Y-m-d'),
        ];
        if (parent::novo($dados)) {
            header('Location: ' . cfg::DEFAULT_URI . 'credito/detalhar/id/' . $this->getProvisionedCredits());
        }
    }

    public function novaTransacao($id, $value, $operation, $observation)
    {
        $dados = [
            'operation_type' => $operation,
            'value' => $value,
            'observation' => $observation,
            'credit_id' => $id,
            'created_at' => date('Y-m-d H:i:s')
        ];
        return parent::novo($dados);
    }

    private function atualizaSaldoCredito($id)
    {
        $query = "" .
            " SELECT " .
            " (SELECT SUM(value) FROM 
                credit_historic 
                WHERE operation_type = 'CREDITO'
                and credit_id = :id) as credito, " .
            " (SELECT SUM(value) FROM 
                credit_historic 
                WHERE operation_type = 'DEBITO'
                and credit_id = :id) as debito ";

        $stmt = $this->pdo->prepare($query);
        $stmt->execute([':id' => $id]);
        $result = $stmt->fetch(\PDO::FETCH_ASSOC);

        $total = $result['credito'] - $result['debito'];
        $query = " UPDATE credit SET `value` = :total WHERE id = :id";
        $stmt = $this->pdo->prepare($query);
        $stmt->execute([':total' => $total, ':id' => $id]);
    }

    private function validaAll()
    {
        // Seta todos os valores
        $this->setTime(time())
            ->setId(filter_input(INPUT_POST, 'id') ?? time())
            ->setOperationType(filter_input(INPUT_POST, 'operation_type', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setObservation(strtoupper(filter_input(INPUT_POST, 'observation', FILTER_SANITIZE_SPECIAL_CHARS)))
            ->setProvisionedCredits(filter_input(INPUT_POST, 'provisioned_credits_id'))
            ->setValue(filter_input(INPUT_POST, 'value', FILTER_SANITIZE_SPECIAL_CHARS));

        $value = str_replace(".", "", $this->getValue());
        $value = str_replace(",", ".", $value);
        $this->setValue($value);
        // Inicia a Validação dos dados
        $this->validaId()
            ->validaObservation()
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

    private function validaObservation()
    {
        $value = v::stringType()->notEmpty()->validate($this->getObservation());
        if (!$value || !Utils::checkLength($this->getObservation(), 1, 60)) {
            msg::showMsg('O campo observação deve ser deve ser preenchido corretamente.'
                . '<script>focusOn("observation");</script>', 'danger');
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
