{Se cuenta con un archivo que posee información de las ventas que realiza
 una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas
 organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales
 del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado
 en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total
de ventas obtenido
por la empresa.

El formato del archivo maestro está dado por: cliente (cod cliente, nombre
 y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente,
año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes
 no realizaron
compras. No es necesario que informe tales meses en el reporte.
   
}


program untitled;
const
	valoralto = 9999;
type
	fecha = record
		dia:1..31;
		mes: integer;
		anio:integer;
	end;
	
	cliente = record
		codigo:integer;
		nombre:string;
		apellido:string;
	end;
	
	venta = record
		c:cliente;
		f:fecha;
		monto:real;
	end;
	
	maestro = file of venta;

procedure leer(var mae:maestro; var m:venta);
begin
	if (not eof(mae)) then
		read(mae, m)
	else begin
		m.c.codigo := valoralto;
	end;
end;

procedure informar(var mae:maestro);
var m:venta;
	clienteActual:cliente; totalMensualActual:real;
	totalAnioActual:real; fechaActual:fecha;
	montoTotalEmpresa:real;
begin
	montoTotalEmpresa := 0;
	leer(mae,m);
	while (m.c.codigo <> valoralto) do begin
		clienteActual := m.c;
		writeln('cliente: ');
		writeln(m.c.codigo,m.c.nombre,m.c.apellido);
		while (m.c.codigo = clienteActual.codigo) do begin
			fechaActual.anio := m.f.anio;
			totalAnioActual := 0;
			while (m.c.codigo = clienteActual.codigo) and (m.f.anio = fechaActual.anio) do begin
				fechaActual.mes := m.f.mes; 
				totalMensualActual := 0;
				while (m.c.codigo = clienteActual.codigo) and (m.f.anio = fechaActual.anio) and (m.f.mes = fechaActual.mes) do begin
					totalMensualActual := totalMensualActual + m.monto;
					leer(mae,m);
				end;
				if (totalMensualActual <> 0) then begin
					writeln('mes ',fechaActual.mes,' el total es de: ',totalMensualActual);
					totalAnioActual := totalAnioActual + totalMensualActual;
					montoTotalEmpresa := montoTotalEmpresa + totalMensualActual;
				end;
				
			end;
			writeln('monto total del anio ',fechaActual.anio,': ',totalAnioActual);
		end;
	end;
	writeln('monto total de la empresa: ',montoTotalEmpresa);
end;



var 
	mae:maestro;
BEGIN
	assign(mae,'maestro');
	reset(mae);
	informar(mae);
	close(mae);
	
END.

