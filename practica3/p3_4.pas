{
   Dada la siguiente estructura:
type
reg_flor = record
nombre: String[45];
codigo:integer;
end;
tArchFlores = file of reg_flor;
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
Abre el archivo y agrega una flor, recibida
 como
 parámetro
manteniendo la política descrita anteriormente
procedure
 agregarFlor
 (var
 a:
 tArchFlores
 ;
 nombre:
 string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.

ADEMAS HAGO EL 5 TMB

5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
   
}


program untitled;
type
	reg_flor = record
		nombre: String[45];
		codigo:integer;
	end;
	tArchFlores = file of reg_flor;


procedure agregarFlor(var a: tArchFlores; nombre:string; codigo:integer);
var
	cab, reg, nuevo: reg_flor;
	pos:integer;
begin
	reset(a);
	read(a,cab);
	if (cab.codigo = 0) then
		seek(a,filesize(a))
	else begin
		pos:=-cab.codigo;
		seek(a,pos);
		read(a,reg);
		cab.codigo:=reg.codigo;
		seek(a,0);
		write(a,cab);
		seek(a,pos);
	end;
	nuevo.nombre:=nombre;
	nuevo.codigo:=codigo;
	write(a,nuevo);
	close(a);
end;

procedure listarFlores(var a:tArchFlores);
var r:reg_flor;
begin
	reset(a);
	while not eof(a) do begin
		read(a,r);
		if (r.codigo > 0) then 
			writeln(r.nombre, r.codigo);
	end;
	close(a);
end;


//-------------------------- 5 -----------------------------------------------
procedure buscarPos(var a:tArchFlores; var pos:integer; var encontro:boolean; codEliminar:integer);
var r:reg_flor; 
begin
	encontro:=false;
	pos:=-1;
	while not eof(a) and encontro = false do begin
		read(a,r);
		if (r.codigo = codEliminar) then begin
			pos := filepos(a)-1;
			encontro:=true;
		end;
	end;
end;


procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
var
	cab,reg:reg_flor; encontro:boolean; pos:integer;
begin
	reset(a);
	buscarPos(a,pos,encontro,flor.codigo);
	if (encontro) then begin
		seek(a,0);
		read(a,cab);
		seek(a,pos);
		read(a,reg);
		reg.codigo:=cab.codigo;
		seek(a,pos);
		write(a,reg);
		cab.codigo:=-pos;
		seek(a,0);
		write(a,cab);
	end;
	close(a);
end;

BEGIN
	
	
END.

