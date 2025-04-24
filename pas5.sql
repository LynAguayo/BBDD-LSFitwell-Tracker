DELIMITER $$

CREATE PROCEDURE actualitzar_MD_activitat()
BEGIN
    DECLARE nom_tmp VARCHAR(50);
    DECLARE done INT DEFAULT FALSE;  -- Declaramos la variable 'done'

    -- Cursor per recórrer noms únics de tipus_activitat de activitats_raw
    DECLARE cur CURSOR FOR
        SELECT DISTINCT 
            LOWER(TRIM(COALESCE(NULLIF(tipus_activitat, ''), 'activitat_desconeguda')))
        FROM activitats_raw;

    -- Manejo del fin del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Abrir el cursor
    OPEN cur;

    lectura: LOOP
        FETCH cur INTO nom_tmp;
        IF done THEN
            LEAVE lectura;
        END IF;

        -- Comprobar si ya existe la actividad en MD_activitat
        IF NOT EXISTS (
            SELECT 1 FROM MD_activitat WHERE nom = nom_tmp
        ) THEN
            -- Insertar la nueva actividad con una descripción automática
            INSERT INTO MD_activitat (nom, descripcio)
            VALUES (nom_tmp, CONCAT('Descripció automàtica per a "', nom_tmp, '"'));
        END IF;
    END LOOP;

    -- Cerrar el cursor
    CLOSE cur;
END $$

DELIMITER ;