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