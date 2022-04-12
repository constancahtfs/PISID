DELIMITER $$

DROP PROCEDURE IF EXISTS `InserirMedicao` $$
CREATE DEFINER=`Software`@`localhost`
PROCEDURE InserirMedicao(zona INT(11), sensor INT(11), tiposensor CHAR(1), date_time TIMESTAMP, measurement DECIMAL(5,2))
BEGIN
	SELECT *  FROM medicao;
    INSERT INTO medicao(IDMedicao, IDSensor, TipoSensor, IDZona, Valor, Datetime)
    VALUES
    (uuid(), sensor, tiposensor, zona, measurement, date_time);
END $$

DELIMITER ;