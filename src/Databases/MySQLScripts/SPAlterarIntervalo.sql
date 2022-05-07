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