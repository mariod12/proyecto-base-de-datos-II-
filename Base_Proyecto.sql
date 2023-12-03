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


-- Insert data into Paises table
INSERT INTO Personas.Paises (descripcion) VALUES
('Honduras'),
('El Salvador'),
('Guatemala');

-- Insert data into Departamentos table
INSERT INTO Personas.Departamentos (idPais, descripcion) VALUES
(1, 'Cortes'),
(1, 'Francisco Morazán'),
(2, 'San Salvador'),
(3, 'Guatemala City');

-- Insert data into Municipios table
INSERT INTO Personas.Municipios (idDepto, decripcion) VALUES
(1, 'San Pedro Sula'),
(1, 'Tegucigalpa'),
(2, 'Distrito Central'),
(3, 'Mixco');

-- Insert data into Colonias table
INSERT INTO Personas.Colonias (id_municipio, descripcion) VALUES
(1, 'Colonia Alameda'),
(2, 'Colonia Palmira'),
(3, 'Colonia Escalón'),
(4, 'Colonia San Juan');

-- Insert data into Generos table
INSERT INTO personas.Generos (descripcion) VALUES
('Masculino'),
('Femenino'),
('Otro');

-- Insert data into Personas table
INSERT INTO Personas.Personas (identidad,id_colonia, id_genero, P_nombre, P_apellido, direccion, telefono, fecha_nacimiento, correo) VALUES
(08012232,1, 1, 'John', 'Doe', '123 Main Street', '987654321', '1990-01-15', 'john.doe@example.com'),
(0993293,2, 2, 'Jane', 'Doe', '456 Oak Avenue', '123456789', '1985-05-20', 'jane.doe@example.com')
INSERT INTO Personas.Personas (identidad, id_colonia, id_genero, P_nombre, P_apellido, direccion, telefono, fecha_nacimiento, correo) VALUES
(98765433, 3, 2, 'Michael', 'Johnson', '567 Maple Street', '111222333', '1993-09-18', 'michael.johnson@example.com'),
(65432109, 1, 1, 'Olivia', 'Williams', '876 Birch Avenue', '444555666', '1980-07-12', 'olivia.williams@example.com'),
(11223344, 2, 2, 'Daniel', 'Taylor', '345 Cedar Lane', '666777888', '1998-04-30', 'daniel.taylor@example.com'),
(88990011, 3, 1, 'Sophia', 'Miller', '789 Oak Road', '999000111', '1987-11-26', 'sophia.miller@example.com'),
(22334455, 1, 2, 'Matthew', 'Davis', '987 Pine Avenue', '123789456', '1991-06-08', 'matthew.davis@example.com');


select * from personas.personas

-- Inserta datos en la tabla tipoCliente
INSERT INTO Clientes.tipoCliente (descripcion, beneficios) VALUES
('Cliente Regular', 'Descuentos especiales'),
('Cliente VIP', 'Acceso a eventos exclusivos'),
('Cliente Corporativo', 'Beneficios para empresas');


-- Inserta datos en la tabla Clientes
INSERT INTO Clientes.Clientes (id_persona, id_tipo_cliente,fecha_afiliaccion) VALUES
(98765433, 1, '2021-03-10'),
(88990011, 2, '2020-12-05'),
(22334455, 1, '2019-08-20')
-- Inserta datos en la tabla PuestosTrabajo
INSERT INTO Empleados.PuestosTrabajo (descripcion, comentario) VALUES
('Gerente General', 'Responsable de la dirección estratégica'),
('Asistente de Ventas', 'Atención al cliente y apoyo en ventas'),
('Desarrollador de Software', 'Programación y desarrollo de software');

-- Inserta datos en la tabla Empleados
INSERT INTO Empleados.Empleados (id_empleado,id_persona, id_puesto, Salario, Fecha_de_contratacion) VALUES
(1,08012232,1, 5000.00, '2022-02-01'),
(2,0993293,2, 2500.00, '2021-06-15'),
(3,11223344,3, 6000.00, '2020-11-10');


--Insertar datos en la tabla Sucursales
INSERT INTO Ventas.Sucursales (idLocal, idcolonia, descripcion, horaApertura, horaCierre, telefono, eMail)
VALUES
(1, 1, 'Sucursal A', '08:00', '18:00', '12345678', 'sucursalA@email.com'),
(2, 2, 'Sucursal B', '09:00', '19:00', '87654321', 'sucursalB@email.com'),
(3, 4, 'Sucursal C', '10:00', '20:00', '55443322', 'sucursalC@email.com'),
(4, 1, 'Sucursal D', '08:30', '18:30', '11223344', 'sucursalD@email.com');

-- Insertar datos en la tabla Paquetes
INSERT INTO Ventas.Paquetes (nombre, descripcion)
VALUES
('Paquete A', 'paquete premium '),
('Paquete B', 'paquete regular');

-- Insertar datos en la tabla Forma_pago
INSERT INTO Ventas.Forma_pago (descripcion)
VALUES
('Prepago'),
('Pospago');


-- Insertar datos en la tabla Tipo_Servicio
INSERT INTO Ventas.Tipo_Servicio (nombre, id_forma_pago)
VALUES
('Hogar', 1),
('Móvil', 2);

-- Insertar datos en la tabla Servicios_Planes
INSERT INTO Ventas.Servicios_Planes (nombre, precio_mensual, id_tipo_servicio)
VALUES
('Plan 1', 50.00, 1),
('Plan 2', 75.00, 2),
('Plan 3', 60.00, 2),
('Plan 4', 80.00, 2),
('Plan 5', 90.00, 1),
('Plan 6', 70.00, 1),
('Plan 7', 100.00, 2);


-- Insertar datos en la tabla Paquetes_Servicios_Planes
INSERT INTO Ventas.Paquetes_Servicios_Planes (cantidad, precio, tiempo_duracion, velocidad, medio, limite, id_servicios_planes, id_paquete)
VALUES
('10 GB', 30.00, '2023-12-31', '50 Mbps', 'Fibra Óptica', 0, 1, 1),
('20 GB', 50.00, '2023-12-31', '100 Mbps', 'Cable', 1, 2, 2);
INSERT INTO Ventas.Paquetes_Servicios_Planes (cantidad, precio, tiempo_duracion, velocidad, medio, limite, id_servicios_planes, id_paquete)
VALUES
('15 GB', 40.00, '2023-12-31', '75 Mbps', 'Satélite', 0, 2, 2),
('25 GB', 60.00, '2023-12-31', '120 Mbps', 'DSL', 0, 2, 2),
('30 GB', 70.00, '2023-12-31', '150 Mbps', 'Fibra Óptica', 1, 1, 2),
('18 GB', 50.00, '2023-12-31', '90 Mbps', 'Cable', 0, 2, 1),
('12 GB', 35.00, '2023-12-31', '60 Mbps', 'Fibra Óptica', 1, 1, 1);


select * from Ventas.Paquetes_Servicios_Planes

-- Inserciones en la tabla Contrato_Compra
INSERT INTO Ventas.Contrato_Compra (fecha_inicio, fecha_fin, id_servicios_planes, id_cliente)
VALUES
('2023-01-01', '2023-12-31', 1, 1),
('2023-02-15', '2023-11-30', 2, 2),
('2023-03-20', '2023-10-15', 6, 3),
('2023-04-10', '2023-09-30', 7, 1),
('2023-05-05', '2023-08-20', 3, 2);

select * from  Ventas.Contrato_Compra 

-- Inserciones en la tabla Renovaciones
INSERT INTO ventas.Renovaciones (id_contrato, fecha_de_renovacion)
VALUES
(2, '2023-11-15'),
(2, '2023-10-10'),
(3, '2023-09-05'),
(4, '2023-08-01'),
(5, '2023-07-15');

-- Inserciones en la tabla Factura
INSERT INTO ventas.Factura (n_Factura, id_empleado, id_contrato_Compra,
    fecha_hora, id_local, monto_pagado, cambio, sub_total, gravado15, total
)
VALUES
(1, 1,  2, '2023-11-20 12:30:00', 1, 100.00, 10.00, 90.00, 13.50, 103.50),
(2, 2, 2, '2023-10-15 15:45:00', 2, 75.00, 5.00, 70.00, 10.50, 80.50),
(3, 1,  3, '2023-09-10 10:00:00', 3, 120.00, 15.00, 105.00, 15.75, 120.75),
(4, 3, 4, '2023-08-05 14:20:00', 2, 90.00, 8.00, 82.00, 12.30, 94.30),
(5, 3, 5, '2023-07-20 11:15:00', 1, 150.00, 20.00, 130.00, 19.50, 149.50);


