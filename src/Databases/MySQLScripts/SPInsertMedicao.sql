DELIMITER //

CREATE DEFINER=`Software`@`localhost` PROCEDURE InsertMedicao(zona INT(11), sensor INT(11), tiposensor CHAR(1), date_time TIMESTAMP, measurement DECIMAL(5,2))
BEGIN
	SELECT *  FROM medicao;
    insert into medicao(IDMedicao, IDSensor, TipoSensor, IDZona, Valor, Datetime)
    values
    (uuid(), sensor, tiposensor, zona, measurement, date_time);
END //

DELIMITER ;