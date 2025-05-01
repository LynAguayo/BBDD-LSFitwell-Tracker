-- Evelyn Aguayo, Mariona Arenillas i Alexandra Sofronie
USE fitwell;
DROP TABLE IF EXISTS control_carregues;
CREATE TABLE control_carregues (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_fitxer VARCHAR(255),
    files_insertades INT,
    data_carrega DATE,
    hora_carrega TIME
);

DELIMITER $$
DROP PROCEDURE IF EXISTS netejar_dades_activitat$$
CREATE PROCEDURE netejar_dades_activitat(IN nom_fitxer VARCHAR(255))
BEGIN
    DECLARE registres_afegits INT;

    TRUNCATE TABLE activitats_net;

    INSERT INTO activitats_net (
        id_usuari,
        data_activitat,
        hora_inici,
        durada_minuts,
        tipus_activitat,
        calories,
        dispositiu,
        es_cap_setmana
    )
    SELECT
        id_usuari,
        data_activitat,
        hora_inici,
        durada_minuts,
        tipus_activitat,
        calories,
        dispositiu,
        (DAYOFWEEK(data_activitat) = 1 OR DAYOFWEEK(data_activitat) = 7)
    FROM
        activitats_raw
    WHERE
        data_activitat = DATE_SUB(CURDATE(), INTERVAL 1 DAY);

    SET registres_afegits = ROW_COUNT();

    -- Inserir registre de control
    INSERT INTO control_carregues (nom_fitxer, files_insertades, data_carrega, hora_carrega)
    VALUES (nom_fitxer, registres_afegits, CURDATE(), CURTIME());

    -- Informació de resum
    SELECT
        COUNT(*) AS registres_processats,
        SUM(es_cap_setmana) AS activitats_cap_setmana,
        SUM(NOT es_cap_setmana) AS activitats_dia_setmana
    FROM
        activitats_net;
END $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS exportar_control_carregues$$
CREATE PROCEDURE exportar_control_carregues()
BEGIN
    SET @query = "
        SELECT * FROM control_carregues 
        INTO OUTFILE 'C:/Users/level/Desktop/LSFitwell/control_carregues.csv'
        FIELDS TERMINATED BY ',' 
        LINES TERMINATED BY '\n'
    ";

    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END $$

DELIMITER ;

-- Executar els procedure 
CALL netejar_dades_activitat('activitats.csv');
CALL exportar_control_carregues();
