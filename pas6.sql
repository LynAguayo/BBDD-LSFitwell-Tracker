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

-- Crear taula d'auditoria per registrar modificacions i esborrats
DROP TABLE IF EXISTS auditoria_MD_activitat;

CREATE TABLE auditoria_MD_activitat (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_activitat INT,
    nom_antic VARCHAR(50),
    descripcio_antiga TEXT,
    tipus_operacio ENUM('MODIFICACIÓ', 'ESBORRAT') NOT NULL,
    usuari VARCHAR(100) NOT NULL,
    data_operacio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger per a modificacions 
DELIMITER //

CREATE TRIGGER trg_MD_activitat_update
AFTER UPDATE ON MD_activitat
FOR EACH ROW
BEGIN
    IF OLD.nom <> NEW.nom OR OLD.descripcio <> NEW.descripcio THEN
        INSERT INTO auditoria_MD_activitat (
            id_activitat, nom_antic, descripcio_antiga,
            tipus_operacio, usuari
        )
        VALUES (
            OLD.id_activitat, OLD.nom, OLD.descripcio,
            'MODIFICACIÓ', CURRENT_USER()
        );
    END IF;
END //

DELIMITER ;

-- Trigger per a esborrats
DELIMITER //

CREATE TRIGGER trg_MD_activitat_delete
BEFORE DELETE ON MD_activitat
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_MD_activitat (
        id_activitat, nom_antic, descripcio_antiga,
        tipus_operacio, usuari
    )
    VALUES (
        OLD.id_activitat, OLD.nom, OLD.descripcio,
        'ESBORRAT', CURRENT_USER()
    );
END //

DELIMITER ;

-- Fer modificacions i esborrats per comprovar que els triggers funcionen  
-- Exemple de modificació
UPDATE MD_activitat
SET descripcio = 'Activitat suau de caminar diàriament'
WHERE nom = 'caminar';

-- Exemple d’esborrat
DELETE FROM MD_activitat
WHERE nom = 'natació';

-- Consulta per verificar
SELECT * FROM auditoria_MD_activitat;
