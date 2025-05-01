
-- Evelyn Aguayo, Mariona Arenillas i Alexandra Sofronie
USE fitwell;

DROP USER IF EXISTS 'lsfit_data_loader'@'%';
DROP USER IF EXISTS 'lsfit_user'@'%';
DROP USER IF EXISTS 'lsfit_backup'@'%';
DROP USER IF EXISTS 'lsfit_auditor'@'%';
DROP USER IF EXISTS 'lsfit_admin'@'%';

CREATE USER 'lsfit_data_loader'@'%' IDENTIFIED BY 'loader123';
CREATE USER 'lsfit_user'@'%' IDENTIFIED BY 'user123';
CREATE USER 'lsfit_backup'@'%' IDENTIFIED BY 'backup123';
CREATE USER 'lsfit_auditor'@'%' IDENTIFIED BY 'audit123';
CREATE USER 'lsfit_admin'@'%' IDENTIFIED BY 'admin123';

-- Permisos per a lsfit_data_loader:
-- Només pot treballar amb la taula activitats_raw i carregar fitxers
GRANT SELECT, INSERT, UPDATE, DELETE ON fitwell.activitats_raw TO 'lsfit_data_loader'@'%';
GRANT FILE ON *.* TO 'lsfit_data_loader'@'%';  -- Permet carregar fitxers des del servidor

-- Permisos per a lsfit_user:
-- Pot manipular dades però no crear estructures
GRANT SELECT, INSERT, UPDATE, DELETE ON fitwell.* TO 'lsfit_user'@'%';
GRANT EXECUTE ON fitwell.* TO 'lsfit_user'@'%';  -- Permet executar procedures
GRANT FILE ON *.* TO 'lsfit_user'@'%';  -- Permet generar fitxers

-- Permisos per a lsfit_backup:
-- Lectura a producció i tot els permisos al backup (excepte donar permisos)
GRANT SELECT ON fitwell.* TO 'lsfit_backup'@'%';
GRANT ALL PRIVILEGES ON fitwell_backup.* TO 'lsfit_backup'@'%';
REVOKE GRANT OPTION ON fitwell_backup.* FROM 'lsfit_backup'@'%';  -- Revoca capacitat de donar permisos

-- Permisos per a lsfit_auditor:
-- Només consultes de lectura a ambdues bases
GRANT SELECT ON fitwell.* TO 'lsfit_auditor'@'%';
GRANT SELECT ON fitwell_backup.* TO 'lsfit_auditor'@'%';

-- Permisos per a lsfit_admin:
-- Accés complet a ambdues bases de dades
GRANT ALL PRIVILEGES ON fitwell.* TO 'lsfit_admin'@'%';
GRANT ALL PRIVILEGES ON fitwell_backup.* TO 'lsfit_admin'@'%';

FLUSH PRIVILEGES;