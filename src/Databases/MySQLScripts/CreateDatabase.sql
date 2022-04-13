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

-- --------------------------------------------------------

--
-- Procedure CriarAdministrador
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `CriarAdministrador` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `CriarAdministrador` (IN `nome` VARCHAR(150), IN `email` VARCHAR(64), IN `pass` VARCHAR(64), IN `role` ENUM('Administrador'))
BEGIN
    SET `email` := CONCAT("'", `email`, "'"),
        `pass` := CONCAT("'", `pass`, "'");


    SET @`sql` := CONCAT('CREATE USER IF NOT EXISTS ', `email`, ' IDENTIFIED BY ', `pass`);
	PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET @`sql` := CONCAT('GRANT ', `role`, ' TO ', `email`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET @`sql` := CONCAT('SET DEFAULT ROLE ', `role`, ' FOR ', `email`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET `nome` := REPLACE(`nome`,'''',''),
        `email` := REPLACE(`email`,'''','');


    INSERT INTO utilizador(IDUtilizador, NomeUtilizador, EmailUtilizador, TipoUtilizador)
    VALUES (uuid(), `nome`, `email`, `role`);


    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Procedure CriarUtilizador
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `CriarUtilizador` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `CriarUtilizador` (IN `nome` VARCHAR(150), IN `email` VARCHAR(64), IN `pass` VARCHAR(64), IN `role` ENUM('Investigador', 'Técnico'))
BEGIN
    SET `email` := CONCAT("'", `email`, "'"),
        `pass` := CONCAT("'", `pass`, "'");


    SET @`sql` := CONCAT('CREATE USER IF NOT EXISTS ', `email`, ' IDENTIFIED BY ', `pass`);
	PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET @`sql` := CONCAT('GRANT ', `role`, ' TO ', `email`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET @`sql` := CONCAT('SET DEFAULT ROLE ', `role`, ' FOR ', `email`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET `nome` := REPLACE(`nome`,'''',''),
        `email` := REPLACE(`email`,'''','');


    INSERT INTO utilizador(IDUtilizador, NomeUtilizador, EmailUtilizador, TipoUtilizador)
    VALUES (uuid(), `nome`, `email`, `role`);


    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Procedure ApagarUtilizador
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `ApagarUtilizador` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `ApagarUtilizador` (IN `email` VARCHAR(150))
BEGIN
    SET `email` := CONCAT("'", `email`, "'");

    SET @`sql` = CONCAT('SELECT COUNT(EmailUtilizador) INTO @utilizador FROM utilizador WHERE EmailUtilizador=', `email`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF @utilizador=0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Utilizador não existe.";
    END IF;


    SET @`sql` = CONCAT('SELECT u.TipoUtilizador INTO @role FROM utilizador u WHERE u.EmailUtilizador=', `email`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF STRCMP("A",@role) = 0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Não pode apagar Administradores";
    END IF;


    SET @`sql` = CONCAT('DELETE FROM utilizador WHERE EmailUtilizador=', `email`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET @`sql` := CONCAT('DROP USER IF EXISTS ', `email`);
	PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Procedure CriarCultura
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `CriarCultura` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `CriarCultura` (IN `nome_cultura` VARCHAR(150),  IN `IDZona` INT(11))
BEGIN
    SET @`sql` = CONCAT('SELECT COUNT(IDZona) INTO @zona FROM zona WHERE IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF @zona=0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Zona não existe.";
    END IF;

    SET @uuid = uuid();
    SET FOREIGN_KEY_CHECKS=0;
    INSERT INTO cultura(IDCultura, IDUtilizador, IDZona, NomeCultura, Estado)
    VALUES (@uuid, "NÃO_ATRIBUÍDA", `IDZona`, `nome_cultura`, 0);
    SET FOREIGN_KEY_CHECKS=1;


    SET @`sql` = CONCAT('SELECT s.LimiteSuperior INTO @TMax FROM sensor s WHERE s.TipoSensor = ''T'' AND s.IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT s.LimiteSuperior INTO @HMax FROM sensor s WHERE s.TipoSensor = ''H'' AND s.IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT s.LimiteSuperior INTO @LMax FROM sensor s WHERE s.TipoSensor = ''L'' AND s.IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT s.LimiteInferior INTO @TMin FROM sensor s WHERE s.TipoSensor = ''T'' AND s.IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT s.LimiteInferior INTO @HMin FROM sensor s WHERE s.TipoSensor = ''H'' AND s.IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT s.LimiteInferior INTO @LMin FROM sensor s WHERE s.TipoSensor = ''L'' AND s.IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    INSERT INTO parametrocultura(IDCultura, TipoSensor, ValorMax, ValorMin, ToleranciaMax, ToleranciaMin)
    VALUES (@uuid, "T", @TMax, @TMin, 0, 0),
           (@uuid, "H", @HMax, @HMin, 0, 0),
           (@uuid, "L", @LMax, @LMin, 0, 0);


    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Procedure ApagarCultura
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `ApagarCultura` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `ApagarCultura` (IN `nome` VARCHAR(50))
BEGIN
    SET `nome` := CONCAT("'", `nome`, "'");

    SET @`sql` = CONCAT('SELECT c.Estado INTO @estado FROM cultura c WHERE c.NomeCultura=', `nome`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF @estado=1 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Não pode apagar culturas ativas.";
    END IF;


    SET `nome` := REPLACE(`nome`,'''','');
    DELETE FROM cultura WHERE NomeCultura=nome;


    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Procedure AtribuirCultura
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `AtribuirCultura` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `AtribuirCultura` (IN `nome_cultura` VARCHAR(50), IN `email_investigador` VARCHAR(150))
BEGIN
    SET `email_investigador` := CONCAT("'", `email_investigador`, "'"),
        `nome_cultura` := CONCAT("'", `nome_cultura`, "'");

    SET @`sql` = CONCAT('SELECT COUNT(EmailUtilizador) INTO @investigador FROM utilizador WHERE EmailUtilizador=', `email_investigador`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF @investigador=0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Utilizador não existe.";
    END IF;
    -- --------------------------------------------------------

    SET @`sql` = CONCAT('SELECT u.TipoUtilizador INTO @role FROM utilizador u WHERE u.EmailUtilizador=', `email_investigador`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF NOT STRCMP("I",@role) = 0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Utilizador não é Investigador.";
    END IF;
    -- --------------------------------------------------------

    SET @`sql` = CONCAT('SELECT COUNT(NomeCultura) INTO @cultura FROM cultura WHERE NomeCultura=', `nome_cultura`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF @cultura=0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Cultura não existe.";
    END IF;
    -- --------------------------------------------------------

    SET @`sql` = CONCAT('SELECT u.IDUtilizador INTO @utilizador FROM utilizador u WHERE u.EmailUtilizador=', `email_investigador`);
        PREPARE `stmt` FROM @`sql`;
        EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT c.IDUtilizador INTO @delegated_to FROM cultura c WHERE c.NomeCultura=', `nome_cultura`);
        PREPARE `stmt` FROM @`sql`;
        EXECUTE `stmt`;

    IF STRCMP(@utilizador,@delegated_to) = 0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Cultura já está atribuída ao Investigador.";
    END IF;

    IF NOT STRCMP("NÃO_ATRIBUÍDA",@delegated_to) = 0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Cultura já está atribuída a outro Investigador.";
    END IF;
    -- --------------------------------------------------------

    SET `nome_cultura` := REPLACE(`nome_cultura`,'''','');

    UPDATE cultura
    SET IDUtilizador=@utilizador
    WHERE NomeCultura = nome_cultura;


    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Procedure AlterarParametrosCultura
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `AlterarParametrosCultura` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `AlterarParametrosCultura` (IN `NomeCultura` VARCHAR(50), IN `TipoSensor` ENUM('T', 'H', 'L'), IN `ValorMax` DECIMAL(5,2), IN `ValorMin` DECIMAL(5,2), IN `TolMax` DECIMAL(5,2), IN `TolMin` DECIMAL(5,2))
BEGIN
    SELECT USER() INTO @caller;
    SET @caller := SUBSTRING_INDEX(@caller,'@',2),
        @caller := CONCAT("'", @caller, "'"),
        `NomeCultura` := CONCAT("'", `NomeCultura`, "'"),
        @sensor := CONCAT("'", `TipoSensor`, "'");

    SET @`sql` = CONCAT('SELECT u.IDUtilizador INTO @utilizador FROM utilizador u WHERE u.EmailUtilizador=', @caller);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT c.IDUtilizador INTO @delegated_to FROM cultura c WHERE c.NomeCultura=', `NomeCultura`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    IF ((NOT STRCMP(@utilizador,@delegated_to) = 0) OR (@utilizador IS NULL)) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Só pode alterar os parâmetros das suas culturas.";
    END IF;

    IF ValorMin>ValorMax THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Valor mínimo não pode ser maior que valor máximo.";
    END IF;

    IF TolMin>TolMax THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Tolerância mínima não pode ser maior que tolerância máxima.";
    END IF;

    IF TolMax>ValorMax THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Valor máximo não pode ser maior que tolerância máxima.";
    END IF;

    IF TolMin<ValorMin THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Valor mínimo não pode ser maior que tolerância mínima.";
    END IF;


    SET @`sql` = CONCAT('SELECT c.IDZona INTO @zona FROM cultura c WHERE c.NomeCultura=', `NomeCultura`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` := CONCAT('SELECT s.LimiteSuperior INTO @SensorMax FROM sensor s WHERE s.TipoSensor=', @sensor, " AND s.IDZona=", @zona);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT s.LimiteInferior INTO @SensorMin FROM sensor s WHERE s.TipoSensor=', @sensor,' AND s.IDZona=', @zona);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF ValorMax>@SensorMax THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Valor máximo não pode ultrapassar limites do sensor.";
    END IF;

    IF ValorMin<@SensorMin THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Valor mínimo não pode ultrapassar limites do sensor.";
    END IF;

    SELECT @utilizador;
    SELECT @delegated_to;

    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Procedure InserirMedicao
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `InserirMedicao` $$
CREATE DEFINER=`Software`@`localhost`
PROCEDURE InserirMedicao(zona INT(11), sensor INT(11), tiposensor CHAR(1), date_time TIMESTAMP, measurement DECIMAL(5,2))
BEGIN
	SELECT *  FROM medicao;
    INSERT INTO medicao(IDMedicao, IDSensor, TipoSensor, IDZona, Valor, Datetime)
    VALUES
    (uuid(), sensor, tiposensor, zona, measurement, date_time);
END $$

DELIMITER ;

-- --------------------------------------------------------
-- space for more procedures
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

-- --------------------------------------------------------

--
-- Role Administrador
--

DROP ROLE IF EXISTS Administrador;
CREATE ROLE Administrador;
GRANT SELECT ON estufa.cultura TO Administrador;
GRANT SELECT ON estufa.parametrocultura TO Administrador;
GRANT SELECT ON estufa.utilizador TO Administrador;
GRANT SELECT ON estufa.medicao TO Administrador;
GRANT SELECT ON estufa.alerta TO Administrador;
GRANT SELECT ON estufa.sensor TO Administrador;
GRANT SELECT ON estufa.zona TO Administrador;
GRANT SELECT ON estufa.logs TO Administrador;
GRANT EXECUTE ON PROCEDURE CriarUtilizador TO Administrador;
GRANT EXECUTE ON PROCEDURE ApagarUtilizador TO Administrador;
GRANT EXECUTE ON PROCEDURE CriarCultura TO Administrador;
GRANT EXECUTE ON PROCEDURE ApagarCultura TO Administrador;
GRANT EXECUTE ON PROCEDURE AtribuirCultura TO Administrador;

-- --------------------------------------------------------

--
-- Role Investigador
--

DROP ROLE IF EXISTS Investigador;
CREATE ROLE Investigador;
GRANT SELECT ON estufa.sensor TO Investigador;
GRANT SELECT ON estufa.zona TO Investigador;
GRANT SELECT ON estufa.cultura TO Investigador;
GRANT SELECT ON estufa.parametrocultura TO Investigador;
GRANT EXECUTE ON PROCEDURE AlterarParametrosCultura TO Investigador;

-- --------------------------------------------------------

--
-- Variáveis para testes
--

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

CALL CriarAdministrador('admin','admin@estufa.pt','admin','Administrador');
-- --------------------------------------------------------