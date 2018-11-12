<?php

header("Content-Type: application/json;charset=utf-8");

require 'vendor/autoload.php';

use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

//$app = new \Slim\App;

$app = new \Slim\App([
    'settings' => [
        'displayErrorDetails' => true
	],
	// pagina 404
	'notFoundHandler' => function ($c) {
		return function ($request, $response) use ($c) {
			return $response->withStatus(404)
				//->withHeader('Content-Type', 'text/html')
				->withHeader('Content-Type', 'application/json')
				->write(json_encode(['info' => "Nada encontrado."], JSON_UNESCAPED_UNICODE));
		};
	}
]);

// Middleware executado entre o processamento das requisições
$app->add(function ($request, $response, $next) {
	// codigo executado ANTES de processar a requisição
	//$response->getBody()->write('BEFORE');
	
	//////////////////////////////////////////////////
	$response = $next($request, $response);
	//////////////////////////////////////////////////

	// codigo executado DEPOIS de processar a requisição
	//$response->getBody()->write('AFTER');

	return $response
            ->withHeader('Access-Control-Allow-Origin', '*')
            ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
            ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
});

$app->any('/', function (Request $request, $response, $args) {
	$data['info'] = "Bem-Vindo a API Estoque Lab!";
	return $response->withStatus(200)->withHeader('Content-Type', 'application/json')->write(json_encode($data, JSON_UNESCAPED_UNICODE)); 
});

require_once('api/reagente.php');

require_once('api/vidraria.php');

require_once('api/usuario.php');

require_once('api/classificacao.php');

require_once('api/nivel.php');

require_once('api/operacao.php');

require_once('api/tamanho.php');

require_once('api/tipooperacao.php');

require_once('api/unidade.php');

require_once('api/teste/teste.php');

$app->run();