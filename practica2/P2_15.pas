{
   La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
y total de ejemplares vendido.
Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo
   
}


program untitled;
const
	valoralto = 9999;
	mesAlto = 12;
	diaAlto = 13;
	dimF = 100;
type
	infoM = record
		anio:integer;
		dia:1..32;
		mes: 1..13;
		cod:integeR;
		name:string;
		descripcion:string;
		precio:real;
		totalEjemplares:integer;
		totalEjemplaresVendidos:integer;
	end;
	
	infoD = Record
		anio:integer;
		dia:1..32;
		mes: 1..13;
		cod:integeR;
		totalEjemplaresVendidos:integer;
	end;
	
	maestro = file of infoM;
	detalle = file of infoD;
	detalles = array[1..dimF] of detalle;
	reg_det = array[1..dimF] of infoD;
		

procedure leerM(var mae:maestro; var m:infoM);
begin
	if (not eof(mae)) then
		read(mae,m)
	else
		m.anio := valoralto;
end;

procedure leerD(var det:detalle; var d:infoD);
begin
	if (not eof(det)) then
		read(det,d)
	else
		d.anio := valoralto;
end;

procedure cerrarDetalles(var det:detalles);
var i:integer;
begin
	for i:=1 to dimF do close(det[i]);
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

procedure minimo(var det:detalles; var d:reg_det; var min:infoD);
var
	posMin:integer; i:integer;
begin
	posMin:=-1;
	min.anio := valoralto;
	min.mes := mesAlto;
	min.dia := diaAlto;
	min.cod := valoralto;
	for i:=1 to dimF do begin
		if (d[i].anio < min.anio) or ((d[i].anio = min.anio) and (d[i].mes < min.mes)) or ((d[i].anio = min.anio) and (d[i].mes = min.mes) and (d[i].dia < min.dia)) or ((d[i].anio = min.anio) and (d[i].mes = min.mes) and (d[i].dia = min.dia) and (d[i].cod < min.cod)) then begin
			posMin := i;
			min := d[i];
		end;
	end;
	if (posMin <> -1) then 
		leerD(det[posMin], d[posMin]);
end;


procedure actualizar(var mae:maestro; var det:detalles);
var
	m:infoM; min:infoD; d:reg_det;
	maxVentas,maxAnio, maxMes, maxDia: integer;
	minVentas,minAnio, minMes, minDia: integer;
	maxCod:integer;
	minCod:integer;
	cantVentas:integer;
begin
	maxVentas:=-1;
	maxAnio:=-1;
	maxDia:=-1;
	maxMes:=-1;
	minVentas:=valoralto;
	minAnio:=valoralto;
	minMes:=valoralto;
	minDia:=valoralto;
	maxCod:=-1;
	minCod:=valoralto;
	
	reset(mae);
	leerM(mae,m);
	cargarDetalles(det,d);
	minimo(det,d,min);
	
	while (m.anio <> valoralto) do begin
		cantVentas:=0;
		while (min.anio<m.anio) or ((min.anio=m.anio) and (min.mes < m.mes)) or ((min.anio=m.anio) and (min.mes = m.mes) and (min.dia<m.dia)) or ((min.anio=m.anio) and (min.mes = m.mes) and (min.dia=m.dia) and (min.cod < m.cod)) do //se puede simplificar
			minimo(det,d,min);
		while (m.anio=min.anio) and (m.mes= min.mes) and (m.dia = min.dia) and (m.cod = min.cod) do begin
			cantVentas := cantVentas + min.totalEjemplaresVendidos;
			minimo(det,d,min);
		end;
		
		if (cantVentas < minVentas) then begin
			minVentas:=cantVentas;
			minAnio:=m.anio;
			minMes:=m.mes;
			minDia:=m.dia;
			minCod:=m.cod;
		end;
		
		if (cantVentas > maxVentas) then begin
			maxVentas:=cantVentas;
			maxAnio:=m.anio;
			maxMes:=m.mes;
			maxDia:=m.dia;
			maxCod:=m.cod;
		end;
		
		
		m.totalEjemplaresVendidos := m.totalEjemplaresVendidos + cantVentas;
		m.totalEjemplares := m.totalEjemplares - cantVentas;
		seek(mae,filepos(mae)-1);
		write(mae,m);
		leerM(mae,m);
	end;
	writeln('aca iformo el min');
	writeln('aca informo el max');
	close(mae);
	cerrarDetalles(det);
end;

var
	mae:maestro; det:detalles;
BEGIN
	assign(mae,'maestroP2_15');
	actualizar(mae,det);
	
END.

