<?php
namespace src\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use src\DAO\GenericDAO;

abstract class GenericController
{

    public function processRequest(GenericDAO $dao, $request, $response, $args): Response
    {
        $error = null;
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
                break;
            case 'DELETE':
                //$data = "DELETE";
                $data = $dao->delete(isset($args['id']) ? $request->getAttribute('id') : null);
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

        return $response->withStatus($error ? $error : 200)->withJson($data);
    }

}
