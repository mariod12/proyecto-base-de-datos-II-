
use Empresa_Telecomunicaciones

--dimension clientes
SELECT 
	c.id_cliente, 
	p.P_nombre+' '+p.P_apellido Nombre,
    p.direccion,
    p.telefono,
    YEAR(GETDATE()) - YEAR(p.fecha_nacimiento) Edad,  
   p.correo,
    Co.descripcion  colonia,
    Mun.decripcion  municipio,
    Dep.descripcion  departamento,
    Pa.descripcion  pais,
    Gen.descripcion  genero,
    tc.descripcion  tipo_cliente,
    tc.beneficios,
    c.fecha_afiliaccion
FROM Clientes.Clientes c
inner join Personas.Personas p ON c.id_persona = p.identidad
inner join personas.Colonias co ON p.id_colonia = co.id_colonia
inner join  Personas.Municipios mun ON co.id_municipio = mun.idMuncipio
inner join Personas.Departamentos dep ON mun.idDepto = dep.idDepto
inner join   Personas.Paises pa ON dep.idPais = pa.idPais
inner join Personas.Generos gen ON p.id_genero = gen.id_genero
inner join Clientes.tipoCliente tc ON C.id_tipo_cliente = tc.id_tipo_cliente;

--dimension EMPLEADOS  
SELECT 
	c.id_empleado, 
	p.P_nombre+' '+p.P_apellido Nombre,
    p.telefono,
    YEAR(GETDATE()) - YEAR(p.fecha_nacimiento) Edad,  
	 Gen.descripcion  genero,
	c.Fecha_de_contratacion,
	c.Salario,
	p.correo,
	pt.descripcion Puesto,
	pt.comentario Descripcion_puesto,
    Co.descripcion  colonia,
    Mun.decripcion  municipio,
    Dep.descripcion  departamento,
    p.direccion,
    Pa.descripcion  pais
FROM Empleados.Empleados c
inner join Personas.Personas p ON c.id_persona = p.identidad
inner join personas.Colonias co ON p.id_colonia = co.id_colonia
inner join  Personas.Municipios mun ON co.id_municipio = mun.idMuncipio
inner join Personas.Departamentos dep ON mun.idDepto = dep.idDepto
inner join   Personas.Paises pa ON dep.idPais = pa.idPais
inner join Personas.Generos gen ON p.id_genero = gen.id_genero
inner join Empleados.PuestosTrabajo pt on pt.idPuesto=c.id_puesto

--dimension tiempo desde factura 

select distinct month (f.fecha_hora) Mes, 
year (f.fecha_hora) Anio,
f.fecha_hora Fecha 
from ventas.Factura f
--dimension servicios 
SELECT Sp.,sp.id_paquetes_s_p,S.nombre Planes, S.precio_mensual, TS.nombre AS 'Tipo de servicio', P.nombre Paquete, SP.cantidad, SP.medio, SP.tiempo_duracion, SP.velocidad 
FROM Ventas.Paquetes_Servicios_Planes SP 
INNER JOIN Ventas.Servicios_Planes S  
ON SP.id_servicios_planes=S.id_servicios_planes 
INNER JOIN Ventas.Tipo_Servicio TS
ON S.id_tipo_servicio=TS.id_tipo_servicio
INNER JOIN Ventas.Paquetes P
ON SP.id_paquete=P.id_paquete

--dimension contratos 
SELECT CC.id_contrato_Compra, CC.id_cliente, SP.nombre, TS.nombre AS 'Tipo servicio', SP.precio_mensual, CC.fecha_inicio, CC.fecha_fin
FROM Ventas.Contrato_Compra CC
INNER JOIN Ventas.Servicios_Planes SP
ON CC.id_servicios_planes=SP.id_servicios_planes
INNER JOIN Ventas.Tipo_Servicio TS
ON SP.id_tipo_servicio=TS.id_tipo_servicio
INNER JOIN Clientes.Clientes C 
ON CC.id_cliente=C.id_cliente

---dimension sucursales 

SELECT
    s.idLocal,
    s.descripcion AS sucursal_nombre,
    s.horaApertura,
    s.horaCierre,
    s.telefono,
    s.eMail,
    CONCAT(c.descripcion, ', ', m.decripcion, ', ', d.descripcion, ', ', p.descripcion) AS ubicacion
FROM Ventas.Sucursales s
inner join Personas.Colonias c ON s.idcolonia = c.id_colonia
inner join Personas.Municipios m ON c.id_municipio = m.idMuncipio
inner join Personas.Departamentos d ON m.idDepto = d.idDepto
inner join Personas.Paises p ON d.idPais = p.idPais;

/*
SELECT  S.idLocal, S.descripcion Nombre, C.descripcion Ubicacion, s.horaApertura, s.horaCierre, s.telefono, s.eMail FROM Ventas.Sucursales S
INNER JOIN Personas.Colonias C
ON S.idcolonia=C.id_colonia
*/

--tabla de hechos factura ventas 
SELECT
    F.n_Factura,
	CC.id_cliente,
    E.id_empleado,
    CC.id_contrato_Compra,
    SP.id_servicios_planes,
    CL.idLocal,
	f.total,
	f.fecha_hora
FROM
    ventas.Factura F
inner join Empleados.Empleados E ON F.id_empleado = E.id_empleado
inner join Ventas.Contrato_Compra CC ON F.id_contrato_Compra = CC.id_contrato_Compra
inner join Ventas.Servicios_Planes SP ON CC.id_servicios_planes = SP.id_servicios_planes
inner join ventas.Sucursales CL on F.id_local = CL.idLocal
	order by f.fecha_hora desc
	



	select * from ventas.Factura
	select * from ventas.Contrato_Compra
	select * from ventas.Servicios_Planes
	select * from ventas.Paquetes
	select * from Empleados.Empleados
