{
   Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
●
 Cada archivo detalle está ordenado por cod_usuario y fecha.
●
 Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
●
 El archivo maestro debe crearse en la siguiente ubicación física: /var/log.

   
}


program p2_6;
const dimF=5; valoralto=9999;
type
	fechaDatos = record
		dia:1..31;
		mes:1..12;
		anio:integer;
	end; 
	datosDet = record
		codigo:integer;
		fecha:fechaDatos;
		tiempo_sesion:real;
	end;
	
	detalle = file of datosDet;
	detalles = array[1..dimF] of detalle;
	reg_det = array[1..dimF] of datosDet;
	
	maestro = file of datosDet;
	
procedure leerD(var det:detalle; var d:datosDet);
begin
	if (not eof(det)) then read(det,d)
	else begin
		d.codigo := valoralto;
		d.fecha.anio := 9999;
		d.fecha.mes := 12;
		d.fecha.dia := 31;
	end;
end;


function fechaMenor(f1, f2: fechaDatos): boolean;
begin
  fechaMenor :=
    (f1.anio < f2.anio) or
    ((f1.anio = f2.anio) and (f1.mes < f2.mes)) or
    ((f1.anio = f2.anio) and (f1.mes = f2.mes) and (f1.dia < f2.dia));
end;

procedure minimo(var d:reg_det; var min:datosDet; var det:detalles);
var
	i,minPos:integer;
begin
	min.codigo:=valoralto;
	min.fecha.dia:=31;
	min.fecha.mes:=12;
	min.fecha.anio:=9999;
	minPos:=-1;
	for i:=1 to dimF do begin
		if ((d[i].codigo < min.codigo) or ((d[i].codigo = min.codigo) and (fechaMenor(d[i].fecha,min.fecha)))) then begin
			min := d[i];
			minPos := i;
		end;
	end;
	if (minPos<>-1) then
		leerD(det[minPos], d[minPos]);
end;

procedure cargarDetalles(var det:detalles; var d:reg_det);
var
	i:integer; nombre:string;
begin
	for i:=1 to dimF do begin
		readln(nombre);
		assign(det[i],nombre);
		reset(det[i]);
		leerD(det[i], d[i]);
	end;
end;

procedure cerrarDetalles(var det:detalles);
var i:integer;
begin for i:=1 to dimF do close(det[i]);
end;

function fechaEsIgual(f,f2:fechaDatos):boolean;
begin
	fechaEsIgual := (f.dia = f2.dia) and (f.mes = f2.mes) and (f.anio = f2.anio);
end;

procedure crearMaestro(var mae:maestro; var det:detalles);
var min,actual:datosDet; d:reg_det; nombreMae:string;
begin
	readln(nombreMae);
	assign(mae, '/var/log/' + nombreMae);
	rewrite(mae);
	cargarDetalles(det,d);
	minimo(d,min,det);
	while (min.codigo <> valoralto) do begin
		actual.codigo := min.codigo;
		actual.fecha := min.fecha;
		actual.tiempo_sesion := 0;
		while (actual.codigo = min.codigo) and fechaEsIgual(actual.fecha,min.fecha) do begin
			actual.tiempo_sesion := actual.tiempo_sesion + min.tiempo_sesion;
			minimo(d,min,det);
		end;
		write(mae,actual);
	end;
	close(mae);
	cerrarDetalles(det);
end;



var
	mae:maestro; det:detalles;
BEGIN
	crearMaestro(mae,det);
END.

