{
   Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra:
 cod_prenda,
 descripción,
 colores,
 tipo_prenda,
 stock
 y
precio_unitario.
Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.
}


program untitled;
type
	prenda = record
		cod:integer;
		descripcion:string;
		colores:strinG;
		tipo_prenda:string;
		stock:integer;
		precio_unitario:real;
	end;

	archivo = file of prenda;
	obsoletas = file of integer;
	nuevo = file of prenda; //podia usar archivo aaaaaaaaaaaaaaaa


procedure bajaLogica(var a:archivo; var o:obsoletas);
var
	p:prenda; ob:integer; esta: boolean;
begin
	reset(a);
	reset(o);
	while not eof(o) do begin
		read(o,ob);
		esta:=false;
		while not eof(a) and (esta = false) do begin
			read(a,p);
			if (p.cod = ob) then begin
				p.stock := -p.stock;
				seek(a,filepos(a)-1);
				write(a,p);
				esta:=true;
			end;
		end;
		seek(a,0);
	end;
	close(a);
	close(o);
end;

procedure prendasNoBorradas(var a:archivo; var n:nuevo);
var
	ap:prenda;
begin
	reset(a);
	rewrite(n);
	while (not eof (a)) do begin
		read(a,ap);
		if (ap.stock >= 0) then
			write(n,ap)
	end;
	close(a);
	close(n);
end;


BEGIN
	
	
END.

