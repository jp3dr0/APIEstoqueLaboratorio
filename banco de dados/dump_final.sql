-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 10-Dez-2018 às 15:50
-- Versão do servidor: 10.1.28-MariaDB
-- PHP Version: 7.1.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `estoque_lab`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `set_operacao_pendente` (IN `pendente_opcao` CHAR(1), IN `item` INT, IN `opcao` CHAR(1))  MODIFIES SQL DATA
IF opcao <=> 'R' THEN
	UPDATE operacao SET pendente = pendente_opcao WHERE Reagente_idReagente = item limit 1;
ELSEIF opcao <=> 'V' THEN
	UPDATE operacao SET pendente = pendente_opcao WHERE Vidraria_idVidraria = item limit 1;
END IF$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `set_operacao_qtd` (IN `qtd_escolha` INT, IN `item` INT, IN `opcao` CHAR(1))  MODIFIES SQL DATA
IF opcao <=> 'R' THEN
	UPDATE `operacao` SET qtd = qtd_escolha WHERE Reagente_idReagente = item limit 1;
ELSEIF opcao <=> 'V' THEN
	UPDATE `operacao` SET qtd = qtd_escolha WHERE Vidraria_idVidraria = item limit 1;
END IF$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `classificacao`
--

CREATE TABLE `classificacao` (
  `id` int(11) NOT NULL,
  `nome` varchar(45) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `classificacao`
--

INSERT INTO `classificacao` (`id`, `nome`) VALUES
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

CREATE TABLE `nivel` (
  `id` int(11) NOT NULL,
  `nome` varchar(30) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `nivel`
--

INSERT INTO `nivel` (`id`, `nome`) VALUES
(0, 'Aluno'),
(1, 'Professor'),
(2, 'Tecnico'),
(3, 'Administrador');

-- --------------------------------------------------------

--
-- Estrutura da tabela `operacao`
--

CREATE TABLE `operacao` (
  `id` int(11) NOT NULL,
  `reagente` int(11) DEFAULT NULL,
  `vidraria` int(11) DEFAULT NULL,
  `data` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario` int(11) NOT NULL,
  `tipoOperacao` int(11) NOT NULL,
  `qtd` int(11) NOT NULL,
  `img` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comentario` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pendente` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `operacao`
--

INSERT INTO `operacao` (`id`, `reagente`, `vidraria`, `data`, `usuario`, `tipoOperacao`, `qtd`, `img`, `comentario`, `pendente`) VALUES
(14, NULL, 14, '2017-12-11 13:54:49', 1, 1, 10, NULL, NULL, 0),
(15, NULL, 14, '0000-00-00 00:00:00', 1, 1, 10, NULL, NULL, 0),
(16, NULL, 14, '0000-00-00 00:00:00', 1, 1, 10, NULL, NULL, 0),
(19, 126, NULL, '0000-00-00 00:00:00', 2, 4, 0, NULL, NULL, 0),
(20, 127, NULL, '0000-00-00 00:00:00', 2, 4, 0, NULL, NULL, 0),
(21, 128, NULL, '0000-00-00 00:00:00', 2, 4, 0, NULL, NULL, 0),
(22, 124, NULL, '0000-00-00 00:00:00', 2, 5, 0, NULL, NULL, 0),
(23, 123, NULL, '0000-00-00 00:00:00', 2, 5, 0, NULL, NULL, 0),
(24, 122, NULL, '0000-00-00 00:00:00', 2, 6, 0, NULL, NULL, 0),
(25, 122, NULL, '0000-00-00 00:00:00', 2, 1, 0, NULL, NULL, 1),
(26, 122, NULL, '2018-12-09 21:36:34', 2, 2, 2, NULL, NULL, 0),
(27, 122, NULL, '2018-12-09 21:39:15', 2, 2, 2, NULL, NULL, 0),
(28, 122, NULL, '2018-12-09 21:40:40', 2, 2, 2, NULL, NULL, 0),
(29, 122, NULL, '2018-12-09 21:41:35', 2, 2, 2, NULL, NULL, 0),
(30, 122, NULL, '2018-12-09 21:42:23', 2, 2, 2, NULL, NULL, 0),
(31, 122, NULL, '2018-12-09 21:42:45', 2, 2, 2, NULL, NULL, 0),
(32, 122, NULL, '2018-12-09 21:43:35', 2, 2, 2, NULL, NULL, 0),
(33, 127, NULL, '2018-12-09 21:44:47', 2, 1, 0, NULL, NULL, 1),
(34, 127, NULL, '2018-12-09 21:45:01', 2, 2, 2, NULL, NULL, 0),
(35, 127, NULL, '2018-12-09 21:45:49', 2, 1, 0, NULL, NULL, 1),
(36, 126, NULL, '2018-12-09 21:46:38', 2, 1, 2, NULL, NULL, 1),
(37, 126, NULL, '2018-12-09 21:46:54', 2, 2, 2, NULL, NULL, 0),
(38, 126, NULL, '2018-12-09 21:48:17', 2, 2, 2, NULL, NULL, 0),
(39, 126, NULL, '2018-12-09 21:48:17', 2, 2, 2, NULL, NULL, 0),
(40, 126, NULL, '2018-12-09 21:49:03', 2, 2, 2, NULL, NULL, 0),
(41, 126, NULL, '2018-12-09 21:49:14', 2, 2, 2, NULL, NULL, 0),
(42, 126, NULL, '2018-12-09 21:49:38', 2, 2, 2, NULL, NULL, 0),
(43, 126, NULL, '2018-12-09 21:49:56', 2, 2, 2, NULL, NULL, 0),
(44, 126, NULL, '2018-12-09 21:50:10', 2, 2, 2, NULL, NULL, 0),
(45, 126, NULL, '2018-12-09 21:50:30', 2, 2, 2, NULL, NULL, 0),
(46, 126, NULL, '2018-12-09 21:51:12', 2, 2, 2, NULL, NULL, 0),
(47, 126, NULL, '2018-12-09 21:51:23', 2, 2, 2, NULL, NULL, 0),
(48, 126, NULL, '2018-12-09 21:51:53', 2, 2, 2, NULL, NULL, 0),
(49, 126, NULL, '2018-12-09 21:53:40', 2, 2, 2, NULL, NULL, 0),
(50, 126, NULL, '2018-12-09 21:54:03', 2, 2, 2, NULL, NULL, 0),
(51, 126, NULL, '2018-12-09 21:54:21', 2, 2, 2, NULL, NULL, 0),
(52, 126, NULL, '2018-12-09 21:54:35', 2, 2, 2, NULL, NULL, 0),
(54, 125, NULL, '2018-12-09 21:55:15', 2, 1, 2, NULL, NULL, 0),
(55, 125, NULL, '2018-12-09 21:55:23', 2, 2, 2, NULL, NULL, 0),
(57, 125, NULL, '2018-12-09 21:56:10', 2, 2, 2, NULL, NULL, 0),
(59, 125, NULL, '2018-12-09 21:57:21', 2, 2, 2, NULL, NULL, 0),
(61, 125, NULL, '2018-12-09 21:58:03', 2, 2, 2, NULL, NULL, 0),
(63, 125, NULL, '2018-12-09 21:58:20', 2, 2, 2, NULL, NULL, 0),
(65, 125, NULL, '2018-12-09 21:58:49', 2, 2, 2, NULL, NULL, 0),
(67, 125, NULL, '2018-12-09 21:59:16', 2, 2, 2, NULL, NULL, 0),
(69, 125, NULL, '2018-12-09 21:59:42', 2, 2, 2, NULL, NULL, 0),
(71, 125, NULL, '2018-12-09 22:00:06', 2, 2, 2, NULL, NULL, 0),
(73, 125, NULL, '2018-12-09 22:00:26', 2, 2, 2, NULL, NULL, 0),
(75, 125, NULL, '2018-12-09 22:01:43', 2, 2, 2, NULL, NULL, 0),
(77, 125, NULL, '2018-12-09 22:02:29', 2, 2, 2, NULL, NULL, 0),
(78, 129, NULL, '2018-12-09 22:05:09', 2, 4, 0, NULL, NULL, 0),
(79, 129, NULL, '2018-12-09 22:05:35', 2, 1, 2, NULL, NULL, 0),
(80, 129, NULL, '2018-12-09 22:06:09', 2, 2, 2, NULL, NULL, 0),
(81, 129, NULL, '2018-12-09 22:07:09', 2, 1, 2, NULL, NULL, 0),
(82, 129, NULL, '2018-12-09 22:07:33', 2, 3, 2, NULL, NULL, 0),
(83, NULL, 125, '2018-12-09 23:07:58', 2, 1, 2, NULL, NULL, 0),
(84, NULL, 125, '2018-12-09 23:08:13', 2, 2, 2, NULL, NULL, 0),
(85, NULL, 124, '2018-12-10 00:23:39', 1, 1, 2, NULL, NULL, 1),
(86, NULL, 124, '2018-12-10 00:24:34', 1, 2, 2, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `operacoes_permitidas_por_nivel`
--

CREATE TABLE `operacoes_permitidas_por_nivel` (
  `nivel_id` int(11) NOT NULL,
  `tipooperacao_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `operacoes_permitidas_por_nivel`
--

INSERT INTO `operacoes_permitidas_por_nivel` (`nivel_id`, `tipooperacao_id`) VALUES
(0, 1),
(0, 2),
(0, 3),
(1, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `reagente`
--

CREATE TABLE `reagente` (
  `id` int(11) NOT NULL,
  `img` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qtdEstoqueLacrado` int(11) DEFAULT NULL,
  `qtdEstoqueAberto` int(11) DEFAULT '0',
  `qtdEstoqueTotal` int(11) DEFAULT NULL,
  `nome` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `comentario` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `classificacao` int(11) NOT NULL,
  `valor` int(11) DEFAULT NULL,
  `unidade` int(11) DEFAULT NULL,
  `excluido` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `reagente`
--

INSERT INTO `reagente` (`id`, `img`, `qtdEstoqueLacrado`, `qtdEstoqueAberto`, `qtdEstoqueTotal`, `nome`, `comentario`, `classificacao`, `valor`, `unidade`, `excluido`) VALUES
(3, NULL, 1, 0, 1, 'ácido bórico', NULL, 1, 500, 4, 0),
(4, NULL, 2, 0, 2, 'ácido clorídrico ', NULL, 1, 1000, 1, 0),
(5, NULL, 1, 0, 1, 'ácido fosfórico 85 %', NULL, 1, 1000, 1, 0),
(6, NULL, 5, 0, 5, 'ácido sulfúrico', NULL, 1, 1000, 1, 0),
(7, NULL, 1, 0, 1, 'ácido tricloroacético', NULL, 1, 500, 4, 0),
(8, NULL, 1, 0, 1, 'ácido acético glacial', NULL, 1, 1000, 1, 0),
(9, NULL, 1, 0, 1, 'ácido ascórbico', NULL, 1, 500, 4, 0),
(10, NULL, 1, 0, 1, 'ácido cítrico anidro', NULL, 1, 500, 4, 0),
(11, NULL, 1, 0, 1, 'fenol cristal (ácido fénico)', NULL, 1, 500, 4, 0),
(12, NULL, 1, 0, 1, 'ácido oxálico', NULL, 1, 500, 4, 0),
(13, NULL, 1, 0, 1, 'ácido salicílico', NULL, 1, 250, 4, 0),
(14, NULL, 1, 0, 1, 'carvão ativo em pó purificado', NULL, 2, 500, 4, 0),
(15, NULL, 1, 0, 1, 'silica gel azul 4-8mm', NULL, 2, 1000, 4, 0),
(16, NULL, 1, 0, 1, 'silicagel azul ', NULL, 2, 500, 4, 0),
(17, NULL, 3, 0, 3, 'hidróxido de amônio ', NULL, 3, 1000, 1, 0),
(18, NULL, 1, 0, 1, 'hidróxido de cácio', NULL, 3, 500, 4, 0),
(19, NULL, 1, 0, 1, 'hidróxido de potássio 85 % lentilhas', NULL, 3, 500, 4, 0),
(20, NULL, 1, 0, 1, 'hidróxido de sódio micropérolas ', NULL, 3, 1000, 4, 0),
(21, NULL, 1, 0, 1, 'alaranjado de metila ', NULL, 4, 25, 4, 0),
(22, NULL, 1, 0, 1, 'amido solúvel ', NULL, 4, 500, 4, 0),
(23, NULL, 1, 0, 1, 'azul de bromotimol', NULL, 4, 5, 4, 0),
(24, NULL, 2, 0, 2, 'azul de metileno ', NULL, 4, 50, 4, 0),
(25, NULL, 3, 0, 3, 'edta (sal dipotássio)', NULL, 4, 50, 4, 0),
(26, NULL, 1, 0, 1, 'fenoftaleina ', NULL, 4, 25, 4, 0),
(27, NULL, 1, 0, 1, 'murexida', NULL, 4, 25, 4, 0),
(28, NULL, 1, 0, 1, 'preto de eriocromo t : ', NULL, 4, 25, 4, 0),
(29, NULL, 1, 0, 1, 'purpura de bromocresol', NULL, 4, 25, 4, 0),
(30, NULL, 1, 0, 1, 'óxido de mercúrio ii (amarelo)', NULL, 5, 25, 4, 0),
(31, NULL, 1, 0, 1, 'peróxido de hidrogênio ', NULL, 5, 1000, 1, 0),
(32, NULL, 0, 0, 0, 'dicromato de amônio ', NULL, 6, 500, 4, 0),
(33, NULL, 2, 0, 2, 'cloreto de amônio ', NULL, 6, 500, 4, 0),
(34, NULL, 1, 0, 1, 'molibdato de amônio tetrahidratado ', NULL, 6, 100, 4, 0),
(35, NULL, 1, 0, 1, 'azida sódica ', NULL, 7, 50, 4, 0),
(36, NULL, 1, 0, 1, 'bicarbonato de sódio comecial', NULL, 7, 500, 4, 0),
(37, NULL, 2, 0, 2, 'bicarbonato de sódio ', NULL, 7, 500, 4, 0),
(38, NULL, 1, 0, 1, 'bissulfito de sódio ', NULL, 7, 500, 4, 0),
(39, NULL, 1, 0, 1, 'citrato de sódio tribásico dihidratado ', NULL, 7, 500, 4, 0),
(40, NULL, 3, 0, 3, 'cloreto de sódio cristalizado', NULL, 7, 500, 4, 0),
(41, NULL, 1, 0, 1, 'acetato de  sódio anidro ', NULL, 7, 250, 4, 0),
(42, NULL, 1, 0, 1, 'acetato de sódio trihidratado ', NULL, 7, 500, 4, 0),
(43, NULL, 1, 0, 1, 'meta bissulfito de sódio', NULL, 7, 500, 4, 0),
(44, NULL, 2, 0, 2, 'molibdato de sódio dihidratado ', NULL, 7, 100, 4, 0),
(45, NULL, 1, 0, 1, 'nitrato de sódio ', NULL, 7, 500, 4, 0),
(46, NULL, 1, 0, 1, 'nitrito de sódio ', NULL, 7, 500, 4, 0),
(47, NULL, 1, 0, 1, 'silicato de sódio (puro)', NULL, 7, 500, 4, 0),
(48, NULL, 1, 0, 1, 'tartarato de sódio e potássio 4h2o ', NULL, 7, 500, 4, 0),
(49, NULL, 1, 0, 1, 'tiossulfato de sódio ', NULL, 7, 1000, 4, 0),
(50, NULL, 2, 0, 2, 'tiossulfato de sódio pentahidratado', NULL, 7, 1000, 4, 0),
(51, NULL, 2, 0, 2, 'meta bissulfito de potássio ', NULL, 7, 500, 4, 0),
(52, NULL, 1, 0, 1, 'acetato de potássio ', NULL, 7, 500, 4, 0),
(53, NULL, 1, 0, 1, 'brometo de potássico', NULL, 7, 250, 4, 0),
(54, NULL, 1, 0, 1, 'cloreto de potássio ', NULL, 7, 500, 4, 0),
(55, NULL, 1, 0, 1, 'cloreto de potássio reagente analítico', NULL, 7, 1000, 4, 0),
(56, NULL, 1, 0, 1, 'dicromato de potássio ', NULL, 7, 500, 4, 0),
(57, NULL, 1, 0, 1, 'ferrocianeto de potássio trihidratado ', NULL, 7, 500, 4, 0),
(58, NULL, 1, 0, 1, 'fosfato de potássio dibásico ', NULL, 7, 500, 4, 0),
(59, NULL, 1, 0, 1, 'fosfato de potássio monobásico ', NULL, 7, 500, 4, 0),
(60, NULL, 2, 0, 2, 'iodeto de potássio ', NULL, 7, 250, 4, 0),
(61, NULL, 2, 0, 2, 'permanganato de potássio ', NULL, 7, 500, 4, 0),
(62, NULL, 1, 0, 1, 'cloreto de manganésio ', NULL, 7, 500, 4, 0),
(63, NULL, 1, 0, 1, 'carbonato de cálcio ', NULL, 7, 500, 4, 0),
(64, NULL, 1, 0, 1, 'cloreto de cálcio dihidratado ', NULL, 7, 500, 4, 0),
(65, NULL, 1, 0, 1, 'cloreto de bário dihidratado', NULL, 7, 500, 4, 0),
(66, NULL, 1, 0, 1, 'sulfato de alumínio', NULL, 9, 500, 4, 0),
(67, NULL, 1, 0, 1, 'cloreto de estanho ii dihidratado ', NULL, 10, 100, 4, 0),
(68, NULL, 2, 0, 2, 'cloreto de ferro iii (ico) hexahidratado', NULL, 10, 500, 4, 0),
(69, NULL, 1, 0, 1, 'cloreto de manganês ii (oso) tetrahidratado ', NULL, 10, 500, 4, 0),
(70, NULL, 1, 0, 1, 'cloreto de níquel 6h2o ', NULL, 10, 500, 4, 0),
(71, NULL, 1, 0, 1, 'cloreto de zinco', NULL, 10, 250, 4, 0),
(72, NULL, 1, 0, 1, 'nitrato de chumbo ii ', NULL, 10, 500, 4, 0),
(73, NULL, 1, 0, 1, 'nitrato de cobalto (hexahidratado)', NULL, 10, 250, 4, 0),
(74, NULL, 1, 0, 1, 'nitrato de níquel', NULL, 10, 1000, 4, 0),
(75, NULL, 1, 0, 1, 'sulfato de cobre ii', NULL, 10, 500, 4, 0),
(76, NULL, 1, 0, 1, 'sulfato de ferro ii e amônio 6h2o ', NULL, 10, 500, 4, 0),
(77, NULL, 1, 0, 1, 'sulfato de ferro iii (ico) 1h2o ', NULL, 10, 500, 4, 0),
(78, NULL, 1, 0, 1, 'sulfato de manganês ii (ico) ', NULL, 10, 500, 4, 0),
(79, NULL, 1, 0, 1, 'sulfato de zinco', NULL, 10, 500, 4, 0),
(80, NULL, 0, 0, 0, 'acetona ', NULL, 10, 1000, 1, 0),
(81, NULL, 2, 0, 2, 'álcool butílico normal ', NULL, 10, 1000, 1, 0),
(82, NULL, 3, 0, 3, 'álcool etílico absoluto', NULL, 10, 1000, 1, 0),
(83, NULL, 1, 0, 1, 'álcool etílico, 95 %', NULL, 10, 1000, 1, 0),
(84, NULL, 1, 0, 1, 'álcool isopropílico', NULL, 10, 1000, 1, 0),
(85, NULL, 1, 0, 1, 'benzeno ', NULL, 10, 1000, 1, 0),
(86, NULL, 1, 0, 1, 'clorofórmio ', NULL, 10, 1000, 1, 0),
(87, NULL, 1, 0, 1, 'd(+) glucose anidra (dextrose) ', NULL, 10, 500, 4, 0),
(88, NULL, 1, 0, 1, 'difenilamina ', NULL, 10, 100, 4, 0),
(89, NULL, 1, 0, 1, 'formaldeido 37% ', NULL, 10, 1000, 1, 0),
(90, NULL, 1, 0, 1, 'glicerina ', NULL, 10, 1000, 1, 0),
(91, NULL, 1, 0, 1, 'naftaleno puríssimo', NULL, 10, 500, 4, 0),
(92, NULL, 1, 0, 1, 'n-hexano 95 % ', NULL, 10, 1000, 1, 0),
(93, NULL, 1, 0, 1, 'sacarose ', NULL, 10, 500, 4, 0),
(94, NULL, 1, 0, 1, 'ureia ', NULL, 10, 500, 4, 0),
(95, NULL, 1, 0, 1, 'xileno (xilol) ', NULL, 10, 1000, 1, 0),
(96, NULL, 1, 0, 1, '2,2 bipiridina ', NULL, 10, 5, 4, 0),
(97, NULL, 2, 0, 2, 'iodo metálico ', NULL, 12, 100, 4, 0),
(98, NULL, 2, 5, 7, 'magnésio em fita puríssimo (larg.: 2 a 4 mm; ', NULL, 12, 25, 4, 0),
(116, NULL, 5, 2, 7, 'acido louco', NULL, 1, 25, 3, 0),
(117, 'img', 5, 5, 10, 'acido loukao', NULL, 1, 25, 3, 0),
(118, 'img', 5, 5, 10, 'acido loukao', NULL, 1, 25, 3, 0),
(119, 'img', 5, 5, 10, 'acido loukao', NULL, 1, 25, 3, 0),
(120, 'img', 5, 5, 10, 'acido loukao', NULL, 1, 25, 3, 0),
(121, 'img', 5, 5, 10, 'acido loukao', NULL, 1, 25, 3, 0),
(122, 'imga', 1, 14, 15, 'acido aoico', NULL, 1, 25, 3, 0),
(123, 'imga', 1, 0, 1, 'acido ao', NULL, 1, 25, 3, 0),
(124, 'imga', 1, 0, 1, 'acido ao', NULL, 1, 25, 3, 0),
(125, 'imga', 3, 24, 27, 'acido ao', NULL, 1, 25, 3, 0),
(126, 'imga', 3, 32, 35, 'acido ao', NULL, 1, 25, 3, 0),
(127, 'imga', 1, 2, 3, 'acido ao', NULL, 1, 25, 3, 0),
(128, 'imga', 4, 0, 4, 'acido aoico', NULL, 1, 25, 3, 1),
(129, 'img', 4, 2, 6, 'acido loukao', NULL, 1, 25, 3, 0);

--
-- Acionadores `reagente`
--
DELIMITER $$
CREATE TRIGGER `tr_reagente_insert` BEFORE INSERT ON `reagente` FOR EACH ROW BEGIN

SET @aberto_new = new.qtdEstoqueAberto;
SET @lacrado_new = new.qtdEstoqueLacrado;
SET @total_new = new.qtdEstoqueTotal;

if @aberto_new < 0 || @lacrado_new < 0 THEN
	SIGNAL sqlstate '45001' set message_text = "Não é possível adicionar um valor negativo!";
end if;

if @aberto_new is NULL then
	set new.qtdEstoqueAberto = 0;
end if;

if @total_new is NULL || @total_new <= 0 then
	set new.qtdEstoqueTotal = @aberto_new + @lacrado_new;
end if;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tr_reagente_update` BEFORE UPDATE ON `reagente` FOR EACH ROW BEGIN
SET @aberto_new = new.qtdEstoqueAberto;
SET @aberto_old = old.qtdEstoqueAberto;
SET @lacrado_new = new.qtdEstoqueLacrado;
SET @lacrado_old = old.qtdEstoqueLacrado;

SET @total_new = new.qtdEstoqueTotal;

if @aberto_new < 0 || @lacrado_new < 0 THEN
	SIGNAL sqlstate '45001' set message_text = "Não é possível adicionar um valor negativo!";
end if;

set new.qtdEstoqueTotal = @aberto_new + @lacrado_new;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tamanho`
--

CREATE TABLE `tamanho` (
  `id` int(11) NOT NULL,
  `nome` varchar(45) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `tamanho`
--

INSERT INTO `tamanho` (`id`, `nome`) VALUES
(1, 'P'),
(2, 'M'),
(3, 'G'),
(4, 'Pequeno'),
(5, 'Grande');

-- --------------------------------------------------------

--
-- Estrutura da tabela `tipooperacao`
--

CREATE TABLE `tipooperacao` (
  `id` int(11) NOT NULL,
  `nome` varchar(30) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `tipooperacao`
--

INSERT INTO `tipooperacao` (`id`, `nome`) VALUES
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

CREATE TABLE `unidade` (
  `id` int(11) NOT NULL,
  `nome` varchar(45) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `unidade`
--

INSERT INTO `unidade` (`id`, `nome`) VALUES
(1, 'mL'),
(2, 'L'),
(3, 'mm'),
(4, 'g'),
(5, 'kg');

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `nome` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `nivel` int(11) NOT NULL,
  `senha` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `login` varchar(25) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `usuario`
--

INSERT INTO `usuario` (`id`, `nome`, `nivel`, `senha`, `email`, `login`) VALUES
(1, 'João Pedro Ribeiro', 3, 'senha123', 'jp3dr0436@gmail.com', 'jp3dr0'),
(2, 'Rogério', 2, 'amoquimica', NULL, 'RogerioIFRN'),
(3, 'Fabiana Oliveira', 3, 'pdcgld', NULL, 'fabi123'),
(4, 'Leo', 1, 'qwerty', 'leozin@gmail.com', 'leozinho123'),
(5, 'Xand', 1, 'avioes', 'xandinho@gmail.com', 'xandaviao'),
(6, 'Lucas Costa', 3, 'secreti', 'lukinhas@gmail.com', 'lukinhas'),
(7, 'Lucas Costa', 3, 'secreti', 'lukinhas@gmail.com', 'lukinhas'),
(8, 'Lucas Costa', 3, 'secreti', 'lukinhas@gmail.com', 'lukinhas'),
(9, 'Lucas Costa', 3, 'secreti', 'lukinhas@gmail.com', 'lukinhas'),
(10, 'Lucas Costa', 3, 'secreti', 'lukinhas@gmail.com', 'lukinhas'),
(11, 'Lucas Costa', 3, 'secreti', 'lukinhas@gmail.com', 'lukinhas'),
(12, 'Lucas Costa', 3, 'secreti', 'lukinhas@gmail.com', 'lukinhas'),
(13, 'Lucas Costa', 3, 'secreti', 'lukinhas@gmail.com', 'lukinhas'),
(14, 'Lucas Costa', 3, 'secreti', 'lukinhas@gmail.com', 'lukinhas'),
(15, 'Lucas Costa', 3, 'secreti', 'lukinhas@gmail.com', 'lukinhas'),
(16, 'Lucas Costa', 3, 'secreti', 'lukinhas@gmail.com', 'lukinhas');

-- --------------------------------------------------------

--
-- Estrutura da tabela `vidraria`
--

CREATE TABLE `vidraria` (
  `id` int(11) NOT NULL,
  `img` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `qtdEstoque` int(11) NOT NULL,
  `nome` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `comentario` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `valor` int(11) DEFAULT NULL,
  `tamanho` int(11) DEFAULT NULL,
  `unidade` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Extraindo dados da tabela `vidraria`
--

INSERT INTO `vidraria` (`id`, `img`, `qtdEstoque`, `nome`, `comentario`, `valor`, `tamanho`, `unidade`) VALUES
(5, 'hrth', 8, 'becker de vidro', 'eryjt', 2000, NULL, 1),
(6, NULL, 3, 'at becker de vidro', NULL, 1000, NULL, 2),
(7, NULL, 0, 'becker de vidro', NULL, 600, NULL, 1),
(8, NULL, 1, 'becker de vidro', NULL, 250, NULL, 1),
(9, NULL, 68, 'becker de vidro', NULL, 150, NULL, 1),
(10, NULL, 16, 'becker de vidro', NULL, 100, NULL, 1),
(11, NULL, 7, 'becker de vidro', NULL, 10, NULL, 1),
(12, NULL, 3, 'becker de plástico', NULL, 4000, NULL, 1),
(13, NULL, 3, 'becker de plástico', NULL, 2000, NULL, 1),
(14, NULL, 18, 'erlenmeyer de vidro', NULL, 500, NULL, 1),
(15, NULL, 56, 'erlenmeyer de vidro', NULL, 250, NULL, 1),
(16, NULL, 43, 'erlenmeyer de vidro', NULL, 125, NULL, 1),
(17, NULL, 4, 'capacete de proteção', NULL, NULL, 1, NULL),
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
(62, NULL, 4, 'picnômetro sem termômetro ', NULL, 10, NULL, 1),
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
(124, NULL, 3, 'detergente alcalino', NULL, 5, NULL, 2),
(125, NULL, 2, 'teste', 'testando com', 3, NULL, 2);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_itens`
-- (See below for the actual view)
--
CREATE TABLE `view_itens` (
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_reagente_min`
-- (See below for the actual view)
--
CREATE TABLE `view_reagente_min` (
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_vidraria_min`
-- (See below for the actual view)
--
CREATE TABLE `view_vidraria_min` (
);

-- --------------------------------------------------------

--
-- Structure for view `view_itens`
--
DROP TABLE IF EXISTS `view_itens`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_itens`  AS  select `view_reagente_min`.`tipoItem` AS `tipoItem`,`view_reagente_min`.`id` AS `id`,`view_reagente_min`.`img` AS `img`,`view_reagente_min`.`qtd` AS `qtd`,`view_reagente_min`.`nome` AS `nome`,`view_reagente_min`.`classificacaoReagente` AS `classificacaoReagente`,`view_reagente_min`.`tamanhoVidraria` AS `tamanhoVidraria`,`view_reagente_min`.`valor` AS `valor`,`view_reagente_min`.`unidade` AS `unidade`,`view_reagente_min`.`comentario` AS `comentario` from `view_reagente_min` union select `view_vidraria_min`.`tipoItem` AS `tipoItem`,`view_vidraria_min`.`id` AS `id`,`view_vidraria_min`.`img` AS `img`,`view_vidraria_min`.`qtd` AS `qtd`,`view_vidraria_min`.`nome` AS `nome`,`view_vidraria_min`.`classificacaoReagente` AS `classificacaoReagente`,`view_vidraria_min`.`tamanhoVidraria` AS `tamanhoVidraria`,`view_vidraria_min`.`valor` AS `valor`,`view_vidraria_min`.`unidade` AS `unidade`,`view_vidraria_min`.`comentario` AS `comentario` from `view_vidraria_min` ;

-- --------------------------------------------------------

--
-- Structure for view `view_reagente_min`
--
DROP TABLE IF EXISTS `view_reagente_min`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_reagente_min`  AS  select 'R' AS `tipoItem`,`reagente`.`idReagente` AS `id`,`reagente`.`imgReagente` AS `img`,`reagente`.`qtd_estoque_Reagente_total` AS `qtd`,`reagente`.`nomeReagente` AS `nome`,`reagente`.`ClassificacaoReagente` AS `classificacaoReagente`,NULL AS `tamanhoVidraria`,`reagente`.`valorCapacidadeReagente` AS `valor`,`reagente`.`UnidadeReagente` AS `unidade`,`reagente`.`comentarioReagente` AS `comentario` from `reagente` order by `reagente`.`idReagente` ;

-- --------------------------------------------------------

--
-- Structure for view `view_vidraria_min`
--
DROP TABLE IF EXISTS `view_vidraria_min`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_vidraria_min`  AS  select 'V' AS `tipoItem`,`vidraria`.`idVidraria` AS `id`,`vidraria`.`imgVidraria` AS `img`,`vidraria`.`qtd_estoque_Vidraria` AS `qtd`,`vidraria`.`nomeVidraria` AS `nome`,NULL AS `classificacaoReagente`,`vidraria`.`tamanhoCapacidadeVidraria` AS `tamanhoVidraria`,`vidraria`.`valorCapacidadeVidraria` AS `valor`,`vidraria`.`UnidadeVidraria` AS `unidade`,`vidraria`.`comentarioVidraria` AS `comentario` from `vidraria` order by `vidraria`.`idVidraria` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `classificacao`
--
ALTER TABLE `classificacao`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nivel`
--
ALTER TABLE `nivel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `operacao`
--
ALTER TABLE `operacao`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_Retirada_Usuario1_idx` (`usuario`),
  ADD KEY `fk_Operacao_TipoOperacao1_idx` (`tipoOperacao`),
  ADD KEY `fk_Operacao_Reagente` (`reagente`),
  ADD KEY `fk_Operacao_Vidraria` (`vidraria`);

--
-- Indexes for table `operacoes_permitidas_por_nivel`
--
ALTER TABLE `operacoes_permitidas_por_nivel`
  ADD PRIMARY KEY (`nivel_id`,`tipooperacao_id`),
  ADD KEY `fk_nivel_has_tipooperacao_tipooperacao1_idx` (`tipooperacao_id`),
  ADD KEY `fk_nivel_has_tipooperacao_nivel1_idx` (`nivel_id`);

--
-- Indexes for table `reagente`
--
ALTER TABLE `reagente`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_Reagente_Classificacao1_idx` (`classificacao`),
  ADD KEY `fk_Reagente_Unidade` (`unidade`);

--
-- Indexes for table `tamanho`
--
ALTER TABLE `tamanho`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tipooperacao`
--
ALTER TABLE `tipooperacao`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `unidade`
--
ALTER TABLE `unidade`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_Usuario_Nivel_idx` (`nivel`);

--
-- Indexes for table `vidraria`
--
ALTER TABLE `vidraria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_vidraria_Unidade` (`unidade`),
  ADD KEY `fk_vidraria_tamanho` (`tamanho`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `classificacao`
--
ALTER TABLE `classificacao`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `nivel`
--
ALTER TABLE `nivel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `operacao`
--
ALTER TABLE `operacao`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT for table `reagente`
--
ALTER TABLE `reagente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=130;

--
-- AUTO_INCREMENT for table `tamanho`
--
ALTER TABLE `tamanho`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tipooperacao`
--
ALTER TABLE `tipooperacao`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `unidade`
--
ALTER TABLE `unidade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `vidraria`
--
ALTER TABLE `vidraria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=126;

--
-- Constraints for dumped tables
--

--
-- Limitadores para a tabela `operacao`
--
ALTER TABLE `operacao`
  ADD CONSTRAINT `fk_Operacao_Reagente` FOREIGN KEY (`reagente`) REFERENCES `reagente` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Operacao_TipoOperacao1` FOREIGN KEY (`tipoOperacao`) REFERENCES `tipooperacao` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Operacao_Vidraria` FOREIGN KEY (`vidraria`) REFERENCES `vidraria` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Retirada_Usuario1` FOREIGN KEY (`usuario`) REFERENCES `usuario` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `operacoes_permitidas_por_nivel`
--
ALTER TABLE `operacoes_permitidas_por_nivel`
  ADD CONSTRAINT `fk_nivel_has_tipooperacao_nivel1` FOREIGN KEY (`nivel_id`) REFERENCES `nivel` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_nivel_has_tipooperacao_tipooperacao1` FOREIGN KEY (`tipooperacao_id`) REFERENCES `tipooperacao` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `reagente`
--
ALTER TABLE `reagente`
  ADD CONSTRAINT `fk_Reagente_Classificacao1` FOREIGN KEY (`classificacao`) REFERENCES `classificacao` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Reagente_Unidade` FOREIGN KEY (`unidade`) REFERENCES `unidade` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_Usuario_Nivel` FOREIGN KEY (`nivel`) REFERENCES `nivel` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `vidraria`
--
ALTER TABLE `vidraria`
  ADD CONSTRAINT `fk_vidraria_Unidade` FOREIGN KEY (`unidade`) REFERENCES `unidade` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_vidraria_tamanho` FOREIGN KEY (`tamanho`) REFERENCES `tamanho` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
