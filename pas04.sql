-- Evelyn Aguayo, Mariona Arenillas i Alexandra Sofronie
USE fitwell;
DROP TABLE IF EXISTS MD_activitat;
CREATE TABLE MD_activitat (
    id_activitat INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    descripcio TEXT
);

INSERT INTO MD_activitat (nom, descripcio) VALUES
('caminar', 'Activitat fisica basica de caminar'),
('correr', 'Activitat cardiovascular intensa'),
('bicicleta', 'Ciclisme, pot ser estatic o en ruta'),
('ioga', 'Activitat de relaxacio i flexibilitat'),
('natacio', 'Esport aquatic que treballa tot el cos');

ALTER TABLE activitats_net ADD COLUMN id_activitat INT;

ALTER TABLE activitats_net ADD CONSTRAINT fk_tipus_activitat FOREIGN KEY (id_activitat) REFERENCES MD_activitat(id_activitat) ON UPDATE CASCADE ON DELETE CASCADE;

UPDATE activitats_net an
JOIN MD_activitat ma ON an.tipus_activitat = ma.nom
SET an.id_activitat = ma.id_activitat;