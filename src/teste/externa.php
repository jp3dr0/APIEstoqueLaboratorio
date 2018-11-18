<?php
use \Psr\Http\Message\ServerRequestInterface as Request;

class Teste
{

    public function vaquejada(Request $request, $response, $args)
    {
        $data = "apaixonado";
        return $response->withStatus(200)->withHeader('Content-Type', 'application/json')->write($data);
    }

    public function um($req, $res, $tipo)
    {
        $data = "um";
        if (isset($args['id'])) {
            $data = $data . " " . $args['id'];
        }
        return $res->withStatus(200)->withHeader('Content-Type', 'application/json')->write($data);
    }

    public function dois($req, $res, $tipo)
    {
        $data = "dois";
        if (isset($args['id'])) {
            $data = $data . " " . $args['id'];
        }
        return $res->withStatus(200)->withHeader('Content-Type', 'application/json')->write($data);
    }
}
