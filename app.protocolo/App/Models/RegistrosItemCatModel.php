<?php

namespace App\Models;

use HTR\System\ModelCRUD as CRUD;
use HTR\Helpers\Mensagem\Mensagem as msg;
use HTR\Helpers\Paginator\Paginator;
use App\Models\ItemModel as Item;
use App\Models\RegistrosModel as Registros;
use Respect\Validation\Validator as v;
use App\Config\Configurations as cfg;
use App\Helpers\Utils;

class RegistrosItemCatModel extends CRUD
{

    protected $entidade = 'registers_items_cat';

    /**
     * @var \HTR\Helpers\Paginator\Paginator
     */
    protected $paginator;

    public function returnAll()
    {
        return $this->findAll();
    }

    public function findById($id)
    {
        $query = "
            SELECT C.*, SUM(A.value) as total FROM registers_items_cat as A
            INNER JOIN cat_material_service as B ON B.id = A.cat_id
            WHERE B.id = ?";
        $stmt = $this->pdo->prepare($query);
        $stmt->execute([$id]);
        return $stmt->fetch(\PDO::FETCH_ASSOC);
    }

    public function novoRegistro($dados, $registerId)
    {
        $item = new Item();
        foreach ($dados as $catId => $item) {
            $dados = [
                'registers_id' => $registerId,
                'cat_id' => $catId,
                'value' => $item['value']
            ];
            parent::novo($dados);
        }
    }

    public function removerRegistro($id)
    {
        $stmt = $this->pdo->prepare("DELETE FROM {$this->entidade} WHERE requests_id = ? ;");
        $stmt->bindValue(1, $id);
        return $stmt->execute();
    }

    public function eliminarItem($id, $idlitsa)
    {
        $this->db->instrucao('select')
            ->setaEntidade($this->getEntidade())
            ->setaFiltros()
            ->where('requests_id', '=', $idlitsa);
        $numRows = count($this->db->executa('select')->fetchAll(\PDO::FETCH_ASSOC));
        if ($numRows > 1) {
            parent::remover($id);
        }
        header("Location:" . cfg::DEFAULT_URI . "solicitacao/detalhar/idlista/{$idlitsa}");
    }

    public function findAllItemsByRequestId($requestId)
    {
        $query = "";
        $stmt = $this->pdo->prepare($query);
        $stmt->execute([$requestId]);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }
}
