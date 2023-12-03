
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


SELECT
    s.idLocal,
    s.descripcion AS sucursal_nombre,
    s.horaApertura,
    s.horaCierre,
    s.telefono,
    s.eMail,
    CONCAT(c.descripcion, ', ', m.decripcion, ', ', d.descripcion, ', ', p.descripcion) AS ubicacion
FROM
    Ventas.Sucursales s
JOIN
    Personas.Colonias c ON s.idcolonia = c.id_colonia
JOIN
    Personas.Municipios m ON c.id_municipio = m.idMuncipio
JOIN
    Personas.Departamentos d ON m.idDepto = d.idDepto
JOIN
    Personas.Paises p ON d.idPais = p.idPais;


	/*
--toda la info de los servicios 
use Empresa_Telecomunicaciones
	SELECT 
    Contrato_Compra.id_contrato_Compra,
    Contrato_Compra.fecha_inicio,
    Contrato_Compra.fecha_fin,
    Paquetes.id_paquete,
    Paquetes.nombre AS nombre_paquete,
    Paquetes.descripcion AS descripcion_paquete,
    Forma_pago.descripcion AS forma_pago,
    Tipo_Servicio.nombre AS tipo_servicio,
    Servicios_Planes.nombre AS nombre_servicio_plan,
    Servicios_Planes.precio_mensual,
    Paquetes_Servicios_Planes.cantidad,
    Paquetes_Servicios_Planes.precio,
    Paquetes_Servicios_Planes.tiempo_duracion,
    Paquetes_Servicios_Planes.velocidad,
    Paquetes_Servicios_Planes.medio,
    Paquetes_Servicios_Planes.limite
FROM 
    Ventas.Contrato_Compra
JOIN 
    Ventas.Servicios_Planes ON Contrato_Compra.id_servicios_planes = Servicios_Planes.id_servicios_planes
JOIN 
    Ventas.Paquetes_Servicios_Planes ON Servicios_Planes.id_servicios_planes = Paquetes_Servicios_Planes.id_servicios_planes
JOIN 
    Ventas.Paquetes ON Paquetes_Servicios_Planes.id_paquete = Paquetes.id_paquete
JOIN 
    Ventas.Tipo_Servicio ON Servicios_Planes.id_tipo_servicio = Tipo_Servicio.id_tipo_servicio
JOIN 
    Ventas.Forma_pago ON Tipo_Servicio.id_forma_pago = Forma_pago.id_forma_pago;
*/

SELECT Sp.,sp.id_paquetes_s_p,S.nombre Planes, S.precio_mensual, TS.nombre AS 'Tipo de servicio', P.nombre Paquete, SP.cantidad, SP.medio, SP.tiempo_duracion, SP.velocidad 
FROM Ventas.Paquetes_Servicios_Planes SP 
INNER JOIN Ventas.Servicios_Planes S  
ON SP.id_servicios_planes=S.id_servicios_planes 
INNER JOIN Ventas.Tipo_Servicio TS
ON S.id_tipo_servicio=TS.id_tipo_servicio
INNER JOIN Ventas.Paquetes P
ON SP.id_paquete=P.id_paquete


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
FROM
    Ventas.Sucursales s
JOIN
    Personas.Colonias c ON s.idcolonia = c.id_colonia
JOIN
    Personas.Municipios m ON c.id_municipio = m.idMuncipio
JOIN
    Personas.Departamentos d ON m.idDepto = d.idDepto
JOIN
    Personas.Paises p ON d.idPais = p.idPais;

/*
SELECT  S.idLocal, S.descripcion Nombre, C.descripcion Ubicacion, s.horaApertura, s.horaCierre, s.telefono, s.eMail FROM Ventas.Sucursales S
INNER JOIN Personas.Colonias C
ON S.idcolonia=C.id_colonia
*/

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
    ventas.Factura AS F
JOIN
    Empleados.Empleados AS E ON F.id_empleado = E.id_empleado
JOIN
    Ventas.Contrato_Compra AS CC ON F.id_contrato_Compra = CC.id_contrato_Compra
JOIN
    Ventas.Servicios_Planes AS SP ON CC.id_servicios_planes = SP.id_servicios_planes
JOIN
    ventas.Sucursales AS CL ON F.id_local = CL.idLocal
	order by f.fecha_hora desc
	



	select * from ventas.Factura
	select * from ventas.Contrato_Compra
	select * from ventas.Servicios_Planes
	select * from ventas.Paquetes
	select * from Empleados.Empleados