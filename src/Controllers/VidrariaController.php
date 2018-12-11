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
        $allowed = $request->getAttribute('decoded_token_data')['nivel'] >= 2;
        switch ($request->getMethod()) {
            case 'GET':
                return isset($args['id']) ? $this->getVidraria($response, $request->getAttribute('id')) : $this->getVidrarias($response);
                break;
            case 'POST':
                return $allowed ? $this->createVidraria($request, $response) : $response->withStatus(401)->withJson(["msg" => "Você não tem as permissões necessárias para fazer isso."]);
                break;
            case 'PUT':
                return $allowed ? $this->updateVidraria($request, $response) : $response->withStatus(401)->withJson(["msg" => "Você não tem as permissões necessárias para fazer isso."]);
                break;
            case 'DELETE':
                return $allowed ? $this->deleteVidraria($request, $response) : $response->withStatus(401)->withJson(["msg" => "Você não tem as permissões necessárias para fazer isso."]);
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
        $userId = $request->getAttribute('decoded_token_data')['id'];

        if ($allowed) {
            $obj = $this->getDAO()->get(false, $id);
            $estoque = $obj['qtdEstoque'];

            // retirada
            if ($operacao == 1) {
                $post = $this->getDAO()->post(json_encode([
                    "qtdEstoque" => $estoque - $qtd,
                ]), $request->getAttribute('id'));
                if ($post['affected_rows'] > 0) {
                    $operacaoController = new OperacaoController();

                    $data = $operacaoController->create([
                        "vidraria" => $id,
                        "usuario" => $userId,
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
                        "qtdEstoque" => $estoque + $qtd,
                    ]), $request->getAttribute('id'));

                    if ($post['affected_rows'] > 0) {

                        $data = $operacaoController->create([
                            "vidraria" => $id,
                            "usuario" => $userId,
                            "tipoOperacao" => 2,
                            "qtd" => $qtd,
                        ]);
                    }
                }
                // com defeito
                else {
                    $data = $operacaoController->create([
                        "vidraria" => $id,
                        "usuario" => $userId,
                        "tipoOperacao" => 3,
                        "qtd" => $qtd,
                    ]);
                }

                $pendentes = $operacaoController->getPendentes(2);

                foreach ($pendentes as $key => $value) {
                    if ($value['vidraria'] == $id && $value['qtd'] == $qtd) {
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

    private function createVidraria(Request $request, Response $response): Response
    {
        $post = $this->getDAO()->post($request->getBody());
        if ($post['affected_rows'] > 0) {
            $operacaoController = new OperacaoController();
            $id = $this->getDAO()->lastInserted();
            $data = $operacaoController->create([
                "vidraria" => $id,
                "usuario" => $request->getAttribute('decoded_token_data')['id'],
                "tipoOperacao" => 4,
            ]);
        }
        return $response->withStatus(200)->withJson($data);
    }

    private function deleteVidraria(Request $request, Response $response): Response
    {
        //echo $request->getAttribute('id');
        $post = $this->getDAO()->delete($request->getAttribute('id'), true);
        //print_r($post);
        if ($post['affected_rows'] > 0) {
            $operacaoController = new OperacaoController();
            $id = $request->getAttribute('id');
            $data = $operacaoController->create([
                "reagente" => $id,
                "usuario" => $request->getAttribute('decoded_token_data')['id'],
                "tipoOperacao" => 5,
            ]);
        }
        return $response->withStatus(200)->withJson($data);
    }

    private function updateVidraria(Request $request, Response $response): Response
    {
        $post = $this->getDAO()->post($request->getBody(), $request->getAttribute('id'));
        if ($post['affected_rows'] > 0) {
            $operacaoController = new OperacaoController();
            $id = $request->getAttribute('id');
            $data = $operacaoController->create([
                "vidraria" => $id,
                "usuario" => $request->getAttribute('decoded_token_data')['id'],
                "tipoOperacao" => 6,
            ]);
        }
        return $response->withStatus(200)->withJson($data);
    }

    private function getVidrarias(Response $response): Response
    {
        $objs = $this->getDAO()->get(true, null, true);

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
