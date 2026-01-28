USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'bd_ventas')
BEGIN
    ALTER DATABASE bd_ventas_bi SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE bd_ventas_bi;
END
GO

CREATE DATABASE bd_ventas_bi;
GO

USE bd_ventas_bi;
GO

-- Dimensión Cliente
CREATE TABLE dim_cliente (
    id INT IDENTITY(1,1) PRIMARY KEY,
	id_cliente INT,
    num_documento VARCHAR(20),
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    direccion VARCHAR(200),
    celular VARCHAR(15),
    email VARCHAR(100),
    fecha_nacimiento DATE,
    genero VARCHAR(20),
    estado_civil VARCHAR(20)
);
GO

-- Dimensión Producto
CREATE TABLE dim_producto (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_producto INT,
    nombre VARCHAR(100),
    categoria VARCHAR(50),
    marca VARCHAR(20),
    gramaje INT,
    unid_gramaje VARCHAR(10),
    precio_sug MONEY
);
GO

-- Dimensión Sucursal
CREATE TABLE dim_sucursal (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_sucursal INT,
    codigo VARCHAR(20),
    direccion VARCHAR(200),
    telefono VARCHAR(15),
    fecha_creacion DATE,
    gerente_id INT
);
GO

-- Dimensión Tiempo
CREATE TABLE dim_tiempo (
    id INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE,
    anio INT,
    mes INT,
    dia INT
);
GO

-- Tabla de Hechos: Ventas
CREATE TABLE hechos_ventas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    id_sucursal INT,
    id_tiempo INT,
    cantidad INT,
    precio_unitario MONEY,
    monto_total MONEY,
    FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id),
    FOREIGN KEY (id_producto) REFERENCES dim_producto(id),
    FOREIGN KEY (id_sucursal) REFERENCES dim_sucursal(id),
    FOREIGN KEY (id_tiempo) REFERENCES dim_tiempo(id)
);
GO