<?php
namespace src\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

interface RouteableInterface
{
    public function handleRequest(Request $request, Response $response, array $args): Response;
}
