DELIMITER $$

DROP TRIGGER IF EXISTS `DesatribuirCultura` $$
CREATE DEFINER=`root`@`localhost`
TRIGGER `DesatribuirCultura` BEFORE DELETE ON `utilizador` FOR EACH ROW
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        RESIGNAL;
    DECLARE EXIT HANDLER FOR SQLWARNING
       RESIGNAL;
    DECLARE EXIT HANDLER FOR NOT FOUND
        RESIGNAL;

    SET FOREIGN_KEY_CHECKS = 0;
    UPDATE cultura
    SET IDUtilizador = "NÃO_ATRIBUÍDA"
    WHERE IDUtilizador = OLD.IDUtilizador;
    SET FOREIGN_KEY_CHECKS = 1;

END$$

DELIMITER ;