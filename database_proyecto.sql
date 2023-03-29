DROP TABLE IF EXISTS usuario CASCADE ;
DROP TABLE IF EXISTS administrador CASCADE ;
DROP TABLE IF EXISTS cliente CASCADE ;
DROP TABLE IF EXISTS producto CASCADE ;
DROP TABLE IF EXISTS lineaVenta CASCADE ;
DROP TABLE IF EXISTS venta CASCADE ;
DROP TABLE IF EXISTS encuentro CASCADE ;
DROP TABLE IF EXISTS especie CASCADE ;
DROP TABLE IF EXISTS genero CASCADE ;
DROP TABLE IF EXISTS familia CASCADE ;
DROP TABLE IF EXISTS orden CASCADE ;
DROP TABLE IF EXISTS clase CASCADE ;
DROP TABLE IF EXISTS filo CASCADE ;
DROP TABLE IF EXISTS reino CASCADE ;

CREATE TABLE usuario(
	id_usuario 			serial,
	nombre				varchar(50) NOT NULL,
	apellidos 			varchar(50) NOT NULL,
	correo				varchar(256) NOT NULL,
	username 			varchar(16) UNIQUE,
	passwd 				varchar(16) NOT NULL,
	fechaNac			date NOT NULL,
	CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
	CONSTRAINT mail CHECK (correo ILIKE '%@%' ),
	CONSTRAINT st_passwd CHECK (passwd ~ '^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+])')
);

CREATE TABLE cliente(
	id_usuario 			serial,
	CONSTRAINT pk_cliente PRIMARY KEY (id_usuario)
)INHERITS (usuario);

CREATE TABLE administrador(
	id_usuario 			serial,
	dni 				varchar(9) NOT NULL,
	CONSTRAINT pk_administrador PRIMARY KEY (id_usuario),
	CONSTRAINT dni_ck CHECK (dni ~ '^[0-9]{8}$' )
)INHERITS (usuario);

CREATE TABLE reino(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	CONSTRAINT pk_reino PRIMARY KEY (nombre)
);

CREATE TABLE filo(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	reino 				varchar(50),
	CONSTRAINT pk_filo PRIMARY KEY (nombre)
);

CREATE TABLE clase(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	filo 				varchar(50),
	CONSTRAINT pk_clase PRIMARY KEY (nombre)
);

CREATE TABLE orden(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	clase 				varchar(50),
	CONSTRAINT pk_orden PRIMARY KEY (nombre)
);

CREATE TABLE familia(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	orden 				varchar(50),
	CONSTRAINT pk_familia PRIMARY KEY (nombre)
);

CREATE TABLE genero(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	familia 				varchar(50),
	CONSTRAINT pk_genero PRIMARY KEY (nombre)
);

CREATE TABLE especie(
	nombre 				varchar(50),
	descripcion 		TEXT NOT NULL,
	genero 				varchar(50),
	CONSTRAINT pk_especie PRIMARY KEY (nombre)
);

CREATE TABLE encuentro (
	usuario 			int,
	especie 			varchar(50),
	fechaEncuentro 		date NOT NULL,
	hora 				timestamp,
	descripcion 		TEXT NOT NULL,
	foto 				bytea NOT NULL,
	zona 				varchar (50) NOT NULL,
	tamaño 				NUMERIC, 
	peso 				NUMERIC,
	sexo				char,
	CONSTRAINT pk_encuentro PRIMARY KEY (usuario,especie),
	CONSTRAINT sex_check CHECK (sexo ILIKE 'M' OR sexo ILIKE 'F')
);

CREATE TABLE producto (
	id_producto 		serial,
	nombre				varchar (50) NOT NULL,
	precioU 			NUMERIC NOT NULL,
	descripcion 		TEXT NOT NULL,
	valoracion 			SMALLINT NOT NULL,
	categoria 			varchar(50),
	CONSTRAINT 	pk_producto PRIMARY KEY (id_producto),
	CONSTRAINT valoracion_check CHECK (valoracion BETWEEN 1 AND 5)
);

CREATE TABLE lineaVenta(
	linea_cod			serial,
	cod_venta 			int,
	id_producto			int,
	uds 				SMALLINT NOT NULL,
	precioTotal			NUMERIC NOT NULL,
	CONSTRAINT pk_lineaVenta PRIMARY KEY (linea_cod,cod_venta)
);

CREATE TABLE venta(
	id_venta 			serial,
	cliente 			int,
	fecha				date NOT NULL,
	total 				NUMERIC NOT NULL,
	CONSTRAINT pk_venta PRIMARY KEY (id_venta)
);


ALTER TABLE encuentro 
ADD CONSTRAINT fk_usuario FOREIGN KEY (usuario) REFERENCES cliente,
ADD CONSTRAINT fk_especie FOREIGN KEY (especie) REFERENCES especie;

ALTER TABLE especie 
ADD CONSTRAINT fk_genero FOREIGN KEY (genero) REFERENCES genero;
ALTER TABLE genero  
ADD CONSTRAINT fk_familia FOREIGN KEY (familia) REFERENCES familia;
ALTER TABLE familia 
ADD CONSTRAINT fk_orden FOREIGN KEY (orden) REFERENCES orden;
ALTER TABLE orden  
ADD CONSTRAINT fk_clase FOREIGN KEY (clase) REFERENCES clase;
ALTER TABLE clase 
ADD CONSTRAINT fk_filo FOREIGN KEY (filo) REFERENCES filo;
ALTER TABLE filo  
ADD CONSTRAINT fk_reino FOREIGN KEY (reino) REFERENCES reino;

ALTER TABLE lineaventa 
ADD CONSTRAINT fk_cod_venta FOREIGN KEY (cod_venta) REFERENCES venta,
ADD CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES producto;

ALTER TABLE venta
ADD CONSTRAINT fk_cliente FOREIGN KEY (cliente) REFERENCES cliente;