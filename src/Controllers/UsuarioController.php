<?php

namespace src\Controllers;

use Firebase\JWT\JWT;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

//use \Firebase\JWT\JWT;
//use \Tuupola\Base62;

use src\DAO\GenericDAO;
use Tuupola\Base62;

final class UsuarioController extends GenericController implements RouteableInterface
{

    protected $dao;

    public function __construct()
    {
        $this->dao = new GenericDAO("Usuário", "Usuários", "usuario", explode("`, `", COLUNAS_USUARIO));
    }

    public function getDAO(): GenericDAO
    {
        return $this->dao;
    }

    public function handleRequest(Request $request, Response $response, array $args): Response
    {
        return $this->processRequest($this->getDAO(), $request, $response, $args, true);
    }

    public function login($input)
    {
        $body = json_decode($input, true);

        $email = $body['email'];
        $senha = $body['senha'];

        $user = $this->getDAO()->get(false, null, false, "WHERE email = '" . $email . "' AND senha = '" . $senha . "'");
        //print_r($user);
        if ($user) {
            //$nivel = $user[0]['nivel'];
            return $user[0];
        } else {
            return null;
            //return $response->withStatus(401)->withJson(["msg" => "Usuário não encontrado."]);
        }
    }

    public function registrar($input)
    {
        //$body = json_decode($input, true);

        $post = $this->getDAO()->post($input);
        //print_r($user);
        if ($post['affected_rows'] > 0) {
            //$nivel = $user[0]['nivel'];
            $user = json_decode($input, true);
            $user['id'] = $this->getDAO()->lastInserted();
            return $user;
        } else {
            return null;
            //return $response->withStatus(401)->withJson(["msg" => "Usuário não encontrado."]);
        }
    }

    public function getToken($user)
    {
        $base62 = new \Tuupola\Base62;

        $now = new \DateTime();
        // tempo de expiração do token
        $future = new \DateTime("now +2 hours");
        // identificador unico do token
        $jti = $base62->encode(random_bytes(16));

        $payload = [
            "jti" => $jti,
            //"iat" => $now->getTimeStamp(),
            //"nbf" => $future->getTimeStamp(),
            "nivel" => $user['nivel'],
            "id" => $user['id'],
        ];

        return JWT::encode($payload, getenv('JWT_SECRET'), "HS256");
    }

}
