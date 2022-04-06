-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 06-Abr-2022 às 22:50
-- Versão do servidor: 10.4.14-MariaDB
-- versão do PHP: 7.4.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `estufa_dados`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `alerta`
--

CREATE TABLE `alerta` (
  `IDAlerta` varchar(50) COLLATE utf8_bin NOT NULL,
  `IDZona` int(11) NOT NULL,
  `IDCultura` varchar(50) COLLATE utf8_bin NOT NULL,
  `IDSensor` int(11) NOT NULL,
  `TipoAlerta` varchar(1) COLLATE utf8_bin NOT NULL,
  `Datetime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Valor` decimal(5,2) NOT NULL,
  `Mensagem` varchar(150) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estrutura da tabela `cultura`
--

CREATE TABLE `cultura` (
  `IDCultura` varchar(50) COLLATE utf8_bin NOT NULL,
  `IDZona` int(11) NOT NULL,
  `NomeCultura` varchar(50) COLLATE utf8_bin NOT NULL,
  `Estado` tinyint(1) NOT NULL,
  `IDUtilizador` varchar(50) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estrutura da tabela `medicao`
--

CREATE TABLE `medicao` (
  `IDMedicao` varchar(50) COLLATE utf8_bin NOT NULL,
  `IDZona` int(11) NOT NULL,
  `IDSensor` int(11) NOT NULL,
  `TipoSensor` char(1) NOT NULL,
  `Valor` decimal(5,2) DEFAULT NULL,
  `Datetime` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estrutura da tabela `parametrocultura`
--

CREATE TABLE `parametrocultura` (
  `IDCultura` varchar(50) COLLATE utf8_bin NOT NULL,
  `TipoSensor` char(1) COLLATE utf8_bin NOT NULL,
  `ValorMax` decimal(5,2) NOT NULL,
  `ValorMin` decimal(5,2) NOT NULL,
  `ToleranciaMax` decimal(5,2) NOT NULL,
  `ToleranciaMin` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estrutura da tabela `sensor`
--

CREATE TABLE `sensor` (
  `IDSensor` int(11) NOT NULL,
  `TipoSensor` char(1) COLLATE utf8_bin NOT NULL,
  `IDZona` int(11) NOT NULL,
  `LimiteInferior` decimal(5,2) NOT NULL,
  `LimiteSuperior` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estrutura da tabela `utilizador`
--

CREATE TABLE `utilizador` (
  `IDUtilizador` varchar(50) COLLATE utf8_bin NOT NULL,
  `NomeUtilizador` varchar(150) COLLATE utf8_bin NOT NULL,
  `EmailUtilizador` varchar(64) COLLATE utf8_bin NOT NULL,
  `TipoUtilizador` varchar(1) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estrutura da tabela `zona`
--

CREATE TABLE `zona` (
  `IDZona` int(11) NOT NULL,
  `Temperatura` decimal(5,2) NOT NULL,
  `Humidade` decimal(5,2) NOT NULL,
  `Luz` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `alerta`
--
ALTER TABLE `alerta`
  ADD PRIMARY KEY (`IDAlerta`);

--
-- Índices para tabela `cultura`
--
ALTER TABLE `cultura`
  ADD PRIMARY KEY (`IDCultura`,`IDUtilizador`),
  ADD KEY `IDUtilizador` (`IDUtilizador`);

--
-- Índices para tabela `medicao`
--
ALTER TABLE `medicao`
  ADD PRIMARY KEY (`IDMedicao`);

--
-- Índices para tabela `parametrocultura`
--
ALTER TABLE `parametrocultura`
  ADD PRIMARY KEY (`IDCultura`,`TipoSensor`);

--
-- Índices para tabela `sensor`
--
ALTER TABLE `sensor`
  ADD PRIMARY KEY (`IDSensor`,`TipoSensor`);

--
-- Índices para tabela `utilizador`
--
ALTER TABLE `utilizador`
  ADD PRIMARY KEY (`IDUtilizador`,`NomeUtilizador`);

--
-- Índices para tabela `zona`
--
ALTER TABLE `zona`
  ADD PRIMARY KEY (`IDZona`);

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `cultura`
--
ALTER TABLE `cultura`
  ADD CONSTRAINT `cultura_ibfk_1` FOREIGN KEY (`IDUtilizador`) REFERENCES `utilizador` (`IDUtilizador`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cultura_ibfk_2` FOREIGN KEY (`IDCultura`) REFERENCES `parametrocultura` (`IDCultura`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
