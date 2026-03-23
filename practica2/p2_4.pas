{
  A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.
}


program p2_4;
const valoralto = 'Zzzzzzzzzzzzzzzzzzzzzz';
type
	maestroDatos = record
		nombreProvincia: string;
		cantPalfabetizadas:integer;
		encuestados:integer;
	end;
	
	detalleDatos = record
		md: maestroDatos;
		codLocalidad:integer;
	end;
	
	maestro = file of maestroDatos;
	detalle = file of detalleDatos;

procedure leerM(var mae1:maestro; var m:maestroDatos);
begin
	if (not eof(mae1)) then read(mae1,m)
	else m.nombreProvincia := valoralto;
end;

procedure leerD(var det:detalle; var d:detalleDatos);
begin
	if (not eof(det)) then read(det,d)
	else d.md.nombreProvincia := valoralto;
end;

procedure minimo(var d1,d2,min: detalleDatos; 
var det1,det2:detalle);
begin
	if (d1.md.nombreProvincia < d2.md.nombreProvincia) then begin
		min := d1;
		leerD(det1,d1);
	end
	else begin
		min := d2;
		leerD(det2,d2);
	end;
end;

procedure proceso(var det1,det2:detalle; var mae1:maestro);
var d1,d2,min: detalleDatos; m:maestroDatos;
	totalCPA, totalEncuestados:integer;
	provinciaActual:string;
begin
	reset(mae1);
	reset(det1);
	reset(det2);
	
	leerM(mae1,m);
	leerD(det1,d1);
	leerD(det2,d2);
	minimo(d1,d2,min,det1,det2);
	
	while (min.md.nombreProvincia <> valoralto) do begin
		totalCPA:=0; //total cant provincias alfabetizadas
		totalEncuestados:=0;
		provinciaActual:=min.md.nombreProvincia;
		while (min.md.nombreProvincia = provinciaActual) do begin
			totalCPA:=totalCPA+min.md.cantPalfabetizadas;
			totalEncuestados:=totalEncuestados+min.md.encuestados;
			minimo(d1,d2,min,det1,det2);
		end;
		
		while (m.nombreProvincia <> provinciaActual) do //el 0 ese es la idea de esto
			leerM(mae1,m);
		
		m.cantPalfabetizadas := m.cantPalfabetizadas + totalCPA;
	    m.encuestados := m.encuestados + totalEncuestados;
		seek(mae1,filepos(mae1)-1);
		write(mae1,m);
	end;
	close(mae1);
	close(det1);
	close(det2);
end;
		
	

var
	mae1:maestro;
	det1, det2:detalle;
BEGIN
	assign(mae1,'maestro');
	assign(det1,'detalle1');
	assign(det2, 'detalle2');
	proceso(det1,det2,mae1);
	
END.

