{
  Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.
   
}


program untitled;
type
	info = record
		nroAsistente:integer;
		apellido:string;
		nombre:string;
		email:string;
		tel:integer;
		dni:integer;
	end;
	
	archivo = file of info;


procedure generarArch(var arch:archivo);
var
	m:info;
begin
	rewrite(arch);
	writeln('ingresar cod');
	readln(m.nroAsistente);
	while (m.nroAsistente > 0) do begin
		writeln('ingresar apellido');
		readln(m.apellido);
		writeln('ingresar nombre');
		readln(m.nombre);
		writeln('ingresar email');
		readln(m.email);
		writeln('ingresar tel');
		readln(m.tel);
		writeln('ingresar dni');
		readln(m.dni);
		write(arch,m);
		
		writeln('ingresar cod');
		readln(m.nroAsistente);
	end;
	close(arch);
end;



procedure eliminar(var arch:archivo);
var
	m:info;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,m);
		if (m.nroAsistente < 1000) then begin
			m.apellido := '@'+m.apellido;
			seek(arch,filepos(arch)-1);
			write(arch,m);
		end;
	end;
	close(arch);
end;



var
	arch:archivo;
BEGIN
	assign(arch,'archivoP3_2');
	generarArch(arch);
	eliminar(arch);
END.

