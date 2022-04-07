DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `EditarParametroCultura` (IN `IDCultura` VARCHAR(50), IN `TipoSensor` CHAR(1), IN `ValorMax` DECIMAL(5,2), IN `ValorMin` DECIMAL(5,2), IN `ToleranciaMax` DECIMAL(5,2), IN `ToleranciaMin` DECIMAL(5,2) )  BEGIN
    SET
    `IDCultura` := CONCAT("'", `IDCultura`, "'"),
    `TipoSensor` := CONCAT("'", `TipoSensor`, "'"),
    `ValorMax` := CONCAT("'", `ValorMax`, "'"),
    `ValorMin` := CONCAT("'", `ValorMin`, "'"),
    `ToleranciaMax` := CONCAT("'", `ToleranciaMax`, "'"),
    `ToleranciaMin` := CONCAT("'", `ToleranciaMin`, "'");

/*
    SET
    `p_Nome` := REPLACE(`p_Nome`,'''',''),
    `p_Email` := REPLACE(`p_Email`,'''',''),
    `p_Role` := REPLACE(`p_Role`,'''',''),
    `p_Role` := SUBSTRING(`p_Role`, 1, 1);

*/

    INSERT INTO parametrocultura(IDCultura, TipoSensor, ValorMax, ValorMin, ToleranciaMax, ToleranciaMin)
    VALUES (`IDCultura`, `TipoSensor`, `ValorMax`, `ValorMin`, `ToleranciaMax`, `ToleranciaMin`);

    FLUSH PRIVILEGES;
END$$

DELIMITER ;







/* TENTEI E NÃO DEU BEM

CREATE PROCEDURE Masterinsertupdatedelete (@IDCultura     VARCHAR(50),
                                          @TipoSensor    CHAR(1),
                                          @ValorMax      DECIMAL(5,2),
                                          @ValorMin      DECIMAL(5, 2),
                                          @ToleranciaMax DECIMAL(5, 2),
                                          @ToleranciaMin DECIMAL(5, 2),
                                          @StatementType NVARCHAR(20) = '')

AS
    BEGIN
        IF @StatementType = 'INSERT'
            BEGIN
                INSERT INTO parametrocultura
                            (IDCultura,
                            TipoSensor,
                            ValorMax,
                            ValorMin,
                            ToleranciaMax,
                            ToleranciaMin)
                VALUES      (@IDCultura,
                            @TipoSensor,
                            @ValorMax,
                            @ValorMin,
                            @ToleranciaMax,
                            @ToleranciaMin)
            END

        IF @StatementType = 'UPDATE'
                BEGIN
                    UPDATE parametrocultura
                    SET    ValorMax = @ValorMax,
                           ValorMin = @ValorMin
                           ToleranciaMax = @ToleranciaMax
                           ToleranciaMin = @ToleranciaMin
                    WHERE  IDCultura = @IDCultura,
                           TipoSensor = @TipoSensor
                END
    END
*/