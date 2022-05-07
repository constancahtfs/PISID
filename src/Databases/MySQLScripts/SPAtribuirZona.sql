DELIMITER $$

DROP PROCEDURE IF EXISTS `AtribuirZona` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `AtribuirZona` (IN `nro_zona` VARCHAR(50), IN `email_tecnico` VARCHAR(150))
BEGIN
    SET `email_tecnico` := CONCAT("'", `email_tecnico`, "'"),
        `nro_zona` := CONCAT("'", `nro_zona`, "'");

    SET @`sql` = CONCAT('SELECT COUNT(EmailUtilizador) INTO @tecnico FROM utilizador WHERE EmailUtilizador=', `email_tecnico`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF @tecnico=0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Utilizador não existe.";
    END IF;
    -- --------------------------------------------------------

    SET @`sql` = CONCAT('SELECT u.TipoUtilizador INTO @role FROM utilizador u WHERE u.EmailUtilizador=', `email_tecnico`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @role_check = SUBSTR(@role, 1, 1);

    IF NOT STRCMP("T",@role_check) = 0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Utilizador não é Técnico.";
    END IF;
    -- --------------------------------------------------------

    SET @`sql` = CONCAT('SELECT COUNT(IDZona) INTO @zona FROM zona WHERE IDZona=', `nro_zona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF @zona=0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Zona não existe.";
    END IF;
    -- --------------------------------------------------------

    SET @zone_check = SUBSTR(@role, 2, 1),
        `nro_zona` := REPLACE(`nro_zona`,'''','');

    IF STRCMP(`nro_zona`,@zone_check) = 0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Zona já está atribuída ao Técnico.";
    END IF;

    -- --------------------------------------------------------

    SET `email_tecnico` := REPLACE(`email_tecnico`,'''',''),
        @tipo = CONCAT(@role_check, `nro_zona`);

    UPDATE utilizador
    SET TipoUtilizador=@tipo
    WHERE EmailUtilizador = email_tecnico;


    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;