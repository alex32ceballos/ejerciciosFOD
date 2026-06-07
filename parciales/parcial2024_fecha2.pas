const
	dimF = 30;
	valoralto=9999;
type
	rango = 1..dimF;
	
	infoMae = record
		codigo:integer;
		nombre:string;
		cantCasos:integer;
	end;
	
	infoDet = record
		codigo:integer;
		cantCasos:integer;
	end;
	
	maestro = file of infoMae;
	detalle = file of infoDet;
	detalles = array[rango] of detalle;
	reg_detalles = array[rango] of infoDet;

procedure cerrarDetalles(var dets:detalles);
var i:integer;
begin
	for i:=1 to dimF do 
		close(dets[i]);
end;



procedure leerD(var det:detalle;var id:infoDet);
begin
	if not eof(det) then
		read(det,id)
	else
		id.codigo := valoralto;
end;


procedure leerM(var mae:maestro;var im:infoMae);
begin
	if not eof(mae) then
		read(mae,im)
	else
		im.codigo := valoralto;
end;



procedure cargarDetalles(var dets:detalles; var reg_dets:reg_detalles);
var
	i:integer; nombre:string;
begin
	for i:=1 to dimF do begin
		readln(nombre);
		assign(dets[i],nombre);
		reset(dets[i]);
		leerD(dets[i],reg_dets[i]);
	end;
end;


procedure minimo(var dets:detalles; var reg_dets:reg_detalles; var min:infoDet);
var
	i:integer; pos:integer;
begin
	pos:=-1;
	min.codigo := valoralto;
	for i:=1 to dimF do 
		if (reg_dets[i].codigo < min.codigo) then begin
			min := reg_dets[i];
			pos := i;
		end;
	if (pos <> -1) then
		leerD(dets[pos],reg_dets[pos]);
end;

procedure actualizar(var mae:maestro; var dets:detalles);
var
	reg_dets:reg_detalles;
	regM:infoMae;
	min:infoDet;
	totalCasosPositivos:integer;
begin
	reset(mae);
	cargarDetalles(dets,reg_dets);
	leerM(mae,regM);
	while (regM.codigo <> valoralto) do begin
		minimo(dets,reg_dets,min);
		totalCasosPositivos:=0;
		while (min.codigo = regM.codigo) do begin
			totalCasosPositivos:=totalCasosPositivos+min.cantCasos;
			minimo(dets,reg_dets,min);
		end;
		regM.cantCasos:=regM.cantCasos+totalCasosPositivos;
		if (regM.cantCasos > 15) then
			writeln(regM.codigo, regM.nombre);
		seek(mae,filepos(mae)-1);
		write(mae,regM);
		leerM(mae,regM);
	end;
	close(mae);
	cerrarDetalles(dets);
end;

//ppal
var
	mae:maestro;
	dets:detalles;
begin
	assign(mae,'maestro');
	actualizar(mae,dets);
end.
