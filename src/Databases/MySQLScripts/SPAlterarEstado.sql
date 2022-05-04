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