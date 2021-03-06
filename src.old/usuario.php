<?php

$app->any('/usuario[/{id}]', function ($request, $response, $args) {
	require_once('conexao.php');
	
	require_once('constants.php');

	require_once('controlador.php');

	require_once('getinterno.php');
	
	$getinterno = new GetInterno();

	$body = $request->getBody();
	$json_obj = json_decode ( $body);
	$json_aa = json_decode ( $body ,true);

	$id = $request->getAttribute('id');

	$colunas = explode("`, `", COLUNAS_USUARIO);

	$bindAdapter = "sisss";

	$bind_json_param = 'bind';

	if($body != "" && isset($json_aa[$bind_json_param])) {
		$colunas = array();
		foreach ($json_aa as $key => $value) {
			array_push($colunas, $key);
		}

		if (($key = array_search($bind_json_param, $colunas)) !== false) {
		    unset($colunas[$key]);
		}

		$bindParamPersonalizado = $json_aa[$bind_json_param];
	}

	$controlador = new Controlador("Usuário", "Usuários", "usuario", $colunas, $bindAdapter);
	
    $metodo = $request->getMethod();
    if ($metodo == 'GET'){
    	if(isset($args['id'])){
    		try {
				$data = $controlador->getEntidade($mysqli, $id);
				
				$id_nivel = (int) $data['nivel'];

				$nivel = $getinterno->getNivel($id_nivel,$mysqli);

				$data['nivel'] = $nivel;
			} 
			catch (Exception $e) {
				$data = $e;
			}		
    	}
    	else{
    		try {
				$data = $controlador->getCollection($mysqli);

				foreach ($data as $key => $item) {
					$id_nivel = (int) $data[$key]['nivel'];

					$nivel = $getinterno->getNivel($id_nivel,$mysqli);

					$data[$key]['nivel'] = $nivel;
				}
			} 
			catch (Exception $e) {
				$data = $e;
			}	
    	}
    }
    else if ($metodo == 'POST'){
    	try {
			// se tiver recebido uma collection
			if(gettype($json_obj) == "array"){
				$data = "recebi uma collection! nada feito";
			}
			// se tiver recebido uma entidade
			else{
				if (isset($id)){
					$data = $controlador->postEntidade($mysqli, $body, $id);
				}
				else {
					$data = $controlador->postEntidade($mysqli, $body);
				}
			}	
		} 
		catch (Exception $e) {
			$data = $e;
		}
    }
    else if ($metodo == 'PUT'){
    	if(isset($args['id'])){
    		try {
				// se tiver recebido uma collection
				if(gettype($json_obj) == "array"){
					$data = "recebi uma collection! nada feito";
				}
				// se tiver recebido uma entidade
				else{
					// atualizar todas as colunas
					if(sizeof($json_aa) == sizeof($colunas)){
						$data = $controlador->updateEntidade($mysqli, $id, $body);
					}
					// colunas especificas
					else{
						$data = $controlador->updateEntidade($mysqli, $id, $body, $bindParamPersonalizado, $bind_json_param);
					}				
				}				
			} 
			catch (Exception $e) {
				$data = $e;
			}
    	}
    	else{
    		$data = "recebi uma collection! nada feito";
			/*
			try {
				$body = $request->getBody();

				$json_obj = json_decode ( $body);
				$json_aa = json_decode ( $body ,true);

				// se tiver recebido uma collection
				if(gettype($json_obj) == "array"){
					$resposta = "recebi uma collection!";
				}
				// se tiver recebido uma entidade
				else{
					//echo "recebi uma entidade!";

					$id = $request->getAttribute('id');

					if($id == null){
						$resposta = [
							"erro" => "Body não recebeu nada ou não recebeu o id",
							"id_recebido" => $id
						];
					}
					else {
						$nome = $json_aa['nome'];
						$idade = $json_aa['idade'];
						$instrumento = $json_aa['instrumento'];
						$sexo = $json_aa['sexo'];
						$telefone = $json_aa['telefone'];

						$query = "UPDATE `musicos` SET `nome` = ?, `idade` = ?, `instrumento` = ?, `sexo` = ?, `telefone` = ? WHERE `musicos`.`id` = $id;";

						$stmt = $mysqli->prepare($query);

						$stmt->bind_param("siisi", $nome, $idade, $instrumento, $sexo, $telefone);

						$stmt->execute();

						$resposta = "Músico atualizado";
					}
				}
				return $response->withStatus(200)->write(json_encode($resposta, JSON_UNESCAPED_UNICODE));
			} 
			catch (Exception $e) {
				echo "Erro: ". $e;	
			}
			*/	
    	}
    }
    else if ($metodo == 'DELETE'){
    	try {
			$data = $controlador->deleteEntidade($mysqli, $id);
		} 
		catch (Exception $e) {
			$data = $e;
		}
    }
    else {
    	$data = "Roteamento não funcionou corretamente!";
    }
	return $response->withStatus(200)->withHeader('Content-Type', 'application/json')->write(json_encode($data, JSON_UNESCAPED_UNICODE));
});
