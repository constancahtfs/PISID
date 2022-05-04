DELIMITER $$

DROP TRIGGER IF EXISTS `AlertaValores` $$
CREATE DEFINER=`root`@`localhost`
TRIGGER `AlertaValores` BEFORE INSERT ON `medicao` FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE id_cultura VARCHAR(50);
    DECLARE estado_ INT(11);
    DECLARE utilizador VARCHAR(50);
    DECLARE ValMin DECIMAL(5,2);
    DECLARE ValMax DECIMAL(5,2);
    DECLARE nome_cultura VARCHAR(50);
    DECLARE cur1 CURSOR FOR SELECT IDCultura, Estado, IDUtilizador FROM cultura WHERE IDZona = NEW.IDZona;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur1;

    alert_loop: LOOP
        FETCH cur1 INTO id_cultura, estado_, utilizador;

        IF done THEN
            LEAVE alert_loop;
        END IF;

        IF (estado_ = 1 AND NOT STRCMP("NÃO_ATRIBUÍDA", utilizador) = 0) THEN

            SELECT ValorMax, ValorMin INTO ValMax, ValMin FROM parametrocultura WHERE IDCultura = id_cultura AND TipoSensor = NEW.TipoSensor;
            SELECT NomeCultura INTO nome_cultura FROM cultura WHERE IDCultura = id_cultura;

            IF (NEW.Valor <= ValMin) THEN
                INSERT INTO alerta(IDAlerta, IDZona, NomeCultura, IDCultura, IDUtilizador, IDSensor, TipoSensor, TipoAlerta, Datetime, Valor, Mensagem)
                VALUES (uuid(), NEW.IDZona, nome_cultura, id_cultura, utilizador, NEW.IDSensor, NEW.TipoSensor, 'V', CURRENT_TIMESTAMP, NEW.Valor, "Medição excedeu valor mínimo do sensor.");
            ELSEIF (NEW.Valor >= ValMax) THEN
                INSERT INTO alerta(IDAlerta, IDZona, NomeCultura, IDCultura, IDUtilizador, IDSensor, TipoSensor, TipoAlerta, Datetime, Valor, Mensagem)
                VALUES (uuid(), NEW.IDZona, nome_cultura, id_cultura, utilizador, NEW.IDSensor, NEW.TipoSensor, 'V', CURRENT_TIMESTAMP, NEW.Valor, "Medição excedeu valor máximo do sensor.");
            END IF;
        END IF;
    END LOOP alert_loop;

    CLOSE cur1;
END$$

DELIMITER ;