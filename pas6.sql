-- Crear una nova taula de registre per guardar les insercions a activitats_net:
CREATE TABLE log_insercions (
    id_log INT AUTO_INCREMENT PRIMARY KEY, 
    id_registre INT, 
    usuari_mysql VARCHAR(100),
    timestamp_insercio DATETIME
);

-- Crear un trigger que afegeix una entrada a log_insercions cada cop que es fa una inserció: 
DELIMITER $$
CREATE TRIGGER trg_log_insercio
AFTER INSERT ON activitats_net
FOR EACH ROW 
BEGIN
    INSERT INTO log_insercions (id_registre, usuari_mysql, timestamp_insercio)
    VALUES (NEW.id_registre, CURRENT_USER(), NOW());
END $$

DELIMITER ;

-- Carregar les dades del CSV 
LOAD DATA INFILE '"C:/Users/level/Desktop/BBDD-Trigger i eventos/activitats2.csv"'
INTO TABLE activitats_net
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- ignoramos la primera línea
(id_usuari, data_activitat, hora_inici, durada_minuts, tipus_activitat, calories, dispositiu)
SET es_cap_setmana = DAYOFWEEK(data_activitat) IN (1, 7);

-- Comprovar el funcionament
SELECT * FROM log_insercions ORDER BY timestamp_insercio DESC; 