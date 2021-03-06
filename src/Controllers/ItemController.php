<?php
namespace src\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use src\DAO\GenericDAO;

class ItemController extends GenericController implements RouteableInterface
{

    protected $dao;
    private $itemType;

    public function __construct(string $itemType)
    {
        $this->dao = new GenericDAO("Reagente", "Reagentes", "reagente", explode("`, `", COLUNAS_REAGENTE));
    }

    public function getDAO(): GenericDAO
    {
        return $this->dao;
    }

    public function handleRequest(Request $request, Response $response, array $args): Response
    {
        $allowed = $request->getAttribute('decoded_token_data')['nivel'] >= 3;
        switch ($request->getMethod()) {
            case 'GET':
                return isset($args['id']) ? $this->getItem($response, $request->getAttribute('id')) : $this->getItens($response);
                break;
            case 'POST':
                return $allowed ? $this->create($request, $response) : $response->withStatus(401)->withJson(["msg" => "Você não tem as permissões necessárias para fazer isso."]);
                break;
            case 'PUT':
                return $allowed ? $this->update($request, $response) : $response->withStatus(401)->withJson(["msg" => "Você não tem as permissões necessárias para fazer isso."]);
                break;
            case 'DELETE':
                return $allowed ? $this->delete($request, $response) : $response->withStatus(401)->withJson(["msg" => "Você não tem as permissões necessárias para fazer isso."]);
                break;
            default:
                return $this->processRequest($this->getDAO(), $request, $response, $args, true);
                break;
        }

    }

    public function operacao(Request $request, Response $response, array $args): Response
    {
        $allowed = $request->getAttribute('decoded_token_data')['nivel'] >= 1;
        $operacao = json_decode($request->getBody(), true)['tipoOperacao'];
        $qtd = json_decode($request->getBody(), true)['qtd'];
        $id = $request->getAttribute('id');

        if ($allowed) {
            $obj = $this->getDAO()->get(false, $id);
            $lacrado = $obj['qtdEstoqueLacrado'];
            $aberto = $obj['qtdEstoqueAberto'];

            // retirada
            if ($operacao == 1) {
                $post = $this->getDAO()->post(json_encode([
                    "qtdEstoqueLacrado" => $lacrado - $qtd,
                ]), $request->getAttribute('id'));
                if ($post['affected_rows'] > 0) {
                    $operacaoController = new OperacaoController();

                    $data = $operacaoController->create([
                        $this->itemType => $id,
                        "usuario" => 2,
                        "tipoOperacao" => 1,
                        "pendente" => 1,
                        "qtd" => $qtd,
                    ]);

                }
            }
            // devolução
            else {
                $operacaoController = new OperacaoController();
                if ($operacao == 2) {
                    $post = $this->getDAO()->post(json_encode([
                        "qtdEstoqueAberto" => $aberto + $qtd,
                    ]), $request->getAttribute('id'));

                    if ($post['affected_rows'] > 0) {

                        $data = $operacaoController->create([
                            $this->itemType => $id,
                            "usuario" => 2,
                            "tipoOperacao" => 2,
                            "qtd" => $qtd,
                        ]);
                    }
                }
                // com defeito
                else {
                    $data = $operacaoController->create([
                        $this->itemType => $id,
                        "usuario" => 2,
                        "tipoOperacao" => 3,
                        "qtd" => $qtd,
                    ]);
                }

                $pendentes = $operacaoController->getPendentes(2);

                foreach ($pendentes as $key => $value) {
                    if ($value[$this->itemType] == $id && $value['qtd'] == $qtd) {
                        $operacaoController->setPendente($value['id'], 0);
                        break;
                    }
                }

            }

            return $response->withStatus(200)->withJson($data);
        } else {
            return $response->withStatus(401)->withJson(["msg" => "Você não tem as permissões necessárias para fazer isso."]);
        }
    }

    private function create(Request $request, Response $response): Response
    {
        $post = $this->getDAO()->post($request->getBody());
        if ($post['affected_rows'] > 0) {
            $operacaoController = new OperacaoController();
            $id = $this->getDAO()->lastInserted();
            $data = $operacaoController->create([
                $this->itemType => $id,
                "usuario" => 2,
                "tipoOperacao" => 4,
            ]);
        }
        return $response->withStatus(200)->withJson($data);
    }

    private function delete(Request $request, Response $response): Response
    {
        //echo $request->getAttribute('id');
        $post = $this->getDAO()->delete($request->getAttribute('id'), true);
        //print_r($post);
        if ($post['affected_rows'] > 0) {
            $operacaoController = new OperacaoController();
            $id = $request->getAttribute('id');
            $data = $operacaoController->create([
                $this->itemType => $id,
                "usuario" => 2,
                "tipoOperacao" => 5,
            ]);
        }
        return $response->withStatus(200)->withJson($data);
    }

    private function update(Request $request, Response $response): Response
    {
        $post = $this->getDAO()->post($request->getBody(), $request->getAttribute('id'));
        if ($post['affected_rows'] > 0) {
            $operacaoController = new OperacaoController();
            $id = $request->getAttribute('id');
            $data = $operacaoController->create([
                $this->itemType => $id,
                "usuario" => 2,
                "tipoOperacao" => 6,
            ]);
        }
        return $response->withStatus(200)->withJson($data);
    }

}
