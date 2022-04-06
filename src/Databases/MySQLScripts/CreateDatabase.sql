-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 06, 2022 at 11:45 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `estufa`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CriarUtilizador` (IN `p_Nome` VARCHAR(150), IN `p_Email` VARCHAR(64), IN `p_Pass` VARCHAR(64), IN `p_Role` VARCHAR(30))  BEGIN
    SET
    `p_Nome` := CONCAT("'", `p_Nome`, "'"),
    `p_Email` := CONCAT("'", `p_Email`, "'"),
    `p_Pass` := CONCAT("'", `p_Pass`, "'"),
    `p_Role` := CONCAT("'", `p_Role`, "'");


    SET @`sql` := CONCAT('CREATE USER IF NOT EXISTS ', `p_Email`, ' IDENTIFIED BY ', `p_Pass`);
	PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET @`sql` := CONCAT('GRANT ', `p_Role`, ' TO ', `p_Email`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET
    `p_Nome` := REPLACE(`p_Nome`,'''',''),
    `p_Email` := REPLACE(`p_Email`,'''',''),
    `p_Role` := REPLACE(`p_Role`,'''',''),
    `p_Role` := SUBSTRING(`p_Role`, 1, 1);


    INSERT INTO utilizador(IDUtilizador, NomeUtilizador, EmailUtilizador, TipoUtilizador)
    VALUES (uuid(), `p_Nome`, `p_Email`, `p_Role`);


    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;


DELIMITER //

CREATE DEFINER=`Software`@`localhost` PROCEDURE InsertMedicao(zona INT(11), sensor INT(11), date_time TIMESTAMP, measurement DECIMAL(5,2))
BEGIN
	SELECT *  FROM medicao;
    insert into medicao(IDMedicao, IDSensor, IDZona, Valor, Datetime)
    values
    (uuid(), sensor, zona, measurement, date_time);
END //

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `alerta`
--

CREATE TABLE `alerta` (
  `IDAlerta` varchar(50) NOT NULL,
  `IDZona` int(11) NOT NULL,
  `IDCultura` varchar(50) NOT NULL,
  `IDSensor` int(11) NOT NULL,
  `TipoAlerta` varchar(1) NOT NULL,
  `Datetime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `Valor` decimal(5,2) NOT NULL,
  `Mensagem` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `cultura`
--

CREATE TABLE `cultura` (
  `IDCultura` varchar(50) NOT NULL,
  `IDUtilizador` varchar(50) NOT NULL,
  `IDZona` int(11) NOT NULL,
  `NomeCultura` varchar(50) NOT NULL,
  `Estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `IDLog` varchar(50) NOT NULL,
  `IDMedicao` varchar(50) NOT NULL,
  `IDZona` int(11) NOT NULL,
  `IDSensor` int(11) NOT NULL,
  `Valor` decimal(5,2) NOT NULL,
  `Datetime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `medicao`
--

CREATE TABLE `medicao` (
  `IDMedicao` varchar(50) NOT NULL,
  `IDZona` int(11) NOT NULL,
  `IDSensor` int(11) NOT NULL,
  `Valor` decimal(5,2) NOT NULL,
  `Datetime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `TipoSensor` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `parametrocultura`
--

CREATE TABLE `parametrocultura` (
  `IDCultura` varchar(50) NOT NULL,
  `TipoSensor` char(1) NOT NULL,
  `ValorMax` decimal(5,2) NOT NULL,
  `ValorMin` decimal(5,2) NOT NULL,
  `ToleranciaMax` decimal(5,2) NOT NULL,
  `ToleranciaMin` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `sensor`
--

CREATE TABLE `sensor` (
  `IDSensor` int(11) NOT NULL,
  `TipoSensor` char(1) NOT NULL,
  `IDZona` int(11) NOT NULL,
  `LimiteInferior` decimal(5,2) NOT NULL,
  `LimiteSuperior` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `utilizador`
--

CREATE TABLE `utilizador` (
  `IDUtilizador` varchar(50) NOT NULL,
  `NomeUtilizador` varchar(150) NOT NULL,
  `EmailUtilizador` varchar(64) NOT NULL,
  `TipoUtilizador` varchar(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `zona`
--

CREATE TABLE `zona` (
  `IDZona` int(11) NOT NULL,
  `Temperatura` decimal(5,2) NOT NULL,
  `Humidade` decimal(5,2) NOT NULL,
  `Luz` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alerta`
--
ALTER TABLE `alerta`
  ADD PRIMARY KEY (`IDAlerta`),
  ADD KEY `IDCultura` (`IDCultura`);

--
-- Indexes for table `cultura`
--
ALTER TABLE `cultura`
  ADD PRIMARY KEY (`IDCultura`,`IDUtilizador`),
  ADD KEY `IDUtilizador` (`IDUtilizador`),
  ADD KEY `IDZona` (`IDZona`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`IDLog`,`IDMedicao`),
  ADD KEY `IDMedicao` (`IDMedicao`);

--
-- Indexes for table `medicao`
--
ALTER TABLE `medicao`
  ADD PRIMARY KEY (`IDMedicao`),
  ADD KEY `IDZona` (`IDZona`),
  ADD KEY `IDSensor` (`IDSensor`);

--
-- Indexes for table `parametrocultura`
--
ALTER TABLE `parametrocultura`
  ADD PRIMARY KEY (`IDCultura`,`TipoSensor`);

--
-- Indexes for table `sensor`
--
ALTER TABLE `sensor`
  ADD PRIMARY KEY (`IDSensor`,`TipoSensor`),
  ADD KEY `IDZona` (`IDZona`);

--
-- Indexes for table `utilizador`
--
ALTER TABLE `utilizador`
  ADD PRIMARY KEY (`IDUtilizador`) USING BTREE,
  ADD UNIQUE KEY `NomeUtilizador` (`NomeUtilizador`);

--
-- Indexes for table `zona`
--
ALTER TABLE `zona`
  ADD PRIMARY KEY (`IDZona`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alerta`
--
ALTER TABLE `alerta`
  ADD CONSTRAINT `alerta_ibfk_1` FOREIGN KEY (`IDCultura`) REFERENCES `cultura` (`IDCultura`) ON DELETE CASCADE;

--
-- Constraints for table `cultura`
--
ALTER TABLE `cultura`
  ADD CONSTRAINT `cultura_ibfk_1` FOREIGN KEY (`IDUtilizador`) REFERENCES `utilizador` (`IDUtilizador`) ON DELETE CASCADE,
  ADD CONSTRAINT `cultura_ibfk_2` FOREIGN KEY (`IDZona`) REFERENCES `zona` (`IDZona`) ON DELETE CASCADE;

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`IDMedicao`) REFERENCES `medicao` (`IDMedicao`) ON DELETE CASCADE;

--
-- Constraints for table `medicao`
--
ALTER TABLE `medicao`
  ADD CONSTRAINT `medicao_ibfk_1` FOREIGN KEY (`IDZona`) REFERENCES `sensor` (`IDZona`) ON DELETE CASCADE,
  ADD CONSTRAINT `medicao_ibfk_2` FOREIGN KEY (`IDSensor`) REFERENCES `sensor` (`IDSensor`) ON DELETE CASCADE;

--
-- Constraints for table `parametrocultura`
--
ALTER TABLE `parametrocultura`
  ADD CONSTRAINT `parametrocultura_ibfk_1` FOREIGN KEY (`IDCultura`) REFERENCES `cultura` (`IDCultura`) ON DELETE CASCADE;

--
-- Constraints for table `sensor`
--
ALTER TABLE `sensor`
  ADD CONSTRAINT `sensor_ibfk_1` FOREIGN KEY (`IDZona`) REFERENCES `zona` (`IDZona`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


INSERT INTO `zona` (`IDZona`, `Temperatura`, `Humidade`, `Luz`) VALUES
(1, '12.00', '20.00', '10.00'),
(2, '13.00', '30.00', '20.00');


INSERT INTO `sensor` (`IDSensor`, `TipoSensor`, `LimiteInferior`, `LimiteSuperior`, `IDZona`) VALUES
(1, 'H', '0.00', '100.00', 1),
(1, 'L', '0.00', '500.00', 1),
(1, 'T', '0.00', '45.00', 1),
(2, 'H', '0.00', '90.00', 2),
(2, 'L', '0.00', '300.00', 2),
(2, 'T', '2.00', '50.00', 2);
