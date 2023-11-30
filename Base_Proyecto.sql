CREATE DATABASE Telecomunication_Bussines;
GO

USE Telecomunication_Bussines;
GO

CREATE SCHEMA Personas
GO

CREATE SCHEMA Clientes
GO

CREATE SCHEMA Empleados
GO

CREATE SCHEMA Ventas
GO

CREATE TABLE Personas.genero(
id_genero INT IDENTITY PRIMARY KEY,
descripcion NVARCHAR (50));
GO

CREATE TABLE Personas.departamento(
id_departamento INT IDENTITY PRIMARY KEY,
descripcion VARCHAR(100));
GO

CREATE TABLE Personas.municipio(
id_municipio INT IDENTITY PRIMARY KEY,
descripcion VARCHAR(100));
GO

CREATE TABLE Personas.colonia(
id_colonia INT IDENTITY PRIMARY KEY,
descripcion VARCHAR(100)
);
GO

CREATE TABLE Personas.Personas (
    ID_persona NVARCHAR(50) PRIMARY KEY,
    p_nombre NVARCHAR(50),
	s_nombre NVARCHAR(50),
    p_apellido NVARCHAR(50),
	s_apellido NVARCHAR(50),
    Direccion NVARCHAR(100),
	fecha_nacimiento date,
    Numero_de_telefono NVARCHAR(15),
	correo_electronico NVARCHAR(100)
	id_colonia INT,
	id_genero INT
);
GO


CREATE TABLE Clientes.Clientes (
    ID_Cliente INT PRIMARY KEY,
    ID_persona NVARCHAR(50),
	fecha_afiliaccion DATE, 
	id_tipo_cliente INT,

);
GO

CREATE TABLE Clientes.tipoCliente(
  id_tipo_cliente INT IDENTITY PRIMARY KEY,
  descripcion NVARCHAR(100),
  beneficios NVARCHAR(100) );
  GO

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


CREATE TABLE Residencial.Facturacion (
    ID_Factura INT PRIMARY KEY,
    ID_Cliente INT,
	ID_Servicio INT,
    Fecha_de_emision DATE,
    Fecha_de_vencimiento DATE,
    Total_a_pagar DECIMAL(10,2)
);
GO


CREATE TABLE Empleados (
    ID_Empleado INT PRIMARY KEY,
    Nombre NVARCHAR(50),
    Apellido NVARCHAR(50),
    Cargo NVARCHAR(50),
    Fecha_de_contratacion DATE
);
GO

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


