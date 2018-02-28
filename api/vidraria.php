<?php

$app->any('/vidraria[/{id}]', function ($request, $response, $args) {
    require_once('conexao.php');

	require_once('controlador.php');

	require_once('constants.php');

	require_once('getinterno.php');
	
	$getinterno = new GetInterno();

	$body = $request->getBody();
	$json_obj = json_decode ( $body);
	$json_aa = json_decode ( $body ,true);

	$id = $request->getAttribute('id');

	$colunas = explode("`, `", COLUNAS_VIDRARIA);

	$bindAdapter = "sissiii";

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

	$controlador = new Controlador("Vidraria", "Vidrarias", "vidraria", $colunas, $bindAdapter);
	
    $metodo = $request->getMethod();
    if ($metodo == 'GET'){
    	if(isset($args['id'])){
    		try {
				$data = $controlador->getEntidade($mysqli, $id);
				
				$id_tamanho = (int) $data['tamanho'];

				$id_unidade = (int) $data['unidade'];

				$tamanho = $getinterno->getTamanho($id_tamanho,$mysqli);

				$unidade = $getinterno->getUnidade($id_unidade,$mysqli);

				$data['tamanho'] = $tamanho;

				$data['unidade'] = $unidade;
			} 
			catch (Exception $e) {
				$data = $e;
			}		
    	}
    	else{
    		try {
				$data = $controlador->getCollection($mysqli);

				foreach ($data as $key => $item) {
					$id_tamanho = (int) $data[$key]['tamanho'];

				$id_unidade = (int) $data[$key]['unidade'];

				$tamanho = $getinterno->getTamanho($id_tamanho,$mysqli);

				$unidade = $getinterno->getUnidade($id_unidade,$mysqli);

				$data[$key]['tamanho'] = $tamanho;

				$data[$key]['unidade'] = $unidade;
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
					if(sizeof($json_aa) >= sizeof($colunas)){
						$data = $controlador->updateEntidade($mysqli, $id, $body);
					}
					// colunas especificas
					else if (sizeof($json_aa) < sizeof($this->colunasDB)){
						$data = $controlador->updateEntidade($mysqli, $id, $body, $bindParamPersonalizado, $bind_json_param);
					}				
				}				
			} 
			catch (Exception $e) {
				$data = $e;
			}
			/*
			$data = [
				"json_aa" => print_r($json_aa),
				"sizeof json_aa" => sizeof($json_aa),
				"sizeof colunas" => sizeof($colunas)
			];
			*/
    	}
    	else{
    		$data = "recebi uma collection! nada feito";
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
