{
13. Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
a.
 Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
b.
 Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
  
 
ESTA MALLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL, ERA RECORRER MAESTRO CCOMO PRINCIPAL
DE ESA MANERA PODRIA HACER BIEN EL PUNTO B (EL A ESTA BIEN)
}


program untitled;
const
	valoralto='ZZZZZ';
	dimF=2;
type
	datosL = record
		destino:string;
		anio:integer;
		mes:1..13;
		dia:1..32;
		horaSalida:1..25;
	end;
	
	lista = ^nodo;
	nodo = record
		dato: datosL;
		sig:lista;
	end;
	
	datoM = record
		destino:string;
		anio:integer;
		mes:1..13;
		dia:1..32;
		horaSalida:1..25;
		cantAsientosDisp:integer;
	end;
	
	datoD = record
		destino:string;
		anio:integer;
		mes:1..13;
		dia:1..32;
		horaSalida:1..25;
		cantAsientosComprados:integer;
	end;
	
	maestro = file of datoM;
	
	detalle = file of datoD;
	detalles = array[1..dimF] of detalle;
	reg_det = array[1..dimF] of datoD;
	
procedure agregarAdelante(var L:lista; d:datosL);
var
	nuevo:lista;
begin
	new(nuevo);
	nuevo^.dato:=d;
	nuevo^.sig := L;
	L:=nuevo;
end;


procedure leerM(var mae:maestro; var m:datoM);
begin
	if (not eof(mae)) then
		read(mae,m)
	else
		m.destino := valoralto;
end;

procedure leerD(var det:detalle; var d:datoD);
begin
	if (not eof(det)) then
		read(det,d)
	else
		d.destino := valoralto;
end;

procedure minimo(var det:detalles; var d:reg_det; var min:datoD);
var
	minPos,i:integer;
begin
	minPos:=-1;
	min.destino := valoralto;
	min.anio := 9999;
	min.mes := 13;
	min.dia := 32;
	min.horaSalida := 25;
	for i:= 1 to dimF do begin
		if (d[i].destino < min.destino) or ((d[i].destino = min.destino) and (d[i].anio < min.anio)) or ((d[i].destino = min.destino) and (d[i].anio = min.anio) and (d[i].mes < min.mes)) or ((d[i].destino = min.destino) and (d[i].anio = min.anio) and (d[i].mes = min.mes) and (d[i].dia < min.dia)) or ((d[i].destino = min.destino) and (d[i].anio = min.anio) and (d[i].mes = min.mes) and (d[i].dia = min.dia) and (d[i].horaSalida < min.horaSalida)) then begin
			minPos := i;
			min := d[i];
		end;
	end;
		
	if (minPos <> -1) then
		leerD(det[minPos],d[minPos]);
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
var i:integer;
begin
	for i:= 1 to dimF do
		close(det[i]);
end;


procedure actualizar(var mae:maestro; var det:detalles; var L:lista);
var d:reg_det; m:datoM; min:datoD; totalComprados,X:integer;
	anioAct, mesAct, diaAct, horaSalidaAct: integer;
	destinoAct:string;
	dL:datosL;
begin
	readln(X);
	cargarDetalles(det,d);
	reset(mae);
	leerM(mae,m);
	minimo(det,d,min);
	while (min.destino <> valoralto) do begin
		destinoAct := min.destino;
		anioAct := min.anio;
		mesAct := min.mes;
		diaAct := min.dia;
		horaSalidaAct := min.horaSalida;
		totalComprados := 0;

		while (min.destino = destinoAct) and (min.anio = anioAct) and (min.mes = mesAct) and (min.dia = diaAct) and (min.horaSalida = horaSalidaAct) do begin
			totalComprados := totalComprados + min.cantAsientosComprados;
			minimo(det,d,min);
		end;
		
		while (m.destino <> valoralto) and ((m.destino < destinoAct) or ((m.destino = destinoAct) and (m.anio < anioAct)) or ((m.destino = destinoAct) and (m.anio = anioAct) and (m.mes < mesAct)) or ((m.destino = destinoAct) and (m.anio = anioAct) and (m.mes = mesAct) and (m.dia < diaAct)) or ((m.destino = destinoAct) and (m.anio = anioAct) and (m.mes = mesAct) and (m.dia = diaAct) and (m.horaSalida < horaSalidaAct))) do
			leerM(mae,m);
		
		m.cantAsientosDisp := m.cantAsientosDisp - totalComprados;
		dL.destino := destinoAct;
		dL.anio := anioAct;
		dL.mes := mesAct;
		dL.dia := diaAct;
		dL.horaSalida := horaSalidaAct;
		if (m.cantAsientosDisp < X) then
			agregarAdelante(L,dL);
		seek(mae,filepos(mae)-1);
		write(mae,m);
	end;
	close(mae);
	cerrarDetalles(det);
end;

var
	mae:maestro; det:detalles; L:lista;
BEGIN
	L:=nil;
	assign(mae,'maestroP2_12');
	actualizar(mae,det,L);
END.

