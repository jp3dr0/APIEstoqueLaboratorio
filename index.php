<?php

require 'vendor/autoload.php';

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

//$app = new \Slim\App;

$app = new \Slim\App([
    'settings' => [
        'displayErrorDetails' => true
    ]
]);

$app->add(function ($req, $res, $next) {
    $response = $next($req, $res);
    return $response
            ->withHeader('Access-Control-Allow-Origin', '*')
            ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
            ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
});

header("Content-Type: application/json;charset=utf-8");

require_once('api/reagente.php');

require_once('api/vidraria.php');

require_once('api/usuario.php');

require_once('api/classificacao.php');

require_once('api/nivel.php');

require_once('api/operacao.php');

require_once('api/tamanho.php');

require_once('api/tipooperacao.php');

require_once('api/unidade.php');

$app->any('/', function (Request $request, $response, $args) {
	$data = json_encode ( [
		"api" => "Estoque Laboratório IFRN",
		"version" => "1.0.0"
	], JSON_UNESCAPED_UNICODE);
	return $response->withStatus(200)->withHeader('Content-Type', 'application/json')->write($data);    
});

$app->any('/teste[/{id}]', function (Request $request, $response, $args) {
    // Apply changes to books or book identified by $args['id'] if specified.
	// To check which method is used: $request->getMethod();
	switch ($request->getMethod()) {
		case 'GET':
			$data = "READ";
			break;
		case 'PUT':
			$data = "UPDATE";
			break;
		case 'POST':
			$data = "CREATE";
			break;
		case 'DELETE':
			$data = "DELETE";
			break;
		
		default:
			$data = "Erro ao encontrar verbo HTTP";
			break;
	}
	if(isset($args['id'])){
		$data = $data . " " . $args['id'];
	}
	return $response->withStatus(200)->withHeader('Content-Type', 'application/json')->write($data);    
});

// CHEATS

// CREATE/POST ENTITY
	/*

	//$nome = $request->getParam('nome');

	//$nome = $request->getParsedBody()['nome'];

	//$nome = $request->getAttribute('nome');

	//$app = \Slim\Slim::getInstance ();

	//$app->request()->getBody();

	//$nome = $_POST['nome'];

	echo json_encode($nome, JSON_UNESCAPED_UNICODE);
	*/

	/*
	$stmt->execute([
	":nome" => $nome,
	":idade" => $idade,
	":instrumento" => $instrumento,
	":sexo" => $sexo,
	":telefone" => $telefone
	]);﻿
	*/

	/*
	$stmt->bind_param("ssisi", $nome, $idade, $instrumento, $sexo, $telefone);

	$stmt->execute();
	*/

$app->run();