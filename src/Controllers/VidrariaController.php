<?php
namespace src\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use src\DAO\GenericDAO;

final class VidrariaController extends GenericController implements RouteableInterface
{

    protected $dao;

    public function __construct()
    {
        $this->dao = new GenericDAO("Vidraria", "Vidrarias", "vidraria", explode("`, `", COLUNAS_VIDRARIA));
    }

    public function getDAO(): GenericDAO
    {
        return $this->dao;
    }

    public function handleRequest(Request $request, Response $response, array $args): Response
    {
        if ($request->getMethod() == "GET") {
            return isset($args['id']) ? $this->getVidraria($response, $request->getAttribute('id')) : $this->getVidrarias($response);
        } else {
            return $this->processRequest($this->getDAO(), $request, $response, $args);
        }
    }

    private function getVidrarias(Response $response): Response
    {
        $objs = $this->getDAO()->get(true);

        for ($i = 0; $i < sizeof($objs); $i++) {
            $objs[$i] = $this->joinObjects($objs[$i]);
        }

        return $response->withStatus(200)->withJson($objs);
    }

    private function getVidraria(Response $response, int $id): Response
    {
        $obj = $this->getDAO()->get(false, $id);
        $obj = $this->joinObjects($obj);
        return $response->withStatus(200)->withJson($obj);
    }

    private function joinObjects($obj)
    {
        $id_tamanho = (int) $obj['tamanho'];

        $id_unidade = (int) $obj['unidade'];

        $tamanhoController = new TamanhoController();

        $unidadeController = new UnidadeController();

        $obj['tamanho'] = $id_tamanho == null ? null : $tamanhoController->getDAO()->get(false, $id_tamanho);

        $obj['unidade'] = $id_unidade == null ? null : $unidadeController->getDAO()->get(false, $id_unidade);

        return $obj;
    }

}
