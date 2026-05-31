program untitled;
const
	valoralto = 9999;
type
	puntos = 0..3;
	
	datosMaestro = record
		codEquipo:integer;
		nombreEquipo:string;
		cantPartidosJugados:integer;
		cantPartidosGanados:integer;
		cantPartidosEmpatados:integer;
		cantPartidosPerdidos:integer;
		cantPuntos:integer;
	end;
	
	datosDetalle = record
		codEquipo:integer;
		fechaPartido:integer;
		cantPuntos:puntos;
		codEquipoRival:integer;
	end;
	
	maestro = file of datosMaestro;
	detalle = file of datosDetalle;
	
	reg_detalles = array[1..12] of datosDetalle;
	detalles = array[1..12] of detalle;


procedure leerM(var mae:maestro;var dm: datosMaestro);
begin
	if not eof(mae) then
		read(mae,dm)
	else
		dm.codEquipo:=valoralto;
end;


procedure leerD(var det:detalle; var dd:datosDetalle);
begin
	if not eof(det) then
		read(det,dd)
	else
		dd.codEquipo:=valoralto;
end;

procedure cargarDetalles(var dets:detalles; var reg_dets:reg_detalles);
var
	nombre:string; i:integer;
begin
	for i:=1 to 12 do begin
		readln(nombre);
		assign(dets[i],nombre);
		reset(dets[i]);
		leerD(dets[i],reg_dets[i]);
	end;
end;


procedure minimo(var dets:detalles; var reg_dets:reg_detalles; var min:datosDetalle);
var
	i:integer; posMin:integer; 
begin
	posMin:=-1;
	min.codEquipo:=9999;
	for i:=1 to 12 do begin
		if (reg_dets[i].codEquipo < min.codEquipo) then begin
			min := reg_dets[i];
			posMin:=i;
		end;
	end;
	if (posMin <> -1) then
		leerD(dets[posMin],reg_dets[posMin]);
end;


procedure actualizar(var dets:detalles; var mae:maestro);
var
	reg_dets:reg_detalles;
	min:datosDetalle;
	dm:datosMaestro;
	cantPartidosGanados:integer;
	cantPartidosEmpatados:integer;
	cantPartidosPerdidos:integer;
	cantPartidosJugados:integer;
	cantPuntos:integer;
	maxPuntos:integer;
	maxNombre:string;
begin
	cargarDetalles(dets,reg_dets);
	minimo(dets,reg_dets,min);
	leerM(mae,dm);
	maxPuntos:=-1;
	maxNombre:='ZZZZ';
	while (min.codEquipo <> valoralto) do begin
		leerM(mae,dm);
		while (dm.codEquipo < min.codEquipo) do 
			leerM(mae,dm);
		cantPartidosGanados:=0;
		cantPartidosPerdidos:=0;
		cantPartidosJugados:=0;
		cantPartidosEmpatados:=0;
		cantPuntos:=0;
		while (min.codEquipo = dm.codEquipo) do begin
			if min.cantPuntos = 3 then
				cantPartidosGanados := cantPartidosGanados + 1
			else if min.cantPuntos = 0 then
				cantPartidosPerdidos := cantPartidosPerdidos + 1
			else if min.cantPuntos = 1 then
				cantPartidosEmpatados := cantPartidosEmpatados + 1;
			cantPartidosJugados := cantPartidosJugados +1;
			cantPuntos := cantPuntos + min.cantPuntos;
			
			minimo(dets,reg_dets,min);
		end;
		
		seek(mae,filepos(mae)-1);
		dm.cantPartidosGanados:=dm.cantPartidosGanados + cantPartidosGanados;
		dm.cantPartidosPerdidos:=dm.cantPartidosPerdidos + cantPartidosPerdidos;
		dm.cantPartidosEmpatados:=dm.cantPartidosEmpatados + cantPartidosEmpatados;
		dm.cantPartidosJugados:=dm.cantPartidosJugados+cantPartidosJugados;
		dm.cantPuntos:=dm.cantPuntos+cantPuntos;
		write(mae,dm);
		
		writeln(dm.nombreEquipo, cantPuntos);
		
		if (cantPuntos > maxPuntos) then begin
			maxPuntos:=cantPuntos;
			maxNombre:=dm.nombreEquipo;
		end;
	end;
	writeln(maxNombre,maxPuntos);
	cerrarDetalles(dets);
end;

procedure cerrarDetalles(var dets:detalles);
var i:integer;
begin
	for i:=1 to 12 do
		close(dets[i]);
end;
	

//ppal
var
	dets:detalles; mae:maestro;
begin
	assign(mae,'maestro');
	reset(mae);
	actualizar(dets,mae);
	close(mae);
end.
