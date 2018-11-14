<?php
	$conn = new mysqli("localhost", "root", "", "estoque_lab");
	$charset = "utf8";
	mysqli_set_charset($conn, $charset);
	if (mysqli_connect_errno())
				  {
				  echo "Failed to connect to MySQL: " . mysqli_connect_error();
				  }
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
				$capacidade = mb_strtolower($dados[1], 'UTF-8');
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
				echo $capacidade;
				echo "<br>";
				echo '$dados[2]';
				echo "<br>";
				echo $quantidade;
				echo "<br>";
				echo "<br>";


				$unidades_query = $conn->query("SELECT * FROM `unidade`");
				$tamanhos_query = $conn->query("SELECT * FROM `tamanho`");

				//$row = mysqli_fetch_assoc($result1);
				//echo sizeof($row);
				//print_r ($row);

				$unidades = [];
				$tamanhos = [];

				while($row = mysqli_fetch_assoc($unidades_query)){
					array_push($unidades, $row['nomeUnidade']);
				};      

				while($row = mysqli_fetch_assoc($tamanhos_query)){
					array_push($tamanhos, $row['nomeTamanho']);
				};

				print_r ($unidades);
				echo "<br>";
				print_r ($tamanhos);
				echo "<br>";

				//if(in_array($tamanho, $unidades)){}	

				$valor_encontrado_unidade = false;
				$valor_encontrado_tamanho = false;

				foreach ($unidades as &$unidade) {
					if(strpos($capacidade, $unidade) !== false || strpos($capacidade, strtolower($unidade) ) !== false || strpos($capacidade, strtoupper($unidade) ) !== false){
						echo "A unidade é ";
						echo $unidade;
						$valor_bd = (int)$capacidade;
						//$unidade_bd = preg_replace('/[0-9]+/', '', $capacidade);
						$unidade_bd = $unidade;
						echo ", valor para o bd: ";
						echo $valor_bd;
						echo ", unidade para o bd: ";
						echo $unidade_bd;
						$valor_encontrado_unidade = true;
						break;	
					}
				}

				echo "<br>";

				if(!$valor_encontrado_unidade){
					foreach ($tamanhos as &$tamanho) {
						if(strpos($capacidade, $tamanho) !== false || strpos($capacidade, strtolower($tamanho) ) !== false || strpos($capacidade, strtoupper($tamanho) ) !== false){
							echo "O tamanho é ";
							echo $tamanho;
							echo ", tamanho para o bd: ";
							$tamanho_bd = $tamanho;
							echo $tamanho_bd;
							$valor_encontrado_tamanho = true;
							break;	
						}
					}
					echo "<br>";
				}			

				if($valor_encontrado_tamanho){
					$tamanho_index_query = $conn->query("SELECT idTamanho FROM `tamanho` where nomeTamanho = '".$tamanho_bd."'");
					echo gettype($tamanho_index_query);
					echo "<br>";
					$array = mysqli_fetch_array($tamanho_index_query);
					$tamanho_index = $array[0];					
					echo $tamanho_index;
					echo "<br>";
					$query = "INSERT INTO `vidraria` (`nomeVidraria`, `tamanhoCapacidadeVidraria`, `qtd_estoque_Vidraria`) VALUES ('$nome', '$tamanho_index', '$quantidade')";
				}
				elseif($valor_encontrado_unidade){
					$unidade_index_query = $conn->query("SELECT idUnidade FROM `unidade` where nomeUnidade = '".$unidade_bd."'");
					echo gettype($unidade_index_query);
					echo "<br>";
					$array = mysqli_fetch_array($unidade_index_query);
					$unidade_index = $array[0];
					echo $unidade_index;
					echo "<br>";
					$query = "INSERT INTO `vidraria` (`nomeVidraria`, `valorCapacidadeVidraria`, `UnidadeVidraria`, `qtd_estoque_Vidraria`) VALUES ('$nome', '$valor_bd', '$unidade_index', '$quantidade')";
				}
				elseif(!$valor_encontrado_unidade && !$valor_encontrado_tamanho){
					$query = "INSERT INTO `vidraria` (`nomeVidraria`, `qtd_estoque_Vidraria`) VALUES ('$nome', '$quantidade')";	
				}				
				
				$result = $conn->query($query);	
				//echo $query;
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

				$classificacao_reagente = mb_strtolower($dados[0], 'UTF-8');
				$nome = mb_strtolower($dados[1], 'UTF-8');
				$quantidade = mb_strtolower($dados[2], 'UTF-8');
				$capacidade = mb_strtolower($dados[3], 'UTF-8');

				echo "<br>";
				echo 'contador: '; 
				echo $c;
				echo "<br>";
				echo '$dados[0]';
				echo "<br>";
				echo $classificacao_reagente;
				echo "<br>";
				echo '$dados[1]';
				echo "<br>";
				echo $nome;
				echo "<br>";
				echo '$dados[2]';
				echo "<br>";
				echo $quantidade;
				echo "<br>";
				echo '$dados[3]';
				echo "<br>";
				echo $capacidade;
				echo "<br>";

				$unidades_query = $conn->query("SELECT * FROM `unidade`");
				$classificacao_query = $conn->query("SELECT * FROM `classificacao`");

				//$row = mysqli_fetch_assoc($result1);
				//echo sizeof($row);
				//print_r ($row);

				$unidades = [];
				$classificacoes = [];

				while($row = mysqli_fetch_assoc($unidades_query)){
					array_push($unidades, $row['nomeUnidade']);
				};      

				while($row = mysqli_fetch_assoc($classificacao_query)){
					array_push($classificacoes, $row['nomeClassificacao']);
				};

				print_r ($unidades);
				echo "<br>";
				print_r ($classificacoes);
				echo "<br>";

				//if(in_array($tamanho, $unidades)){}	

				foreach ($unidades as &$unidade) {
					if(strpos($capacidade, $unidade) !== false || strpos($capacidade, strtolower($unidade) ) !== false || strpos($capacidade, strtoupper($unidade) ) !== false){
						echo "A unidade é ";
						echo $unidade;
						$valor_bd = (int)$capacidade;
						//$unidade_bd = preg_replace('/[0-9]+/', '', $capacidade);
						$unidade_bd = $unidade;
						echo ", valor para o bd: ";
						echo $valor_bd;
						echo ", unidade para o bd: ";
						echo $unidade_bd;
						break;	
					}
				}

				echo "<br>";

				foreach ($classificacoes as &$classificacao) {
						$classificacao = mb_strtolower($classificacao);
						//echo $classificacao;
						//echo " == ";
						//echo $classificacao_reagente;
						//echo " ?";
						if(strpos($classificacao_reagente, $classificacao) !== false || strpos($classificacao_reagente, strtolower($classificacao) ) !== false || strpos($classificacao_reagente, strtoupper($classificacao) ) !== false){
							echo "A classificacao é ";
							echo $classificacao;
							echo ", classificacao para o bd: ";
							$classificacao_bd = $classificacao_reagente;
							echo $classificacao_bd;
							break;	
						}
				}

				echo "<br>";		

				$unidade_index_query = $conn->query("SELECT idUnidade FROM `unidade` where nomeUnidade = '".$unidade_bd."'");
				echo gettype($unidade_index_query);
				echo "<br>";
				$array = mysqli_fetch_array($unidade_index_query);
				$unidade_index = $array[0];
				echo $unidade_index;
				echo "<br>";		

				$classificacao_index_query = $conn->query("SELECT idClassificacao FROM `classificacao` where nomeClassificacao = '".$classificacao_bd."'");
				echo gettype($classificacao_index_query);
				echo "<br>";
				$array = mysqli_fetch_array($classificacao_index_query);
				$classificacao_index = $array[0];
				echo $classificacao_index;
				echo "<br>";	

				$result = $conn->query("INSERT INTO reagente (ClassificacaoReagente, nomeReagente, qtd_estoque_Reagente_lacrado, valorCapacidadeReagente, UnidadeReagente) VALUES ('$classificacao_index', '$nome', '$quantidade', '$valor_bd', '$unidade_index')");
				//echo "INSERT INTO reagente (ClassificacaoReagente, nomeReagente, qtd_estoque_Reagente_lacrado, valorCapacidadeReagente, UnidadeReagente) VALUES ('$classificacao_index', '$nome', '$quantidade', '$valor_bd', '$unidade_index')";
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

		mysqli_close($conn);
	}
?>