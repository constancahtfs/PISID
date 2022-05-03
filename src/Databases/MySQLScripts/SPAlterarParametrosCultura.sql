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
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Valor máximo não pode ser maior que tolerância máxima.";
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