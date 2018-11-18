<?php
namespace src\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use src\DAO\GenericDAO;

final class ReagenteController extends GenericController implements RouteableInterface
{

    protected $dao;

    public function __construct()
    {
        $this->dao = new GenericDAO("Reagente", "Reagentes", "reagente", explode("`, `", COLUNAS_REAGENTE));
    }

    public function getDAO(): GenericDAO
    {
        return $this->dao;
    }

    public function handleRequest(Request $request, Response $response, array $args): Response
    {
        if ($request->getMethod() == "GET") {
            return isset($args['id']) ? $this->getReagente($response, $request->getAttribute('id')) : $this->getReagentes($response);
        } else {
            return $this->processRequest($this->getDAO(), $request, $response, $args);
        }
    }

    private function getReagentes(Response $response): Response
    {
        $objs = $this->getDAO()->get(true);

        for ($i = 0; $i < sizeof($objs); $i++) {
            $objs[$i] = $this->joinObjects($objs[$i]);
        }

        return $response->withStatus(200)->withJson($objs);
    }

    private function getReagente(Response $response, int $id): Response
    {
        $obj = $this->getDAO()->get(false, $id);
        $obj = $this->joinObjects($obj);
        return $response->withStatus(200)->withJson($obj);
    }

    private function joinObjects($obj)
    {
        $id_classificacao = (int) $obj['classificacao'];

        $id_unidade = (int) $obj['unidade'];

        $classificacaoController = new ClassificacaoController();

        $unidadeController = new UnidadeController();

        $obj['classificacao'] = $id_classificacao == null ? null : $classificacaoController->getDAO()->get(false, $id_classificacao);

        $obj['unidade'] = $id_unidade == null ? null : $unidadeController->getDAO()->get(false, $id_unidade);

        return $obj;
    }

}
