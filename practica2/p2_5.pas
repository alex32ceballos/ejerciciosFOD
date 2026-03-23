{Se cuenta con un archivo de productos de una cadena de venta de alimentos 
congelados.
De cada producto se almacena: código del producto, nombre, descripción, 
stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de 
la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock 
del archivo
maestro. La información que se recibe en los detalles es: código de producto y 
cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock 
disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el 
mismo
procedimiento de actualización, o realizarlo en un procedimiento separado 
(analizar
ventajas/desventajas en cada caso).

Nota: todos los archivos se encuentran ordenados por código de productos. 
En cada detalle
puede venir 0 o N registros de un determinado producto.}


program p2_5;
const
	valoralto = 9999;
	dimF = 30;
type
	producto = record
		codigo:integer;
		nombre:string;
		descripcion:string;
		stockDisponible:integer;
		stockMin:integer;
		precio:real;
	end;
	
	venta = record
		codigo:integer;
		cantVendidas:integer;
	end;
	
	detalle = file of venta;
	maestro = file of producto;
	arc_detalle = array[1..dimF] of detalle;
	reg_detalle = array[1..dimF] of venta;

procedure leerM(var mae:maestro; var m:producto);
begin
	if (not eof(mae)) then read(mae,m)
	else m.codigo := valoralto;
end;

procedure leerD(var det:detalle; var d:venta);
begin
	if (not eof(det)) then read(det,d)
	else d.codigo := valoralto;
end;

procedure minimo(var d: reg_detalle; var min:venta; var det:arc_detalle);
var i:integer; minPos:integer;
begin
	min.codigo:=valoralto;
	minPos:=-1;
	for i:=1 to dimF do begin
		if (d[i].codigo < min.codigo) then begin
			min:=d[i];
			minPos:=i;
		end;
	end;
	if minPos<>-1 then
		leerD(det[minPos],d[minPos]);
end;

procedure cargarDetalles(var d:reg_detalle; var det:arc_detalle);
var i:integer; nombre:string;
begin
	for i:=1 to dimF do begin
		readln(nombre);
		assign(det[i],nombre);
		reset(det[i]);
		leerD(det[i],d[i]);
	end;
end;

procedure actualizar(var det:arc_detalle; var mae:maestro; var archtxt:text);
var
	d:reg_detalle; actual,min:venta; m:producto; i:integer;
begin
	rewrite(archtxt);
	cargarDetalles(d,det);
	reset(mae);
	leerM(mae,m);
	minimo(d,min,det);
	while (min.codigo <>valoralto) do begin
		actual.codigo:=min.codigo;
		actual.cantVendidas:=0;
		while (min.codigo = actual.codigo) do begin
			actual.cantVendidas := actual.cantVendidas + min.cantVendidas;
			minimo(d,min,det);
		end;
		
		while (m.codigo <> actual.codigo) do begin
			leerM(mae,m);
		end;
		m.stockDisponible := m.stockDisponible - actual.cantVendidas;
		{Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock 
disponible por
debajo del stock mínimo.}
		if (m.stockDisponible < m.stockMin) then
			writeln(archtxt, m.nombre, m.descripcion, m.stockDisponible, m.precio);
		seek(mae,filepos(mae)-1);
		write(mae,m);
	end;
	for i:=1 to dimF do
		close(det[i]);
	close(mae);
	close(archtxt);
end;
	
var
	det:arc_detalle;
	mae:maestro;
	archtxt:text;
BEGIN
	assign(mae,'maestro');
	assign(archtxt,'achtextoEJ5.txt');
	actualizar(det,mae,archtxt);
END.

