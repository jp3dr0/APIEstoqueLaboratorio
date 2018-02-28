<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

class Teste {
    public function um($req, $res, $tipo){
        $data = "um";
        if(isset($args['id'])){
            $data = $data . " " . $args['id'];
        }
        return $res->withStatus(200)->withHeader('Content-Type', 'application/json')->write($data);  
    }
    
    public function dois($req, $res, $tipo){
        $data = "dois";
        if(isset($args['id'])){
            $data = $data . " " . $args['id'];
        }
        return $res->withStatus(200)->withHeader('Content-Type', 'application/json')->write($data);  
    }
}
