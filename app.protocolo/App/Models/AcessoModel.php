<?php

/*
 * @Model Acesso
 */

namespace App\Models;

use HTR\System\ModelCRUD as CRUD;
use HTR\Helpers\Mensagem\Mensagem as msg;
use HTR\Helpers\Paginator\Paginator;
use HTR\Helpers\Session\Session;
use HTR\Helpers\Criptografia\Criptografia as Cripto;
use App\Config\Configurations as cfg;
use Respect\Validation\Validator as v;

class AcessoModel extends CRUD
{
    // Tabela usada neste Model
    protected $entidade = 'users_login';

    // Recebe o resultado da consulta feita no Banco de Dados
    private $resultadoPaginator;
    // Recebe o Array de links da navegação da paginação
    private $navPaginator;

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

    public function paginator($pagina, $busca = null, $user = null)
    {
        $innerJoin = " INNER JOIN oms ON users_login.oms_id = oms.id";
        $dados = [
            'pdo' => $this->pdo,
            'entidade' => $this->entidade . $innerJoin,
            'pagina' => $pagina,
            'maxResult' => 20,
            'select' => 'users_login.*, oms.naval_indicative',
            //'where' => 'nome LIKE ?',
            //'bindValue' => [0 => '%MONTEIRO%']
        ];

        if (isset($user) && $user['level'] == 2) {
            $dados['where'] = "users_login.id = :Id and users_login.isActive = :active";
            $dados['bindValue'] = [
                ':Id' => $user['id'],
                ':active' => 1
            ];
        }

        if ($busca) {
            $dados['where'] = " "
                . " users_login.name LIKE :seach "
                . " OR oms.naval_indicative LIKE :seach ";
            $dados['bindValue'][':seach'] = '%' . $busca . '%';
        }

        $paginator = new Paginator($dados);
        $this->resultadoPaginator =  $paginator->getResultado();
        $this->navPaginator = $paginator->getNaveBtn();
    }

    public function novoRegistro()
    {
        // Seta automaticamente os atributos necessários
        $this->startSeters()
            // Valida os Dados enviados através do formulário
            ->validaPassword()
            ->validaUsername()
            ->validaName()
            ->validaEmail()
            ->validaLevel();

        $dados = [
            'username' => $this->getUsername(),
            'password' => $this->getPassword(),
            'name' => $this->getName(),
            'email' => $this->getEmail(),
            'level' => $this->getLevel(),
            'change_password' => 1,
            'oms_id' => $this->getOmsId(),
            'isActive' => 1, // 1-ativo; 0-inativo  Default : 1
            'created_at' => $this->getTime(),
            'updated_at' => $this->getTime()
        ];

        if (parent::novo($dados)) {
            msg::showMsg('111', 'success');
        } else {
            msg::showMsg('000', 'danger');
        }
    }

    public function editarRegistro()
    {
        // Seta automaticamente os atributos necessários
        $this->startSeters()
            // Valida os Dados enviados através do formulário
            ->validaUsername()
            ->validaName()
            ->validaEmail()
            ->validaLevel()
            // Verifica se há registro igual
            ->evitarDuplicidade();

        $dados = [
            'id' => $this->getId(),
            'username' => $this->getUsername(),
            'name' => $this->getName(),
            'email' => $this->getEmail(),
            'level' => $this->getLevel(),
            'oms_id' => $this->getOmsId(),
            'isActive' => $this->getActive(), // 1-ativo; 0-inativo  Default : 1
            'updated_at' => $this->getTime()
        ];

        if ($this->getPassword()) {
            $this->validaPassword();
            $dados['password'] = $this->getPassword();
        }

        // Verifica se há uma sessão iniciada
        if (!isset($_SESSION['userId'])) {
            $session = new Session();
            $session->startSession();
        }
        // consulta dados o usuário logado
        $user = $this->findById($_SESSION['userId']);
        if ($user['level'] == 1) {
            // Compara o ID do usuário logado com o do enviado pelo formulário
            if ($user['id'] != $this->getId()) {
                $dados['change_password'] = 1;
            }
        } else {
            // Para usuário com o nível diferente de 1-Addministrador
            $this->setId($user['id']);
            $dados['isActive'] = $user['isActive'];
            $dados['level'] = $user['level'];
            $dados['om'] = $user['om'];
        }
        if (parent::editar($dados, $this->getId())) {
            msg::showMsg('001', 'success');
        }
    }

    public function remover($id)
    {
        if (parent::remover($id)) {
            header('Location: ' . cfg::DEFAULT_URI . 'acesso/visualizar/');
        }
    }

    public function findById($id)
    {
        $value = parent::findById($id);

        if ($value) {
            return $value;
        }

        msg::showMsg('Este registro não foi encontrado. Você será redirecionado em 5 segundos.'
            . '<meta http-equiv="refresh" content="0;URL=' . cfg::DEFAULT_URI . 'acesso" />', 'danger', false);
    }

    /*
     * Método usado para alterar a senha do usuário no primeiro acesso
     */
    public function mudarSenha(array $dados)
    {
        $this->setTime()
            ->setPassword($dados['password'])
            ->validaPassword();

        $dadosAlt = [
            'password' => $this->getPassword(),
            'change_password' => 0,
            'updated_at' => $this->getTime()
        ];

        if (parent::editar($dadosAlt, $dados['id'])) {
            msg::showMsg('A senha foi alterada com sucesso! '
                . 'Você será redirecionado para a página inicial em 5 segundos.'
                . '<meta http-equiv="refresh" content="5;URL=' . cfg::DEFAULT_URI . '" />', 'success');
        }
    }

    /*
     * Evita o registro de dados repetidos no Banco de Dados
     */
    private function evitarDuplicidade()
    {
        /// Evita a duplicidade de registros
        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND name = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getName());
        $stmt->execute();
        if ($stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('Já existe um registro com este Nome.'
                . '<script>focusOn("name")</script>', 'warning');
        }

        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND email = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getEmail());
        $stmt->execute();
        if ($stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('Já existe um registro com este E-mail.'
                . '<script>focusOn("email")</script>', 'warning');
        }

        $stmt = $this->pdo->prepare("SELECT * FROM {$this->entidade} WHERE id != ? AND username = ?");
        $stmt->bindValue(1, $this->getId());
        $stmt->bindValue(2, $this->getUsername());
        $stmt->execute();
        if ($stmt->fetch(\PDO::FETCH_ASSOC)) {
            msg::showMsg('O Login indicado não pode ser usado. Por favor, escolha outro Login.'
                . '<script>focusOn("username")</script>', 'warning');
        }
    }

    /*
     * Método de Login no sistema
     */
    public function login()
    {
        // Recebe o valor enviado pelo formulário de login
        $username = filter_input(INPUT_POST, 'username');
        $password = filter_input(INPUT_POST, 'password');

        // Verifica se todos os campos foram preenchidos
        if ($username && $password) {
            $cripto = new Cripto;
            // cripitografa os dados enviados
            //$username = $cripto->encode($username);
            // consulta se existe um susário registrado com o USERNAME fornecido
            $result = $this->findByUsername($username);

            if (!$result) {
                // retorna a mensagem de dialogo
                msg::showMsg('<strong>Usuário Inválido.</strong>'
                    . ' Verifique se digitou corretamente.'
                    . '<script>focusOn("username");</script>', 'warning');
            }

            if ($result['isActive'] === '0') {
                // retorna a mensagem de dialogo
                msg::showMsg('<strong>Usuário Bloqueado!</strong><br>'
                    . ' Consulte o Administrador do Sistema para mais informações.'
                    . '<br><style>body{background-color:#CD2626;</style>'
                    . ADCONT, 'danger');
            }

            // verifica a autenticidade da senha
            if ($cripto->passVerify($password, $result['password'])) {
                // Caso seja um usuário autêntico, inicia a sessão
                $this->registerSession($result);
                return; // stop script
            } else {
                // retorna a mensagem de dialogo
                msg::showMsg('<strong>Senha Inválida.</strong>'
                    . ' Verifique se digitou corretamente.'
                    . '<script>focusOn("password");</script>', 'warning');
            }
        }
        // retorna a mensagem de dialogo
        msg::showMsg('Todos os campos são preenchimento obrigatório.', 'danger');
    }

    /*
     * Método usado para auxialiar a autenticação de usuário
     * Inicia a Sessão
     */
    private function registerSession($dados)
    {
        $session = new Session();
        $session->startSession();
        $_SESSION['token'] = $session->getToken();
        $_SESSION['userId'] = $dados['id'];
        echo '<meta http-equiv="refresh" content="0;URL=' . cfg::DEFAULT_URI . '" />'
            . '<script>window.location = "' . cfg::DEFAULT_URI . '"; </script>';
        return true; // stop script
    }

    /*
     * Método usado para deslogar usuário
     */
    public function logout()
    {
        $session = new Session();
        return $session->stopSession();
    }


    /*
     * Seta os valores aos atributos
     */
    private function startSeters()
    {
        // Seta todos os valores
        $this->setTime(date('Y-m-d h:i:s'))
            ->setId(filter_input(INPUT_POST, 'id'))
            ->setUsername(filter_input(INPUT_POST, 'username'))
            ->setPassword(filter_input(INPUT_POST, 'password'))
            ->setOmsId(filter_input(INPUT_POST, 'oms_id', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setName(filter_input(INPUT_POST, 'name', FILTER_SANITIZE_SPECIAL_CHARS))
            ->setEmail(filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL))
            ->setLevel(filter_input(INPUT_POST, 'level', FILTER_SANITIZE_NUMBER_INT))
            ->setActive(filter_input(INPUT_POST, 'isActive', FILTER_SANITIZE_NUMBER_INT));
        return $this;
    }

    /// Seters
    private function setId($value = null)
    {
        $this->id = !empty($value) ? $value : $this->getTime();
        return $this;
    }

    public function getResultadoPaginator()
    {
        return $this->resultadoPaginator;
    }

    public function getNavePaginator()
    {
        return $this->navPaginator;
    }

    // Validação
    private function validaId()
    {
        $value = v::intVal()->validate($this->getId());
        if (!$value) {
            msg::showMsg('O ID deve ser um número inteiro válido.', 'danger');
        }
        return $this;
    }

    private function validaUsername()
    {
        $value = v::stringType()->notEmpty()->validate($this->getUsername());
        if (!$value) {
            msg::showMsg('O campo Login deve ser preenchido corretamente.'
                . '<script>focusOn("username");</script>', 'danger');
        }

        return $this;
    }

    private function validaPassword()
    {
        $value = v::stringType()->notEmpty()->length(8, null)->validate($this->getPassword());
        if (!$value) {
            msg::showMsg('O campo Senha deve ser preenchido corretamente'
                . ' com no <strong>mínimo 8 caracteres</strong>.'
                . '<script>focusOn("password");</script>', 'danger');
        }

        $this->criptoVar('password', $this->getPassword(), true);

        return $this;
    }

    private function validaName()
    {
        $value = v::stringType()->notEmpty()->validate($this->getName());
        if (!$value) {
            msg::showMsg('O campo Nome deve ser preenchido corretamente.'
                . '<script>focusOn("name");</script>', 'danger');
        }
        return $this;
    }

    private function validaEmail()
    {
        $value = v::email()->notEmpty()->validate($this->getEmail());
        if (!$value) {
            msg::showMsg('O campo E-mail deve ser preenchido corretamente.'
                . '<script>focusOn("email");</script>', 'danger');
        }
        return $this;
    }

    private function validaLevel()
    {
        $value = v::intVal()->notEmpty()->validate($this->getLevel());
        if (!$value) {
            msg::showMsg('O campo Nível de Acesso deve ser deve ser preenchido corretamente.'
                . '<script>focusOn("level");</script>', 'danger');
        }
        return $this;
    }

    private function criptoVar($attribute, $value, $password = false)
    {
        $cripto = new Cripto;
        if (!$password) {
            $this->$attribute = $cripto->encode($value);
        } else {
            $this->$attribute = $cripto->passHash($value);
        }
        return $this;
    }
}
