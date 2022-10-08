<?php

namespace App\Models;

use HTR\System\ModelCRUD as CRUD;
use App\Models\AcessoModel;
use DateTimeZone;
use App\Config\Configurations as cfg;

class HistoricoAcaoModel extends CRUD
{

    protected $entidade = 'historic_status_registers';

    /**
     * Process the historic request status.
     * @param int $id Identification of Solicitação
     * @param int $userId Identification of Usuários
     * @param string $status The status to be executed
     */
    public function novoRegistro(int $requestId, int $userId, string $status, string $observation = null, string $document)
    {
        $date = new \DateTime('now', new DateTimeZone('America/Sao_Paulo'));
        $result = (new AcessoModel())->findById($userId);

        $dados = [
            'registers_id' => $requestId,
            'users_id' => $userId,
            'status_id' => $status,
            'user_name' => $result['name'],
            'resulting_document' => $document,
            'observation' => $observation,
            'date_action' => $date->format('Y-m-d H:i:s')
        ];
        parent::novo($dados);
    }

    public function allHistoricByRequestId($registerId)
    {
        $query = "" .
            " SELECT  sol.id as registerId, historic.id as historicId, " .
            " sol.*, historic.*, modality.name as modality, " . 
            " oms.naval_indicative, status.name as statusName " .
            " FROM {$this->entidade} as historic " .
            " INNER JOIN registers as sol ON sol.id = historic.registers_id " .
            " INNER JOIN modality ON modality.id = sol.modality_id " .
            " INNER JOIN oms ON oms.id = sol.oms_id " .
            " INNER JOIN status ON status.id = historic.status_id " .
            " WHERE historic.registers_id = :registerId ";

        $stmt = $this->pdo->prepare($query);
        $stmt->execute([':registerId' => $registerId]);
        return $stmt->fetchAll(\PDO::FETCH_ASSOC);
    }

    public function removerStatus($id)
    {
        $status = $this->findById($id);
        if (parent::remover($id)) {
            header('Location: ' . cfg::DEFAULT_URI . 'registros/historico/id/' . $status['registers_id']);
        }
    }
}
