
USE bd_ventas;
GO

-- Poblar dim_tiempo
SELECT DISTINCT 
    fecha,
    YEAR(fecha) AS anio,
    MONTH(fecha) AS mes,
    DAY(fecha) AS dia
FROM pedido;

-- Poblar dim_cliente
SELECT 
    id AS id_cliente, num_documento, nombres, apellidos, direccion, celular, email,
    fecha_nacimiento, genero, estado_civil
FROM cliente;

-- Poblar dim_producto
SELECT 
    id AS id_producto, nombre, categoria, marca, gramaje, unid_gramaje, precio_sug
FROM producto;

-- Poblar dim_sucursal
SELECT 
    id AS id_sucursal, codigo, direccion, telefono, fecha_creacion, gerente_id
FROM sucursal;

-- Poblar hechos ventas
SELECT 
    p.fecha,
	p.id_cliente,
    st.id_producto,
    st.id_sucursal,
    dp.cantidad,
    st.precio_unitario,
    (dp.cantidad * st.precio_unitario) AS monto_total
FROM detalle_pedido dp
JOIN pedido p ON dp.id_pedido = p.id
JOIN stock st ON dp.id_stock = st.id;


-- Limpiar dimensiones
USE bd_ventas_bi;
GO

DELETE FROM dim_tiempo
    DBCC CHECKIDENT('dim_tiempo', RESEED, 0);
DELETE FROM dim_cliente
    DBCC CHECKIDENT('dim_cliente', RESEED, 0);
DELETE FROM dim_producto
    DBCC CHECKIDENT('dim_producto', RESEED, 0);
DELETE FROM dim_sucursal
    DBCC CHECKIDENT('dim_sucursal', RESEED, 0);
DELETE FROM hechos_ventas
    DBCC CHECKIDENT('hechos_ventas', RESEED, 0);

DROP TABLE dim_tiempo
DROP TABLE dim_cliente
DROP TABLE dim_producto
DROP TABLE dim_sucursal
DROP TABLE hechos_ventas

