DELIMITER //

CREATE PROCEDURE InsertMedicao(zona INT(11), sensor INT(11), date_time TIMESTAMP, measurement DECIMAL(5,2))
BEGIN
	SELECT *  FROM medicao;
    insert into medicao(IDMedicao, IDSensor, IDZona, Valor, Datetime)
    values
    (uuid(), sensor, zona, measurement, date_time);
END //

DELIMITER ;