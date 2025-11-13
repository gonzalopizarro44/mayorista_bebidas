-- ============================================
-- 🚀 BASE DE DATOS: mayorista_bebidas (versión corregida)
-- ============================================

DROP TABLE IF EXISTS detalle_pedido CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;

-- ============================================
-- 🧍‍♂️ Tabla de Clientes
-- ============================================
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    direccion VARCHAR(150),
    telefono VARCHAR(30),
    saldo NUMERIC(10,2) DEFAULT 0
);

-- ============================================
-- 🍾 Tabla de Productos
-- ============================================
CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_unitario NUMERIC(10,2) NOT NULL CHECK (precio_unitario >= 0),
    stock_actual INTEGER DEFAULT 0 CHECK (stock_actual >= 0)
);

-- ============================================
-- 🧾 Tabla de Pedidos
-- ============================================
CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL REFERENCES clientes(id_cliente) ON DELETE CASCADE,
    fecha_pedido TIMESTAMP DEFAULT NOW(),
    estado VARCHAR(20) DEFAULT 'Pendiente' CHECK (estado IN ('Pendiente', 'Aceptado', 'Rechazado')),
    total NUMERIC(10,2) DEFAULT 0 CHECK (total >= 0)
);

-- ============================================
-- 📦 Tabla de Detalle de Pedido
-- ============================================
CREATE TABLE detalle_pedido (
    id_detalle SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    id_producto INTEGER NOT NULL REFERENCES productos(id_producto),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    subtotal NUMERIC(10,2) DEFAULT 0
);

-- ============================================
-- ⚙️ Trigger: calcular subtotal al insertar detalle
-- ============================================
CREATE OR REPLACE FUNCTION calcular_subtotal()
RETURNS TRIGGER AS $$
BEGIN
    NEW.subtotal := NEW.cantidad * (SELECT precio_unitario FROM productos WHERE id_producto = NEW.id_producto);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calcular_subtotal
BEFORE INSERT OR UPDATE ON detalle_pedido
FOR EACH ROW
EXECUTE FUNCTION calcular_subtotal();

-- ============================================
-- ⚙️ Trigger: actualizar total del pedido
-- ============================================
CREATE OR REPLACE FUNCTION actualizar_total_pedido()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE pedidos
    SET total = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM detalle_pedido
        WHERE id_pedido = NEW.id_pedido
    )
    WHERE id_pedido = NEW.id_pedido;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_total
AFTER INSERT OR UPDATE OR DELETE ON detalle_pedido
FOR EACH ROW
EXECUTE FUNCTION actualizar_total_pedido();

-- ============================================
-- ⚙️ Trigger: actualizar stock y saldo al aceptar pedido
-- ============================================
CREATE OR REPLACE FUNCTION descontar_stock_y_actualizar_saldo()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.estado = 'Aceptado' THEN
        -- Descontar stock
        UPDATE productos
        SET stock_actual = stock_actual - dp.cantidad
        FROM detalle_pedido dp
        WHERE dp.id_pedido = NEW.id_pedido
          AND productos.id_producto = dp.id_producto;

        -- Actualizar saldo del cliente
        UPDATE clientes
        SET saldo = saldo + NEW.total
        WHERE id_cliente = NEW.id_cliente;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_descontar_stock
AFTER UPDATE OF estado ON pedidos
FOR EACH ROW
WHEN (NEW.estado = 'Aceptado')
EXECUTE FUNCTION descontar_stock_y_actualizar_saldo();

-- ============================================
-- ✅ Fin del script
-- ============================================
