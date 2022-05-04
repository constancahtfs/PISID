DELIMITER $$

DROP PROCEDURE IF EXISTS `InserirMedicao` $$
CREATE DEFINER=`root`@`localhost`
PROCEDURE InserirMedicao(zona INT(11), sensor INT(11), tiposensor CHAR(1), date_time TIMESTAMP, measurement DECIMAL(5,2), id VARCHAR(50))
BEGIN
    INSERT INTO medicao(IDMedicao, IDZona, IDSensor, TipoSensor, Valor, Datetime)
    VALUES (id, zona, sensor, tiposensor, measurement, date_time);
END $$

DELIMITER ;