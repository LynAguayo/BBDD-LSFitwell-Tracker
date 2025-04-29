-- Creació dels usuaris
CREATE USER 'lsfit_data_loader'@'%' IDENTIFIED BY 'loader123';
CREATE USER 'lsfit_user'@'%' IDENTIFIED BY 'user123';
CREATE USER 'lsfit_backup'@'%' IDENTIFIED BY 'backup123';
CREATE USER 'lsfit_auditor'@'%' IDENTIFIED BY 'audit123';
CREATE USER 'lsfit_admin'@'%' IDENTIFIED BY 'admin123';

-- Permisos per cada usuari
-- lsfit_data_loader - Carregar i gestionar activitats_raw
GRANT SELECT, INSERT, UPDATE, DELETE, FILE ON lsfit.activitats_raw TO 'lsfit_data_loader'@'%';

-- lsfit_user - Pot operar sobre dades però no estructurals 
GRANT SELECT, INSERT, UPDATE, DELETE, FILE ON lsfit.* TO 'lsfit_user'@'%';
-- No permetem CREATE, ALTER, DROP

-- lsfit_backup - Pot operar a lsfit_backup, i llegir de lsfit
GRANT SELECT ON lsfit.* TO 'lsfit_backup'@'%';
GRANT ALL PRIVILEGES ON lsfit_backup.* TO 'lsfit_backup'@'%';
-- Excepte GRANT OPTION (no pot donar permisos)

-- lsfit_auditor - Només pot veure dades
GRANT SELECT ON lsfit.* TO 'lsfit_auditor'@'%';
GRANT SELECT ON lsfit_backup.* TO 'lsfit_auditor'@'%';

-- lsfit_admin - Control total a lsfit i lsfit_backup
GRANT ALL PRIVILEGES ON lsfit.* TO 'lsfit_admin'@'%';
GRANT ALL PRIVILEGES ON lsfit_backup.* TO 'lsfit_admin'@'%';
-- No pot accedir a altres BDs
