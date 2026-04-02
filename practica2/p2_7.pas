{7.
Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1.
 Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2.
 Idem anterior para los recuperados.
3.
 Los casos activos se actualizan con el valor recibido en el detalle.
4.
 Idem anterior para los casos nuevos hallados.
 
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).

}


program p2_7;
const 
	dimF = 10;
	valoralto = 9999;
type
	informacionD = Record
		codigoLocalidad:integer;
		nombreLocalidad:string;
		codigoCepa:integer;
		nombreCepa:string;
		cantidadCasosActivos:integer;
		cantidadCasosNuevos:integer;
		cantidadRecuperados:integer;
		cantidadFallecidos:integer;
	end;
	
	informacionM = record
		codigoLocalidad:integer;
		nombreLocalidad:string;
		codigoCepa:integer;
		nombreCepa:string;
		cantidadCasosActivos:integer;
		cantidadCasosNuevos:integer;
		cantidadRecuperados:integer;
		cantidadFallecidos:integer;
	end;
	
	detalle = file of informacionD;
	detalles = array[1..dimF] of detalle;
	reg_det = array[1..dimF] of informacionD;
	
	maestro = file of informacionM;
	
procedure leerD(var det:detalle; var d:informacionD);
begin
	if (not eof(det)) then
		read(det,d)
	else begin
		d.codigoLocalidad := valoralto;
		d.codigoCepa := valoralto;
	end;
end;

procedure leerM(var mae:maestro; var m:informacionM);
begin
	if (not eof(mae)) then
		read(mae,m)
	else begin
		m.codigoLocalidad := valoralto;
		m.codigoCepa := valoralto;
	end;
end;

procedure minimo(var det:detalles; var d:reg_det; var min:informacionD);
var i, minPos:integer;
begin
	minPos := -1;
	min.codigoLocalidad := valoralto;
	min.codigoCepa := valoralto;
	
	for i:=1 to dimF do begin
		if (d[i].codigoLocalidad < min.codigoLocalidad) or ((d[i].codigoLocalidad = min.codigoLocalidad) and (d[i].codigoCepa < min.codigoCepa)) then begin
			minPos := i;
			min := d[i];
		end;
	end;
	
	if (minPos <> -1) then
		leerD(det[minPos],d[minPos]);
end;

procedure cargarDetalles(var det:detalles; var d:reg_det);
var i:integer; nombre:string;
begin
	for i:=1 to dimF do begin
		readln(nombre);
		assign(det[i],nombre);
		reset(det[i]);
		leerD(det[i],d[i]);
	end;
end;

procedure cerrarDetalles(var det:detalles);
var i:integer; begin for i:=1 to dimF do close(det[i]); end;

procedure actualizar(var mae:maestro; var det:detalles);
var
	d:reg_det; min,actual:informacionD; m:informacionM;
begin
	
	reset(mae);
	leerM(mae,m);
	cargarDetalles(det,d);
	minimo(det,d,min);
	while (min.codigoLocalidad <> valoralto) do begin
		actual.cantidadFallecidos := 0;
		actual.cantidadRecuperados := 0;
		actual.cantidadCasosActivos := 0;
		actual.cantidadCasosNuevos := 0;
		actual.codigoLocalidad := min.codigoLocalidad;
	actual.codigoCepa := min.codigoCepa;
		while (min.codigoLocalidad = actual.codigoLocalidad) and (min.codigoCepa = actual.codigoCepa) do begin
			actual.cantidadFallecidos := actual.cantidadFallecidos + min.cantidadFallecidos;
			actual.cantidadRecuperados := actual.cantidadRecuperados + min.cantidadRecuperados;
			actual.cantidadCasosActivos := actual.cantidadCasosActivos + min.cantidadCasosActivos;
			actual.cantidadCasosNuevos := actual.cantidadCasosNuevos + min.cantidadCasosNuevos;
			minimo(det,d,min);
		end;
		
		while ((m.codigoLocalidad < actual.codigoLocalidad) or (m.codigoCepa < actual.codigoCepa)) do //sigue leyendo mientras ambos sean distintos
			leerM(mae,m); //this is perfect
		
		m.cantidadFallecidos := m.cantidadFallecidos + actual.cantidadFallecidos;
		m.cantidadRecuperados := m.cantidadRecuperados + actual.cantidadRecuperados;
		m.cantidadCasosActivos := actual.cantidadCasosActivos;
		m.cantidadCasosNuevos := actual.cantidadCasosNuevos;
		seek(mae,filepos(mae)-1);
		write(mae,m);
	end;
	close(mae);
	cerrarDetalles(det);
end;

procedure informar(var mae:maestro);
var 
	m:informacionM; 
	locActual:integer;
	cont:integer;
	supera:boolean;
begin
	
	reset(mae);
	leerM(mae,m);
	cont:=0;
	while (m.codigoLocalidad <> valoralto) do begin
		locActual := m.codigoLocalidad;
		supera := false;
		
		while (m.codigoLocalidad = locActual) do begin
			if (m.cantidadCasosActivos > 50) then
				supera := true;
			leerM(mae,m);
		end;
		
		if (supera) then
			cont := cont + 1;
	end;
	writeln(cont);
	close(mae);
end;

var 
	det:detalles; mae:maestro;
BEGIN
	assign(mae,'maestro');
	actualizar(mae,det);
	informar(mae);
END.

