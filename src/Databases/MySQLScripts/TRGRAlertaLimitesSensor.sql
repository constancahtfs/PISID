DELIMITER $$

DROP TRIGGER IF EXISTS `AlertaLimitesSensor` $$
CREATE DEFINER=`root`@`localhost`
TRIGGER `AlertaLimitesSensor` BEFORE INSERT ON `medicao` FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tipo VARCHAR(50);
    DECLARE utilizador VARCHAR(50);
    DECLARE LimMin DECIMAL(5,2);
    DECLARE LimMax DECIMAL(5,2);
    DECLARE prev INT(11);
    DECLARE creds VARCHAR(50);
    DECLARE cur1 CURSOR FOR SELECT TipoUtilizador, IDUtilizador FROM utilizador WHERE TipoUtilizador = creds;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET creds = CONCAT("T", NEW.IDZona);

    OPEN cur1;

    alert_loop: LOOP
        FETCH cur1 INTO tipo, utilizador;

        IF done THEN
            LEAVE alert_loop;
        END IF;

        SELECT LimiteSuperior, LimiteInferior INTO LimMax, LimMin FROM sensor WHERE TipoSensor = NEW.TipoSensor AND IDZona = NEW.IDZona;
        SELECT COUNT(*) INTO prev FROM alerta WHERE TipoAlerta = "S" AND TipoSensor = NEW.TipoSensor AND IDUtilizador = utilizador AND Datetime >= now() - interval 1 minute;

        IF (prev = 0) THEN
            IF (NEW.Valor <= LimMin) THEN
                INSERT INTO alerta(IDAlerta, IDZona, NomeCultura, IDCultura, IDUtilizador, IDSensor, TipoSensor, TipoAlerta, Datetime, Valor, Mensagem)
                VALUES (uuid(), NEW.IDZona, DEFAULT, DEFAULT, utilizador, NEW.IDSensor, NEW.TipoSensor, 'S', CURRENT_TIMESTAMP, NEW.Valor, "Sensor ultrapassou valores mínimos!");
            ELSEIF (NEW.Valor >= LimMax) THEN
                INSERT INTO alerta(IDAlerta, IDZona, NomeCultura, IDCultura, IDUtilizador, IDSensor, TipoSensor, TipoAlerta, Datetime, Valor, Mensagem)
                VALUES (uuid(), NEW.IDZona, DEFAULT, DEFAULT, utilizador, NEW.IDSensor, NEW.TipoSensor, 'S', CURRENT_TIMESTAMP, NEW.Valor, "Sensor ultrapassou valores máximos!");
            END IF;
        END IF;
    END LOOP alert_loop;

    CLOSE cur1;
END$$

DELIMITER ;