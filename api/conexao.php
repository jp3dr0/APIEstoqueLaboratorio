<?php
$host = "localhost";
$usuario = "root";
$senha = "";
$db = "estoque_lab";

$mysqli = new mysqli($host, $usuario, $senha, $db);
$mysqli->set_charset("utf8");