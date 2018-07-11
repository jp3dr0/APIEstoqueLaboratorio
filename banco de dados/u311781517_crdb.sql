
-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tempo de Geração: 28/02/2018 às 00:51:33
-- Versão do Servidor: 10.1.22-MariaDB
-- Versão do PHP: 5.2.17

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Banco de Dados: `u311781517_crdb`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `classificacao`
--

CREATE TABLE IF NOT EXISTS `classificacao` (
  `idClassificacao` int(11) NOT NULL,
  `nomeClassificacao` varchar(45) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `classificacao`
--

INSERT INTO `classificacao` (`idClassificacao`, `nomeClassificacao`) VALUES
(1, 'Ácidos Inorgânicos'),
(2, 'Adsorventes'),
(3, 'Bases Inorgânicas'),
(4, 'Indicadores'),
(5, 'Óxidos e Peróxidos'),
(6, 'Sais de Amônio'),
(7, 'Sais do Grupo I / Sódio'),
(8, 'Sais do Grupo II / Magnésio Cálcio e Bário'),
(9, 'Sais do Grupo III / Aluminio'),
(10, 'Sais dos Metais de Transição'),
(11, 'Solventes e Sólidos Orgãnicos'),
(12, 'Sólidos Inorgânicos');

-- --------------------------------------------------------

--
-- Estrutura da tabela `nivel`
--

CREATE TABLE IF NOT EXISTS `nivel` (
  `idNivel` int(11) NOT NULL,
  `nomeNivel` varchar(30) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `nivel`
--

INSERT INTO `nivel` (`idNivel`, `nomeNivel`) VALUES
(0, 'Administrador'),
(1, 'Aluno'),
(2, 'Professor'),
(3, 'Tecnico');

-- --------------------------------------------------------

--
-- Estrutura da tabela `operacao`
--

CREATE TABLE IF NOT EXISTS `operacao` (
  `idOperacao` int(11) NOT NULL,
  `Reagente_idReagente` int(11) DEFAULT NULL,
  `Vidraria_idVidraria` int(11) DEFAULT NULL,
  `dataOperacao` datetime NOT NULL,
  `Usuario_idUsuario` int(11) NOT NULL,
  `TipoOperacao_idTipoOperacao` int(11) NOT NULL,
  `qtd` int(11) NOT NULL,
  `img` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comentario` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pendente` char(1) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `operacao`
--

INSERT INTO `operacao` (`idOperacao`, `Reagente_idReagente`, `Vidraria_idVidraria`, `dataOperacao`, `Usuario_idUsuario`, `TipoOperacao_idTipoOperacao`, `qtd`, `img`, `comentario`, `pendente`) VALUES
(14, NULL, 14, '2017-12-11 13:54:49', 1, 1, 10, NULL, NULL, 'S');

--
-- Gatilhos `operacao`
--
DROP TRIGGER IF EXISTS `tr_operacao`;
DELIMITER //
CREATE TRIGGER `tr_operacao` BEFORE INSERT ON `operacao`
 FOR EACH ROW BEGIN
	SET NEW.dataOperacao = NOW();
    
    SET @nivel = (SELECT Nivel_idNivel from usuario where idUsuario = new.Usuario_idUsuario LIMIT 1);
    
    SET @operacao = new.TipoOperacao_idTipoOperacao;
    SET @retirada = 1;
    SET @devolucao = 2;
    set @devolucao_com_defeito = 3;
    SET @adicao = 4;
    SET @remocao = 5;
    SET @edicao = 6;
    
    IF new.Reagente_idReagente IS NULL THEN
    	SET @item = new.Vidraria_idVidraria;
        SET @escolha = 'vidraria';
    ELSEIF new.Vidraria_idVidraria IS NULL THEN
    	SET @item = new.Reagente_idReagente;
        SET @escolha = 'reagente';
    ELSEIF new.Reagente_idReagente IS NULL && new.Vidraria_idVidraria IS NULL THEN
    	SIGNAL sqlstate '45001' set message_text = "Insira um item para fazer alguma operação!";
    END IF;
    
    IF (@nivel <=> 1) THEN
        SIGNAL sqlstate '45001' set message_text = "Aluno não pode fazer nenhuma operação!";
    ELSEIF (@nivel <=> 2) THEN
        if @operacao <=> @adicao || @operacao <=> @remocao || @operacao <=> @edicao then
			SIGNAL sqlstate '45001' set message_text = "Professor não pode fazer esse tipo de operação!";
        end if;
    END IF;

    
    IF @operacao <=> @retirada THEN
        if @escolha <=> 'reagente' then
        	SET @qtdAberto = (SELECT qtd_estoque_Reagente_aberto from reagente where @item = idReagente LIMIT 1);
            SET @qtdFechado = (SELECT qtd_estoque_Reagente_lacrado from reagente where @item = idReagente LIMIT 1);
        	if new.qtd <= @qtdAberto then
            	SET @newQtdAberto = @qtdAberto - new.qtd;
            	UPDATE reagente SET qtd_estoque_Reagente_aberto = @newQtdAberto WHERE idReagente = @item;
            elseif new.qtd > @qtdAberto then
            	if new.qtd - @qtdAberto <= @qtdFechado then
                	UPDATE reagente SET qtd_estoque_Reagente_aberto = '0' WHERE idReagente = @item;
                    SET @newQtdFechado = new.qtd - @qtdAberto;
                    UPDATE reagente SET qtd_estoque_Reagente_lacrado = @newQtdFechado WHERE idReagente = @item;
                else
                	SIGNAL sqlstate '45001' set message_text = "Quantidade não disponível no estoque!";
                end if;
            end if;
        elseif @escolha <=> 'vidraria' then
			SET @qtdVidraria = (SELECT qtd_estoque_Vidraria from vidraria where @item = idVidraria LIMIT 1);
        	if new.qtd <= @qtdVidraria then
				SET @newQtd = @qtdVidraria - new.qtd;
                UPDATE vidraria SET qtd_estoque_Vidraria = @newQtd WHERE idVidraria = @item;
			else
				SIGNAL sqlstate '45001' set message_text = "Quantidade não disponível no estoque!";
			end if;
        end if;
        set new.pendente = 'S';
    ELSEIF @operacao <=> @devolucao THEN
    	if @escolha <=> 'reagente' then
			SET @oldQtd = (SELECT qtd_estoque_Reagente_aberto FROM `reagente` where idReagente = @item limit 1);
        	SET @retirada_atrelada_qtd = (SELECT qtd FROM operacao WHERE Reagente_idReagente = @item limit 1);
            if new.qtd < @retirada_atrelada_qtd then
				SET @newQtd = @retirada_atrelada_qtd - new.qtd;
                SET @newQtd = @newQtd + @oldQtd;
                UPDATE reagente SET qtd_estoque_Reagente_aberto = @newQtd WHERE idReagente = @item;
			elseif new.qtd <=> @retirada_atrelada_qtd then
				SET @newQtd = @retirada_atrelada_qtd - new.qtd;
                SET @newQtd = @newQtd + @oldQtd;
                UPDATE reagente SET qtd_estoque_Reagente_aberto = @newQtd WHERE idReagente = @item;
				CALL `set_operacao_pendente`('N', @item, 'R');
			else
				SIGNAL sqlstate '45001' set message_text = "Você está devolvendo mais do que você retirou! Nada feito, refaça a operação.";
			end if;
        elseif @escolha <=> 'vidraria' then
			SET @oldQtd = (SELECT qtd_estoque_Vidraria FROM `vidraria` where idVidraria = @item limit 1);
			SET @retirada_atrelada_qtd = (SELECT qtd FROM operacao WHERE Vidraria_idVidraria = @item limit 1);
            if new.qtd < @retirada_atrelada_qtd then
				SET @newQtd = @retirada_atrelada_qtd - new.qtd;
                SET @newQtd = @newQtd + @oldQtd;
                UPDATE vidraria SET qtd_estoque_Vidraria = @newQtd WHERE idVidraria = @item;
			elseif new.qtd <=> @retirada_atrelada_qtd then
				SET @newQtd = @retirada_atrelada_qtd - new.qtd;
                SET @newQtd = @newQtd + @oldQtd;
                UPDATE vidraria SET qtd_estoque_Vidraria = @newQtd WHERE idVidraria = @item;
				CALL `set_operacao_pendente`('N', @item, 'V');
			else
				SIGNAL sqlstate '45001' set message_text = "Você está devolvendo mais do que você retirou! Nada feito, refaça a operação.";
			end if;
        end if;
    ELSEIF @operacao <=> @devolucao_com_defeito THEN
    	if @escolha <=> 'reagente' then
        	SET @retirada_atrelada_qtd = (SELECT qtd FROM operacao WHERE Reagente_idReagente = @item limit 1);
            if new.qtd < @retirada_atrelada_qtd then
				SET @newQtd = @retirada_atrelada_qtd - new.qtd;
                CALL `set_operacao_qtd`(@newQtd, @item, 'V');
			elseif new.qtd <=> @retirada_atrelada_qtd then
				SET @newQtd = @retirada_atrelada_qtd - new.qtd;
                CALL `set_operacao_qtd`(@newQtd, @item, 'V');
				CALL `set_operacao_pendente`('N', @item, 'R');
			else
				SIGNAL sqlstate '45001' set message_text = "Você está devolvendo mais do que você retirou! Nada feito, refaça a operação.";
			end if;
		elseif @escolha <=> 'vidraria' then
			SET @retirada_atrelada_qtd = (SELECT qtd FROM operacao WHERE Vidraria_idVidraria = @item limit 1);
            if new.qtd < @retirada_atrelada_qtd then
				SET @newQtd = @retirada_atrelada_qtd - new.qtd;
                CALL `set_operacao_qtd`(@newQtd, @item, 'R');
			elseif new.qtd <=> @retirada_atrelada_qtd then
				SET @newQtd = @retirada_atrelada_qtd - new.qtd;
                CALL `set_operacao_qtd`(@newQtd, @item, 'R');
				UPDATE `operacao` SET `pendente` = 'N' WHERE Vidraria_idVidraria = @item limit 1;
			else
				SIGNAL sqlstate '45001' set message_text = "Você está devolvendo mais do que você retirou! Nada feito, refaça a operação.";
			end if;
		end if;
    ELSEIF @operacao <=> @adicao THEN
    	if @escolha <=> 'reagente' then
            if new.qtd >= 0 then
				SET @oldQtd = (SELECT qtd_estoque_Reagente_lacrado FROM `reagente` WHERE idReagente = @item);
				SET @newQtd = @oldQtd + new.qtd;
                UPDATE reagente SET qtd_estoque_Reagente_lacrado = @newQtd WHERE idReagente = @item;
			else
				SIGNAL sqlstate '45001' set message_text = "A quantidade não é válida.";
			end if;
        elseif @escolha <=> 'vidraria' then
			if new.qtd >= 0 then
				SET @oldQtd = (SELECT qtd_estoque_Vidraria FROM `vidraria` WHERE idVidraria = @item);
				SET @newQtd = @oldQtd + new.qtd;
                UPDATE reagente SET qtd_estoque_Vidraria = @newQtd WHERE idVidraria = @item;
			else
				SIGNAL sqlstate '45001' set message_text = "A quantidade não é válida.";
			end if;
        end if;
    ELSEIF @operacao <=> @remocao THEN
    	if @escolha <=> 'reagente' then
            if new.qtd >= 0 then
				SET @oldQtd = (SELECT qtd_estoque_Reagente_lacrado FROM `reagente` WHERE idReagente = @item);
				SET @newQtd = @oldQtd - new.qtd;
                UPDATE reagente SET qtd_estoque_Reagente_lacrado = @newQtd WHERE idReagente = @item;
			else
				SIGNAL sqlstate '45001' set message_text = "A quantidade não é válida.";
			end if;
        elseif @escolha <=> 'vidraria' then
			if new.qtd >= 0 then
				SET @oldQtd = (SELECT qtd_estoque_Vidraria FROM `vidraria` WHERE idVidraria = @item);
				SET @newQtd = @oldQtd - new.qtd;
                UPDATE reagente SET qtd_estoque_Vidraria = @newQtd WHERE idVidraria = @item;
			else
				SIGNAL sqlstate '45001' set message_text = "A quantidade não é válida.";
			end if;
        end if;
    ELSEIF @operacao <=> @edicao THEN
    	if new.img is null && new.comentario is null then
			SIGNAL sqlstate '45001' set message_text = "Você não proveu nenhum valor para comentario ou imagem.";
		elseif new.img is null then
			if @escolha <=> 'reagente' then
				UPDATE `reagente` SET `comentarioReagente` = new.comentario WHERE `reagente`.`idReagente` = @item;
            elseif @escolha <=> 'vidraria' then
				UPDATE `vidraria` SET `comentarioVidraria` = new.comentario WHERE `vidraria`.`idVidraria` = @item;
            end if;
		elseif new.comentario is null then
			if @escolha <=> 'reagente' then
				UPDATE `reagente` SET `imgReagente` = new.img WHERE `reagente`.`idReagente` = @item;
            elseif @escolha <=> 'vidraria' then
				UPDATE `vidraria` SET `imgVidraria` = new.img WHERE `vidraria`.`idVidraria` = @item;
            end if;
		else
			if @escolha <=> 'reagente' then
				UPDATE `reagente` SET `imgReagente` = new.img, `comentarioReagente` = new.comentario WHERE `reagente`.`idReagente` = @item;
            elseif @escolha <=> 'vidraria' then
				UPDATE `vidraria` SET `imgVidraria` = new.img, `comentarioVidraria` = new.comentario WHERE `vidraria`.`idVidraria` = @item;
            end if;
        end if;
    END IF;
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `reagente`
--

CREATE TABLE IF NOT EXISTS `reagente` (
  `idReagente` int(11) NOT NULL,
  `imgReagente` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qtd_estoque_Reagente_lacrado` int(11) DEFAULT NULL,
  `qtd_estoque_Reagente_aberto` int(11) NOT NULL DEFAULT '0',
  `qtd_estoque_Reagente_total` int(11) DEFAULT NULL,
  `nomeReagente` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `comentarioReagente` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ClassificacaoReagente` int(11) NOT NULL,
  `valorCapacidadeReagente` int(11) DEFAULT NULL,
  `UnidadeReagente` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `reagente`
--

INSERT INTO `reagente` (`idReagente`, `imgReagente`, `qtd_estoque_Reagente_lacrado`, `qtd_estoque_Reagente_aberto`, `qtd_estoque_Reagente_total`, `nomeReagente`, `comentarioReagente`, `ClassificacaoReagente`, `valorCapacidadeReagente`, `UnidadeReagente`) VALUES
(3, NULL, 1, 0, 1, 'ácido bórico', NULL, 1, 500, 4),
(4, NULL, 2, 0, 2, 'ácido clorídrico ', NULL, 1, 1000, 1),
(5, NULL, 1, 0, 1, 'ácido fosfórico 85 %', NULL, 1, 1000, 1),
(6, NULL, 5, 0, 5, 'ácido sulfúrico', NULL, 1, 1000, 1),
(7, NULL, 1, 0, 1, 'ácido tricloroacético', NULL, 1, 500, 4),
(8, NULL, 1, 0, 1, 'ácido acético glacial', NULL, 1, 1000, 1),
(9, NULL, 1, 0, 1, 'ácido ascórbico', NULL, 1, 500, 4),
(10, NULL, 1, 0, 1, 'ácido cítrico anidro', NULL, 1, 500, 4),
(11, NULL, 1, 0, 1, 'fenol cristal (ácido fénico)', NULL, 1, 500, 4),
(12, NULL, 1, 0, 1, 'ácido oxálico', NULL, 1, 500, 4),
(13, NULL, 1, 0, 1, 'ácido salicílico', NULL, 1, 250, 4),
(14, NULL, 1, 0, 1, 'carvão ativo em pó purificado', NULL, 2, 500, 4),
(15, NULL, 1, 0, 1, 'silica gel azul 4-8mm', NULL, 2, 1000, 4),
(16, NULL, 1, 0, 1, 'silicagel azul ', NULL, 2, 500, 4),
(17, NULL, 3, 0, 3, 'hidróxido de amônio ', NULL, 3, 1000, 1),
(18, NULL, 1, 0, 1, 'hidróxido de cácio', NULL, 3, 500, 4),
(19, NULL, 1, 0, 1, 'hidróxido de potássio 85 % lentilhas', NULL, 3, 500, 4),
(20, NULL, 1, 0, 1, 'hidróxido de sódio micropérolas ', NULL, 3, 1000, 4),
(21, NULL, 1, 0, 1, 'alaranjado de metila ', NULL, 4, 25, 4),
(22, NULL, 1, 0, 1, 'amido solúvel ', NULL, 4, 500, 4),
(23, NULL, 1, 0, 1, 'azul de bromotimol', NULL, 4, 5, 4),
(24, NULL, 2, 0, 2, 'azul de metileno ', NULL, 4, 50, 4),
(25, NULL, 3, 0, 3, 'edta (sal dipotássio)', NULL, 4, 50, 4),
(26, NULL, 1, 0, 1, 'fenoftaleina ', NULL, 4, 25, 4),
(27, NULL, 1, 0, 1, 'murexida', NULL, 4, 25, 4),
(28, NULL, 1, 0, 1, 'preto de eriocromo t : ', NULL, 4, 25, 4),
(29, NULL, 1, 0, 1, 'purpura de bromocresol', NULL, 4, 25, 4),
(30, NULL, 1, 0, 1, 'óxido de mercúrio ii (amarelo)', NULL, 5, 25, 4),
(31, NULL, 1, 0, 1, 'peróxido de hidrogênio ', NULL, 5, 1000, 1),
(32, NULL, 0, 0, 0, 'dicromato de amônio ', NULL, 6, 500, 4),
(33, NULL, 2, 0, 2, 'cloreto de amônio ', NULL, 6, 500, 4),
(34, NULL, 1, 0, 1, 'molibdato de amônio tetrahidratado ', NULL, 6, 100, 4),
(35, NULL, 1, 0, 1, 'azida sódica ', NULL, 7, 50, 4),
(36, NULL, 1, 0, 1, 'bicarbonato de sódio comecial', NULL, 7, 500, 4),
(37, NULL, 2, 0, 2, 'bicarbonato de sódio ', NULL, 7, 500, 4),
(38, NULL, 1, 0, 1, 'bissulfito de sódio ', NULL, 7, 500, 4),
(39, NULL, 1, 0, 1, 'citrato de sódio tribásico dihidratado ', NULL, 7, 500, 4),
(40, NULL, 3, 0, 3, 'cloreto de sódio cristalizado', NULL, 7, 500, 4),
(41, NULL, 1, 0, 1, 'acetato de  sódio anidro ', NULL, 7, 250, 4),
(42, NULL, 1, 0, 1, 'acetato de sódio trihidratado ', NULL, 7, 500, 4),
(43, NULL, 1, 0, 1, 'meta bissulfito de sódio', NULL, 7, 500, 4),
(44, NULL, 2, 0, 2, 'molibdato de sódio dihidratado ', NULL, 7, 100, 4),
(45, NULL, 1, 0, 1, 'nitrato de sódio ', NULL, 7, 500, 4),
(46, NULL, 1, 0, 1, 'nitrito de sódio ', NULL, 7, 500, 4),
(47, NULL, 1, 0, 1, 'silicato de sódio (puro)', NULL, 7, 500, 4),
(48, NULL, 1, 0, 1, 'tartarato de sódio e potássio 4h2o ', NULL, 7, 500, 4),
(49, NULL, 1, 0, 1, 'tiossulfato de sódio ', NULL, 7, 1000, 4),
(50, NULL, 2, 0, 2, 'tiossulfato de sódio pentahidratado', NULL, 7, 1000, 4),
(51, NULL, 2, 0, 2, 'meta bissulfito de potássio ', NULL, 7, 500, 4),
(52, NULL, 1, 0, 1, 'acetato de potássio ', NULL, 7, 500, 4),
(53, NULL, 1, 0, 1, 'brometo de potássico', NULL, 7, 250, 4),
(54, NULL, 1, 0, 1, 'cloreto de potássio ', NULL, 7, 500, 4),
(55, NULL, 1, 0, 1, 'cloreto de potássio reagente analítico', NULL, 7, 1000, 4),
(56, NULL, 1, 0, 1, 'dicromato de potássio ', NULL, 7, 500, 4),
(57, NULL, 1, 0, 1, 'ferrocianeto de potássio trihidratado ', NULL, 7, 500, 4),
(58, NULL, 1, 0, 1, 'fosfato de potássio dibásico ', NULL, 7, 500, 4),
(59, NULL, 1, 0, 1, 'fosfato de potássio monobásico ', NULL, 7, 500, 4),
(60, NULL, 2, 0, 2, 'iodeto de potássio ', NULL, 7, 250, 4),
(61, NULL, 2, 0, 2, 'permanganato de potássio ', NULL, 7, 500, 4),
(62, NULL, 1, 0, 1, 'cloreto de manganésio ', NULL, 7, 500, 4),
(63, NULL, 1, 0, 1, 'carbonato de cálcio ', NULL, 7, 500, 4),
(64, NULL, 1, 0, 1, 'cloreto de cálcio dihidratado ', NULL, 7, 500, 4),
(65, NULL, 1, 0, 1, 'cloreto de bário dihidratado', NULL, 7, 500, 4),
(66, NULL, 1, 0, 1, 'sulfato de alumínio', NULL, 9, 500, 4),
(67, NULL, 1, 0, 1, 'cloreto de estanho ii dihidratado ', NULL, 10, 100, 4),
(68, NULL, 2, 0, 2, 'cloreto de ferro iii (ico) hexahidratado', NULL, 10, 500, 4),
(69, NULL, 1, 0, 1, 'cloreto de manganês ii (oso) tetrahidratado ', NULL, 10, 500, 4),
(70, NULL, 1, 0, 1, 'cloreto de níquel 6h2o ', NULL, 10, 500, 4),
(71, NULL, 1, 0, 1, 'cloreto de zinco', NULL, 10, 250, 4),
(72, NULL, 1, 0, 1, 'nitrato de chumbo ii ', NULL, 10, 500, 4),
(73, NULL, 1, 0, 1, 'nitrato de cobalto (hexahidratado)', NULL, 10, 250, 4),
(74, NULL, 1, 0, 1, 'nitrato de níquel', NULL, 10, 1000, 4),
(75, NULL, 1, 0, 1, 'sulfato de cobre ii', NULL, 10, 500, 4),
(76, NULL, 1, 0, 1, 'sulfato de ferro ii e amônio 6h2o ', NULL, 10, 500, 4),
(77, NULL, 1, 0, 1, 'sulfato de ferro iii (ico) 1h2o ', NULL, 10, 500, 4),
(78, NULL, 1, 0, 1, 'sulfato de manganês ii (ico) ', NULL, 10, 500, 4),
(79, NULL, 1, 0, 1, 'sulfato de zinco', NULL, 10, 500, 4),
(80, NULL, 0, 0, 0, 'acetona ', NULL, 10, 1000, 1),
(81, NULL, 2, 0, 2, 'álcool butílico normal ', NULL, 10, 1000, 1),
(82, NULL, 3, 0, 3, 'álcool etílico absoluto', NULL, 10, 1000, 1),
(83, NULL, 1, 0, 1, 'álcool etílico, 95 %', NULL, 10, 1000, 1),
(84, NULL, 1, 0, 1, 'álcool isopropílico', NULL, 10, 1000, 1),
(85, NULL, 1, 0, 1, 'benzeno ', NULL, 10, 1000, 1),
(86, NULL, 1, 0, 1, 'clorofórmio ', NULL, 10, 1000, 1),
(87, NULL, 1, 0, 1, 'd(+) glucose anidra (dextrose) ', NULL, 10, 500, 4),
(88, NULL, 1, 0, 1, 'difenilamina ', NULL, 10, 100, 4),
(89, NULL, 1, 0, 1, 'formaldeido 37% ', NULL, 10, 1000, 1),
(90, NULL, 1, 0, 1, 'glicerina ', NULL, 10, 1000, 1),
(91, NULL, 1, 0, 1, 'naftaleno puríssimo', NULL, 10, 500, 4),
(92, NULL, 1, 0, 1, 'n-hexano 95 % ', NULL, 10, 1000, 1),
(93, NULL, 1, 0, 1, 'sacarose ', NULL, 10, 500, 4),
(94, NULL, 1, 0, 1, 'ureia ', NULL, 10, 500, 4),
(95, NULL, 1, 0, 1, 'xileno (xilol) ', NULL, 10, 1000, 1),
(96, NULL, 1, 0, 1, '2,2 bipiridina ', NULL, 10, 5, 4),
(97, NULL, 2, 0, 2, 'iodo metálico ', NULL, 12, 100, 4),
(98, NULL, 2, 0, 2, 'magnésio em fita puríssimo (larg.: 2 a 4 mm; ', NULL, 12, 25, 4),
(104, 'gdgfn', 1, 1, 2, 'teste', 'nfgfn', 1, 2, 2);

--
-- Gatilhos `reagente`
--
DROP TRIGGER IF EXISTS `tr_reagente_insert`;
DELIMITER //
CREATE TRIGGER `tr_reagente_insert` BEFORE INSERT ON `reagente`
 FOR EACH ROW BEGIN

SET @aberto_new = new.qtd_estoque_Reagente_aberto;
SET @lacrado_new = new.qtd_estoque_Reagente_lacrado;

if @aberto_new < 0 || @lacrado_new < 0 THEN
	SIGNAL sqlstate '45001' set message_text = "Não é possível adicionar um valor negativo!";
end if;

if new.qtd_estoque_Reagente_aberto is NULL then
	set new.qtd_estoque_Reagente_aberto = 0;
end if;

set new.qtd_estoque_Reagente_total = new.qtd_estoque_Reagente_aberto + new.qtd_estoque_Reagente_lacrado;

END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `tr_reagente_update`;
DELIMITER //
CREATE TRIGGER `tr_reagente_update` BEFORE UPDATE ON `reagente`
 FOR EACH ROW BEGIN
SET @aberto_new = new.qtd_estoque_Reagente_aberto;
SET @aberto_old = old.qtd_estoque_Reagente_aberto;
SET @lacrado_new = new.qtd_estoque_Reagente_lacrado;
SET @lacrado_old = old.qtd_estoque_Reagente_lacrado;

if @aberto_new < 0 || @lacrado_new < 0 THEN
	SIGNAL sqlstate '45001' set message_text = "Não é possível adicionar um valor negativo!";
end if;

set new.qtd_estoque_Reagente_total = new.qtd_estoque_Reagente_aberto + new.qtd_estoque_Reagente_lacrado;

END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tamanho`
--

CREATE TABLE IF NOT EXISTS `tamanho` (
  `idTamanho` int(11) NOT NULL,
  `nomeTamanho` varchar(45) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `tamanho`
--

INSERT INTO `tamanho` (`idTamanho`, `nomeTamanho`) VALUES
(1, 'P'),
(2, 'M'),
(3, 'G'),
(4, 'Pequeno'),
(5, 'Grande');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tipooperacao`
--

CREATE TABLE IF NOT EXISTS `tipooperacao` (
  `idTipoOperacao` int(11) NOT NULL,
  `nomeOperacao` varchar(30) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `tipooperacao`
--

INSERT INTO `tipooperacao` (`idTipoOperacao`, `nomeOperacao`) VALUES
(1, 'Retirada'),
(2, 'Devolução'),
(3, 'Devolução com defeito'),
(4, 'Adição'),
(5, 'Remoção'),
(6, 'Edição');

-- --------------------------------------------------------

--
-- Estrutura da tabela `unidade`
--

CREATE TABLE IF NOT EXISTS `unidade` (
  `idUnidade` int(11) NOT NULL,
  `nomeUnidade` varchar(45) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `unidade`
--

INSERT INTO `unidade` (`idUnidade`, `nomeUnidade`) VALUES
(1, 'mL'),
(2, 'L'),
(3, 'mm'),
(4, 'g'),
(5, 'kg');

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE IF NOT EXISTS `usuario` (
  `idUsuario` int(11) NOT NULL,
  `nomeUsuario` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `Nivel_idNivel` int(11) NOT NULL,
  `senhaUsuario` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `emailUsuario` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `loginUsuario` varchar(25) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `nomeUsuario`, `Nivel_idNivel`, `senhaUsuario`, `emailUsuario`, `loginUsuario`) VALUES
(1, 'João Pedro Ribeiro', 0, 'senha123', 'jp3dr0436@gmail.com', 'jp3dr0'),
(2, 'Rogério', 2, 'amoquimica', NULL, 'RogerioIFRN'),
(3, 'Fabiana Oliveira', 3, 'pdcgld', NULL, 'fabi123'),
(4, 'Leo', 1, 'qwerty', 'leozin@gmail.com', 'leozinho123'),
(5, 'Xand', 1, 'avioes', 'xandinho@gmail.com', 'xandaviao');

-- --------------------------------------------------------

--
-- Estrutura da tabela `vidraria`
--

CREATE TABLE IF NOT EXISTS `vidraria` (
  `idVidraria` int(11) NOT NULL,
  `imgVidraria` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qtd_estoque_Vidraria` int(11) NOT NULL,
  `nomeVidraria` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `comentarioVidraria` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `valorCapacidadeVidraria` int(11) DEFAULT NULL,
  `tamanhoCapacidadeVidraria` int(11) DEFAULT NULL,
  `UnidadeVidraria` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `vidraria`
--

INSERT INTO `vidraria` (`idVidraria`, `imgVidraria`, `qtd_estoque_Vidraria`, `nomeVidraria`, `comentarioVidraria`, `valorCapacidadeVidraria`, `tamanhoCapacidadeVidraria`, `UnidadeVidraria`) VALUES
(12, '', 3, 'becker de plástico new', '', 4000, 0, 1),
(13, NULL, 3, 'becker de plástico', NULL, 2000, NULL, 1),
(14, NULL, 18, 'erlenmeyer de vidro', NULL, 500, NULL, 1),
(15, NULL, 56, 'erlenmeyer de vidro', NULL, 250, NULL, 1),
(16, NULL, 43, 'erlenmeyer de vidro', NULL, 125, NULL, 1),
(17, '', 4, 'capacete de proteção gshsu', '', 0, 2, 0),
(18, NULL, 3, 'condensador de bola', NULL, NULL, NULL, NULL),
(19, NULL, 2, 'desecador', NULL, NULL, NULL, NULL),
(20, NULL, 7, 'anel de ferro', NULL, NULL, 1, NULL),
(21, NULL, 192, 'tubo de ensaio', NULL, NULL, NULL, NULL),
(22, NULL, 16, 'tubo para digestão de amostras', NULL, NULL, NULL, NULL),
(23, NULL, 12, 'proveta de vidro', NULL, 1000, NULL, 1),
(24, NULL, 5, 'proveta de vidro', NULL, 500, NULL, 1),
(25, NULL, 9, 'proveta de vidro', NULL, 100, NULL, 1),
(26, NULL, 5, 'proveta de vidro', NULL, 50, NULL, 1),
(27, NULL, 8, 'proveta de vidro', NULL, 25, NULL, 1),
(28, NULL, 10, 'proveta de vidro', NULL, 10, NULL, 1),
(29, NULL, 14, 'óculos de proteção', NULL, NULL, NULL, NULL),
(30, NULL, 2, 'funil de separação', NULL, 500, NULL, 1),
(31, NULL, 3, 'funil de separação', NULL, 250, NULL, 1),
(32, NULL, 3, 'funil de separação', NULL, 125, NULL, 1),
(33, NULL, 9, 'pisseta volumétrica ', NULL, 500, NULL, 1),
(34, NULL, 3, 'pisseta volumétrica ', NULL, 250, NULL, 1),
(35, NULL, 4, 'frasco lava olhos de emergência', NULL, 500, NULL, 1),
(36, NULL, 6, 'garra dupla', NULL, NULL, NULL, NULL),
(37, NULL, 3, 'pinça metálica para cadinho', NULL, NULL, NULL, NULL),
(38, NULL, 5, 'pinça metálica anatomica para disecação', NULL, NULL, NULL, NULL),
(39, NULL, 6, 'lamparina a álcool', NULL, NULL, NULL, NULL),
(40, NULL, 12, 'cadinho de porcelana', NULL, 30, NULL, 1),
(41, NULL, 11, 'cadinho de porcelana', NULL, 25, NULL, 1),
(42, NULL, 30, 'pipeta volumétrica', NULL, 100, NULL, 1),
(43, NULL, 12, 'pipeta volumétrica', NULL, 50, NULL, 1),
(44, NULL, 4, 'pipeta volumétrica', NULL, 25, NULL, 1),
(45, NULL, 11, 'pipeta volumétrica', NULL, 10, NULL, 1),
(46, NULL, 7, 'pipeta volumétrica', NULL, 5, NULL, 1),
(47, NULL, 23, 'pipeta graduada', NULL, 2, NULL, 1),
(48, NULL, 15, 'tela de amianto ', NULL, NULL, NULL, NULL),
(49, NULL, 5, 'pêra de sucção', NULL, NULL, NULL, NULL),
(50, NULL, 6, 'pinça de madeira', NULL, NULL, NULL, NULL),
(51, NULL, 3, 'espátula de metal', NULL, NULL, 1, NULL),
(52, NULL, 12, 'espátula de metal', NULL, NULL, 2, NULL),
(53, NULL, 4, 'espátula de metal', NULL, 0, NULL, 4),
(54, NULL, 3, 'espátula metálica com cabo de madeira', NULL, NULL, NULL, NULL),
(55, NULL, 11, 'bastão de vidro', NULL, NULL, NULL, NULL),
(56, NULL, 7, 'bureta', NULL, 50, NULL, 1),
(57, NULL, 8, 'bureta', NULL, 25, NULL, 1),
(58, NULL, 15, 'bureta', NULL, 10, NULL, 1),
(59, NULL, 6, 'picnômetro sem termômetro ', NULL, 100, NULL, 1),
(60, NULL, 13, 'picnômetro sem termômetro ', NULL, 50, NULL, 1),
(61, NULL, 15, 'picnômetro sem termômetro ', NULL, 25, NULL, 1),
(62, '', 4, 'picnômetro sem termômetruhjko ', '', 10, 0, 1),
(63, NULL, 6, 'picnômetro sem termômetro ', NULL, 5, NULL, 1),
(64, NULL, 4, 'pesa filtro ', NULL, 50, NULL, 1),
(65, NULL, 6, 'pesa filtro ', NULL, 15, NULL, 1),
(66, NULL, 3, 'pesa filtro ', NULL, 10, NULL, 1),
(67, NULL, 6, 'capsula de porcelana', NULL, NULL, 1, NULL),
(68, NULL, 10, 'capsula de porcelana', NULL, NULL, 2, NULL),
(69, NULL, 5, 'capsula de porcelana', NULL, 0, NULL, 4),
(70, NULL, 3, 'grau com pistilo', NULL, 0, NULL, 4),
(71, NULL, 2, 'grau com pistilo', NULL, NULL, 2, NULL),
(72, NULL, 13, 'balão volumétrico', NULL, 1000, NULL, 1),
(73, NULL, 13, 'balão volumétrico', NULL, 500, NULL, 1),
(74, NULL, 47, 'balão volumétrico', NULL, 250, NULL, 1),
(75, NULL, 23, 'balão volumétrico', NULL, 100, NULL, 1),
(76, NULL, 7, 'frasco de plástico', NULL, NULL, NULL, NULL),
(77, NULL, 4, 'estante para tubos de ensaio ', NULL, 0, NULL, 3),
(78, NULL, 0, 'funil analitico de vidro', NULL, 65, NULL, 3),
(79, NULL, 0, 'funil analitico de vidro', NULL, 0, NULL, 4),
(80, NULL, 4, 'bandeja de plástico', NULL, NULL, NULL, NULL),
(81, NULL, 6, 'haste universal', NULL, NULL, NULL, NULL),
(82, NULL, 14, 'frascos  para amostragem de vidro', NULL, NULL, NULL, NULL),
(83, NULL, 2, 'frasco de vidro ambar para soluções', NULL, 1000, NULL, 1),
(84, NULL, 5, 'frasco de vidro ambar para soluções', NULL, 500, NULL, 1),
(85, NULL, 1, 'frasco de vidro ambar para soluções', NULL, 250, NULL, 1),
(86, NULL, 5, 'cones de plástico', NULL, NULL, NULL, NULL),
(87, NULL, 1, 'becquer de vidro ', NULL, 2000, NULL, 1),
(88, NULL, 18, 'becquer de vidro ', NULL, 1000, NULL, 1),
(89, NULL, 32, 'becquer de vidro ', NULL, 600, NULL, 1),
(90, NULL, 3, 'becquer de vidro ', NULL, 500, NULL, 1),
(91, NULL, 43, 'becquer de vidro ', NULL, 250, NULL, 1),
(92, NULL, 62, 'becquer de vidro ', NULL, 150, NULL, 1),
(93, NULL, 15, 'becquer de vidro ', NULL, 100, NULL, 1),
(94, NULL, 7, 'erlenmeyer de vidro', NULL, 500, NULL, 1),
(95, NULL, 13, 'erlenmeyer de vidro', NULL, 250, NULL, 1),
(96, NULL, 82, 'balão volumétrico de vidro', NULL, 100, NULL, 1),
(97, NULL, 16, 'balão volumétrico de vidro', NULL, 250, NULL, 1),
(98, NULL, 7, 'balão volumétrico de vidro', NULL, 500, NULL, 1),
(99, NULL, 6, 'balão volumétrico de plástico', NULL, 1000, NULL, 1),
(100, NULL, 5, 'balão volumétrico de plástico', NULL, 250, NULL, 1),
(101, NULL, 20, 'balão volumétrico de plástico', NULL, 100, NULL, 1),
(102, NULL, 5, 'funil analítico de vidro', NULL, 0, NULL, 4),
(103, NULL, 14, 'frasco ambar de vidro para soluções ', NULL, 1000, NULL, 1),
(104, NULL, 9, 'frasco ambar de vidro para soluções ', NULL, 250, NULL, 1),
(105, NULL, 3, 'proveta de vidro', NULL, 500, NULL, 1),
(106, NULL, 7, 'proveta de vidro', NULL, 100, NULL, 1),
(107, NULL, 6, 'proveta de vidro', NULL, 50, NULL, 1),
(108, NULL, 2, 'proveta de vidro', NULL, 25, NULL, 1),
(109, NULL, 4, 'proveta de vidro', NULL, 10, NULL, 1),
(110, NULL, 27, 'frasco de vidro para amostra', NULL, NULL, NULL, NULL),
(111, NULL, 9, 'frasco lava olho de emergencia', NULL, NULL, NULL, NULL),
(112, NULL, 2, 'cones de plástico', NULL, NULL, NULL, NULL),
(113, NULL, 14, 'pisseta ou frasco lavador', NULL, 500, NULL, 1),
(114, NULL, 13, 'pisseta ou frasco lavador', NULL, 250, NULL, 1),
(115, NULL, 33, 'tela de amianto', NULL, NULL, NULL, NULL),
(116, NULL, 600, 'tubos de ensaio de vidro', NULL, NULL, NULL, NULL),
(117, NULL, 5, 'pipetador pim pumb ', NULL, 2, NULL, 1),
(118, NULL, 4, 'papel de filtro ', NULL, NULL, 1, NULL),
(119, NULL, 2, 'papel de filtro ', NULL, 0, NULL, 4),
(120, NULL, 8, 'bureta de vidro ', NULL, 25, NULL, 1),
(121, NULL, 1, '50ml', NULL, 50, NULL, 1),
(122, NULL, 3, 'pipeta vomumétrica de vidro', NULL, 25, NULL, 1),
(123, NULL, 9, 'detergente neutro', NULL, 5, NULL, 2),
(124, NULL, 5, 'detergente alcalino', NULL, 5, NULL, 2),
(125, NULL, 5, 'teste', NULL, 3, NULL, 2),
(0, NULL, 5, 'teste', NULL, 500, NULL, 2);

-- --------------------------------------------------------

--
-- Estrutura da tabela `view_reagente_min`
--

CREATE TABLE IF NOT EXISTS `view_reagente_min` (
  `tipoItem` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id` int(11) DEFAULT NULL,
  `img` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qtd` int(11) DEFAULT NULL,
  `nome` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `classificacaoReagente` int(11) DEFAULT NULL,
  `tamanhoVidraria` binary(0) DEFAULT NULL,
  `valor` int(11) DEFAULT NULL,
  `unidade` int(11) DEFAULT NULL,
  `comentario` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `view_vidraria_min`
--

CREATE TABLE IF NOT EXISTS `view_vidraria_min` (
  `tipoItem` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `id` int(11) DEFAULT NULL,
  `img` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qtd` int(11) DEFAULT NULL,
  `nome` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `classificacaoReagente` binary(0) DEFAULT NULL,
  `tamanhoVidraria` int(11) DEFAULT NULL,
  `valor` int(11) DEFAULT NULL,
  `unidade` int(11) DEFAULT NULL,
  `comentario` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
