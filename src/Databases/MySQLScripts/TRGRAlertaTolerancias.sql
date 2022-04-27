DELIMITER $$

DROP TRIGGER IF EXISTS `AlertaTolerancias` $$
CREATE DEFINER=`root`@`localhost`
TRIGGER `AlertaTolerancias` BEFORE INSERT ON `medicao` FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE id_cultura VARCHAR(50);
    DECLARE estado_ INT(11);
    DECLARE utilizador VARCHAR(50);
    DECLARE TolMin INT(11);
    DECLARE TolMax INT(11);
    DECLARE cur1 CURSOR FOR SELECT IDCultura, Estado, IDUtilizador FROM cultura WHERE IDZona = NEW.IDZona;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur1;

    alert_loop: LOOP
        FETCH cur1 INTO id_cultura, estado_, utilizador;

        IF done THEN
            LEAVE alert_loop;
        END IF;

        IF (estado_ = 1 AND NOT STRCMP("NÃO_ATRIBUÍDA", utilizador) = 0) THEN

            SELECT ToleranciaMax, ToleranciaMin INTO TolMax, TolMin FROM parametrocultura WHERE IDCultura = id_cultura AND TipoSensor = NEW.TipoSensor;

            IF (NEW.Valor <= TolMin OR NEW.Valor >= TolMax) THEN
                INSERT INTO alerta(IDAlerta, IDZona, IDCultura, IDSensor, TipoAlerta, Datetime, Valor, Mensagem)
                VALUES (uuid(), NEW.IDZona, id_cultura, NEW.IDSensor, 'T', CURRENT_TIMESTAMP, NEW.Valor, "Medição excedeu tolerância da cultura.");
            END IF;
        END IF;
    END LOOP alert_loop;

    CLOSE cur1;
END$$

DELIMITER ;