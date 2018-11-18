<?php
use Psr\Http\Message\ResponseInterface as Response;
use src\Controllers\ClassificacaoController;
use src\Controllers\NivelController;
use src\Controllers\OperacaoController;
use src\Controllers\ReagenteController;
use src\Controllers\TamanhoController;
use src\Controllers\TipoOperacaoController;
use src\Controllers\UnidadeController;
use src\Controllers\UsuarioController;
use src\Controllers\VidrariaController;
use \Psr\Http\Message\ServerRequestInterface as Request;

require_once __DIR__ . '\..\DAO\constants.php';

$app = new \Slim\App([
    'settings' => [
        'displayErrorDetails' => getenv('DISPLAY_ERRORS_DETAILS'),
    ],
    // pagina 404
    'notFoundHandler' => function ($c) {
        return function ($request, $response) use ($c) {
            return $response->withStatus(404)->withJson(['info' => "Nada encontrado."]);
        };
    },
]);

require_once __DIR__ . '\..\teste\teste.php';

function welcome(Request $request, Response $response, $args): Response
{
    return $response->withStatus(200)->withJson(["msg" => "Bem vindo a API Estoque Lab!"]);
}

// =========================================
$app->any('/', "welcome");
$app->any('/reagente[/{id}]', ReagenteController::class . ':handleRequest');
$app->any('/vidraria[/{id}]', VidrariaController::class . ':handleRequest');
$app->any('/classificacao[/{id}]', ClassificacaoController::class . ':handleRequest');
$app->any('/nivel[/{id}]', NivelController::class . ':handleRequest');
$app->any('/operacao[/{id}]', OperacaoController::class . ':handleRequest');
$app->any('/tamanho[/{id}]', TamanhoController::class . ':handleRequest');
$app->any('/tipooperacao[/{id}]', TipoOperacaoController::class . ':handleRequest');
$app->any('/unidade[/{id}]', UnidadeController::class . ':handleRequest');
$app->any('/usuario[/{id}]', UsuarioController::class . ':handleRequest');
// =========================================

require_once __DIR__ . '\..\Middlewares\Middleware.php';

$app->run();
