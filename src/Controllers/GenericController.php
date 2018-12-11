<?php
namespace src\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use src\DAO\GenericDAO;

abstract class GenericController
{

    public function processRequest(GenericDAO $dao, $request, $response, $args, bool $onlyAdmin = false): Response
    {
        $error = null;
        $data = null;
        //echo ($request->getMethod());
        switch ($request->getMethod()) {
            case 'GET':
                //$data = "READ";
                $data = $dao->get(false, isset($args['id']) ? $request->getAttribute('id') : null);
                break;
            case 'POST':
                $data = $dao->post($request->getBody(), isset($args['id']) ? $request->getAttribute('id') : null);
                break;
            case 'PUT':
                //$data = "UPDATE";
                $data = $dao->post($request->getBody(), $request->getAttribute('id'));
                break;
            case 'DELETE':
                //$data = "DELETE";
                $data = $dao->delete(isset($args['id']) ? $request->getAttribute('id') : null);
                break;
            case 'OPTIONS':
                $data = "ok";
                break;
            default:
                $error = 400;

                $data = "Erro ao encontrar verbo HTTP";
                break;
        }

        /*
        if (isset($args['id'])) {
        $data = $data . " " . $args['id'];
        }
         */
        if ($onlyAdmin && $request->getAttribute('decoded_token_data')['nivel'] < 2) {
            return $response->withStatus(401)->withJson(["msg" => "Você não tem as permissões necessárias para fazer isso."]);
        }
        return $response->withStatus($error ? $error : 200)->withJson($data);
    }

}
