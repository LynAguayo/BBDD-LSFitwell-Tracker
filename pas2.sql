DROP TABLE IF EXISTS activitats_net;
CREATE TABLE activitats_net (
    id_registre INT AUTO_INCREMENT PRIMARY KEY,
    id_usuari INT NOT NULL,
    data_activitat DATE NOT NULL,
    hora_inici TIME NOT NULL,
    durada_minuts INT NOT NULL,
    tipus_activitat VARCHAR(50) NOT NULL,
    calories INT NOT NULL,
    dispositiu VARCHAR(50) NOT NULL,
    es_cap_setmana BOOLEAN NOT NULL,
    INDEX idx_data (data_activitat),
    INDEX idx_usuari (id_usuari)
);

DELIMITER //
CREATE PROCEDURE netejar_dades_activitat()
BEGIN
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
        (DAYOFWEEK(data_activitat) = 1) OR (DAYOFWEEK(data_activitat) = 7) AS es_cap_setmana
    FROM 
        activitats_raw
    WHERE 
        data_activitat = DATE_SUB(CURDATE(), INTERVAL 1 DAY);
    
    SELECT 
        COUNT(*) AS registres_processats,
        SUM(es_cap_setmana) AS activitats_cap_setmana,
        SUM(NOT es_cap_setmana) AS activitats_dia_setmana
    FROM 
        activitats_net;
END //
DELIMITER ;


-- CALL netejar_dades_activitat();

-- SELECT * FROM activitats_net;
