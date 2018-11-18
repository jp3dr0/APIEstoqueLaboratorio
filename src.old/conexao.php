<?php
$host = "localhost";
$usuario = "root";
$senha = "";
$db = "estoque_lab";

//$host = "mysql.hostinger.com.br";
//$usuario = "u311781517_cleit";
//$senha = "senha123";
//$db = "u311781517_crdb";

$mysqli = new mysqli($host, $usuario, $senha, $db);
$mysqli->set_charset("utf8");