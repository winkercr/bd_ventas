USE bd_ventas

-- Tabla: producto
DELETE FROM producto;
INSERT INTO producto(nombre, categoria, marca, gramaje, unid_gramaje, precio_sug)
VALUES
('Aceite A1 900 ml', 'Aceites', 'A1', 900, 'ml', 7.6),
('Aceite A2 200 ml', 'Aceites', 'A2', 200, 'ml', 2),
('Aceite A2 1800 ml', 'Aceites', 'A2', 1800, 'ml', 15),
('Aceite A2 900 ml', 'Aceites', 'A2', 900, 'ml', 6.8),
('Aceite A3 900 ml', 'Aceites', 'A3', 900, 'ml', 6.2),
('Detergente B1 140 gr', 'Detergentes', 'B1', 140, 'gr', 1.9),
('Detergente B1 750 ml', 'Detergentes', 'B1', 750, 'ml', 7.6),
('Detergente B2 320 gr', 'Detergentes', 'B2', 320, 'gr', 1.6),
('Detergente B2 730 gr', 'Detergentes', 'B2', 730, 'gr', 6.5),
('Detergente B3 320 gr', 'Detergentes', 'B3', 320, 'gr', 1.5),
('Pasta C1 450 gr', 'Pastas', 'C1', 450, 'gr', 2.4),
('Pasta C1 500 gr', 'Pastas', 'C1', 500, 'gr', 2.5),
('Pasta C2 250 gr', 'Pastas', 'C2', 250, 'gr', 1.6),
('Pasta C2 500 gr', 'Pastas', 'C2', 500, 'gr', 1.6),
('Pasta C3 450 gr', 'Pastas', 'C3', 450, 'gr', 1.7),
('Cereal D1 130 gr', 'Cereales', 'D1', 130, 'gr', 2),
('Cereal D1 80 gr', 'Cereales', 'D1', 80, 'gr', 1.3),
('Conserva E1 140 gr', 'Conservas', 'E1', 140, 'gr', 4.4),
('Conserva E1 140 gr', 'Conservas', 'E1', 140, 'gr', 4.3),
('Harina F1 1000 gr', 'Harinas', 'F1', 1000, 'gr', 6.5),
('Harina F2 1000 gr', 'Harinas', 'F2', 1000, 'gr', 5.4),
('Jabon G1 190 gr', 'Jabones', 'G1', 190, 'gr', 9),
('Jabon G2 190 gr', 'Jabones', 'G2', 190, 'gr', 1.5),
('Lavavajilla H1 1000 gr', 'Lavavajillas', 'H1', 1000, 'gr', 4.2),
('Lavavajilla H2 450 ml', 'Lavavajillas', 'H2', 450, 'ml', 2.7),
('Salsa J1 850 gr', 'Salsas', 'J1', 850, 'gr', 1.9),
('Salsa J2 200 gr', 'Salsas', 'J2', 200, 'gr', 2.9);

-- Tabla: sucursal
DELETE FROM sucursal;
INSERT INTO sucursal (codigo, direccion, telefono, fecha_creacion, gerente_id)
VALUES
('SUC001', 'Av. Javier Prado Este 4200 - San Isidro', '014001001', '2005-03-15', 101),
('SUC002', 'Av. Arequipa 1800 - Lince', '014001002', '2008-07-10', 102),
('SUC003', 'Av. La Marina 2500 - San Miguel', '014001003', '2010-09-22', 103),
('SUC004', 'Av. El Sol 380 - Cusco', '084400100', '2012-11-18', 104),
('SUC005', 'Av. Ejército 900 - Arequipa', '054400200', '2011-06-30', 105);

-- Tabla: cliente
DELETE FROM cliente;
DECLARE @i INT = 1;
WHILE @i <= 20
BEGIN
    INSERT INTO cliente (num_documento, nombres, apellidos, direccion, celular, email, fecha_nacimiento, genero, estado_civil)
    VALUES (
        CAST(ABS(CHECKSUM(NEWID())) % 90000000 + 10000000 AS VARCHAR(20)),
        CONCAT('Nombre', @i),
        CONCAT('Apellido', @i),
        CONCAT('Av. Principal ', @i),
        CONCAT('9', ABS(CHECKSUM(NEWID())) % 90000000),
        CONCAT('cliente', @i, '@correo.com'),
        DATEADD(YEAR, - (ABS(CHECKSUM(NEWID())) % 40 + 18), GETDATE()),
        CASE WHEN @i % 2 = 0 THEN 'Masculino' ELSE 'Femenino' END,
        CASE WHEN @i % 3 = 0 THEN 'Casado' ELSE 'Soltero' END
    );
    SET @i += 1;
END;

-- Tabla: stock
DELETE FROM stock;
INSERT INTO stock (id_sucursal, id_producto, stock_actual, stock_minimo, precio_unitario)
SELECT 
    s.id AS id_sucursal,
    p.id AS id_producto,
    ABS(CHECKSUM(NEWID())) % 200 + 50 AS stock_actual,   -- valor aleatorio entre 50 y 250
    20 AS stock_minimo,                                  -- mínimo fijo
    CAST(ROUND(p.precio_sug + (ABS(CHECKSUM(NEWID())) % 200) / 100.0, 2) AS MONEY ) AS precio_unitario
FROM sucursal s
CROSS JOIN producto p;

-- Tabla: pedido
DELETE FROM pedido;
DECLARE @p INT = 1;
WHILE @p <= 15   -- Generamos 15 pedidos de prueba
BEGIN
    INSERT INTO pedido (id_cliente, fecha, estado, monto_total)
    VALUES (
        (ABS(CHECKSUM(NEWID())) % (SELECT COUNT(*) FROM cliente)) + 1,   -- cliente aleatorio
        DATEADD(DAY, - (ABS(CHECKSUM(NEWID())) % 90), GETDATE()),       -- fecha en los últimos 90 días
        CASE WHEN @p % 2 = 0 THEN 'Pendiente' ELSE 'Completado' END,    -- estado alternado
        0                                                              -- monto_total inicial
    );
    SET @p += 1;
END;

-- Tabla: detalle_pedido
DELETE FROM detalle_pedido;
DECLARE @pedidoId INT, @sucursalId INT, @j INT;
DECLARE pedidos_cursor CURSOR FOR SELECT id FROM pedido;
OPEN pedidos_cursor;
FETCH NEXT FROM pedidos_cursor INTO @pedidoId;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Sucursal aleatoria para este pedido
    SET @sucursalId = (SELECT TOP 1 id FROM sucursal ORDER BY NEWID());
    -- Insertar entre 2 y 5 productos de esa sucursal
    SET @j = 1;
    WHILE @j <= (ABS(CHECKSUM(NEWID())) % 4 + 2)
    BEGIN
        INSERT INTO detalle_pedido (id_pedido, id_stock, cantidad)
        SELECT TOP 1
            @pedidoId,
            s.id,
            ABS(CHECKSUM(NEWID())) % 5 + 1   -- cantidad aleatoria entre 1 y 5
        FROM stock s
        WHERE s.id_sucursal = @sucursalId
        ORDER BY NEWID();
        SET @j += 1;
    END;
    FETCH NEXT FROM pedidos_cursor INTO @pedidoId;
END;
CLOSE pedidos_cursor;
DEALLOCATE pedidos_cursor;

-- Actualizar monto_total de tabla pedido
UPDATE p
SET p.monto_total = (
    SELECT SUM(dp.cantidad * s.precio_unitario)
    FROM detalle_pedido dp
    INNER JOIN stock s ON dp.id_stock = s.id
    WHERE dp.id_pedido = p.id
)
FROM pedido p;




	
SELECT * FROM cliente
SELECT * FROM sucursal
SELECT * FROM producto
SELECT * FROM stock
SELECT * FROM pedido
SELECT * FROM detalle_pedido