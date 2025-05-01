-- Evelyn Aguayo, Mariona Arenillas i Alexandra Sofronie

-- Activar l'event scheduler
SET GLOBAL event_scheduler = ON;

-- Crear la base de dades de backup si no existeix
CREATE DATABASE IF NOT EXISTS lsfit_backup;

-- Crear l'event de còpia setmanal
DELIMITER //

CREATE EVENT backup_setmanal
ON SCHEDULE
    EVERY 1 WEEK
    STARTS '2025-01-05 23:00:00'
    ENDS '2025-12-28 23:00:00'
DO
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE nom_taula VARCHAR(64);
    DECLARE cursor_taules CURSOR FOR
        SELECT table_name FROM information_schema.tables
        WHERE table_schema = 'lsfit';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET @data_sufix = DATE_FORMAT(CURDATE(), '%Y%m%d');

    OPEN cursor_taules;

    bucle: LOOP
        FETCH cursor_taules INTO nom_taula;
        IF done THEN
            LEAVE bucle;
        END IF;

        SET @sql = CONCAT(
            'CREATE TABLE lsfit_backup.', nom_taula, '_', @data_sufix,
            ' AS SELECT * FROM lsfit.', nom_taula
        );
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END LOOP;

    CLOSE cursor_taules;
END //

DELIMITER ;
