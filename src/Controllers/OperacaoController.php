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
        } elseif ($request->getMethod() == "GET" && $nivel >= 3) {
            return isset($args['id']) ? $this->getOperacao($response, $request->getAttribute('id')) : $this->getOperacoes($response);
        } elseif ($nivel >= 3) {
            return $this->processRequest($this->getDAO(), $request, $response, $args);
        } else {
            return $response->withStatus(401)->withJson(["msg" => "Você não tem as permissões necessárias para fazer isso."]);
        }
    }

    /*
    {
    "img": "img",
    "qtdEstoqueLacrado": 5,
    "qtdEstoqueAberto": 5,
    "nome": "acido loukao",
    "classificacao": 1,
    "valor": 25,
    "unidade": 3
    }
     */

    private function createOperacao(Request $request, Response $response, array $args): Response
    {
        $tipo = (int) $request->getParsedBody()['tipoOperacao'];
        //echo $tipo;
        $nivel = $request->getAttribute('decoded_token_data')['nivel'];
        //echo $nivel;

        if (isset($tipo)) {
            // menor ou igual a devolução com defeito
            if ($tipo <= 3) {
                // no minimo professor
                if ($nivel >= 1) {
                    return $this->processRequest($this->getDAO(), $request, $response, $args);
                }
            }
            // maior que devolução com defeito
            else {
                // no minimo tecnico
                if ($nivel >= 2) {
                    return $this->processRequest($this->getDAO(), $request, $response, $args);
                }
            }
        }
        return $response->withStatus(401)->withJson(["msg" => "Você não tem as permissões necessárias para realizar esta operação."]);
    }

    public function create(array $operacao)
    {
        return $this->getDAO()->post(json_encode($operacao));
    }

    public function setPendente(int $operacao, int $pendente)
    {
        return $this->getDAO()->post(json_encode([
            "pendente" => $pendente,
        ]), $operacao);
    }

    public function getPendentes(int $usuario)
    {
        return $this->getDAO()->get(true, null, false, "WHERE usuario = " . $usuario . " AND tipooperacao = 1 AND pendente = 1");
    }

    private function getOperacoes(Response $response): Response
    {
        return $response->withStatus(200)->withJson($this->getDAO()->get(true));
    }

    private function getOperacao(Response $response, int $id): Response
    {
        return $response->withStatus(200)->withJson($this->getDAO()->get(false, $id));
    }

}
