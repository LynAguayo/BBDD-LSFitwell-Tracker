-- Evelyn Aguayo, Mariona Arenillas i Alexandra Sofronie
USE fitwell;
DELIMITER $$
DROP PROCEDURE IF EXISTS actualitzar_MD_activitat$$
CREATE PROCEDURE actualitzar_MD_activitat()
BEGIN
    DECLARE nom_tmp VARCHAR(50);
    DECLARE done INT DEFAULT FALSE;

    DECLARE cur CURSOR FOR
        SELECT DISTINCT
            LOWER(TRIM(COALESCE(NULLIF(tipus_activitat, ''), 'activitat_desconeguda')))
        FROM activitats_raw;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    lectura: LOOP
        FETCH cur INTO nom_tmp;
        IF done THEN
            LEAVE lectura;
        END IF;

        IF NOT EXISTS (
            SELECT 1 FROM MD_activitat WHERE nom = nom_tmp
        ) THEN
            INSERT INTO MD_activitat (nom, descripcio)
            VALUES (nom_tmp, CONCAT('Descripcio automatica per a "', nom_tmp, '"'));
        END IF;
    END LOOP;

    CLOSE cur;
END $$

DELIMITER ;

-- Executar el procedure
CALL actualitzar_MD_activitat();