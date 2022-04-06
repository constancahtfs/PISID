DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EditarParametrosCultura` (IN `IDCultura` VARCHAR(50), IN `TipoSensor` VARCHAR(100), IN `ValorMax` DECIMAL(5,2), IN `ValorMin` DECIMAL(5,2), IN `ToleranciaMax` DECIMAL(5,2), IN `ToleranciaMin` DECIMAL(5,2))
    SET
    `IDCultura` := CONCAT("'", `IDCultura`, "'"),
    `TipoSensor` := CONCAT("'", `TipoSensor`, "'"),
    `ValorMax` := CONCAT("'", `ValorMax`, "'"),
    `ValorMin` := CONCAT("'", `ValorMin`, "'");
    `ToleranciaMax` := CONCAT("'", `ToleranciaMax`, "'");
    `ToleranciaMin` := CONCAT("'", `ToleranciaMin`, "'");

    SET
    `IDCultura` := REPLACE(`IDCultura`,'''',''),
    `TipoSnesor` := REPLACE(`TipoSensor`,'''',''),
    `ValorMax` := REPLACE(`ValorMax`,'''',''),
    `ValorMin` := REPLACE(`ValorMin`,'''',''),
    `TolearnciaMax` := REPLACE(`ToleranciaMax`,'''',''),
    `ToleranciaMin` := SUBSTRING(`ToleranciaMin`, 1, 1);

