-- UNIVERSIDAD ESTATL AMAZONICA
-- DENISIS PORTILLA
-- SEMANA 10 MEGACOMPU - GESTÓN DE INVENTARIOS

-- CREATE DATABASE sirve para crear una base de datos
CREATE DATABASE megacompu_gestion_inventario5;

-- Creación de tablas

-- TABLA 1 PROVEEDOR
CREATE TABLE proveedor (
    id_proveedor int AUTO_INCREMENT,
    nombre_proveedor varchar(100),
    telefono varchar(20),
    direccion varchar(200),
    PRIMARY KEY (id_proveedor)
);
-- TABLA 2 EMPLEADO
CREATE TABLE empleado (
    id_empleado int AUTO_INCREMENT,
    nombres varchar(100),
    apellidos varchar(100),
    cargo varchar(150),
    telefono varchar(15),
    PRIMARY KEY (id_empleado)
);
-- TABLA 3 CLIENTE
CREATE TABLE cliente (
    id_cliente int AUTO_INCREMENT,
    nombre varchar(100),
    telefono varchar(20),
    direccion varchar(200),
    PRIMARY KEY (id_cliente)
);
-- TABLA 4 PRODUCTO
CREATE TABLE producto (
    id_producto int AUTO_INCREMENT,
    nombre_producto varchar(100),
    precio decimal(10,2),
    stock int,
    PRIMARY KEY (id_producto)
);

-- TABLA 5 FACTURA_COMPRA
CREATE TABLE factura_compra (
    id_facturacompra int AUTO_INCREMENT,
    fecha date,
    subtotal decimal(10,2),
    iva decimal(10,2),
    total decimal(10,2),
    id_proveedor int,
    id_empleado int,
    PRIMARY KEY (id_facturacompra),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

-- TABLA 6 DETALLE_COMPRA_PRODUCTO
create table detalle_compra_producto (
	id_detalle_compra int auto_increment,
	cantidad int,
	precio decimal(10,2),
    subtotal decimal(10,2),
    descuento decimal(10,2),
    iva decimal(10,2),
    id_facturacompra int,
    id_producto int,
    primary key (id_detalle_compra),
    FOREIGN KEY (id_facturacompra) REFERENCES factura_compra(id_facturacompra),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- TABLA 7 FACTURA_VENTA
create table factura_venta (
	id_facturaventa int auto_increment,
	fecha date,
	subtotal decimal(10,2),
    iva decimal(10,2),
    total decimal(10,2),
    id_cliente int,
    id_empleado int,
    primary key (id_facturaventa),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)	
);

-- TABLA 8 DETALLE_VENTA_PRODUCTO
create table detalle_venta_producto(
	id_detalle_venta int auto_increment,
    cantidad int,
    precio decimal(10,2),
    subtotal decimal(10,2),
    id_producto int,
    id_facturaventa int,
    primary key (id_detalle_venta),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_facturaventa) REFERENCES factura_venta(id_facturaventa)
);

-- INSERTAR NUEVOS REGISTROS - DATOS
-- TABLA EMPLEADO
select * from empleado
insert into empleado values
	(01, 'Denisis Paola','Portilla Alvarado', 'Vendedora', '0982723301'),
	(02, 'Andrea Sofia', 'Ramirez Arcos','Cajera', '09922334411' ),
	(03, 'Derlyn Josimar', 'Aguinda Grefa', 'Gerente de Ventas', '094821490'),
	(04, 'Brigitte Alexandra', 'Rosillo Espin', 'Bodeguero', '0924344454'),
	(05, 'Jorge Jefferson', 'Ramirez Quimi', 'Administrador', '0994150447');

-- TABLA CLIENTE
select * from cliente
insert into cliente values
	(01, 'Ana','0942778111', 'Av. Amazonas'),
	(02, 'Marcela', '0985669922', 'Calle 10 Agosto' ),
	(03, 'Luis', '0969455055', 'Av Roca Fuerte'),
	(04, 'Anthony', '0924681012', 'Av. 9 deOctubre'),
	(05, 'Adela', '0936912158', 'Vía Tena');

-- TABLA FACTURA_VENTA
select * from factura_venta
insert into factura_venta values
	(01, '2025-08-20',500.00, 75.00, 575.00, 01, 01),
	(02, '2023-02-15', 300.00, 45.00, 345.00, 02, 02 ),
	(03, '2025-08-23', 450.00, 67.50, 517.50, 03, 03),
	(04, '2022-09-12', 200.00, 30.00, 230.00, 04, 04),
	(05, '2023-09-25', 700.00, 105.00, 805.00, 05, 05);

-- TABLA PRODUCTO
select * from producto
insert into producto values
	(01, 'Teclado USB',15.00, 10),
	(02, 'Monitor 24', 120.00, 12 ),
	(03, 'Mouse inalámbrico', 15.00,15 ),
	(04, 'Impresora Multifuncional SpeedPrint',189.00, 13),
	(05, 'Audifonos SoundMax Plus ', 69.00, 10);

-- TABLA DETALLE_VENTA_PRODUCTO
select * from detalle_venta_producto
insert into detalle_venta_producto values
	(01, 2, 15.00, 30.00, 01, 01),
	(02, 3, 120.00, 360.00, 02, 02 ),
	(03, 3, 15.00, 45.00, 03, 03),
	(04, 1, 189.00, 189.00, 04, 04),
	(05, 4, 69.00, 276.00, 05, 05);

-- CONSULTA 1

-- CONSULTA de facturas con información del cliente y empleado
-- JOIN para unir dos tablas relacionadas
-- CONCAT unir dos campos
select
  fv.id_facturaventa as Nro_Factura,
  c.nombre as Cliente, 
  concat(e.nombres, ' ', e.apellidos) as Empleado,
  fv.fecha,
  fv.subtotal,
  (fv.subtotal * 0.15) as iva_calculado,
  (fv.subtotal + (fv.subtotal * 0.15)) as Total_calculado
from factura_venta as fv
join cliente  as c on fv.id_cliente  = c.id_cliente
join empleado as e on fv.id_empleado = e.id_empleado
order by fv.id_facturaventa;

-- CONSULTA 2
-- Consulta Reporte de ventas por producto
select pr.nombre_producto as Producto, 
       SUM(dvp.cantidad) as Total_Unidades_Vendidas, 
       SUM(dvp.subtotal) as Total_Ventas
from detalle_venta_producto dvp
join producto pr on dvp.id_producto = pr.id_producto
group by pr.nombre_producto
order by Total_Ventas desc;