<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

// Middleware executado entre o processamento das requisições
$app->add(function (Request $request, Response $response, callable $next): Response {
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
