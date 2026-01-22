USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'bd_ventas')
BEGIN
    ALTER DATABASE bd_ventas SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE bd_ventas;
END
GO

CREATE DATABASE bd_ventas;
GO

USE bd_ventas;
GO

-- Tabla: cliente
CREATE TABLE cliente (
    id INT IDENTITY(1,1) PRIMARY KEY,
    num_documento VARCHAR(20) NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    celular VARCHAR(15),
    email VARCHAR(100),
    fecha_nacimiento DATE,
    genero VARCHAR(20),
    estado_civil VARCHAR(20)
);
GO

-- Tabla: sucursal
CREATE TABLE sucursal (
    id INT IDENTITY(1,1) PRIMARY KEY,
    codigo VARCHAR(20),
    direccion VARCHAR(200),
    telefono VARCHAR(15),
    fecha_creacion DATE,
    gerente_id INT NULL
);
GO

-- Tabla: producto
CREATE TABLE producto (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    marca VARCHAR(20) NOT NULL,
    gramaje INT NOT NULL,
    unid_gramaje VARCHAR(10) NOT NULL,
	precio_sug MONEY NOT NULL
);
GO

-- Tabla: stock
CREATE TABLE stock (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_sucursal INT NOT NULL,
    id_producto INT NOT NULL,
    stock_actual INT NOT NULL,
    stock_minimo INT NOT NULL,
    precio_unitario MONEY NOT NULL,
    FOREIGN KEY (id_sucursal) REFERENCES sucursal(id),
    FOREIGN KEY (id_producto) REFERENCES producto(id)
);
GO

-- Tabla: pedido
CREATE TABLE pedido (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha DATE NOT NULL,
    estado VARCHAR(20),
    monto_total MONEY DEFAULT 0,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id)
);
GO

-- Tabla: detalle_pedido
CREATE TABLE detalle_pedido (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_stock INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id),
    FOREIGN KEY (id_stock) REFERENCES stock(id)
);
GO

