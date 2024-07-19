/* 
Sprint – Modulo 3
Rodrigo Rojas – Jorge Montoya – Joeshep López – Diego Rivera - Felipe Arias - Nicolas Gajardo
*/

-- Creacion del entorno de trabajo.
-- Creacion de base de datos.
CREATE DATABASE sprintgrupo5;

USE sprintgrupo5;

-- Creacion usuario con todos los privilegios para trabajar con la base de datos recién creada.
CREATE USER 'sprintgrupo5'@'localhost' IDENTIFIED BY 'admin123';
GRANT CREATE, DROP, ALTER, INSERT, UPDATE, DELETE ON sprintgrupo5.* TO 'sprintgrupo5'@'localhost';
FLUSH PRIVILEGES;

-- Creacion de tablas.
/*
La primera almacena todos los datos de los proveedores (nombre de su representante legal, nombre corporativo
dos teléfonos de contacto (y el nombre de quien recibe las llamadas), la categoria de sus productos, y 
correo electronico.
*/
CREATE TABLE proveedores (
id_proveedor INT AUTO_INCREMENT,
nombre_proveedor VARCHAR(50),
representante_legal VARCHAR(50),
telefono_1 BIGINT,
nombre_contacto1 VARCHAR(50),
telefono_2 BIGINT,
nombre_contacto2 VARCHAR(50),
categoria VARCHAR(50),
email VARCHAR(30),
PRIMARY KEY (id_proveedor)
);

/*
La segunda almacena todos los datos de los clientes (nombre, apellido y dirección).
*/
CREATE TABLE clientes (
 id_cliente INT AUTO_INCREMENT,
 nombre VARCHAR(40),
 apellido VARCHAR(40),
 direccion VARCHAR(50),
 PRIMARY KEY (id_cliente)
);

/*
La tercera almacena todos los datos de los productos (precio, su categoría, proveedor y color)
*/
CREATE TABLE Producto (
id_producto INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
precio DECIMAL(10, 2) NOT NULL,
categoria VARCHAR(50) NOT NULL,
color VARCHAR(50) NOT NULL,
stock INT NOT NULL,
id_proveedor INT,
FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor)
);

-- insercion de datos.
-- Datos proveedores.
INSERT INTO Proveedores (representante_legal, nombre_proveedor, telefono_1, nombre_contacto1, telefono_2, nombre_contacto2, categoria, email)
VALUES
('Carlos Pérez', 'Electronica SRL', '123456789', 'Ana Gomez', '987654321', 'Juan Martinez', 'Electrónica', 'facturas@electronica.com'),
('María López', 'CompuStore', '123123123', 'Luis Perez', '456456456', 'Marta Sanchez', 'Computación', 'facturacion@compustore.com'),
('Jorge Hernández', 'HogarPlus', '321321321', 'Sofia Ramirez', '654654654', 'Pedro Silva', 'Hogar', 'ventas@hogarplus.com'),
('Ana Torres', 'DeportesYa', '789789789', 'Ricardo Diaz', '123789456', 'Laura Ruiz', 'Deportes', 'info@deportesya.com'),
('Luis Rojas', 'JuguetesKing', '456789123', 'Camila Vasquez', '789456123', 'Patricia Gutierrez', 'Juguetes', 'contacto@juguetesking.com');

-- datos clientes.
INSERT INTO clientes (nombre, apellido, direccion)
VALUES
('Juan', 'Pérez', 'Calle Falsa 123'),
('María', 'González', 'Av. Siempre Viva 742'),
('Carlos', 'Sánchez', 'Boulevard de los Sueños 56'),
('Ana', 'Martínez', 'Plaza Mayor 1'),
('Lucía', 'Ramírez', 'Paseo del Prado 20');

-- datos productos.
INSERT INTO Producto (nombre, precio, categoria, color, stock, id_proveedor)
VALUES
('Laptop', 150000, 'Computación', 'Negro', 150, 2),
('Laptop', 200000, 'Computación', 'Blanco', 180, 1),
('Smartphone', 800000, 'Electrónica', 'Blanco', 250, 1),
('Smartphone', 900000, 'Electrónica', 'Gris', 200, 2),
('Tablet', 300000, 'Computación', 'Gris', 85, 2),
('Tablet', 150000, 'Computación', 'Blanco', 94, 1),
('Televisor', 1200000, 'Electrónica', 'Negro', 50, 1),
('Bicicleta', 50000, 'Deportes', 'Rojo', 35, 4),
('Cafetera', 80000, 'Hogar', 'Negro', 40, 3),
('Juguete de Peluche', 2000, 'Juguetes', 'Marrón', 90, 5),
('Consola de Videojuegos', 400000, 'Electrónica', 'Negro', 120, 1),
('Consola de Videojuegos', 500000, 'Electrónica', 'Blanco', 100, 2),
('Monitor', 200000, 'Computación', 'Blanco', 80, 2),
('Aspiradora', 150000, 'Hogar', 'Azul', 90, 3);
TRUNCATE TABLE producto;

-- Consultas
-- Cuál es la categoría de productos que más se repite.
SELECT categoria, COUNT(*) as cantidad
FROM Producto
GROUP BY categoria
ORDER BY cantidad DESC
LIMIT 1;

-- Cuáles son los productos con mayor stock.
SELECT nombre, stock
FROM Producto
ORDER BY stock DESC
LIMIT 3;

-- Qué color de producto es más común en nuestra tienda.
SELECT color, COUNT(*) as cantidad
FROM Producto
GROUP BY color
ORDER BY cantidad DESC
LIMIT 1;

-- Cual o cuales son los proveedores con menor stock de productos.
SELECT nombre_proveedor, SUM(stock) as total_stock
FROM Proveedores
JOIN Producto ON Proveedores.id_proveedor = Producto.id_proveedor
GROUP BY Proveedores.id_proveedor
ORDER BY total_stock ASC
LIMIT 3;

-- Por último: Cambien la categoría de productos más popular por ‘Electrónica y computación’.
SET SQL_SAFE_UPDATES = 0;

UPDATE Producto
SET categoria = 'Electrónica y computación'
WHERE categoria = (
    SELECT categoria
    FROM (
        SELECT categoria, COUNT(*) as cantidad
        FROM Producto
        GROUP BY categoria
        ORDER BY cantidad DESC
        LIMIT 1
    ) as subquery
);

SET SQL_SAFE_UPDATES = 1;