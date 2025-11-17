-- 1) (Opcional) Hacer backup rápido de la tabla clientes:
-- COPY clientes TO 'C:\\Users\\gonza\\Documents\\clientes_backup.csv' WITH CSV HEADER;

-- 2) Renombrar la tabla clientes a usuarios
ALTER TABLE clientes RENAME TO usuarios;

-- 3) Agregar columna password para guardar el hash (compatible con Django)
ALTER TABLE usuarios
ADD COLUMN IF NOT EXISTS password VARCHAR(128);

-- 4) Asegurar que exista columna rol (0 cliente / 1 admin)
--ALTER TABLE usuarios
--ADD COLUMN IF NOT EXISTS rol INTEGER DEFAULT 0;

-- 5) Asegurar que exista el campo saldo
--ALTER TABLE usuarios
--ADD COLUMN IF NOT EXISTS saldo NUMERIC(10,2) DEFAULT 0;

-- 6) Asegurar constraints útiles
ALTER TABLE usuarios
    ALTER COLUMN dni SET NOT NULL;

ALTER TABLE usuarios
    ADD CONSTRAINT usuarios_dni_unique UNIQUE (dni);

ALTER TABLE usuarios
    ADD CONSTRAINT usuarios_email_unique UNIQUE (email);
