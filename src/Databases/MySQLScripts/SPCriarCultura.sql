DELIMITER $$

DROP PROCEDURE IF EXISTS `CriarCultura` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE `CriarCultura` (IN `nome_cultura` VARCHAR(150),  IN `IDZona` INT(11))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    ROLLBACK;
    SELECT 'An error has occurred, operation rollbacked and the stored procedure was terminated';

    SET @`sql` = CONCAT('SELECT COUNT(IDZona) INTO @zona FROM zona WHERE IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF @zona=0 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Zona não existe.";
    END IF;

    SET @`sql` = CONCAT('SELECT COUNT(NomeCultura) INTO @cultura FROM cultura WHERE NomeCultura=', `nome_cultura`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    IF @cultura=1 THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = "Não pode criar culturas com o mesmo nome.";
    END IF;


    SET @uuid = uuid();
    SET FOREIGN_KEY_CHECKS=0;
    INSERT INTO cultura(IDCultura, IDUtilizador, IDZona, NomeCultura, Estado)
    VALUES (@uuid, "NÃO_ATRIBUÍDA", `IDZona`, `nome_cultura`, 0);
    SET FOREIGN_KEY_CHECKS=1;


    SET @`sql` = CONCAT('SELECT s.LimiteSuperior INTO @TMax FROM sensor s WHERE s.TipoSensor = ''T'' AND s.IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT s.LimiteSuperior INTO @HMax FROM sensor s WHERE s.TipoSensor = ''H'' AND s.IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT s.LimiteSuperior INTO @LMax FROM sensor s WHERE s.TipoSensor = ''L'' AND s.IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT s.LimiteInferior INTO @TMin FROM sensor s WHERE s.TipoSensor = ''T'' AND s.IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT s.LimiteInferior INTO @HMin FROM sensor s WHERE s.TipoSensor = ''H'' AND s.IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;

    SET @`sql` = CONCAT('SELECT s.LimiteInferior INTO @LMin FROM sensor s WHERE s.TipoSensor = ''L'' AND s.IDZona=', `IDZona`);
    PREPARE `stmt` FROM @`sql`;
    EXECUTE `stmt`;


    INSERT INTO parametrocultura(IDCultura, TipoSensor, ValorMax, ValorMin, ToleranciaMax, ToleranciaMin)
    VALUES (@uuid, "T", @TMax, @TMin, 0, 0),
           (@uuid, "H", @HMax, @HMin, 0, 0),
           (@uuid, "L", @LMax, @LMin, 0, 0);


    DEALLOCATE PREPARE `stmt`;
    FLUSH PRIVILEGES;
END$$

DELIMITER ;