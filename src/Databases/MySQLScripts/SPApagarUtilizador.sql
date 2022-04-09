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