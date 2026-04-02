{ La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el
 sitio web
de la organización. En dicho servidor, se almacenan en un archivo todos los accesos
 que se
realizan al sitio. La información que se almacena en el archivo es la
 siguiente: año, mes, día,
idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra
 ordenado
por los siguientes criterios: año, mes, día e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se
 indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar
 el formato
mostrado a continuación:
Año : ---
Mes:-- 1
día:-- 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
--------
idusuario N Tiempo total de acceso en el dia 1 mes 1
Tiempo total acceso dia 1 mes 1
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 1
--------
idusuario N Tiempo total de acceso en el dia N mes 1
Tiempo total acceso dia N mes 1
Total tiempo de acceso mes 1
------
Mes 12
día 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
--------
idusuario N Tiempo total de acceso en el dia 1 mes 12
Tiempo total acceso dia 1 mes 12
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 12
--------
idusuario N Tiempo total de acceso en el dia N mes 12
Tiempo total acceso dia N mes 12
Total tiempo de acceso mes 12
Total tiempo de acceso año
Se deberá tener en cuenta las siguientes aclaraciones:
● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.
●
●
●
El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
Debe definir las estructuras de datos necesarias.
El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.
}


program untitled;
const
	valoralto = 9999;
type
	informacion = record
		anio, mes, dia: integer;
		id: integer;
		acceso: real;
	end;
	
	maestro = file of informacion;
	
procedure leer(var mae:maestro; var m:informacion);
begin
	if (not eof(mae)) then
		read(mae,m)
	else
		m.anio := valoralto;
end;


procedure informar(var mae:maestro);
var
	m:informacion; anio,mesAct,diaAct,idAct:integer;
	totalAcceso,totalAmes,totalAdia,totalAanio:real;
begin
	reset(mae);
	leer(mae,m);
	write('Ingrese el año a informar: ');
	readln(anio);
	while (m.anio <> valoralto) and (m.anio < anio) do
		leer(mae, m);
	if (m.anio <> valoralto) and (m.anio = anio) then begin
		writeln('anio: ',m.anio);
		totalAanio:=0;
		while (m.anio = anio) do begin
			mesAct := m.mes;
			writeln('mes: ',m.mes);
			totalAmes:=0;
			while (m.anio = anio) and (m.mes = mesAct) do begin
				diaAct := m.dia;
				writeln('dia: ', m.dia);
				totalAdia:=0;
				while (m.anio = anio) and (m.mes = mesAct) and (m.dia = diaAct) do begin
					idAct:=m.id;
					totalAcceso:=0; //id usuario acceso
					while (m.anio = anio) and (m.mes = mesAct) and (m.dia = diaAct) and (m.id = idAct) do begin
						totalAcceso := totalAcceso + m.acceso;
						totalAanio := totalAanio + m.acceso;
						totalAmes := totalAmes + m.acceso;
						totalAdia := totalAdia + m.acceso;
						leer(mae,m);
					end;
					writeln('idUsuario ',idAct, 'tiempo todal de acceso en el mes ',mesAct,' dia ',diaAct,' es de ', totalAcceso);
				end;
				writeln('Tiempo total acceso dia ', diaAct, ' mes ', mesAct,': ',totalAdia);
			end;
			writeln('Total tiempo de acceso mes ',mesAct,': ',totalAmes);
		end;
		writeln('Total tiempo de acceso año ',anio,': ',totalAanio);
	end
	else
		writeln('anio no encontrado');
	close(mae);
end;
	

var
	mae:maestro;
BEGIN
	assign(mae, 'maestroP2_11');
	informar(mae);
END.

