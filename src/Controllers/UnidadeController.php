<?php
namespace src\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use src\DAO\GenericDAO;

final class UnidadeController extends GenericController implements RouteableInterface
{

    protected $dao;

    public function __construct()
    {
        $this->dao = new GenericDAO("Unidade", "Unidades", "unidade", explode("`, `", COLUNAS_UNIDADE));
    }

    public function getDAO(): GenericDAO
    {
        return $this->dao;
    }

    public function handleRequest(Request $request, Response $response, array $args): Response
    {
        return $this->processRequest($this->getDAO(), $request, $response, $args, true);
    }

}
