<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
// Middleware executado entre o processamento das requisições

$app->add(function (Request $request, Response $response, callable $next): Response {
    // codigo executado ANTES de processar a requisição
    //$response->getBody()->write('BEFORE');

    //return $response->write("oi");

    //////////////////////////////////////////////////
    $response = $next($request, $response);
    //////////////////////////////////////////////////

    // codigo executado DEPOIS de processar a requisição
    //$response->getBody()->write('AFTER');
    //$response->getBody()->write('AFTER');

    return $response
        ->withHeader('Access-Control-Allow-Origin', '*')
        ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
        ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
});

/*
$app->options('/{routes:.+}', function ($request, $response, $args) {
return $response->withStatus(200);
});

$app->add(function ($req, $res, $next) {
$response = $next($req, $res);
return $response
->withHeader('Access-Control-Allow-Origin', '*')
->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
});
$app->add(new Tuupola\Middleware\CorsMiddleware([
"origin" => ["*"],
"methods" => ["GET", "POST", "PATCH", "DELETE", "OPTIONS"],
"headers.allow" => ["Origin", "Content-Type", "Authorization", "Accept", "ignoreLoadingBar", "X-Requested-With", "Access-Control-Allow-Origin"],
"headers.expose" => [],
"credentials" => true,
"cache" => 0,
]));
 */
