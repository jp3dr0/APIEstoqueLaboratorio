<?php
namespace src\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use src\DAO\GenericDAO;

final class OperacaoController extends GenericController implements RouteableInterface
{

    protected $dao;

    public function __construct()
    {
        $this->dao = new GenericDAO("Operação", "Operações", "operacao", explode("`, `", COLUNAS_OPERACAO));
    }

    public function getDAO(): GenericDAO
    {
        return $this->dao;
    }

    public function handleRequest(Request $request, Response $response, array $args): Response
    {
        $payload = $request->getAttribute('decoded_token_data');

        $nivel = $request->getAttribute('decoded_token_data')['nivel'];

        if ($request->getMethod() == "POST") {
            return $this->createOperacao($request, $response, $args);
        } elseif ($nivel >= 3) {
            return $this->processRequest($this->getDAO(), $request, $response, $args);
        } else {
            return $response->withStatus(401)->withJson(["msg" => "Você não tem as permissões necessárias para fazer isso."]);
        }
    }

    private function createOperacao(Request $request, Response $response, array $args): Response
    {
        $tipo = $request->getParsedBody()['tipoOperacao'];
        $nivel = $request->getAttribute('decoded_token_data')['nivel'];

        if (isset($tipo)) {
            // menor ou igual a devolução com defeito
            if ($tipo <= 3) {
                // no minimo professor
                if ($nivel >= 1) {
                    $this->processRequest($this->getDAO(), $request, $response, $args);
                }
            }
            // maior que devolução com defeito
            else {
                // no minimo tecnico
                if ($nivel >= 2) {
                    $this->processRequest($this->getDAO(), $request, $response, $args);
                }
            }
        }
        return $response->withStatus(401)->withJson(["msg" => "Você não tem as permissões necessárias para realizar esta operação."]);
    }

}
