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
    DROP COLUMN tipus_activitat;

-- Afegir el nou camp i clau forana
ALTER TABLE activitats_net
    ADD id_activitat INT,
    ADD CONSTRAINT fk_tipus_activitat FOREIGN KEY (id_activitat) REFERENCES MD_activitat(id_activitat);

