-- ===============================
-- CARGA INICIAL: PRODUCTOS
-- ===============================
INSERT INTO productos (nombre, descripcion, precio, stock) VALUES
('Coca Cola 1.5L', 'Gaseosa Coca Cola botella 1.5L', 1200.00, 20),
('Pepsi 1.5L', 'Gaseosa Pepsi botella 1.5L', 1100.00, 20),
('Agua Mineral 1L', 'Botella de agua mineral 2L', 800.00, 20),
('Fanta Naranja 1.5L', 'Gaseosa Fanta Naranja 1.5L', 1150.00, 20),
('Sprite 1.5L', 'Gaseosa Sprite botella 1.5L', 1150.00, 20);

-- ===============================
-- CARGA INICIAL: CLIENTES
-- rol = 0 = cliente
-- rol = 1 = administrador
-- ===============================
INSERT INTO clientes (nombre, dni, email, direccion, telefono, saldo, rol) VALUES
('Juan Pérez', '30111222', 'juanperez@example.com', 'Av. Siempre Viva 123', '1122334455', 0.00, 0),
('María Gómez', '30222333', 'mariagomez@example.com', 'Calle Luna 456', '1199887766', 0.00, 0),
('Carlos Fernández', '30333444', 'carlosf@example.com', 'carlosf@example.com', '1133557799', 0.00, 0),
('Lucía Martínez', '30444555', 'luciam@example.com', 'Calle Sol 789', '1166778899', 0.00, 0),
('Pedro Álvarez', '30555666', 'pedroalvarez@example.com', 'Av. Central 1500', '1144556677', 0.00, 0),
('Administrador', '99999999', 'admin@admin.com', 'Sistema', '1111111111', 0.00, 1);
