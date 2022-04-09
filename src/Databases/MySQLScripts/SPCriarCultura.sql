DELIMITER $$

CREATE DEFINER=`root`@`localhost`
PROCEDURE `CriarCultura` (IN `p_NomeCultura` VARCHAR(150), IN `p_EmailInvestigador` VARCHAR(64), IN `p_Zona` INT(1))
BEGIN
    SET
    `p_Nome` := CONCAT("'", `p_Nome`, "'"),
    `p_Email` := CONCAT("'", `p_Email`, "'"),
    `p_Pass` := CONCAT("'", `p_Pass`, "'"),
    `p_Role` := CONCAT("'", `p_Role`, "'");


    SET @`sql` := CONCAT('CREATE USER IF NOT EXISTS ', `p_Email`, ' IDENTIFIED BY ', `p_Pass`);
	PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET @`sql` := CONCAT('GRANT ', `p_Role`, ' TO ', `p_Email`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET @`sql` := CONCAT('SET DEFAULT ROLE ', `p_Role`, ' FOR ', `p_Email`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    SET
    `p_Nome` := REPLACE(`p_Nome`,'''',''),
    `p_Email` := REPLACE(`p_Email`,'''',''),
    `p_Role` := REPLACE(`p_Role`,'''',''),
    `p_Role` := SUBSTRING(`p_Role`, 1, 1);


    INSERT INTO utilizador(IDUtilizador, NomeUtilizador, EmailUtilizador, TipoUtilizador)
    VALUES (uuid(), `p_Nome`, `p_Email`, `p_Role`);


    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;