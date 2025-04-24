-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS fitwell;
USE fitwell;

-- Crear la tabla temporal para cargar los datos crudos del CSV
CREATE TABLE activitats_raw (
    id_usuari INT,
    data_activitat DATE,
    hora_inici TIME,
    durada_minuts INT,
    tipus_activitat VARCHAR(50),
    calories INT,
    dispositiu VARCHAR(50)
);

-- Cargar los datos del archivo CSV
LOAD DATA INFILE '"C:/Users/level/Desktop/BBDD-Trigger i eventos/activitats.csv"'
INTO TABLE activitats_raw
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- ignoramos la primera línea

-- Verificar que los datos se cargaron correctamente
-- SELECT COUNT(*) AS total_registres FROM activitats_raw;
-- SELECT * FROM activitats_raw LIMIT 5;
