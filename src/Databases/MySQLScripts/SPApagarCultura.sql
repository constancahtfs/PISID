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