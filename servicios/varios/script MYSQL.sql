-- TDBSystem (Base de datos para el Sistema "Tienda de Barrio"), versión 0.1
-- Un simple modelo de bases de datos para fines académicos

DROP TABLE IF EXISTS categorias_productos;
DROP TABLE IF EXISTS presentaciones_productos;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS bajas_productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS pagos_clientes;
DROP TABLE IF EXISTS personal;
DROP TABLE IF EXISTS proveedores;
DROP TABLE IF EXISTS pagos_proveedores;
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS detalles_ventas;
DROP TABLE IF EXISTS devoluciones_ventas;
DROP TABLE IF EXISTS detalles_devoluciones_ventas;
DROP TABLE IF EXISTS compras;
DROP TABLE IF EXISTS detalles_compras;
DROP TABLE IF EXISTS devoluciones_compras;
DROP TABLE IF EXISTS detalles_devoluciones_compras;

CREATE TABLE categorias_productos (
    id_categoria_producto INT AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_categoria_producto)
);

CREATE TABLE presentaciones_productos (
    id_presentacion_producto INT AUTO_INCREMENT NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_presentacion_producto)
);

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL DEFAULT 0,
    cantidad_disponible INT NOT NULL DEFAULT 0,
    cantidad_minima INT NOT NULL DEFAULT 1,
    cantidad_maxima INT NOT NULL DEFAULT 1,
    id_presentacion_producto INT NOT NULL,
    id_categoria_producto INT NOT NULL,
    PRIMARY KEY (id_producto),
    CONSTRAINT ref_producto__categoria_producto FOREIGN KEY (id_categoria_producto)
        REFERENCES categorias_productos (id_categoria_producto)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT ref_producto__presentacion_producto FOREIGN KEY (id_presentacion_producto)
        REFERENCES presentaciones_productos (id_presentacion_producto)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE bajas_productos (
    id_baja_producto INT NOT NULL,
    tipo_baja VARCHAR(255) NOT NULL,
    cantidad INT NOT NULL DEFAULT 0,
    precio_producto DECIMAL(10, 2) NOT NULL DEFAULT 0,
    id_presentacion_producto INT NOT NULL,
    PRIMARY KEY (id_baja_producto),
    CHECK (tipo_baja IN ('Donación', 'Daño', 'Pérdida', 'Descomposición', 'Destrucción', 'Exclusion')),
    CONSTRAINT ref_baja_productos__producto FOREIGN KEY (id_presentacion_producto)
        REFERENCES productos (id_producto)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE clientes (
    id_cliente VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    telefonos VARCHAR(255),
    direccion VARCHAR(255),
    con_credito BOOLEAN NOT NULL,
    PRIMARY KEY (id_cliente)
);

CREATE TABLE pagos_clientes (
    id_pago_cliente INT AUTO_INCREMENT NOT NULL,
    id_cliente VARCHAR(255) NOT NULL,
    valor_pago DECIMAL(10, 2) NOT NULL DEFAULT 0,
    fecha_pago DATE NOT NULL,
    PRIMARY KEY (id_pago_cliente),
    CONSTRAINT ref_pago_cliente__cliente FOREIGN KEY (id_cliente)
        REFERENCES clientes (id_cliente)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE personal (
    id_persona VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    telefono VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    perfil VARCHAR(255) NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_persona),
    CHECK (perfil IN ('Administrador', 'Vendedor'))
);

CREATE TABLE proveedores (
    id_proveedor VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    telefono VARCHAR(255) NOT NULL,
    correo VARCHAR(255),
    PRIMARY KEY (id_proveedor)
);

CREATE TABLE pagos_proveedores (
    id_pago_proveedor INT AUTO_INCREMENT NOT NULL,
    id_proveedor VARCHAR(255) NOT NULL,
    valor_pago DECIMAL(10, 2) NOT NULL DEFAULT 0,
    fecha_pago DATE NOT NULL,
    PRIMARY KEY (id_pago_proveedor),
    CONSTRAINT ref_pago_proveedor__proveedor FOREIGN KEY (id_proveedor)
        REFERENCES proveedores (id_proveedor)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT NOT NULL,
    fecha_venta DATE NOT NULL,
    total_credito DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total_contado DECIMAL(10, 2) NOT NULL DEFAULT 0,
    id_cliente VARCHAR(255) NOT NULL,
    id_vendedor VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_venta),
    CONSTRAINT ref_venta__cliente FOREIGN KEY (id_cliente)
        REFERENCES clientes (id_cliente)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT ref_venta__personal FOREIGN KEY (id_vendedor)
        REFERENCES personal (id_persona)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE detalles_ventas (
    id_detalle_venta INT AUTO_INCREMENT NOT NULL,
    cantidad_producto INT NOT NULL DEFAULT 0,
    valor_producto DECIMAL(10, 2) NOT NULL DEFAULT 0,
    descuento DECIMAL(10, 2) NOT NULL DEFAULT 0,
    iva DECIMAL(10, 2) NOT NULL DEFAULT 0,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    PRIMARY KEY (id_detalle_venta),
    CONSTRAINT ref_detalle_venta_a_venta FOREIGN KEY (id_venta)
        REFERENCES ventas (id_venta)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT ref_detalle_venta__producto FOREIGN KEY (id_producto)
        REFERENCES productos (id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE devoluciones_ventas (
    id_devolucion_venta INT AUTO_INCREMENT NOT NULL,
    id_venta INT NOT NULL,
    fecha DATE NOT NULL,
    PRIMARY KEY (id_devolucion_venta),
    CONSTRAINT ref_devolucion_venta__venta FOREIGN KEY (id_venta)
        REFERENCES ventas (id_venta)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE detalles_devoluciones_ventas (
    id_detalle_devolucion_venta INT AUTO_INCREMENT NOT NULL,
    id_devolucion_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad_producto INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_detalle_devolucion_venta),
    CONSTRAINT ref_detalle_devolucion__devolucion_venta FOREIGN KEY (id_devolucion_venta)
        REFERENCES devoluciones_ventas (id_devolucion_venta)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE compras (
    id_compra INT AUTO_INCREMENT NOT NULL,
    fecha_compra DATE NOT NULL,
    fecha_recibido DATE NOT NULL,
    total_credito DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total_contado DECIMAL(10, 2) NOT NULL DEFAULT 0,
    id_proveedor VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_compra),
    CONSTRAINT ref_compra__proveedor FOREIGN KEY (id_proveedor)
        REFERENCES proveedores (id_proveedor)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE detalles_compras (
    id_detalle_compra INT AUTO_INCREMENT NOT NULL,
    cantidad_pedida INT NOT NULL DEFAULT 0,
    cantidad_recibida INT NOT NULL DEFAULT 0,
    valor_producto DECIMAL(10, 2) NOT NULL DEFAULT 0,
    iva DECIMAL(10, 2) DEFAULT 0,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    PRIMARY KEY (id_detalle_compra),
    CONSTRAINT ref_detalle_compra__compra FOREIGN KEY (id_pedido)
        REFERENCES compras (id_compra)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT ref_detalle_compra__presentacion_producto FOREIGN KEY (id_producto)
        REFERENCES productos (id_producto)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE devoluciones_compras (
    id_devolucion_compra INT AUTO_INCREMENT NOT NULL,
    id_compra INT NOT NULL,
    fecha_devolucion DATE NOT NULL,
    PRIMARY KEY (id_devolucion_compra),
    CONSTRAINT ref_devolucion_pedido_a_pedido FOREIGN KEY (id_compra)
        REFERENCES compras (id_compra)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE detalles_devoluciones_compras (
    id_detalle_devolucion_compra INT AUTO_INCREMENT NOT NULL,
    id_devolucion_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad_producto INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id_detalle_devolucion_compra),
    CONSTRAINT ref_detalle_devolucion_pedido__devolucion_pedido FOREIGN KEY (id_devolucion_compra)
        REFERENCES devoluciones_compras (id_devolucion_compra)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);
