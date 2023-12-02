CREATE DATABASE BDII_Telecomunication_Bussines;
GO

USE BDII_Telecomunication_Bussines;
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
--CREATE TABLES 

-- estas tablas son para conocer la ubicacion de la empresa, clientes y empleados 
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

-- tablas para registrar los clientes 
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

--tablas para registrar empleados 
CREATE TABLE Empleados.PuestosTrabajo(
idPuesto INTEGER IDENTITY (1,1) PRIMARY KEY,
descripcion VARCHAR (80) NOT NULL,
comentario VARCHAR (150) NULL
);

CREATE TABLE Empleados.Empleados(
id_empleado INTEGER PRIMARY KEY,
id_persona INTEGER NOT NULL,
id_puesto INTEGER NOT NULL, 
Salario DECIMAL(10, 2),
Fecha_de_contratacion DATE,
CONSTRAINT FK_emp_per FOREIGN KEY (id_persona) REFERENCES personas.Personas(idPersona),
CONSTRAINT FK_emp_puesto FOREIGN KEY (id_puesto) REFERENCES empleados.PuestosTrabajo(idPuesto),
);

--esta se puede usar para ver cual es la sucursal que mas ventas tiene 
CREATE TABLE ventas.Sucursales(
idLocal INTEGER PRIMARY KEY,
idcolonia INTEGER NOT NULL,
descripcion VARCHAR (100) NOT NULL, -- para el nombre de la sucursal o direccion, verificar esto 
horaApertura TIME NOT NULL, 
horaCierre TIME NOT NULL, 
telefono VARCHAR (8) NOT NULL,
eMail VARCHAR (50) NULL,
CONSTRAINT FK_sucur_mun FOREIGN KEY (idcolonia) REFERENCES Personas.colonias(id_colonia)
);

CREATE TABLE ventas.Tipos_Servicios_generales(
id_tipo_servicio INT PRIMARY KEY IDENTITY(1,1), 
descripcion varchar(100)--hogar o movil 
);

CREATE TABLE ventas.Tipo_Plan_movil (
id_Tipo_Plan_movil INT PRIMARY KEY IDENTITY(1,1), 
descripcion varchar (50)-- prepago o pospago 
);

CREATE TABLE ventas.servicios_Planes(
id_plan INT PRIMARY KEY IDENTITY(1,1),
id_tipo_plan int not null, 
costo DECIMAL (10,2) NOT NULL,
cantidad_de_datos INT, 
cantidad_de_minutos VARCHAR(100),--Varchar porque puede ser ilimitado 
cantidad_de_mensajes VARCHAR(100),--Varchar porque puede ser ilimitado 
redes_incluidas VARCHAR(100),--fb ig wa tiktok etc 
vigencia_en_dias INT NOT NULL,--TODOS TIENE VIGENCIA 
fecha_de_renovacion DATE, --PUEDE SER NULL, SOLAMENTE ES PARA POSPAGO O PAQUETES PREPAGO QUE SE RENUEVAN 
CONSTRAINT FKservicioplan FOREIGN KEY (id_tipo_plan) REFERENCES ventas.Tipo_Plan_movil(id_Tipo_Plan_movil)

);

CREATE TABLE ventas.TiposServicioHogar (
ID_Tipo_servicioHogar INT PRIMARY KEY,
Nombre_tipoServicio NVARCHAR(50)--internet, fibra optica, tv
);

CREATE TABLE ventas.Servicios_Hogar (
id_ServicioHogar INT PRIMARY KEY,
id_servicio INT not null, 
nombre_servicio NVARCHAR(50),--plan pobre, plan premium, plan para millonarios,plan individual 
tipo_servicio NVARCHAR(50),  -- Pueden ser TV Satelital,Internet por Fibra Óptica,Internet Residencia lo dejo asi porque pueden ser varios de un solo 
precio_mensual DECIMAL(10,2),
velocidad_internet INT,      -- Puede ser NULL si el servicio no incluye internet
cantidad_canalesTV INT,              -- Puede ser NULL si el servicio no incluye televisión
otros_detalles NVARCHAR(MAX),  -- Otros detalles relevantes
fecha_inicio_contrato DATE,   -- Fecha de inicio del contrato para este servicio
fecha_fin_contrato DATE,      -- Fecha de fin del contrato para este servicio
);

--tabla de muchos a muchos para hacer esa union de arriba
CREATE TABLE ventas.Servicios_tipos_muchos(
ID_Tipo_servicioHogar int not null, 
id_ServicioHogar int not null, 
PRIMARY KEY (id_ServicioHogar, ID_Tipo_servicioHogar),
CONSTRAINT FK_ID_Tipo_servicioHogar FOREIGN KEY (ID_Tipo_servicioHogar) REFERENCES ventas.TiposServicioHogar(ID_Tipo_servicioHogar),
CONSTRAINT FK_id_ServicioHogar FOREIGN KEY (id_ServicioHogar) REFERENCES ventas.Servicios_Hogar(id_ServicioHogar) 
);

CREATE TABLE ventas.Servicios_Contratados (
    id_servicio_contratado INT PRIMARY KEY IDENTITY(1,1),
    id_tipo_servicio INT NOT NULL,
	id_servicios_Planes int, -- Puede ser NULL si no es un servicio movil 
    Servicios_Hogar INT, -- Puede ser NULL si no es un servicio hogar
    CONSTRAINT FK_tipo_servicio FOREIGN KEY (id_tipo_servicio) REFERENCES ventas.Tipos_Servicios_generales(id_tipo_servicio),
	CONSTRAINT fk_servicio_planes FOREIGN KEY (id_servicios_Planes) REFERENCES ventas.servicios_Planes(id_plan),
    CONSTRAINT FK_Servicios_Hogar FOREIGN KEY (Servicios_Hogar) REFERENCES ventas.Servicios_Hogar(id_ServicioHogar)
);

--CON ESTA TABLA PUEDO HACER UNA CONSULTA PARA SABER CUALES SON LOS PLANES QUE MAS SE RENUEVAN 
CREATE TABLE ventas.Renovaciones(
id_renovaciones INT PRIMARY KEY IDENTITY (1,1),
id_servicio_contratado INT NOT NULL, 
fecha_de_renovacion DATE NOT NULL,
CONSTRAINT fkservicioContratad FOREIGN KEY (id_servicio_contratado) REFERENCES ventas.Servicios_Contratados(id_servicio_contratado)

);

CREATE TABLE ventas.Factura(
	n_Factura INTEGER PRIMARY KEY,
	id_empleado INTEGER NOT NULL,
	id_cliente INTEGER not null,
	id_sucursal INT NOT NULL, 
	Id_Servicio_Contratado int not null, 
	fecha_hora DATETIME NOT NULL,
	id_local INTEGER NOT NULL,
	monto_pagado DECIMAL (10,2) NOT NULL,
	cambio DECIMAL (10,2) NOT NULL,
	sub_total DECIMAL (10,2) NOT NULL,
	gravado15 DECIMAL (10,2) NOT NULL,
	total DECIMAL (10,2) NOT NULL,
	CONSTRAINT FK_id_empleado FOREIGN KEY (id_empleado) REFERENCES Empleados.Empleados(id_empleado),
	CONSTRAINT FK_id_cliente FOREIGN KEY (id_cliente) REFERENCES Clientes(id_clientes),
	CONSTRAINT FK_id_local FOREIGN KEY (id_local) REFERENCES ventas.Sucursales(idlocal),
	CONSTRAINT FK_servicio_contrado FOREIGN KEY (Id_Servicio_Contratado) REFERENCES ventas.Servicios_Contratados(id_servicio_contratado),
	);



---DIMENSIONES 
---tiempo esta es fija 
---clientes:(Que tipo de servicios se consumen mas por edad)
---(Cuales son los paquetes que mas compran los clientes venden en el mes de diciembre)
---servicios: (Servicios mas solicitados por zonas)tipo de servicios, zonas,
---ventas:(Cuales son los paquetes que mas se venden en el mes de diciembre)
--soporte: (cada cuanto se le da soporte a un tipo de servicio) 
---Empleados: (empleados que mas ventas ha hecho en un lapso de tiempo)


---TIPOS DE SERVICIOS: 
----Planes prepago
----planes postpago(con dispositivo, sin dispositivo)
----planes hogar
----planes empresasiales
----planes y servuicios 






/* tigo y claro te pueden vender

celulares 

celulares con plan (postpago) 

servicios de msj, llamadas e internet (esto puede estar relacionado con celulares con plan) 

el servicio de plan y servicios residenciales deben darse validos por un contrato 

un cliente puede tener varios planes y varios planes pueden ser de un cliente 

servicios redicenciales 
(averiguar que incluyen los servicios residenciles)

contratos para los servicios residenciales y comprar celulares con plan 

para saber cuales son los servicions mas vendidos puedo hacerlo con la tabla de contratos, eso es en servicios

para saber cual es el producto mas vendido en factura 

tengo que relacionar la informacion del contrato en factura para poder obtener el tipo de servicio 
   
   
