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