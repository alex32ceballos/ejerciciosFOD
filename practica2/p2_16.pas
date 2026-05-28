{ Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con información
de las motos que posee a la venta. De cada moto se registra: código, nombre, descripción,
modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles con
información de las ventas de cada uno de los 10 empleados que trabajan. De cada archivo
detalle se dispone de la siguiente información: código de moto, precio y fecha de la venta.
Se debe realizar un proceso que actualice el stock del archivo maestro desde los archivos
detalles. Además se debe informar cuál fue la moto más vendida.
NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
ser recorrido sólo una vez y en forma simultánea con los detalles.
   
}


program untitled;
const
	dimF = 10;
	valoralto = 9999;
type
	moto = record
		cod:integer;
		nombre:string;
		descripcion:string;
		modelo:string;
		marca:string;
		stockAct:integer;
	end;
	
	datoD = record
		 cod:integer;
		 precio:real;
		 fecha:integer;
	end;
	
	maestro = file of moto;
	detalle = file of datoD;
	detalles = array[1..dimF] of detalle;
	reg_det = array[1..dimF] of datoD;
	
procedure leerM(var mae:maestro; var m:moto);
begin
	if (not eof(mae)) then
		read(mae,m)
	else
		m.cod := valoralto;
end;

procedure leerD(var det:detalle; var d:datoD);
begin
	if (not eof(det)) then
		read(det,d)
	else
		d.cod := valoralto;
end;

procedure cargarDetalles(var det:detalles; var d:reg_det);
var
	i:integer; nombre:string;
begin
	for i:=1 to dimF do begin
		readln(nombre);
		assign(det[i], nombre);
		reset(det[i]);
		leerD(det[i],d[i]);
	end;
end;

procedure cerrarDetalles(var det:detalles);
var i:integer;
begin
	for i:=1 to dimF do
		close(det[i]);
end;

procedure minimo(var det:detalles; var min:datoD; var d:reg_det);
var
	i,posMin:integer;
begin
	min.cod:=valoralto;
	posMin:=-1;
	for i:=1 to dimF do begin
		if (d[i].cod < min.cod) then begin
			min:=d[i];
			posMin:=i;
		end;
	end;
	if (posMin <> -1) then leerD(det[posMin],d[posMin]);
end;

procedure actualizar(var mae:maestro; var det:detalles);
var
	m:moto; d:reg_det; min:datoD;
	codAct,cant:integer; cantMax,codMax:integer;
begin
	codMax:=-1;
	cantMax:=-1;
	reset(mae);
	cargarDetalles(det,d);
	minimo(det,min,d);
	leerM(mae,m);
	while (min.cod <> valoralto) do begin
		codAct:=min.cod;
		cant:=0;
		while (min.cod = codAct) do begin
			cant:=cant+1;
			minimo(det,min,d);
		end;
		//actualizo max
		if (cant > cantMax) then begin
			cantMax:=cant;
			codMax:=codAct;
		end;
		
		while (m.cod < codAct) do begin
			leerM(mae,m);
		end;
		
		if (m.cod = codAct) then begin
			m.stockAct := m.stockAct - cant;
			if (m.stockAct < 0) then // si el stock es negativo
				m.stockAct := 0;
		
			seek(mae,filepos(mae)-1);
			write(mae,m);
		end;
	end;
	writeln('la moto mas vendida fue el codigo: ',codMax);
	close(mae);
	cerrarDetalles(det);
end;


var
	mae:maestro; det:detalles;
BEGIN
	assign(mae,'maestroP2_16');
	actualizar(mae,det);
END.

