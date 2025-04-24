-- Eliminar si ja existeix
DROP TABLE IF EXISTS MD_activitat;

-- Crear la taula de catàleg
CREATE TABLE MD_activitat (
    id_activitat INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    descripcio TEXT
);

-- Afegir algunes activitats inicials
INSERT INTO MD_activitat (nom, descripcio) VALUES
('caminar', 'Activitat física bàsica de caminar'),
('córrer', 'Activitat cardiovascular intensa'),
('bicicleta', 'Ciclisme, pot ser estàtic o en ruta'),
('ioga', 'Activitat de relaxació i flexibilitat'),
('natació', 'Esport aquàtic que treballa tot el cos');

-- Modificar activitats_net
ALTER TABLE activitats_net  
    ADD COLUMN id_activitat INT;  -- Agregar la nueva columna para la clave foránea

-- Afegir la clau forana a la nova columna
ALTER TABLE activitats_net
    ADD CONSTRAINT fk_tipus_activitat FOREIGN KEY (id_activitat) REFERENCES MD_activitat(id_activitat);

-- Actualitzar la columna id_activitat basada en tipus_activitat
UPDATE activitats_net an
JOIN MD_activitat ma ON an.tipus_activitat = ma.nom
SET an.id_activitat = ma.id_activitat;