<?php

require_once('conexao.php');

class GetInterno {

    public function __construct(){

    }

    public function getTamanho($id, $mysqli) {
        require_once('tamanho.php'); 

		$idBD = 'idTamanho';

	$colunas = explode("`, `", "nomeTamanho");

	$bindAdapter = "s";

	$bind_json_param = 'bind';
        
    $controlador_tamanho = new Controlador("Tamanho", "Tamanhos", "tamanho", $colunas, $bindAdapter);
		
        return $controlador_tamanho->getEntidade($mysqli, $id, $idBD); 
    }

    public function getUnidade($id, $mysqli) {
        require_once('unidade.php'); 

		$idBD = 'idUnidade';

	$colunas = explode("`, `", "nomeUnidade");

	$bindAdapter = "s";

	$bind_json_param = 'bind'; 
        
	$controlador_unidade = new Controlador("Unidade", "Unidades", "unidade", $colunas, $bindAdapter);
		
        return $controlador_unidade->getEntidade($mysqli, $id, $idBD); 
    }

    public function getClassificacao($id, $mysqli) {
        require_once('classificacao.php'); 

		$idBD = 'idClassificacao'; 
		$colunas = explode("`, `", "nomeClassificacao"); 
		$bindAdapter = "s"; 
        $bind_json_param = 'bind'; 
        
		$controlador_classificacao = new Controlador("Classificação", "Classificações", "classificacao", $colunas, $bindAdapter); 
		
        return $controlador_classificacao->getEntidade($mysqli, $id, $idBD); 
    }
}