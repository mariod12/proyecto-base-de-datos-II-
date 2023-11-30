CREATE DATABASE Telecomunication_Bussines;
GO

USE Telecomunication_Bussines;
GO
--esquemas 
CREATE SCHEMA Personas
GO
CREATE SCHEMA Clientes
GO
CREATE SCHEMA Empleados
GO
CREATE SCHEMA Ventas
GO
--create tables 
CREATE TABLE Personas.Paises(
idPais INTEGER IDENTITY (1,1) PRIMARY KEY,
descripcion VARCHAR (20) NOT NULL
);

CREATE TABLE Personas.Departamentos(
idDepto INTEGER IDENTITY(1,1) PRIMARY KEY, 
idPais INTEGER NOT NULL,
descripcion VARCHAR (50)
CONSTRAINT FK_depto_pais FOREIGN KEY (idPais) REFERENCES Personas.Paises(idPais)
);

CREATE TABLE Personas.Municipios(
idMuncipio INTEGER IDENTITY (1,1) PRIMARY KEY, 
idDepto INTEGER NOT NULL,
decripcion VARCHAR(50)
CONSTRAINT FK_mun_depto FOREIGN KEY (idDepto) REFERENCES Personas.Departamentos(idDepto)
);


CREATE TABLE Personas.Colonias(
id_colonia INT IDENTITY (1,1) PRIMARY KEY,
id_municipio int not null, 
descripcion VARCHAR(100),
CONSTRAINT FK_colonia FOREIGN KEY (id_municipio) REFERENCES Personas.Municipios(idMuncipio)
);
GO

CREATE TABLE personas.Generos(
id_genero INTEGER IDENTITY PRIMARY KEY,
descripcion VARCHAR(20) NOT NULL,
);

CREATE TABLE Personas.Personas(
idPersona INTEGER IDENTITY(1,1) PRIMARY KEY, 
id_colonia INTEGER NOT NULL,
id_genero INTEGER NOT NULL,	
P_nombre VARCHAR (25) NOT NULL, 
S_nombre VARCHAR (25) NULL,
P_apellido VARCHAR (25) NOT NULL,
S_apellido VARCHAR (25) NULL, 
direccion varchar (100), 
telefono varchar (10),
fecha_nacimiento DATE NULL,
correo VARCHAR (100) NOT NULL,
CONSTRAINT FK_per_mun FOREIGN KEY (id_colonia) REFERENCES  Personas.Colonias(id_colonia),
CONSTRAINT FK_per_gen FOREIGN KEY (id_genero) REFERENCES Personas.Generos(id_genero)
);


CREATE TABLE Clientes.tipoCliente(
  id_tipo_cliente INT IDENTITY PRIMARY KEY,
  descripcion NVARCHAR(100),
  beneficios NVARCHAR(100) );
  GO


CREATE TABLE Clientes(
id_clientes INTEGER IDENTITY(1,1) PRIMARY KEY, 
id_persona INTEGER NOT NULL,
id_tipo_cliente INT not null,
fecha_afiliaccion DATE, 
CONSTRAINT Fk_tipo_cliente FOREIGN KEY (id_tipo_cliente) REFERENCES Clientes.tipoCliente(id_tipo_cliente),
CONSTRAINT Fk_persona FOREIGN KEY (id_tipo_cliente) REFERENCES Personas.Personas(idPersona),

);

CREATE TABLE Empleados.PuestosTrabajo(
idPuesto INTEGER IDENTITY (1,1) PRIMARY KEY,
descripcion VARCHAR (80) NOT NULL,
comentario VARCHAR (150) NULL
);


CREATE TABLE Empleados.Empleados (
id_empleado INTEGER PRIMARY KEY,
id_persona INTEGER NOT NULL,
id_puesto INTEGER NOT NULL, 
Salario DECIMAL(10, 2),
Fecha_de_contratacion DATE,
CONSTRAINT FK_emp_per FOREIGN KEY (id_persona) REFERENCES personas.Personas(idPersona),
CONSTRAINT FK_emp_puesto FOREIGN KEY (id_puesto) REFERENCES empleados.PuestosTrabajo(idPuesto),
);

---(productos: Telefonia fija, telefonia movil...)
CREATE TABLE Ventas.Servicios(
    ID_Servicio INT PRIMARY KEY,
	descripcion NVARCHAR(50),
    Costo DECIMAL(10,2),
    Velocidad INT,

);
GO

CREATE TABLE Ventas.Planes (
    ID_plan INT PRIMARY KEY,
    descripcion NVARCHAR(50),
	tiempo_duracion INT,
	);
GO

CREATE TABLE Ventas.Servicios_Planes (
    id_Servicios_Planes INT PRIMARY KEY,
    ID_Servicio INT,
	ID_plan INT,
    Costo DECIMAL(10,2),
	Id_periodo_pago int,
	Cantidad NVARCHAR(50),
);
GO

CREATE TABLE Ventas.Periodo_pago(
    Id_periodo_pago INT PRIMARY KEY,
	Descripcion NVARCHAR(50)
);
GO

CREATE TABLE Ventas.contrato (
    codigo_contrato INT PRIMARY KEY,
    id_Servicios_Planes INT
	ID_Cliente INT,
	fecha_inicio date,
	fecha_fin date, 
	fecha_pago date
);
GO

CREATE TABLE Ventas.factura (
    codigo_factura INT PRIMARY KEY,
	codigo_contrato INT,
    id_Servicios_Planes INT,
	ID_Cliente INT,
	fecha_pago date
);
GO

CREATE TABLE Ventas.Detalle_factura (
    codigo_factura INT PRIMARY KEY,
	codigo_contrato INT,
    id_Servicios_Planes INT,
	ID_Cliente INT,
	fecha_pago date
);
GO

CREATE TABLE Residencial.UsoYTrafico (
    ID_Registro_Uso INT PRIMARY KEY,
    ID_Cliente INT,
	codigo_Servicios_Planes INT,
    Fecha DATE,
    actualizacion_cantidad INT
);
GO

CREATE TABLE Servicios.Soporte (
    ID_Ticket INT PRIMARY KEY,
    ID_Cliente INT,
    Fecha_de_apertura DATETIME,
    Estado NVARCHAR(20),
    Descripcion_del_problema NVARCHAR(MAX)

);
GO


CREATE TABLE ventas.Facturacion (
    ID_Factura INT PRIMARY KEY,
    ID_Cliente INT,
	ID_Servicio INT,
    Fecha_de_emision DATE,
    Fecha_de_vencimiento DATE,
    Total_a_pagar DECIMAL(10,2)
);
GO

CREATE TABLE Factura(
	n_Factura INTEGER PRIMARY KEY,
	id_empleado INTEGER NOT NULL,
	id_cliente INTEGER,
	fecha_hora DATETIME NOT NULL,
	id_local INTEGER NOT NULL,
	monto_pagado DECIMAL (10,2) NOT NULL,
	cambio DECIMAL (10,2) NOT NULL,
	sub_total DECIMAL (10,2) NOT NULL,
	gravado15 DECIMAL (10,2) NOT NULL,
	total DECIMAL (10,2) NOT NULL,
	CONSTRAINT FK_id_empleado FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
	CONSTRAINT FK_id_cliente FOREIGN KEY (id_cliente) REFERENCES Clientes(id_clientes),
	CONSTRAINT FK_id_local FOREIGN KEY (id_local) REFERENCES Sucursales(idlocal)
	);

CREATE TABLE detalle_compra(
	id_detalleCompra INTEGER PRIMARY KEY,
	n_factura INTEGER NOT NULL,
	producto VARCHAR(20) NOT NULL,
	cantidad INTEGER NOT NULL,
	CONSTRAINT FK_n_factura FOREIGN KEY (n_factura) REFERENCES Factura(n_factura),
	CONSTRAINT FK_Producto FOREIGN KEY (producto) REFERENCES Productos(codigo_barras)
	);
ALTER TABLE detalle_compra
ADD PrecioProducto DECIMAL(10,2)


---DIMENSIONES 
---tiempo
---clientes:(Que tipo de servicios se consumen mas por edad)
----(Cuales son los paquetes que mas compran los clientes venden en el mes de diciembre)
---servicios: (Servicios mas solicitados por zonas)tipo de servicios, zonas,
---ventas:(Cuales son los paquetes que mas se venden en el mes de diciembre)
---soporte: (cada cuanto se le da soporte a un tipo de servicio) 
---Empleados: (empleados que mas ventas ha hecho en un lapso de tiempo)


---TIPOS DE SERVICIOS: 
----Planes prepago
----planes postpago(con dispositivo, sin dispositivo)
----planes hogar
----planes empresasiales
----planes y servuicios 


