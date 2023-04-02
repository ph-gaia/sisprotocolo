<?php

namespace App\Models;

use HTR\System\ModelCRUD as CRUD;
use HTR\Helpers\Mensagem\Mensagem as msg;
use HTR\Helpers\Paginator\Paginator;
use Respect\Validation\Validator as v;
use App\Config\Configurations as cfg;
use App\Helpers\Utils;

class ItemModel extends CRUD
{

    protected $entidade = 'biddings_items';

    /**
     * @var \HTR\Helpers\Paginator\Paginator
     */
    protected $paginator;

    public function returnAll()
    {
        return $this->findAll();
    }

    public function fetchDataToEdit(int $id): array
    {
        $licitacao = $this->findById($id);
        $result[] = [];

        if ($licitacao) {
            $result['result'] = $licitacao;
            $query = ""
                . "SELECT "
                . " bol.*, oms.naval_indicative, oms.name "
                . " FROM biddings_items AS item "
                . " INNER JOIN biddings_items_oms AS bol "
                . "     ON bol.biddings_items_id = item.id "
                . " INNER JOIN oms "
                . "     ON oms.id = bol.oms_id "
                . " WHERE item.id = {$licitacao['id']} "
                . " ORDER BY oms.name ";
            $result['oms'] = $this->pdo->query($query)->fetchAll(\PDO::FETCH_ASSOC);
            return $result;
        }
        header('Location: ' . cfg::DEFAULT_URI . 'licitacao/ver');
    }

    public function paginator($pagina, $idlista)
    {
        $select = " ,(SELECT SUM(quantity) FROM biddings_items_oms WHERE biddings_items_id = biddings_items.id) as quantity ";
        $select .= " ,(SELECT SUM(quantity_available) FROM biddings_items_oms WHERE biddings_items_id = biddings_items.id) as quantity_available ";
        $innerJoin = " INNER JOIN `suppliers` ON `biddings_items`.`suppliers_id` = `suppliers`.`id` ";
        // $innerJoin .= " INNER JOIN biddings_items_oms as items ON items.biddings_items_id = `biddings_items`.`id` ";
        $dados = [
            'entidade' => 'biddings_items ' . $innerJoin,
            'pagina' => $pagina,
            'maxResult' => 100,
            'orderBy' => '`biddings_items`.`number` ASC',
            'where' => '`biddings_items`.`biddings_id` = ?',
            'bindValue' => [$idlista],
            'select' => '`biddings_items`.*, `suppliers`.`name` AS supplier' . $select
        ];

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

    public function findByNumberAnBiddings($number, $biddings)
    {
        $query = ""
            . " SELECT * "
            . " FROM {$this->entidade} "
            . " WHERE biddings_id = :biddings and number = :number; ";
        $stmt = $this->pdo->prepare($query);
        $stmt->execute([':number' => $number, ':biddings' => $biddings]);
        return $stmt->fetch(\PDO::FETCH_ASSOC);
    }

    public function novoRegistro()
    {
        // Valida dados
        $this->validaAll();
        // Verifica se há registro igual
        $this->evitarDuplicidade();

        $dados = [
            'biddings_id' => $this->getBiddingsId(),
            'suppliers_id' => $this->getSuppliersId(),
            'number' => $this->getNumber(),
            'name' => $this->getName(),
            'uf' => $this->getUf(),
            'value' => $this->getValue(),
            'total_quantity' => $this->getTotalQuantity(),
            'active' => $this->getActive()
        ];

        if (parent::novo($dados)) {
            $lastId = $this->pdo->lastInsertId();
            $licitacaoListaOms = new LicitacaoListaOmsModel();

            foreach ($this->buildItemsBiddings() as $omId => $quantity) {
                $dados = [
                    'oms_id' => $omId,
                    'biddings_items_id' => $lastId,
                    'quantity' => $quantity,
                    'quantity_available' => $quantity,
                ];
                $licitacaoListaOms->novo($dados);
            }

            msg::showMsg('Sucesso ao executar operação.'
                . '<script>'
                . 'resetFormOnDemand(["number", "name", "uf", "quantity", "value"]);'
                . 'focusOn("number");'
                . '</script>', 'success');
        }
    }

    public function editarRegistro()
    {
        // Valida dados
        $this->validaAll();
        // Verifica se há registro igual
        $this->evitarDuplicidade();

        $dados = [
            'biddings_id' => $this->getBiddingsId(),
            'suppliers_id' => $this->getSuppliersId(),
            'number' => $this->getNumber(),
            'name' => $this->getName(),
            'uf' => $this->getUf(),
            'value' => $this->getValue(),
            'total_quantity' => $this->getTotalQuantity(),
            'active' => $this->getActive()
        ];

        if (parent::editar($dados, $this->getId())) {
            $licitacaoListaOms = new LicitacaoListaOmsModel();

            foreach ($this->buildItemsBiddings() as $itemId => $quantity) {
                $dados = [
                    'quantity' => $quantity,
                ];
                $licitacaoListaOms->editar($dados, $itemId);
            }

            msg::showMsg('001', 'success');
        }
    }

    /**
     * Make the itens of Biggings requests
     * @param array $values The input values
     * @return array
     */
    private function buildItemsBiddings(): array
    {
        $values =  filter_input_array(INPUT_POST);
        $result = [];
        if (isset($values['quantity'], $values['ids']) && is_array($values['quantity'])) {
            foreach ($values['quantity'] as $index => $value) {
                $id = filter_var($values['ids'][$index], FILTER_VALIDATE_INT);
                $quantidade = filter_var(Utils::normalizeFloat($value), FILTER_VALIDATE_FLOAT);

                if ($id && $quantidade) {
                    $result[$id] = $quantidade;
                }
            }
        }

        return $result;
    }

    /**
     * função para atualizar a quantidade de itens da licitação
     * 
     * @param $id identificador do item
     * @param $quantity quantidade solicitada
     */
    public function atualizaQtdDisponivel($id, $quantity)
    {
        $result = $this->findById($id);

        $dados = [
            'quantity_available' => $result['quantity_available'] - $quantity,
        ];

        if (parent::editar($dados, $id)) {
            return true;
        }
    }

    /**
     * função para atualizar a quantidade de itens da licitação
     * 
     * @param $id identificador do item
     * @param $quantity quantidade Empenhada
     */
    public function atualizarQtdEmpenhada($id, $quantity)
    {
        $result = $this->findById($id);

        $dados = [
            'quantity_compromised' => $result['quantity_compromised'] - $quantity,
            'quantity_committed' => $result['quantity_committed'] + $quantity
        ];

        if (parent::editar($dados, $id)) {
            $this->atualizarQtdDisponivel();
            return true;
        }
    }

    private function atualizarQtdDisponivel()
    {
        $stmt = $this->pdo->prepare("UPDATE biddings_items SET quantity_available = quantity - (quantity_compromised + quantity_committed)");
        if ($stmt->execute()) {
            return true;
        }
    }

    /**
     * função para cancelar a quantidade de itens empenhados
     * 
     * @param $id identificador do item
     * @param $quantity quantidade Empenhada
     */
    public function cancelarQtdEmpenhada($id, $quantity)
    {
        $result = $this->findById($id);

        $dados = [
            'quantity' => $result['quantity'] + $quantity,
            'quantity_committed' => $result['quantity_committed'] - $quantity
        ];

        if (parent::editar($dados, $id)) {
            $this->atualizarQtdDisponivel();
            return true;
        }
    }

    public function removerRegistro($id, $idlista)
    {
        $stmt1 = $this->pdo->prepare("DELETE FROM biddings_items_oms WHERE biddings_items_id = ?");
        $stmt1->execute([$id]);
        $stmt = $this->pdo->prepare("DELETE FROM {$this->entidade} WHERE id = ?");
        if ($stmt->execute([$id])) {
            header('Location: ' . cfg::DEFAULT_URI . 'item/listar/idlista/' . $idlista);
        }
    }

    private function evitarDuplicidade()
    {
        /// Evita a duplicidade de registros
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND biddings_id = ? AND number = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getBiddingsId());
        $stmt->bindValue(3, $this->getNumber());
        $stmt->execute();
        if ($stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('Já existe um Item com este Número para esta Licitação.'
                . '<script>focusOn("number")</script>', 'warning');
        }

        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND biddings_id = ? AND name = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getBiddingsId());
        $stmt->bindValue(3, $this->getName());
        $stmt->execute();
        if ($stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('Já existe um Item com este Nome para esta Licitação.'
                . '<script>focusOn("name")</script>', 'warning');
        }
    }

    public function findByIdlista($idlista, $omsId, $supplierId)
    {
        $stmt = $this->pdo->prepare(
            "SELECT `biddings_items`.*, `suppliers`.`cnpj`, `suppliers`.`name` AS supplier,
                biddings_items_oms.quantity, biddings_items_oms.quantity_available,
                suppliers.id as supplier_id
            FROM `biddings_items` 
            INNER JOIN `suppliers` ON `biddings_items`.`suppliers_id` = `suppliers`.`id` 
            INNER JOIN `biddings_items_oms` ON `biddings_items_oms`.`biddings_items_id` = `biddings_items`.`id` 
            WHERE `biddings_items`.`biddings_id` = ? AND `biddings_items_oms`.`oms_id` = ? AND `suppliers`.`id` = ? AND `biddings_items`.`active` = 'yes'
            ORDER BY `biddings_items`.`number` ASC"
        );
        $stmt->execute([$idlista, $omsId, $supplierId]);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    private function validaAll()
    {
        // Seta todos os valuees
        $this->setId(filter_input(INPUT_POST, 'id') ?? time())
            ->setBiddingsId(filter_input(INPUT_POST, 'biddings_id'))
            ->setSuppliersId(filter_input(INPUT_POST, 'suppliers_id'))
            ->setActive(filter_input(INPUT_POST, 'active') == 'on' ? 'yes' : 'no')
            ->setNumber(filter_input(INPUT_POST, 'number', FILTER_VALIDATE_INT))
            ->setIngredientsId(filter_input(INPUT_POST, 'ingredients_id', FILTER_VALIDATE_INT))
            ->setName(filter_input(INPUT_POST, 'name', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setUf(filter_input(INPUT_POST, 'uf', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setValue(filter_input(INPUT_POST, 'value', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setTotalQuantity(filter_input(INPUT_POST, 'total_quantity', FILTER_SANITIZE_SPECIAL_CHARS));

        $this->setValue(Utils::moneyToFloat($this->getValue()));
        $this->setTotalQuantity(Utils::moneyToFloat($this->getTotalQuantity()));
        // Inicia a Validação dos dados
        $this->validaId()
            ->validaBiddingsId()
            ->validaSuppliersId()
            ->validaNumber()
            ->validaName()
            ->validaUf();
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

    private function validaBiddingsId()
    {
        $value = v::intVal()->validate($this->getBiddingsId());
        if (!$value) {
            msg::showMsg('O campo ID LISTA deve ser um número inteiro válido.', 'danger');
        }
        return $this;
    }

    private function validaSuppliersId()
    {
        $value = v::intVal()->validate($this->getSuppliersId());
        if (!$value) {
            msg::showMsg('O campo ID DO FORNECEDOR deve ser um número inteiro válido.', 'danger');
        }
        return $this;
    }

    private function validaNumber()
    {
        $value = v::intVal()->notEmpty()->noWhitespace()->validate($this->getNumber());
        if (!$value) {
            msg::showMsg('O campo Número deve ser deve ser preenchido corretamente.'
                . '<script>focusOn("number");</script>', 'danger');
        }
        return $this;
    }

    private function validaName()
    {
        $value = v::stringType()->notEmpty()->validate($this->getName());
        if (!$value) {
            msg::showMsg('O campo Nome deve ser deve ser preenchido corretamente.'
                . '<script>focusOn("name");</script>', 'danger');
        }
        return $this;
    }

    private function validaUf()
    {
        $value = v::stringType()->notEmpty()->validate($this->getUf());
        if (!$value || !Utils::checkLength($this->getUf(), 1, 4)) {
            msg::showMsg('O campo Nome deve ser deve ser preenchido corretamente.'
                . '<script>focusOn("uf");</script>', 'danger');
        }
        return $this;
    }

    private function validaQuantity()
    {
        $value = v::notEmpty()->noWhitespace()->validate($this->getQuantity());
        if (!$value) {
            msg::showMsg('O campo quantity deve ser preenchido corretamente.'
                . '<script>focusOn("quantity");</script>', 'danger');
        }
        return $this;
    }
}
