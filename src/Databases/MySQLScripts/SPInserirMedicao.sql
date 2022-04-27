DELIMITER $$

DROP PROCEDURE IF EXISTS `InserirMedicao` $$
CREATE DEFINER=`Software`@`localhost`
PROCEDURE InserirMedicao(zona INT(11), sensor INT(11), tiposensor CHAR(1), date_time TIMESTAMP, measurement DECIMAL(5,2))
BEGIN
	SELECT *  FROM medicao;
    INSERT INTO medicao(IDMedicao, IDZona, IDSensor, TipoSensor, Valor, Datetime)
    VALUES (uuid(), zona, sensor, tiposensor, measurement, date_time);
END $$

DELIMITER ;