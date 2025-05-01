-- Evelyn Aguayo, Mariona Arenillas i Alexandra Sofronie

DROP DATABASE IF EXISTS fitwell;
CREATE DATABASE fitwell;
USE fitwell;

DROP TABLE IF EXISTS activitats_raw;
CREATE TABLE activitats_raw (
    id_usuari INT,
    data_activitat DATE,
    hora_inici TIME,
    durada_minuts INT,
    tipus_activitat VARCHAR(50),
    calories INT,
    dispositiu VARCHAR(50)
);

LOAD DATA INFILE 'C:/Users/level/Desktop/LSFitwell/activitats.csv'
INTO TABLE activitats_raw
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 
