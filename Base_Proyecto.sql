CREATE DATABASE Empresa_Telecomunicaciones;
GO


USE Empresa_Telecomunicaciones;
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
identidad varchar(15) PRIMARY KEY, 
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


CREATE TABLE Clientes.Clientes(
id_cliente INTEGER IDENTITY(1,1) PRIMARY KEY, 
id_persona varchar(15) NOT NULL,
id_tipo_cliente INT not null,
fecha_afiliaccion DATE, 
CONSTRAINT Fk_tipo_cliente FOREIGN KEY (id_tipo_cliente) REFERENCES Clientes.tipoCliente(id_tipo_cliente),
CONSTRAINT Fk_persona FOREIGN KEY (id_persona) REFERENCES Personas.Personas(identidad),

);

--tablas para registrar empleados 
CREATE TABLE Empleados.PuestosTrabajo(
idPuesto INTEGER IDENTITY (1,1) PRIMARY KEY,
descripcion VARCHAR (80) NOT NULL,
comentario VARCHAR (150) NULL
);

CREATE TABLE Empleados.Empleados(
id_empleado INTEGER PRIMARY KEY,
id_persona varchar(15) NOT NULL,
id_puesto INTEGER NOT NULL, 
Salario DECIMAL(10, 2),
Fecha_de_contratacion DATE,
CONSTRAINT FK_emp_per FOREIGN KEY (id_persona) REFERENCES personas.Personas(identidad),
CONSTRAINT FK_emp_puesto FOREIGN KEY (id_puesto) REFERENCES empleados.PuestosTrabajo(idPuesto),
);

--esta se puede usar para ver cual es la sucursal que mas ventas tiene 
CREATE TABLE Ventas.Sucursales(
idLocal INTEGER PRIMARY KEY,
idcolonia INTEGER NOT NULL,
descripcion VARCHAR (100) NOT NULL, -- para el nombre de la sucursal o direccion, verificar esto 
horaApertura TIME NOT NULL, 
horaCierre TIME NOT NULL, 
telefono VARCHAR (8) NOT NULL,
eMail VARCHAR (50) NULL,
CONSTRAINT FK_sucur_mun FOREIGN KEY (idcolonia) REFERENCES Personas.colonias(id_colonia)
);

CREATE TABLE Ventas.Paquetes(
id_paquete INT IDENTITY PRIMARY KEY,
nombre VARCHAR(100),
descripcion VARCHAR(100)
);

--prepago pospago 
CREATE TABLE Ventas.Forma_pago(
id_forma_pago INT IDENTITY PRIMARY KEY,
descripcion VARCHAR(20));


CREATE TABLE Ventas.Tipo_Servicio(
id_tipo_servicio INT IDENTITY PRIMARY KEY,
nombre varchar(50),
id_forma_pago INT, 
CONSTRAINT FK_forma_pago FOREIGN KEY (id_forma_pago) REFERENCES Ventas.Forma_pago(id_forma_pago) 
);


CREATE TABLE Ventas.Servicios_Planes(
id_servicios_planes INT IDENTITY PRIMARY KEY,
nombre VARCHAR(100),
precio_mensual decimal,
id_tipo_servicio INT,
CONSTRAINT FK_TipoServici FOREIGN KEY (id_tipo_servicio) REFERENCES Ventas.Tipo_Servicio(id_tipo_servicio)
); 


CREATE TABLE Ventas.Paquetes_Servicios_Planes(
id_paquetes_s_p INT IDENTITY PRIMARY KEY,
cantidad VARCHAR(10),
precio DECIMAL,
tiempo_duracion DATE,
velocidad VARCHAR(20),
medio VARCHAR(100),
limite BIT,
id_servicios_planes INT,
id_paquete INT,
CONSTRAINT FK_serv_planes FOREIGN KEY (id_servicios_planes ) REFERENCES Ventas.Servicios_Planes(id_servicios_planes ) ,
CONSTRAINT FK_paquete FOREIGN KEY (id_paquete) REFERENCES Ventas.Paquetes(id_paquete) 
);

CREATE TABLE Ventas.Contrato_Compra(
id_contrato_Compra INT IDENTITY PRIMARY KEY,
fecha_inicio DATE,
fecha_fin DATE NULL, 
id_servicios_planes INT,
id_cliente INT,
CONSTRAINT FK_serv_plaan FOREIGN KEY (id_servicios_planes) REFERENCES Ventas.Servicios_Planes(id_servicios_planes),
CONSTRAINT FK_cli FOREIGN KEY (id_cliente) REFERENCES Clientes.Clientes(id_cliente)
);

CREATE TABLE ventas.Renovaciones(
id_renovaciones INT PRIMARY KEY IDENTITY (1,1),
id_contrato INT NOT NULL, 
fecha_de_renovacion DATE NOT NULL,
CONSTRAINT fkservicioContratad FOREIGN KEY (id_contrato) REFERENCES Ventas.Contrato_Compra(id_contrato_compra)

);

CREATE TABLE ventas.Factura(
	n_Factura INTEGER PRIMARY KEY,
	id_empleado INTEGER NOT NULL,
	id_contrato_Compra int not null, 
	fecha_hora DATETIME NOT NULL,
	id_local INTEGER NOT NULL,
	monto_pagado DECIMAL (10,2) NOT NULL,
	cambio DECIMAL (10,2) NOT NULL,
	sub_total DECIMAL (10,2) NOT NULL,
	gravado15 DECIMAL (10,2) NOT NULL,
	total DECIMAL (10,2) NOT NULL,
	CONSTRAINT FK_id_empleado FOREIGN KEY (id_empleado) REFERENCES Empleados.Empleados(id_empleado),
	CONSTRAINT FK_id_local FOREIGN KEY (id_local) REFERENCES ventas.Sucursales(idlocal),
	CONSTRAINT FK_servicio_contrado FOREIGN KEY (id_contrato_Compra) REFERENCES ventas.Contrato_Compra(id_contrato_Compra),

	);


