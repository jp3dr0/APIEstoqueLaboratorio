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

//use Slim\Http\Request;
//use Slim\Http\Response;

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

/*
$app->add(new Tuupola\Middleware\CorsMiddleware([
"origin" => ["*"],
"methods" => ["GET", "POST", "PATCH", "DELETE", "OPTIONS"],
"headers.allow" => ["Origin", "Content-Type", "Authorization", "Accept", "ignoreLoadingBar", "X-Requested-With", "Access-Control-Allow-Origin", "content-type"],
"headers.expose" => [],
"credentials" => true,
"cache" => 0,
]));
 */
$app->add(new Tuupola\Middleware\JwtAuthentication([
    "secret" => getenv('JWT_SECRET'), # the secret key
    "secure" => false, # true to enable HTTPS only
    /*
    "rules" => [

    new Tuupola\Middleware\JwtAuthentication\RequestPathRule([
    // degenerate access to URI's
    "path" => [
    "/test",
    "/eae"
    ],

    // allow access to specific URI's without a token
    "passthrough" => [
    "/login",
    "/registrar",
    ],
    new Tuupola\Middleware\JwtAuthentication\RequestMethodRule([
    "passthrough" => ["OPTIONS"],
    ]),
    ],
     */
    "path" => "/v1", /* or ["/api", "/admin"] */

    "ignore" => [
        "/login",
        "/registrar",
    ],

    "attribute" => "decoded_token_data",
    "algorithm" => ["HS256"],
    "error" => function ($response, $arguments) {
        //$data["status"] = "erro";
        $data["msg"] = $arguments["message"];
        return $response->withStatus(401)
            ->withHeader("Content-Type", "application/json")
            ->write(json_encode($data, JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT));
    },
    /*
"before" => function ($request, $arguments) {
return $request->withAttribute("test", "test");
}
"after" => function ($response, $arguments) {
//return $response->withHeader("X-Brawndo", "plants crave");
return $response->withStatus(401)
->withHeader("Content-Type", "application/json")
->write(json_encode("dataa", JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT));
},
 */
]));

require_once __DIR__ . '\..\teste\teste.php';

function welcome(Request $request, Response $response, $args): Response
{
    return $response->withStatus(200)->withJson(["msg" => "Bem vindo a API Estoque Lab!"]);
}

// =========================================

$app->post('/login', function (Request $request, Response $response, array $args) {

    // receber email e senha ou login e senha como input, fazer uma consulta no dao de users com where e por no payload do token o nivel do usuario, se ele existir.
    // se nao, retorna 401 erro

    // implementar endpoint de registro tbm

    $usuarioController = new UsuarioController();

    $user = $usuarioController->login($request->getBody());

    if ($user) {
        $token = $usuarioController->getToken($user);
        return $this->response->withJson(['token' => $token]);
    } else {
        return $response->withStatus(401)->withJson(["msg" => "Usuário não encontrado."]);
    }

});

$app->options('/login', function (Request $request, Response $response, array $args) {
    return $response->withStatus(200)->withJson(["msg" => "ok"]);
});

$app->post('/registrar', function (Request $request, Response $response, array $args) {

    $usuarioController = new UsuarioController();

    $user = $usuarioController->registrar($request->getBody());

    if ($user) {
        $token = $usuarioController->getToken($user);
        return $this->response->withJson(['token' => $token]);
    } else {
        return $response->withStatus(401)->withJson(["msg" => "Erro ao registrar."]);
    }

});

$app->options('/registrar', function (Request $request, Response $response, array $args) {
    return $response->withStatus(200)->withJson(["msg" => "ok"]);
});

$app->any('/', "welcome");

$app->group('/v1', function () use ($app) {

    

    // todos podem dar get, o resto é só tecnico
    $app->any('/reagente[/{id}]', ReagenteController::class . ':handleRequest');
    $app->post('/reagente/{id}/operacao', ReagenteController::class . ':operacao');
    $app->any('/vidraria[/{id}]', VidrariaController::class . ':handleRequest');
    $app->post('/vidraria/{id}/operacao', VidrariaController::class . ':operacao');

    // só admin que faz tudo
    $app->any('/classificacao[/{id}]', ClassificacaoController::class . ':handleRequest');
    $app->any('/nivel[/{id}]', NivelController::class . ':handleRequest');
    $app->any('/tamanho[/{id}]', TamanhoController::class . ':handleRequest');
    $app->any('/tipooperacao[/{id}]', TipoOperacaoController::class . ':handleRequest');
    $app->any('/unidade[/{id}]', UnidadeController::class . ':handleRequest');
    $app->any('/usuario[/{id}]', UsuarioController::class . ':handleRequest');

    // cada nivel tem suas permissoes personalizadas
    $app->any('/operacao[/{id}]', OperacaoController::class . ':handleRequest');
})->add(function ($request, $response, $next) {
    //$response->getBody()->write('It is now ');

    //echo $request->getMethod();

    if($request->getMethod() == 'OPTIONS'){
        return $response->withStatus(200)->withJson(["msg" => "ok"]);
    }

    $payload = $request->getAttribute('decoded_token_data');
    //return $response->withStatus(200)->withJson(["headers" => $request->getHeaders(), 'token' => $request->getHeader('Authorization'), 'payload' => $payload]);

    //print_r($payload);

    // verificar se o token possui o nivel no payload
    // && isset($payload['nivel']) && isset($payload['id']) && $payload['nivel'] >= 0
    if (isset($payload)) {
        //return $response->withJson($payload);
        $response = $next($request, $response);
        //$response->getBody()->write('. Enjoy!');
    } else {
        return $response->withStatus(401)->withJson(["msg" => "Não foi encontrado o claim 'nivel' ou 'id' no payload do JWT.", "payload" => $payload, "headers" => $request->getHeaders(), 'token' => $request->getHeader('Authorization')]);

    }

    return $response;
});
// =========================================

require_once __DIR__ . '\..\Middlewares\Middleware.php';

$app->run();

/*
$sql = "SELECT * FROM users WHERE email= :email";
$sth = $this->db->prepare($sql);
$sth->bindParam("email", $input['email']);
$sth->execute();
$user = $sth->fetchObject();

// verify email address.
if(!$user) {
return $this->response->withJson(['error' => true, 'message' => 'These credentials do not match our records.']);
}

// verify password.
if (!password_verify($input['password'],$user->password)) {
return $this->response->withJson(['error' => true, 'message' => 'These credentials do not match our records.']);
}
$settings = $this->get('settings'); // get settings array.
 */

//$token = JWT::encode(['id' => $user->id, 'email' => $user->email], "SECRET", "HS256");

// implementar expire time

/*
use \Firebase\JWT\JWT;
use \Tuupola\Base62;

$now = new DateTime();
$future = new DateTime("now +2 hours");
$jti = Base62::encode(random_bytes(16));

$secret = "your_secret_key";

$payload = [
"jti" => $jti,
"iat" => $now->getTimeStamp(),
"nbf" => $future->getTimeStamp()
];

$token = JWT::encode($payload, $secret, "HS256");
 */
