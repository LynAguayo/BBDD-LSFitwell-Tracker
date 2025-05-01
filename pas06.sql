-- Evelyn Aguayo, Mariona Arenillas i Alexandra Sofronie
USE fitwell;

-- Definición de la tabla log_insercions
DROP TABLE IF EXISTS log_insercions;
CREATE TABLE log_insercions (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_registre INT,
    usuari_mysql VARCHAR(100),
    timestamp_insercio DATETIME
);

-- Definición del trigger trg_log_insercio
DROP TRIGGER IF EXISTS trg_log_insercio;
DELIMITER $$
CREATE TRIGGER trg_log_insercio
AFTER INSERT ON activitats_net
FOR EACH ROW
BEGIN
    INSERT INTO log_insercions (id_registre, usuari_mysql, timestamp_insercio)
    VALUES (NEW.id_registre, CURRENT_USER(), NOW());
END $$
DELIMITER ;

-- Elimina dades anteriors
-- TRUNCATE TABLE log_insercions;
-- TRUNCATE TABLE activitats_net;
-- TRUNCATE TABLE activitats_raw;

-- Cargar les dades a la taula activitats_raw
LOAD DATA INFILE 'C:/Users/level/Desktop/LSFitwell/activitats_pas06.csv'
INTO TABLE activitats_raw
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_usuari, data_activitat, hora_inici, durada_minuts, tipus_activitat, calories, dispositiu);

-- 4. Filtrar les dades a la taula activitats_net 
CALL netejar_dades_activitat('activitats_pas06.csv');

-- 5. Crear la clave foránea DESPUÉS de cargar los datos
ALTER TABLE log_insercions ADD FOREIGN KEY (id_registre) REFERENCES activitats_net(id_registre);

-- 6. Comprovar el trigger trg_log_insercio
SELECT * FROM log_insercions ORDER BY timestamp_insercio DESC;

-- 7. Definición de la tabla auditoria_MD_activitat
DROP TABLE IF EXISTS auditoria_MD_activitat;
CREATE TABLE auditoria_MD_activitat (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_activitat INT,
    nom_antic VARCHAR(50),
    nom_nou VARCHAR(50),
    descripcio_antiga TEXT,
    descripcio_nova TEXT,
    tipus_operacio ENUM('MODIFICACIO', 'ESBORRAT') NOT NULL,
    usuari VARCHAR(100) NOT NULL,
    data_operacio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Definició dels triggers per MD_activitat
DROP TRIGGER IF EXISTS trg_MD_activitat_update;
DELIMITER //
CREATE TRIGGER trg_MD_activitat_update
AFTER UPDATE ON MD_activitat
FOR EACH ROW
BEGIN
    IF OLD.nom <> NEW.nom OR OLD.descripcio <> NEW.descripcio THEN
        INSERT INTO auditoria_MD_activitat (
            id_activitat, nom_antic, nom_nou, descripcio_antiga, descripcio_nova,
            tipus_operacio, usuari
        )
        VALUES (
            OLD.id_activitat, OLD.nom, NEW.nom, OLD.descripcio, NEW.descripcio,
            'MODIFICACIO', CURRENT_USER()
        );
    END IF;
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trg_MD_activitat_delete;
DELIMITER //
CREATE TRIGGER trg_MD_activitat_delete
BEFORE DELETE ON MD_activitat
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_MD_activitat (
        id_activitat, nom_antic, nom_nou, descripcio_antiga, descripcio_nova,
        tipus_operacio, usuari
    )
    VALUES (
        OLD.id_activitat, OLD.nom, OLD.nom, OLD.descripcio, OLD.descripcio,
        'ESBORRAT', CURRENT_USER()
    );
END //
DELIMITER ;

-- 9. Proves de modificació i esborrat a la taula MD_activitat
UPDATE MD_activitat
SET descripcio = 'Activitat suau de caminar diariament', nom = 'Caminada'
WHERE nom = 'caminar';

DELETE FROM MD_activitat
WHERE nom = 'natacio';

-- 10. Comprovar la taula d'auditoria
SELECT * FROM auditoria_MD_activitat;