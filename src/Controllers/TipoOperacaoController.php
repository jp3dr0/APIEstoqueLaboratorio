<?php
namespace src\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use src\DAO\GenericDAO;

final class TipoOperacaoController extends GenericController implements RouteableInterface
{
    public function handleRequest(Request $request, Response $response, array $args): Response
    {
        return $this->processRequest(new GenericDAO("Tipo de Operação", "Tipo de Operações", "tipooperacao", explode("`, `", COLUNAS_TIPO_OPERACAO)), $request, $response, $args);
    }

}
