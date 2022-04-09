DELIMITER $$

DROP PROCEDURE IF EXISTS `ApagarUtilizador` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `ApagarUtilizador` (IN `email` VARCHAR(150))
BEGIN
    SET `role` := "";
    SELECT u.TipoUtilizador INTO `role` FROM utilizador u WHERE u.EmailUtilizador=email;

    IF STRCMP("A",`role`) = 0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Não pode apagar Administradores";
    END IF;


    DELETE FROM utilizador WHERE EmailUtilizador=email;


    SET @`sql` := CONCAT('DROP USER IF EXISTS ', `email`);
	PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;