{
   Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua, # viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.
Para la actualización del archivo maestro, se debe proceder de la siguiente manera:
●
 Al valor de viviendas sin luz se le resta el valor recibido en el detalle.
●
 Idem para viviendas sin agua, sin gas y sin sanitarios.
●
 A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).
   
}


program untitled;
const 
	dimF = 10;
	valoralto = 9999;
type
	datoM = record
		codProv:integer;
		nombreProv:string;
		codLocalidad:integer;
		nombreLocalidad:string;
		cantViviendasSinLuz:integer;
		cantViviendasSinGas:integer;
		cantViviendasChapa:integer;
		cantViviendiasSinAgua:integer;
		cantViviendasSinSanitario:integer;
	end;
	
	datoD = record
		codProv:integer;
		codLocalidad:integer;
		cantViviendasConLuz:integer;
		cantViviendasConstruidas:integer;
		cantViviendasConAgua:integer;
		cantViviendasConGas:integer;
		cantEntregaSanitarios:integer;
	end;
	
	maestro = file of datoM;
	
	detalle = file of datoD;
	detalles = array[1..dimF] of detalle;
	reg_det = array[1..dimF] of datoD;


procedure leerM(var mae:maestro; var m:datoM);
begin
	if (not eof(mae)) then read(mae,m)
	else m.codProv := valoralto;
end;

procedure leerD(var det:detalle; var d:datoD);
begin
	if (not eof(det)) then read(det,d)
	else d.codProv := valoralto;
end;

procedure cargarDetalles(var det:detalles; var d:reg_det);
var
	i:integer; nombre:string;
begin
	for i:=1 to dimF do begin
		readln(nombre);
		assign(det[i],nombre);
		reset(det[i]);
		leerD(det[i],d[i]);
	end;
end;

procedure cerrarDetalles(var det:detalles);
var i: integer;
begin
	for i:=1 to dimF do close(det[i]);
end;

procedure minimo(var det:detalles; var d:reg_det; var min:datoD);
var
	posMin,i:integer;
begin
	min.codProv := valoralto;
	min.codLocalidad := valoralto;
	posMin:=-1;
	for i:=1 to dimF do begin
		if (d[i].codProv < min.codProv) or ((d[i].codProv = min.codProv) and (d[i].codLocalidad < min.codLocalidad)) then begin
			posMin:=i;
			min:=d[i];
		end
	end;
	if (posMin <> -1) then
		leerD(det[posMin],d[posMin]);
end;

procedure actualizar(var mae:maestro; var det:detalles);
var
	d:reg_det; m:datoM; min:datoD;
begin
	reset(mae);
	cargarDetalles(det,d);
	minimo(det,d,min);
	leerM(mae,m);
	while (min.codProv <> valoralto) do begin
		while (m.codProv <> valoralto) and ((m.codProv < min.codProv) or ((m.codProv = min.codProv) and (m.codLocalidad < min.codLocalidad))) do 
			leerM(mae,m);
		if (m.codProv = min.codProv) and (m.codLocalidad = min.codLocalidad) then begin
			m.cantViviendasSinLuz := m.cantViviendasSinLuz-min.cantViviendasConLuz;
			m.cantViviendasSinGas:=m.cantViviendasSinGas-min.cantViviendasConGas;
			m.cantViviendasChapa:=m.cantViviendasChapa-min.cantViviendasConstruidas;
			m.cantViviendiasSinAgua:=m.cantViviendiasSinAgua-min.cantViviendasConAgua;
			m.cantViviendasSinSanitario:=m.cantViviendasSinSanitario-min.cantEntregaSanitarios;
			
			seek(mae,filepos(mae)-1);
			write(mae,m);
		end;
		minimo(det,d,min);
	end;
	close(mae);
	cerrarDetalles(det);
end;

procedure localidadesSinChapa(var mae:maestro);
var
	total:integer; m:datoM; 
begin
	reset(mae);
	total:=0;
	leerM(mae,m);
	while (m.codProv <> valoralto) do begin
		if (m.cantViviendasChapa = 0) then 
			total:=total+1;
		leerM(mae,m);
	end;
	writeln(total);
end;
			
				
var
	mae:maestro; det:detalles;
BEGIN
	assign(mae,'maestroP2_14');
	actualizar(mae,det);
	localidadesSinChapa(mae);
END.

