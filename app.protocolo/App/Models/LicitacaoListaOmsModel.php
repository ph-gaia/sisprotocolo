<?php
namespace App\Models;

use HTR\System\ModelCRUD as CRUD;

class LicitacaoListaOmsModel extends CRUD
{

    protected $entidade = 'biddings_items_oms';


    public function atualizaQtdDisponivel($id, $omId, $quantity)
    {
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE biddings_items_id != ? AND oms_id = ?");
        $stmt->bindValue(1, $id);
        $stmt->bindValue(2, $omId);
        $stmt->execute();

        $result = $stmt->fetch(\PDO::FETCH_ASSOC);

        $dados = [
            'quantity_available' => $result['quantity_available'] - $quantity,
        ];

        if (parent::editar($dados, $result['id'])) {
            return true;
        }
    }
}
