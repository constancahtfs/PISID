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