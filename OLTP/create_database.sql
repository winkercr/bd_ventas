-- Crear la base de datos
CREATE DATABASE bd_ventas;
GO

-- Usar la base de datos
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
    direccion VARCHAR(200),
    codigo VARCHAR(20),
    telefono VARCHAR(15),
    fecha_creacion DATE,
    sector VARCHAR(50),
    gerente_id INT NULL
);
GO

-- Tabla: vendedor
CREATE TABLE vendedor (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    celular VARCHAR(15),
    email VARCHAR(100),
    fecha_nacimiento DATE,
    genero VARCHAR(20),
    estado_civil VARCHAR(20),
    num_documento VARCHAR(20),
    id_sucursal INT NOT NULL,
    FOREIGN KEY (id_sucursal) REFERENCES sucursal(id)
);
GO

-- Tabla: categoria
CREATE TABLE categoria (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL
);
GO

-- Tabla: producto
CREATE TABLE producto (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_categoria INT NOT NULL,
    nombre_producto VARCHAR(100) NOT NULL,
    marca VARCHAR(50),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id)
);
GO

-- Tabla: pedido
CREATE TABLE pedido (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha DATE NOT NULL,
    estado VARCHAR(20),
    monto DECIMAL(10,2),
    id_vendedor INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id),
    FOREIGN KEY (id_vendedor) REFERENCES vendedor(id)
);
GO

-- Tabla: detalle_pedido
CREATE TABLE detalle_pedido (
    id INT IDENTITY(1,1) PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id),
    FOREIGN KEY (id_producto) REFERENCES producto(id)
);
GO
