--Tablas de Orion
--Tabla datos tercero 
CREATE TYPE datos_tercero AS
(
    dir_tercero         VARCHAR,
    cel_tercero         DECIMAL(10,0),
    tel_tercero         DECIMAL(10,0),
    correo_tercero      VARCHAR,
);

--Tabla Terceros, revisar la creación de Ciudad
CREATE TABLE IF NOT EXISTS tab_terceros
(
    id_tercero          DECIMAL(10,0)          NOT NULL,
    tipo_documento      DECIMAL(1,0)           NOT NULL,
    nom_tercero         VARCHAR                NOT NULL,
    ape1_tercero        VARCHAR                NOT NULL,
    ape2_tercero        VARCHAR                NOT NULL,
    estado              BOOLEAN                NOT NULL,
    empleado            BOOLEAN                NOT NULL,
    cliente             BOOLEAN                NOT NULL,
    proveedor           BOOLEAN                NOT NULL,
    datos_contac        datos_tercero,
    PRIMARY KEY(id_tercero) 
);

--Tabla clientes
CREATE TABLE IF NOT EXISTS tab_clientes
(
    id_cliente          DECIMAL(10,0)          NOT NULL,
    condicion_pago      VARCHAR                NOT NULL,
    PRIMARY KEY(id_cliente),
    FOREIGN KEY(id_cliente)             REFERENCES tab_terceros(id_tercero) 
);

--Tabla Proveedores
CREATE TABLE IF NOT EXISTS tab_proveedores
(
    id_proveedor        DECIMAL(10,0)           NOT NULL,
    condicion_pago      VARCHAR                 NOT NULL,
    PRIMARY KEY(id_proveedor),
    FOREIGN KEY(id_proveedor)           REFERENCES tab_terceros(id_tercero) 
);

--Tabla Rangos
CREATE TYPE  datos_rango AS
(
    id_rango            DECIMAL(1,0),
    nom_rango           VARCHAR,
);


--Tabla Roles
CREATE TABLE IF NOT EXISTS tab_roles
(
    id_cargo            DECIMAL(2,0)            NOT NULL,
    nom_cargo           VARCHAR                 NOT NULL,
    rango               datos_rango,
    descrip_rol         VARCHAR                 NOT NULL,
    PRIMARY KEY(id_cargo)
);    

--Tabla Empleados
CREATE TABLE IF NOT EXISTS tab_empleados
(
    id_tercero          DECIMAL(10,0)           NOT NULL,
    id_cargo            DECIMAL(2,0)            NOT NULL,
    tipo_contrato       DECIMAL(1,0)            NOT NULL, -- 1 fijo, 2 indefinido, 3 obra labor, 4 prestacion de servicios               
    salario_base        DECIMAL(8,0)            NOT NULL,
    fecha_vinc          DATE                    NOT NULL,
    fecha_ter           DATE                    NOT NULL        DEFAULT 'VIGENTE',
    estado              BOOLEAN                 NOT NULL,
    PRIMARY KEY(id_tercero),
    FOREIGN KEY(id_tercero)             REFERENCES tab_terceros(id_tercero)
    FOREIGN KEY(id_cargo)               REFERENCES tab_roles(id_cargo)    
);

--Tabla Permisos
CREATE TABLE IF NOT EXISTS tab_permisos
(
    id_permiso          DECIMAL(2,0)            NOT NULL,
    nom_permiso         VARCHAR                 NOT NULL,
    Permisos            BOOLEAN                 NOT NULL,
    modulo              VARCHAR                 NOT NULL,
    PRIMARY KEY(id_permiso)
);

--Tabla permisos por rol
CREATE TABLE IF NOT EXISTS tab_permisos_por_rol
(
    id_permiso          DECIMAL(2,0)            NOT NULL,
    id_cargo            DECIMAL(2,0)            NOT NULL,
    estado              BOOLEAN                 NOT NULL,
    PRIMARY KEY(id_permiso,id_cargo),
    FOREIGN KEY(id_permiso)             REFERENCES tab_permisos(id_permiso),
    FOREIGN KEY(id_cargo)               REFERENCES tab_roles(id_cargo)
);

--Tabla Usuarios Sistema // Revisar los atributos y las llaves foraneas por el cambio en la tabla de empleados
CREATE TABLE IF NOT EXISTS tab_usuarios
(
    id_usuario          VARCHAR                 NOT NULL,
    id_empleado         DECIMAL(3,0)            NOT NULL,
    id_cargo            DECIMAL(2,0)            NOT NULL,
    clave               VARCHAR                 NOT NULL,
    estado              BOOLEAN                 NOT NULL,
    fecha_crea          DATE                    NOT NULL,
    ultimo_acc          TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    PRIMARY KEY(id_usuario),
    FOREIGN KEY(id_empleado)            REFERENCES tab_empleados(id_terceros,id_cargo),
    FOREIGN KEY(id_cargo)               REFERENCES tab_roles(id_cargo)
);

--Tabla de PQRS
CREATE TABLE IF NOT EXISTS tab_pqrs
(
    id_tercero          DECIMAL(10,0)          NOT NULL,
    tipo_pqr            
    fecha_crea
    
);

CREATE TABLE IF NOT EXISTS tab_pqrs_rta
(
    
);

--Tabla estados
CREATE TYPE datos_estado AS
(
    id_estado           DECIMAL(1,0),
    nom_estado          VARCHAR
)

--Tablas correspondientes al módulo de pedidos
--Tabla del encabezado del pedido
CREATE TABLE IF NOT EXISTS tab_encabezado_pedido
(
    id_pedido           VARCHAR                 NOT NULL,
    id_cliente          DECIMAL(10,0)           NOT NULL,
    id_usuario          VARCHAR                 NOT NULL,
    id_vendedor         DECIMAL(10,0)           NOT NULL,
    fecha_pedido        DATE                    NOT NULL,
    fecha_despacho      DATE                    NOT NULL,
    estado              datos_estado,
    total_pedido        DECIMAL(8,0)            NOT NULL,
    tipo_pago           DECIMAL(1,0)            NOT NULL, -- 1 CREDITO, 2 CONTADO
    obs_pedido          VARCHAR                 NOT NULL,
    PRIMARY KEY(id_pedido),
    FOREIGN KEY(id_cliente)                 REFERENCES tab_clientes(id_cliente),
    FOREIGN KEY(id_usuario)                 REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(id_vendedor)                REFERENCES tab_empleados(id_tercero,id_cargo)
);

--Tabla detalle del pedido
CREATE TABLE IF NOT EXISTS tab_detalle_pedido
(
    id_inventario       DECIMAL(4,0)            NOT NULL,
    id_pedido           VARCHAR                 NOT NULL,
    cantidad            DECIMAL(3,0)            NOT NULL,
    valor_unitario      DECIMAL(6,0)            NOT NULL,
    descuento           DECIMAL(4,2)            NOT NULL,
    sub_total           DECIMAL(6,0)            NOT NULL,
    PRIMARY KEY(id_inventario,id_pedido),
    FOREIGN KEY(id_inventario)              REFERENCES tab_inventario(id_inventario),
    FOREIGN KEY(id_pedido)                  REFERENCES tab_encabezado_pedido(id_pedido)
);