<?php
namespace src\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use src\DAO\GenericDAO;

final class NivelController extends GenericController implements RouteableInterface
{
    public function handleRequest(Request $request, Response $response, array $args): Response
    {
        return $this->processRequest(new GenericDAO("Nível", "Niveis", "nivel", explode("`, `", COLUNAS_NIVEL)), $request, $response, $args, true);
    }

}
