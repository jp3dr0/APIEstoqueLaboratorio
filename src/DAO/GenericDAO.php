<?php
namespace src\DAO;

class GenericDAO extends Conexao
{

    // nome utilizado para representar a entidade, no singular
    private $nomeEntidade;

    // nome utilizado para representar a entidade, no plural
    private $nomeCollection;

    // nome utilizado da entidade no banco de dados (tabela)
    private $nomeEntidadeDB;

    // array com as colunas do banco de dados
    private $colunasDB;

    public function __construct($nomeEntidade = "", $nomeCollection = "", $nomeEntidadeDB = "", $colunasDB = array())
    {
        parent::__construct();

        $this->nomeEntidade = $nomeEntidade;
        $this->nomeCollection = $nomeCollection;
        $this->nomeEntidadeDB = $nomeEntidadeDB;
        $this->colunasDB = $colunasDB;
    }

    public function get(bool $desc = false, int $id = null, string $idBD = 'id', string $view = null, string $queryPersonalizada = null)
    {
        $data = null;
        try {
            // se recebeu uma query
            if ($queryPersonalizada != null) {
                $query = $queryPersonalizada;
            }
            // se recebeu uma view para fazer o select
            else if ($view != null) {
                $query = "SELECT * FROM $view";
            }
            // se nao receber view nem query vai fazer um select com o nomeEntidadeDB
            else {
                $query = "SELECT * FROM " . $this->nomeEntidadeDB;
            }

            // se é pra retornar na ordem descendente
            if ($desc) {
                $query .= " ORDER by id DESC";
            }

            // get entidade
            if (isset($id) && isset($idBD)) {
                $query .= " WHERE $idBD=$id LIMIT 1";
                return $data = $this->pdo->query($query)->fetch(\PDO::FETCH_ASSOC);
            } else {
                $data = $this->query($query);
            }

        } catch (Exception $e) {
            $data = $e;
        } finally {
            //var_dump($data);
            //return isset($data) ? $data : null;
            return $data;
        }
    }

    public function delete($id, $idBD = 'id', $view = null, $query = null)
    {
        try {
            if ($id == null) {
                $resposta = [
                    "erro" => "Body não recebeu nada ou não recebeu o id",
                    "id_recebido" => $id,
                ];
            } else {

                $query = "DELETE FROM " . $this->nomeEntidadeDB . " WHERE $idBD=$id";

                //$data = $this->query($query);

                if ($statement = $this->pdo->prepare($query)) {
                    $statement->execute();

                    if ($statement->rowCount() == 0) {
                        $data = [
                            "erro" => "id não encontrado",
                            "id_recebido" => $id,
                        ];
                    } else {
                        $data = $this->nomeEntidade . " deletado(a)";
                    }

                    /* close statement */
                    $statement->close();
                }
            }

        } catch (Exception $e) {
            echo "Erro: " . $e;
        } finally {
            return $data;
        }
    }

    public function post($body, $id = null, $idBD = 'id', $query = null)
    {
        try {
            $json_obj = json_decode($body);
            $json_aa = json_decode($body, true);

            // se recebeu uma query personalizada
            if ($query != null && $bindParamPersonalizado != null) {

                // nao implementado ainda

                return false;
            }
            // se nao receber view nem query vai fazer um insert normal na entidade
            else {
                // sizeof($json_aa) == sizeof($this->colunasDB)

                $error = false;

                //var_dump($this->colunasDB);

                foreach ($json_aa as $key => $value) {
                    if (!in_array($key, $this->colunasDB)) {
                        $error = true;
                        $parametroErrado = $key;
                    }
                }

                if (!$error) {

                    $colunasJson = [];

                    foreach ($json_aa as $key => $value) {
                        array_push($colunasJson, $key);
                    }

                    $statementValues = [];

                    foreach ($json_aa as $key => $value) {
                        $statementValues[$key] = ":" . $key;
                    }

                    // UPDATE
                    if (isset($id) && isset($idBD)) {

                        $method = " atualizado(a)";

                        $query = "UPDATE " . $this->nomeEntidadeDB . " SET ";

                        foreach ($colunasJson as $key => $value) {
                            $query .= "`" . $value . "`=:" . $value;

                            $query .= ($key + 1) == sizeof($colunasJson) ? "" : ", ";
                        }

                        $query .= " WHERE $idBD = $id;";

                    }
                    // CREATE
                    else {
                        $method = " criado(a)";
                        $query = "INSERT INTO " . $this->nomeEntidadeDB . " (" . implode(", ", $colunasJson) . ") VALUES (" . implode(", ", $statementValues) . ");";
                    }

                    $statement = $this->pdo->prepare($query);

                    //echo ($query);
                    try {
                        $result = $statement->execute($json_aa);
                    } catch (\Exception $ex) {
                        return $ex->getMessage();
                    }
                    if ($result) {
                        return [
                            "msg" => $this->nomeEntidade . $method,
                            "affected_rows" => $statement->rowCount(),
                        ];
                    } else {

                        return $result;
                    }

                    $statement->close();

                } else {

                    return [
                        "erro" => "Você enviou um atributo errado.",
                        "atributoErrado" => $parametroErrado,
                    ];
                    /*
                $data = [
                "erro" => "Você enviou menos parâmetros que o necessário, deveria ser " . sizeof($this->colunasDB),
                "sizeof(json_aa)" => sizeof($json_aa),
                ];
                 */
                }
            }
        } catch (Exception $e) {
            var_dump($e->getMessage());
            return $e;
        } finally {
            //return $data;
        }

    }

    public function postCollection($mysqli, $id, $view = null, $query = null)
    {
        // Não implementado ainda
    }

    private function query($query)
    {
        return $this->pdo->query($query)->fetchAll(\PDO::FETCH_ASSOC);
    }

    // UTILITY

    public static function construct($array)
    {
        $obj = new GenericDAO();
        $obj->setNomeEntidade($array['nomeEntidade']);
        $obj->setNomeCollection($array['nomeCollection']);
        $obj->setNomeEntidadeDB($array['nomeEntidadeDB']);
        $obj->setColunasDB($array['colunasDB']);
        return $obj;

    }

    public function getNomeEntidade()
    {
        return $this->nomeEntidade;
    }

    public function setNomeEntidade($nomeEntidade)
    {
        $this->nomeEntidade = $nomeEntidade;
    }

    public function getNomeCollection()
    {
        return $this->nomeCollection;
    }

    public function setNomeCollection($nomeCollection)
    {
        $this->nomeCollection = $nomeCollection;
    }

    public function getNomeEntidadeDB()
    {
        return $this->nomeEntidadeDB;
    }

    public function setNomeEntidadeDB($nomeEntidadeDB)
    {
        $this->nomeEntidadeDB = $nomeEntidadeDB;
    }

    public function getColunasDB()
    {
        return $this->colunasDB;
    }

    public function setColunasDB($colunasDB)
    {
        $this->colunasDB = $colunasDB;
    }

    public function equals($object)
    {
        if ($object instanceof GenericDAO) {

            if ($this->nomeEntidade != $object->nomeEntidade) {
                return false;

            }

            if ($this->nomeCollection != $object->nomeCollection) {
                return false;

            }

            if ($this->nomeEntidadeDB != $object->nomeEntidadeDB) {
                return false;

            }

            if ($this->colunasDB != $object->colunasDB) {
                return false;

            }

            return true;

        } else {
            return false;
        }

    }

    public function toString()
    {

        return "  [nomeEntidade:" . $this->nomeEntidade . "]  [nomeCollection:" . $this->nomeCollection . "]  [nomeEntidadeDB:" . $this->nomeEntidadeDB . "]  [colunasDB:" . $this->colunasDB . "]";
    }
}
