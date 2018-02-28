<?php

require_once('conexao.php');

class GetInterno {

    public function __construct(){

    }

    public function getTamanho($id, $mysqli) {
        require_once('tamanho.php'); 
        require_once('constants.php');

	$colunas = explode("`, `", COLUNAS_TAMANHO);

	$bindAdapter = "s";

	$bind_json_param = 'bind';
        
    $controlador_tamanho = new Controlador("Tamanho", "Tamanhos", "tamanho", $colunas, $bindAdapter);
		
        return $controlador_tamanho->getEntidade($mysqli, $id); 
    }

    public function getUnidade($id, $mysqli) {
        require_once('unidade.php'); 
        require_once('constants.php');

	$colunas = explode("`, `", COLUNAS_UNIDADE);

	$bindAdapter = "s";

	$bind_json_param = 'bind'; 
        
	$controlador_unidade = new Controlador("Unidade", "Unidades", "unidade", $colunas, $bindAdapter);
		
        return $controlador_unidade->getEntidade($mysqli, $id); 
    }

    public function getClassificacao($id, $mysqli) {
        require_once('classificacao.php'); 
        require_once('constants.php');

		$colunas = explode("`, `", COLUNAS_CLASSIFICACAO); 
		$bindAdapter = "s"; 
        $bind_json_param = 'bind'; 
        
		$controlador_classificacao = new Controlador("Classificação", "Classificações", "classificacao", $colunas, $bindAdapter); 
		
        return $controlador_classificacao->getEntidade($mysqli, $id); 
    }

    public function getNivel($id, $mysqli) {
        require_once('classificacao.php'); 
        require_once('constants.php');

		$colunas = explode("`, `", COLUNAS_NIVEL); 
		$bindAdapter = "s"; 
        $bind_json_param = 'bind'; 
        
        $controlador_nivel = new Controlador("Nível", "Niveis", "nivel", $colunas, $bindAdapter);
		
        return $controlador_nivel->getEntidade($mysqli, $id); 
    }
    
}