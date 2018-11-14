<?php
	$conn = new mysqli("localhost", "root", "", "csv");
	$charset = "utf8";
	mysqli_set_charset($conn, $charset);
	echo printf("character set: %s\n", mysqli_character_set_name($conn));

	header('Content-Type: text/html; charset=UTF-8');

	$arquivo = $_FILES['file']['tmp_name'];
	$nome = $_FILES['file']['name'];

	// isso vai dividir uma string em uma array, pelo delimitador "."
	// ou seja, "alunos.csv" vira um array {"alunos", "csv"}
	$ext = explode(".", $nome);

	// isso pega a ultima posição do array
	// nesse caso, csv
	$tipo = $ext[0];
	$extensao = $ext[1];
	//echo $ext[0];

	if($extensao != "csv"){
		echo "Extensão inválida";
	}
	else{		
		//echo "Extensão válida";
		// essa variavel vai armazenar o arquivo q foi feito o upload
		$objeto = fopen($arquivo, 'r');
		// enquanto tiver dados no arquivo
		if($tipo == "vidrariasquimica" || $tipo == "vidrariascasa"){
			$c = 0;
			while(($dados = fgetcsv($objeto, 1000, ",") ) !== FALSE){
				$c++;		
				//$nome = utf8_encode($dados[0]);
				//$sobrenome = utf8_encode($dados[1]);

				//$classificacao = utf8_encode($dados[0]);
				//$nome = utf8_encode($dados[1]);
				//$quantidade = utf8_encode($dados[2]);

				$nome = mb_strtolower($dados[0], 'UTF-8');
				$tamanho = mb_strtolower($dados[1], 'UTF-8');
				$quantidade = mb_strtolower($dados[2], 'UTF-8');

				echo "<br>";
				echo 'contador: '; 
				echo $c;
				echo "<br>";
				echo '$dados[0]';
				echo "<br>";
				echo $nome;
				echo "<br>";
				echo '$dados[1]';
				echo "<br>";
				echo $tamanho;
				echo "<br>";
				echo '$dados[2]';
				echo "<br>";
				echo $quantidade;
				echo "<br>";

				$result = $conn->query("INSERT INTO `vidrarias` (`nome`, `volume_tamanho`, `qtd`) VALUES ('$nome', '$tamanho', '$quantidade')");
				echo mysqli_error($conn);
			}
		}
		else if ($tipo == "reagentes"){
			$c = 0;
			while(($dados = fgetcsv($objeto, 1000, ",") ) !== FALSE){
				$c++;		
				//$nome = utf8_encode($dados[0]);
				//$sobrenome = utf8_encode($dados[1]);

				//$classificacao = utf8_encode($dados[0]);
				//$nome = utf8_encode($dados[1]);
				//$quantidade = utf8_encode($dados[2]);

				$classificacao = mb_strtolower($dados[0], 'UTF-8');
				$nome = mb_strtolower($dados[1], 'UTF-8');
				$quantidade = mb_strtolower($dados[2], 'UTF-8');

				echo "<br>";
				echo 'contador: '; 
				echo $c;
				echo "<br>";
				echo '$dados[0]';
				echo "<br>";
				echo $classificacao;
				echo "<br>";
				echo '$dados[1]';
				echo "<br>";
				echo $nome;
				echo "<br>";
				echo '$dados[2]';
				echo "<br>";
				echo $quantidade;
				echo "<br>";

				$result = $conn->query("INSERT INTO reagentes (classificacao, nome, qtd) VALUES ('$classificacao', '$nome', '$quantidade')");
				echo mysqli_error($conn);
			}
		}
		else {
			echo "O csv tem que ser só os que eu defini";
		}
		

		if($result){
			echo "Dados inseridos com sucesso";
			}
		else{
			echo "Erro ao inserir os dados";	
		}
	}
?>