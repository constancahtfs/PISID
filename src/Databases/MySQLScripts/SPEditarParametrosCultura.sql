DELIMITER $$

DROP PROCEDURE IF EXISTS `AlterarParametrosCultura`
$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AlterarParametrosCultura` (IN `p_ID` VARCHAR(50), IN `p_Sensor` CHAR(1), IN `p_ValorMax` DECIMAL(5,2), IN `p_ValorMin` DECIMAL(5,2), IN `p_TolMax` DECIMAL(5,2), IN `p_TolMin` DECIMAL(5,2))  BEGIN

    UPDATE parametrocultura
    SET ValorMax = `p_ValorMax`, ValorMin = `p_ValorMin`, ToleranciaMax = `p_TolMax`, ToleranciaMin = `p_TolMin`
    WHERE TipoSensor = `p_Sensor` AND IDCultura = `p_ID`;

END$$

DELIMITER ;