-- Evelyn Aguayo, Mariona Arenillas i Alexandra Sofronie

USE fitwell;
SET GLOBAL event_scheduler = ON;

DROP DATABASE IF EXISTS fitwell_backup;
CREATE DATABASE fitwell_backup;

DROP EVENT IF EXISTS backup_setmanal;
DELIMITER //
CREATE EVENT backup_setmanal
ON SCHEDULE
    EVERY 1 WEEK
    STARTS '2025-01-01 23:00:00'
    ENDS '2025-12-31 23:00:00'
DO
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE nom_taula VARCHAR(64);
    DECLARE cursor_taules CURSOR FOR
        SELECT table_name FROM information_schema.tables
        WHERE table_schema = 'fitwell';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET @data_sufix = DATE_FORMAT(CURDATE(), '%Y%m%d');

    OPEN cursor_taules;

    bucle: LOOP
        FETCH cursor_taules INTO nom_taula;
        IF done THEN
            LEAVE bucle;
        END IF;

        SET @sql = CONCAT(
            'CREATE TABLE fitwell_backup.', nom_taula, '_', @data_sufix,
            ' AS SELECT * FROM fitwell.', nom_taula
        );
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END LOOP;

    CLOSE cursor_taules;
END //

DELIMITER ;
