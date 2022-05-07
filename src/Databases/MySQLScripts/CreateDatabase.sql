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


--
-- Table structure for table `alerta`
--

CREATE TABLE `alerta` (
  `IDAlerta` varchar(50) NOT NULL,
  `IDZona` int(11) NOT NULL,
  `NomeCultura` varchar(50) NOT NULL,
  `IDCultura` varchar(50) NOT NULL,
  `IDUtilizador` varchar(50) NOT NULL,
  `IDSensor` int(11) NOT NULL,
  `TipoSensor` varchar(1) NOT NULL,
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
  `Estado` tinyint(1) NOT NULL,
  `Intervalo` int(11) NOT NULL
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
  `TipoSensor` char(1) NOT NULL,
  `Valor` decimal(5,2) NOT NULL,
  `Datetime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
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
  `TipoUtilizador` varchar(2) NOT NULL
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
  ADD KEY `IDZona` (`IDZona`),
  ADD UNIQUE (`NomeCultura`);

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
-- Procedure CriarAdministrador
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `CriarAdministrador` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `CriarAdministrador` (IN `nome` VARCHAR(150), IN `email` VARCHAR(64), IN `pass` VARCHAR(64), IN `role` ENUM('Administrador', 'Software'))
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
        `email` := REPLACE(`email`,'''',''),
        @role := CAST(`role` as CHAR);

    SET @final = SUBSTR(role, 1, 1);

    INSERT INTO utilizador(IDUtilizador, NomeUtilizador, EmailUtilizador, TipoUtilizador)
    VALUES (uuid(), `nome`, `email`, @final);

    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Procedure CriarUtilizador
--

DELIMITER $$

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
        `email` := REPLACE(`email`,'''',''),
        @role := CAST(`role` as CHAR);

    SET @final = SUBSTR(role, 1, 1);

    INSERT INTO utilizador(IDUtilizador, NomeUtilizador, EmailUtilizador, TipoUtilizador)
    VALUES (uuid(), `nome`, `email`, @final);

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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        SET FOREIGN_KEY_CHECKS = 1;
    DECLARE EXIT HANDLER FOR SQLWARNING
        SET FOREIGN_KEY_CHECKS = 1;
    DECLARE EXIT HANDLER FOR NOT FOUND
        SET FOREIGN_KEY_CHECKS = 1;

    SET @nome_cultura := CONCAT("'", `nome_cultura`, "'");

    SET @`sql` = CONCAT('SELECT COUNT(IDZona) INTO @zona FROM zona WHERE IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF @zona=0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Zona não existe.";
    END IF;

    SET @`sql` = CONCAT('SELECT COUNT(NomeCultura) INTO @cultura FROM cultura WHERE NomeCultura=', @nome_cultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF @cultura=1 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Não pode criar culturas com o mesmo nome.";
    END IF;

    SET @nome_cultura := REPLACE(@nome_cultura,'''','');
    SET @uuid = uuid();
    SET FOREIGN_KEY_CHECKS=0;
    INSERT INTO cultura(IDCultura, IDUtilizador, IDZona, NomeCultura, Estado, Intervalo)
    VALUES (@uuid, "NÃO_ATRIBUÍDA", `IDZona`, @nome_cultura, 0, 1);
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
    VALUES (@uuid, "T", @TMax, @TMin, @TMax, @TMin),
           (@uuid, "H", @HMax, @HMin, @HMax, @HMin),
           (@uuid, "L", @LMax, @LMin, @LMax, @LMin);


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
PROCEDURE `AlterarParametrosCultura` (IN `NomeCultura` VARCHAR(50), IN `TipoSensor` ENUM('T', 'H', 'L'), IN ValorMax DECIMAL(5,2), IN TolMax DECIMAL(5,2), IN TolMin DECIMAL(5,2), IN ValorMin DECIMAL(5,2))
BEGIN
    SELECT USER() INTO @caller;
    SET @caller := SUBSTRING_INDEX(@caller,'@',2),
        @caller := CONCAT("'", @caller, "'"),
        @nome_cultura := CONCAT("'", `NomeCultura`, "'"),
        @sensor := CONCAT("'", `TipoSensor`, "'");

    SET @`sql` = CONCAT('SELECT u.IDUtilizador INTO @utilizador FROM utilizador u WHERE u.EmailUtilizador=', @caller);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT c.IDUtilizador INTO @delegated_to FROM cultura c WHERE c.NomeCultura=', @nome_cultura);
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
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Tolerância máxima não pode ser maior que valor máximo.";
    END IF;

    IF ValorMin>TolMin THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Valor mínimo não pode ser maior que tolerância mínima.";
    END IF;


    SET @`sql` = CONCAT('SELECT c.IDZona INTO @zona FROM cultura c WHERE c.NomeCultura=', @nome_cultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` := CONCAT('SELECT s.LimiteSuperior INTO @SensorMax FROM sensor s WHERE s.TipoSensor=', @sensor, " AND s.IDZona=", @zona);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT s.LimiteInferior INTO @SensorMin FROM sensor s WHERE s.TipoSensor=', @sensor,' AND s.IDZona=', @zona);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @utilizador := CONCAT("'", @utilizador, "'");

    SET @`sql` = CONCAT('SELECT c.IDCultura INTO @idcultura FROM cultura c WHERE c.IDUtilizador=', @utilizador,' AND c.NomeCultura=', @nome_cultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    IF ValorMax>@SensorMax THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Valor máximo não pode ultrapassar limites do sensor.";
    END IF;

    IF ValorMin<@SensorMin THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Valor mínimo não pode ultrapassar limites do sensor.";
    END IF;


    SET @idcultura := CONCAT("'", @idcultura, "'");

	SET @`sql` = CONCAT('UPDATE parametrocultura SET ValorMax=', ValorMax,', ValorMin=', ValorMin,', ToleranciaMax=', TolMax,', ToleranciaMin=', TolMin,' WHERE IDCultura=', @idcultura,' AND TipoSensor=', @sensor);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Procedure AlterarEstado
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `AlterarEstado` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `AlterarEstado` (IN `NomeCultura` VARCHAR(50))
BEGIN
    SELECT USER() INTO @caller;
    SET @caller := SUBSTRING_INDEX(@caller,'@',2),
        @caller := CONCAT("'", @caller, "'"),
        @nome_cultura := CONCAT("'", `NomeCultura`, "'");

    SET @`sql` = CONCAT('SELECT u.IDUtilizador INTO @utilizador FROM utilizador u WHERE u.EmailUtilizador=', @caller);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT c.IDUtilizador INTO @delegated_to FROM cultura c WHERE c.NomeCultura=', @nome_cultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF ((NOT STRCMP(@utilizador,@delegated_to) = 0) OR (@utilizador IS NULL)) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Só pode alterar o estado das suas culturas.";
    END IF;

    SET @utilizador := CONCAT("'", @utilizador, "'");

    SET @`sql` = CONCAT('SELECT c.IDCultura INTO @idcultura FROM cultura c WHERE c.IDUtilizador=', @utilizador,' AND c.NomeCultura=', @nome_cultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @idcultura := CONCAT("'", @idcultura, "'");

    SET @`sql` = CONCAT('SELECT c.Estado INTO @estado FROM cultura c WHERE c.IDUtilizador=', @utilizador,' AND c.NomeCultura=', @nome_cultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF @estado = 0 THEN
	    SET @`sql` = CONCAT('UPDATE cultura SET Estado=', 1,' WHERE IDCultura=', @idcultura);
        PREPARE `stmt` FROM @`sql`;
        EXECUTE `stmt`;
    ELSE
        SET @`sql` = CONCAT('UPDATE cultura SET Estado=', 0,' WHERE IDCultura=', @idcultura);
        PREPARE `stmt` FROM @`sql`;
        EXECUTE `stmt`;
    END IF;

    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Procedure AlterarIntervalo
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `AlterarIntervalo` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `AlterarIntervalo` (IN `NomeCultura` VARCHAR(50), IN NovoIntervalo INT(11))
BEGIN
    SELECT USER() INTO @caller;
    SET @caller := SUBSTRING_INDEX(@caller,'@',2),
        @caller := CONCAT("'", @caller, "'"),
        @nome_cultura := CONCAT("'", `NomeCultura`, "'"),
        @novo_intervalo := CONCAT("'", NovoIntervalo, "'");

    SET @`sql` = CONCAT('SELECT u.IDUtilizador INTO @utilizador FROM utilizador u WHERE u.EmailUtilizador=', @caller);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT c.IDUtilizador INTO @delegated_to FROM cultura c WHERE c.NomeCultura=', @nome_cultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF ((NOT STRCMP(@utilizador,@delegated_to) = 0) OR (@utilizador IS NULL)) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Só pode alterar o intervalo entre alertas das suas culturas.";
    END IF;

    SET @utilizador := CONCAT("'", @utilizador, "'");

    SET @`sql` = CONCAT('SELECT c.IDCultura INTO @idcultura FROM cultura c WHERE c.IDUtilizador=', @utilizador,' AND c.NomeCultura=', @nome_cultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @idcultura := CONCAT("'", @idcultura, "'");

    SET @`sql` = CONCAT('SELECT c.Intervalo INTO @intervalo FROM cultura c WHERE c.IDUtilizador=', @utilizador,' AND c.NomeCultura=', @nome_cultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF NovoIntervalo<1 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Escolha um valor entre 1 e 60 minutos.";
    END IF;

    IF NovoIntervalo>60 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Escolha um valor entre 1 e 60 minutos.";
    END IF;

	SET @`sql` = CONCAT('UPDATE cultura SET Intervalo=', @novo_intervalo,' WHERE IDCultura=', @idcultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Procedure AlterarCultura
--

DELIMITER $$

DROP PROCEDURE IF EXISTS `AlterarCultura` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `AlterarCultura` (IN `NomeCultura` VARCHAR(50), IN `NovoNomeCultura` VARCHAR(50))
BEGIN
    SELECT USER() INTO @caller;
    SET @caller := SUBSTRING_INDEX(@caller,'@',2),
        @caller := CONCAT("'", @caller, "'"),
        @nome_cultura := CONCAT("'", `NomeCultura`, "'"),
        @novo_nome := CONCAT("'", `NovoNomeCultura`, "'");

    SET @`sql` = CONCAT('SELECT u.IDUtilizador INTO @utilizador FROM utilizador u WHERE u.EmailUtilizador=', @caller);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT c.IDUtilizador INTO @delegated_to FROM cultura c WHERE c.NomeCultura=', @nome_cultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF ((NOT STRCMP(@utilizador,@delegated_to) = 0) OR (@utilizador IS NULL)) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Só pode alterar o nome das suas culturas.";
    END IF;

    SET @utilizador := CONCAT("'", @utilizador, "'");

    SET @`sql` = CONCAT('SELECT c.IDCultura INTO @idcultura FROM cultura c WHERE c.IDUtilizador=', @utilizador,' AND c.NomeCultura=', @nome_cultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @idcultura := CONCAT("'", @idcultura, "'");

    SET @`sql` = CONCAT('SELECT COUNT(*) INTO @checks FROM cultura WHERE IDUtilizador=', @utilizador,' AND NomeCultura=', @novo_nome);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF (@checks = 1) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Nome já está em uso, tente outro.";
    END IF;

	SET @`sql` = CONCAT('UPDATE cultura SET NomeCultura=', @novo_nome,' WHERE IDCultura=', @idcultura);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

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
CREATE DEFINER=`root`@`localhost`
PROCEDURE InserirMedicao(zona INT(11), sensor INT(11), tiposensor CHAR(1), date_time TIMESTAMP, measurement DECIMAL(5,2), id VARCHAR(50))
BEGIN
    INSERT INTO medicao(IDMedicao, IDZona, IDSensor, TipoSensor, Valor, Datetime)
    VALUES (id, zona, sensor, tiposensor, measurement, date_time);
END $$

DELIMITER ;

-- --------------------------------------------------------

--
-- Trigger DesatribuirCultura (quando é apagado um utilizador)
--

DELIMITER $$

DROP TRIGGER IF EXISTS `DesatribuirCultura` $$
CREATE DEFINER=`root`@`localhost`
TRIGGER `DesatribuirCultura` BEFORE DELETE ON `utilizador` FOR EACH ROW
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        SET FOREIGN_KEY_CHECKS = 1;
    DECLARE EXIT HANDLER FOR SQLWARNING
        SET FOREIGN_KEY_CHECKS = 1;
    DECLARE EXIT HANDLER FOR NOT FOUND
        SET FOREIGN_KEY_CHECKS = 1;

    SET FOREIGN_KEY_CHECKS = 0;
    UPDATE cultura
    SET IDUtilizador = "NÃO_ATRIBUÍDA", Estado = 0
    WHERE IDUtilizador = OLD.IDUtilizador;
    SET FOREIGN_KEY_CHECKS = 1;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Trigger AlertaTolerancias
--

DELIMITER $$

DROP TRIGGER IF EXISTS `AlertaTolerancias` $$
CREATE DEFINER=`root`@`localhost`
TRIGGER `AlertaTolerancias` BEFORE INSERT ON `medicao` FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE id_cultura VARCHAR(50);
    DECLARE estado_ INT(11);
    DECLARE utilizador VARCHAR(50);
    DECLARE TolMin DECIMAL(5,2);
    DECLARE TolMax DECIMAL(5,2);
    DECLARE prev INT(11);
    DECLARE spacing INT(11);
    DECLARE nome_cultura VARCHAR(50);
    DECLARE cur1 CURSOR FOR SELECT IDCultura, Estado, IDUtilizador FROM cultura WHERE IDZona = NEW.IDZona;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur1;

    alert_loop: LOOP
        FETCH cur1 INTO id_cultura, estado_, utilizador;

        IF done THEN
            LEAVE alert_loop;
        END IF;

        IF (estado_ = 1 AND NOT STRCMP("NÃO_ATRIBUÍDA", utilizador) = 0) THEN

            SELECT ToleranciaMax, ToleranciaMin INTO TolMax, TolMin FROM parametrocultura WHERE IDCultura = id_cultura AND TipoSensor = NEW.TipoSensor;
            SELECT NomeCultura INTO nome_cultura FROM cultura WHERE IDCultura = id_cultura;
            SELECT Intervalo INTO spacing FROM cultura WHERE IDCultura = id_cultura;
            SELECT COUNT(*) INTO prev FROM alerta WHERE IDCultura = id_cultura AND TipoAlerta = "T" AND Datetime >= now() - interval spacing minute;

            IF (prev = 0) THEN
                IF (NEW.Valor <= TolMin) THEN
                    INSERT INTO alerta(IDAlerta, IDZona, NomeCultura, IDCultura, IDUtilizador, IDSensor, TipoSensor, TipoAlerta, Datetime, Valor, Mensagem)
                    VALUES (uuid(), NEW.IDZona, nome_cultura, id_cultura, utilizador, NEW.IDSensor, NEW.TipoSensor, 'T', CURRENT_TIMESTAMP, NEW.Valor, "Medição excedeu tolerância mínima.");
                ELSEIF (NEW.Valor >= TolMax) THEN
                    INSERT INTO alerta(IDAlerta, IDZona, NomeCultura, IDCultura, IDUtilizador, IDSensor, TipoSensor, TipoAlerta, Datetime, Valor, Mensagem)
                    VALUES (uuid(), NEW.IDZona, nome_cultura, id_cultura, utilizador, NEW.IDSensor, NEW.TipoSensor, 'T', CURRENT_TIMESTAMP, NEW.Valor, "Medição excedeu tolerância máxima.");
                END IF;
            END IF;
        END IF;
    END LOOP alert_loop;

    CLOSE cur1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Trigger AlertaValores
--

DELIMITER $$

DROP TRIGGER IF EXISTS `AlertaValores` $$
CREATE DEFINER=`root`@`localhost`
TRIGGER `AlertaValores` BEFORE INSERT ON `medicao` FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE id_cultura VARCHAR(50);
    DECLARE estado_ INT(11);
    DECLARE utilizador VARCHAR(50);
    DECLARE ValMin DECIMAL(5,2);
    DECLARE ValMax DECIMAL(5,2);
    DECLARE prev INT(11);
    DECLARE spacing INT(11);
    DECLARE nome_cultura VARCHAR(50);
    DECLARE cur1 CURSOR FOR SELECT IDCultura, Estado, IDUtilizador FROM cultura WHERE IDZona = NEW.IDZona;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur1;

    alert_loop: LOOP
        FETCH cur1 INTO id_cultura, estado_, utilizador;

        IF done THEN
            LEAVE alert_loop;
        END IF;

        IF (estado_ = 1 AND NOT STRCMP("NÃO_ATRIBUÍDA", utilizador) = 0) THEN

            SELECT ValorMax, ValorMin INTO ValMax, ValMin FROM parametrocultura WHERE IDCultura = id_cultura AND TipoSensor = NEW.TipoSensor;
            SELECT NomeCultura INTO nome_cultura FROM cultura WHERE IDCultura = id_cultura;
            SELECT Intervalo INTO spacing FROM cultura WHERE IDCultura = id_cultura;
            SELECT COUNT(*) INTO prev FROM alerta WHERE IDCultura = id_cultura AND TipoAlerta = "V" AND Datetime >= now() - interval spacing minute;

            IF(prev = 0) THEN
                IF (NEW.Valor <= ValMin) THEN
                    INSERT INTO alerta(IDAlerta, IDZona, NomeCultura, IDCultura, IDUtilizador, IDSensor, TipoSensor, TipoAlerta, Datetime, Valor, Mensagem)
                    VALUES (uuid(), NEW.IDZona, nome_cultura, id_cultura, utilizador, NEW.IDSensor, NEW.TipoSensor, 'V', CURRENT_TIMESTAMP, NEW.Valor, "Medição excedeu valor mínimo do sensor.");
                ELSEIF (NEW.Valor >= ValMax) THEN
                    INSERT INTO alerta(IDAlerta, IDZona, NomeCultura, IDCultura, IDUtilizador, IDSensor, TipoSensor, TipoAlerta, Datetime, Valor, Mensagem)
                    VALUES (uuid(), NEW.IDZona, nome_cultura, id_cultura, utilizador, NEW.IDSensor, NEW.TipoSensor, 'V', CURRENT_TIMESTAMP, NEW.Valor, "Medição excedeu valor máximo do sensor.");
                END IF;
            END IF;
        END IF;
    END LOOP alert_loop;

    CLOSE cur1;
END$$

DELIMITER ;

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
GRANT EXECUTE ON PROCEDURE AlterarCultura TO Investigador;
GRANT EXECUTE ON PROCEDURE AlterarEstado TO Investigador;
GRANT EXECUTE ON PROCEDURE AlterarIntervalo TO Investigador;

-- --------------------------------------------------------

--
-- Role Técnico
--

DROP ROLE IF EXISTS Técnico;
CREATE ROLE Técnico;
GRANT SELECT ON estufa.sensor TO Técnico;
GRANT SELECT ON estufa.zona TO Técnico;
GRANT SELECT ON estufa.logs TO Técnico;

-- --------------------------------------------------------

--
-- Role Software
--

DROP ROLE IF EXISTS Software;
CREATE ROLE Software;
GRANT SELECT, UPDATE ON estufa.sensor TO Software;
GRANT SELECT, UPDATE ON estufa.zona TO Software;
GRANT SELECT, INSERT ON estufa.logs TO Software;
GRANT SELECT, INSERT ON estufa.medicao TO Software;
GRANT SELECT, INSERT ON estufa.alerta TO Software;
GRANT SELECT ON estufa.utilizador TO Software;
GRANT EXECUTE ON PROCEDURE InserirMedicao TO Software;

-- --------------------------------------------------------



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
CALL CriarAdministrador('Software','software@java.pt','software1234','Software');
CALL CriarUtilizador('InvestigadorA', 'a@estufa.pt', 'a', 'Investigador');
CALL CriarUtilizador('InvestigadorB', 'b@estufa.pt', 'b', 'Investigador');
CALL CriarUtilizador('InvestigadorC', 'c@estufa.pt', 'c', 'Investigador');
CALL CriarUtilizador('TécnicoA', 'aT@estufa.pt', 'aT', 'Técnico');

CALL CriarCultura('CulturaA1', '1');
CALL CriarCultura('CulturaB1', '1');
CALL CriarCultura('CulturaA2', '2');
CALL CriarCultura('CulturaB2', '2');
CALL CriarCultura('CulturaC1', '1');
CALL CriarCultura('CulturaC2', '2');

CALL AtribuirCultura('CulturaA1', 'a@estufa.pt');
CALL AtribuirCultura('CulturaB1', 'b@estufa.pt');
CALL AtribuirCultura('CulturaA2', 'a@estufa.pt');
CALL AtribuirCultura('CulturaB2', 'b@estufa.pt');

-- --------------------------------------------------------
