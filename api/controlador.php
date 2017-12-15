<?php

class Controlador{

private $nomeEntidade;
private $nomeCollection;
private $nomeEntidadeDB;
private $colunasDB;
private $bindAdapter;
private $colunasDB_relacionamento;
public function __construct($nomeEntidade= "" ,$nomeCollection= "" ,$nomeEntidadeDB= "" ,$colunasDB= array(),$bindAdapter= "" ,$colunasDB_relacionamento= array()){
$this->nomeEntidade = $nomeEntidade;
$this->nomeCollection = $nomeCollection;
$this->nomeEntidadeDB = $nomeEntidadeDB;
$this->colunasDB = $colunasDB;
$this->bindAdapter = $bindAdapter;
$this->colunasDB_relacionamento = $colunasDB_relacionamento;

}

public static function construct($array){
$obj = new Controlador();
$obj->setNomeEntidade( $array['nomeEntidade']);
$obj->setNomeCollection( $array['nomeCollection']);
$obj->setNomeEntidadeDB( $array['nomeEntidadeDB']);
$obj->setColunasDB( $array['colunasDB']);
$obj->setBindAdapter( $array['bindAdapter']);
$obj->setColunasDB_relacionamento( $array['colunasDB_relacionamento']);
return $obj;

}

// CREATE

public function postEntidade($mysqli, $body, $id = null, $idBD = null, $query = null, $bindParamPersonalizado = null){
	try {
		$json_obj = json_decode ( $body);
		$json_aa = json_decode ( $body ,true);

		// se recebeu uma query personalizada
		if ($query != null && $bindParamPersonalizado != null){

				$stmt = $mysqli->prepare($query);

				foreach($json_aa as $key => $value) {
				    $values[$key] = &$json_aa[$key];
				}

				call_user_func_array(array($stmt, 'bind_param'), array_merge(array($this->bindParamPersonalizado), $values));

				$stmt->execute();

				$data = [
					"msg"=>$this->nomeEntidade." criado(a)",
					"affected_rows"=>$stmt->affected_rows
				];
		}
		// se nao receber view nem query vai fazer um insert normal na entidade
		else {
			if(sizeof($json_aa) == sizeof($this->colunasDB)){
				if(isset($id) && isset($idBD)){
					$query = "INSERT INTO " . $this->nomeEntidadeDB . " (" . "$idBD, " . implode(", ",$this->colunasDB) . ") VALUES (" . " $id, " . rtrim(str_repeat("?, ", sizeof($this->colunasDB)),", ") . ");";
				}
				else{
					$query = "INSERT INTO " . $this->nomeEntidadeDB . " (" . implode(", ",$this->colunasDB) . ") VALUES (" . rtrim(str_repeat("?, ", sizeof($this->colunasDB)),", ") . ");";
				}

				$stmt = $mysqli->prepare($query);

				foreach($json_aa as $key => $value) {
				    $values[$key] = &$json_aa[$key];
				}

				call_user_func_array(array($stmt, 'bind_param'), array_merge(array($this->bindAdapter), $values));

				$stmt->execute();

				$data = [
					"msg"=>$this->nomeEntidade." criado(a)",
					"affected_rows"=>$stmt->affected_rows
				];
				
			}
			else {
				$data = [
					"erro"=>"Você enviou menos parâmetros que o necessário, deveria ser " . sizeof($this->colunasDB),
					"sizeof(json_aa)"=>sizeof($json_aa)
				];
			}
		}			
	} 
	catch (Exception $e) {
		$data = "Erro: ". $e;	
	}
	finally {
		return $data;
	}

}

public function postCollection($mysqli, $id, $view = null, $query = null){
	// Não implementado ainda
}

// READ

public function getEntidade($mysqli, $id, $idBD, $view = null, $query = null){
	try {
		// se recebeu uma query
		if ($query != null){
			$result = $mysqli->query($query);
			$data[] = $result->fetch_assoc();
		}
		// se recebeu uma view para fazer o select
		else if ($view != null){
			$query = "SELECT * FROM " . $view . " WHERE $idBD=$id";
			$result = $mysqli->query($query);
			$data[] = $result->fetch_assoc();
		}
		// se nao receber view nem query vai fazer um select com o nomeEntidadeDB
		else {
			$query = "SELECT * FROM " . $this->nomeEntidadeDB . " WHERE $idBD=$id";
			$result = $mysqli->query($query);
			$data[] = $result->fetch_assoc();
		}	
	} catch (Exception $e) {
		$data = $e;
	}
	finally{
		return $data;
	}
}

public function getCollection($mysqli, $view = null, $query = null){
	try {
		// se recebeu uma query
		if ($query != null){
			$result = $mysqli->query($query);
			while ($row = $result->fetch_assoc()){
				$data[] = $row;
			}
		}
		// se recebeu uma view para fazer o select
		else if ($view != null){
			$query = "SELECT * FROM $view";
			$result = $mysqli->query($query);
			while ($row = $result->fetch_assoc()){
				$data[] = $row;
			}
		}
		// se nao receber view nem query vai fazer um select com o nomeEntidadeDB
		else {
			$query = "SELECT * FROM " . $this->nomeEntidadeDB;
			$result = $mysqli->query($query);
			while ($row = $result->fetch_assoc()){
				$data[] = $row;
			}
		}
	} 
	catch (Exception $e) {
		$data = $e;
	}
	finally{
		return $data;
	}
}

// UPDATE
public function updateEntidade($mysqli, $id, $idBD, $body, $bindParamPersonalizado = null, $bind_json_param = null, $query = null){
	try {
		$json_obj = json_decode ( $body);
		$json_aa = json_decode ( $body ,true);

		// se recebeu uma query personalizada
		if ($query != null && $bindParamPersonalizado != null){

				$stmt = $mysqli->prepare($query);

				foreach($json_aa as $key => $value) {
				    $values[$key] = &$json_aa[$key];
				}

				unset($values[$bind_json_param]);

				call_user_func_array(array($stmt, 'bind_param'), array_merge(array($bindParamPersonalizado), $values));

				$stmt->execute();

				$data = [
					"msg"=>$this->nomeEntidade." atualizado(a)",
					"affected_rows"=>$stmt->affected_rows
				];
		}
		// se nao receber view nem query vai fazer um insert normal na entidade
		else {
			// update todas as colunas
			if(sizeof($json_aa) == sizeof($this->colunasDB)){

				//$query = "UPDATE `musicos` SET `nome` = ?, `idade` = ?, `instrumento` = ?, `sexo` = ?, `telefone` = ? WHERE `musicos`.`id` = $id;";

				$query = "UPDATE " . $this->nomeEntidadeDB . " SET " . implode(" = ?, ",$this->colunasDB) . " = ? " . "WHERE $idBD = $id;";

				$stmt = $mysqli->prepare($query);

				foreach($json_aa as $key => $value) {
				    $values[$key] = &$json_aa[$key];
				}

				call_user_func_array(array($stmt, 'bind_param'), array_merge(array($this->bindAdapter), $values));

				$stmt->execute();

				$data = [
					"msg"=>$this->nomeEntidade." atualizado(a)",
					"affected_rows"=>$stmt->affected_rows
				];
				
			}
			// update coluna(s) especificas
			else {
				//$data = var_dump($this->colunasDB);
				
				$query = "UPDATE " . $this->nomeEntidadeDB . " SET " . implode(" = ?, ",$this->colunasDB) . " = ? " . "WHERE $idBD = $id;";

				$stmt = $mysqli->prepare($query);

				foreach($json_aa as $key => $value) {
				    $values[$key] = &$json_aa[$key];
				}

				unset($values[$bind_json_param]);

				call_user_func_array(array($stmt, 'bind_param'), array_merge(array($bindParamPersonalizado), $values));

				$stmt->execute();

				$data = [
					"msg"=>$this->nomeEntidade." atualizado(a)",
					"affected_rows"=>$stmt->affected_rows
				];
				
			}
		}			
	} 
	catch (Exception $e) {
		$data = "Erro: ". $e;	
	}
	finally {
		return $data;
	}

}

public function updateCollection($mysqli, $id, $view = null, $query = null){
	// Não implementado ainda
}

// DELETE

public function deleteEntidade($mysqli, $id, $idBD, $view = null, $query = null){
	try {
		if ($id == null){
			$resposta = [
					"erro" => "Body não recebeu nada ou não recebeu o id",
					"id_recebido" => $id
				];
		}
		else {

			$query = "DELETE FROM " . $this->nomeEntidadeDB . " WHERE $idBD=$id";

			$data = $query;

			if ($stmt = $mysqli->prepare($query)) {
			    $stmt->execute();

			    if ($stmt->affected_rows == 0){
			    	$data = [
						"erro" => "id não encontrado",
						"id_recebido" => $id
					];
			    }
			    else {
			    	$data = "Músico deletado";
			    }

			    /* close statement */
			    $stmt->close();
			}	
		}
		
	} 
	catch (Exception $e) {
		echo "Erro: ". $e;
	}
	finally{
		return $data;
	}
}

public function getNomeEntidade(){
return $this->nomeEntidade;
}

public function setNomeEntidade($nomeEntidade){
 $this->nomeEntidade=$nomeEntidade;
}

public function getNomeCollection(){
return $this->nomeCollection;
}

public function setNomeCollection($nomeCollection){
 $this->nomeCollection=$nomeCollection;
}

public function getNomeEntidadeDB(){
return $this->nomeEntidadeDB;
}

public function setNomeEntidadeDB($nomeEntidadeDB){
 $this->nomeEntidadeDB=$nomeEntidadeDB;
}

public function getColunasDB(){
return $this->colunasDB;
}

public function setColunasDB($colunasDB){
 $this->colunasDB=$colunasDB;
}

public function getBindAdapter(){
return $this->bindAdapter;
}

public function setBindAdapter($bindAdapter){
 $this->bindAdapter=$bindAdapter;
}

public function getColunasDB_relacionamento(){
return $this->colunasDB_relacionamento;
}

public function setColunasDB_relacionamento($colunasDB_relacionamento){
 $this->colunasDB_relacionamento=$colunasDB_relacionamento;
}
public function equals($object){
if($object instanceof Controlador){

if($this->nomeEntidade!=$object->nomeEntidade){
return false;

}

if($this->nomeCollection!=$object->nomeCollection){
return false;

}

if($this->nomeEntidadeDB!=$object->nomeEntidadeDB){
return false;

}

if($this->colunasDB!=$object->colunasDB){
return false;

}

if($this->bindAdapter!=$object->bindAdapter){
return false;

}

if($this->colunasDB_relacionamento!=$object->colunasDB_relacionamento){
return false;

}

return true;

}
else{
return false;
}

}
public function toString(){

 return "  [nomeEntidade:" .$this->nomeEntidade. "]  [nomeCollection:" .$this->nomeCollection. "]  [nomeEntidadeDB:" .$this->nomeEntidadeDB. "]  [colunasDB:" .$this->colunasDB. "]  [bindAdapter:" .$this->bindAdapter. "]  [colunasDB_relacionamento:" .$this->colunasDB_relacionamento. "]  " ;
}

}