DELIMITER $$

DROP PROCEDURE IF EXISTS `CriarUtilizador` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `CriarUtilizador` (IN `nome` VARCHAR(150), IN `email` VARCHAR(64), IN `pass` VARCHAR(64), IN `role` ENUM('Investigador', 'Técnico'))
BEGIN
    SET `email` := CONCAT("'", `email`, "'"),
        `pass` := CONCAT("'", `pass`, "'");


    SET @`sql` := CONCAT('CREATE USER IF NOT EXISTS ', `email`, ' IDENTIFIED BY ', `pass`);
	PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET @`sql` := CONCAT('GRANT ', `role`, ' TO ', `email`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET @`sql` := CONCAT('SET DEFAULT ROLE ', `role`, ' FOR ', `email`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET `nome` := REPLACE(`nome`,'''',''),
        `email` := REPLACE(`email`,'''',''),
        @role := CAST(`role` as CHAR);

    SET @final = SUBSTR(role, 1, 1);

    INSERT INTO utilizador(IDUtilizador, NomeUtilizador, EmailUtilizador, TipoUtilizador)
    VALUES (uuid(), `nome`, `email`, @final);

    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;