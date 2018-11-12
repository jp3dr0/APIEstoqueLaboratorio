<?php
use \Psr\Http\Message\ServerRequestInterface as Request;

require_once 'externa.php';

$app->group('/teste', function () {

	// mesma função para um array de verbos
    $this->group('/group', function () {
        $this->map(['GET', 'POST'], '', function (Request $request, $response, $args) {
			return $response->withStatus(200)->withHeader('Content-Type', 'application/json')->write("Recebi um GET ou POST");
		});
        $this->map(['PUT', 'DELETE'], '', function (Request $request, $response, $args) {
			return $response->withStatus(200)->withHeader('Content-Type', 'application/json')->write("Recebi um PUT ou DELETE");
		});
	});
	
	// invocando funções
    $this->any('/hello', 'hello');

    // usando metodos de uma classe externa
    $this->any('/vaqueiro[/{id}]', 'Teste:vaquejada');

	// pode ter ou nao o parametro id
    $this->any('/verbo[/{id}]', function (Request $request, $response, $args) {
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
        if (isset($args['id'])) {
            $data = $data . " " . $args['id'];
        }
        return $response->withStatus(200)->withHeader('Content-Type', 'application/json')->write($data);
    });

});

function hello (Request $request, $response, $args) {
	return $response->withStatus(200)->withHeader('Content-Type', 'application/json')->write("Hello World");
}

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
