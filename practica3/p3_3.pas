{
   Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:

a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.

b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de  ́enlace ́ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:


i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.

ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.

iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.


c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.


NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.
   
   
}


program untitled;
type
	novela = record
		cod:integer;
		genero:string;
		nombre:string;
		duracion:integer;
		director:string;
		precio:real;
	end;
	
	archivo = file of novela;

//---------------------------------A------------------------------------------------------------
procedure crearArch(var arch:archivo; var archtxt:text);
var
	nombre:string; n:novela;
begin
	readln(nombre);
	assign(arch,nombre); //este tendria que ir en el ppal
	rewrite(arch);
	n.cod:=0;
	n.genero:='';
	n.nombre:='';
	n.duracion:=0;
	n.director:='';
	n.precio:=0;
	write(arch,n);
	readln(n.cod);
	while (n.cod <> -1) do begin
		readln(n.genero);
		readln(n.nombre);
		readln(n.duracion);
		readln(n.director);
		readln(n.precio);
		write(arch,n);
		readln(n.cod);
	end;
	close(arch);
end;

//-------------------------------------B1-------------------------------------------------------------

procedure puntoB1(var arch:archivo); //alta lista invertida
var
	cab,n,reg:novela; pos:integer;  //n de nuevo
begin
	reset(arch);
	readln(n.cod);
	readln(n.genero);
	readln(n.nombre);
	readln(n.duracion);
	readln(n.director);
	readln(n.precio);
	
	read(arch,cab);
	if(cab.cod = 0)then begin
		seek(arch,filesize(arch));
	end
	else begin
		pos:=-cab.cod;
		seek(arch,pos);
		read(arch,reg);
		cab.cod:=reg.cod;
		seek(arch,0);
		write(arch,cab);
		seek(arch,pos);
	end;
	write(arch,n);
	close(arch);
end;


//-------------------------------B2---------------------------------------------------------
procedure puntoB2(var arch:archivo); //modificar registro
var
	n:novela; cod:integer; ok:boolean;
begin
	reset(arch);
	readln(cod);
	ok:=False;
	while (not eof(arch) and ok = False) do begin
		read(arch,n);
		if (n.cod = cod) then
			ok := True
	end;
	if(ok)then begin
		readln(n.genero);
		readln(n.nombre);
		readln(n.duracion);
		readln(n.director);
		readln(n.precio);
		seek(arch,filepos(arch)-1);
		write(arch,n);
	end;
	close(arch);
end;


//------------------------------B3--------------------------------------------

procedure buscarPosAeliminar(var arch:archivo; var pos:integer);
var
	cod:integer; esta:boolean; n:novela;
begin
	readln(cod);
	pos:=-1;
	esta:=false;
	reset(arch);
	while not eof(arch) and (esta = false)do begin
		read(arch,n);
		if (n.cod = cod) then begin
			pos:=filepos(arch)-1;
			esta:=True;
		end;
	end;
	close(arch);
end;


procedure puntoB3(var arch:archivo);
var
	pos:integer; cab,reg:novela;
begin
	buscarPosAeliminar(arch,pos);
	if (pos > -1) then begin
		reset(arch);
		read(arch,cab);
		seek(arch,pos);
		read(arch,reg);
		reg.cod:=cab.cod;
		seek(arch,pos);
		write(arch,reg);
		cab.cod:=-pos;
		seek(arch,0);
		write(arch,cab);
		close(arch);
	end;
end;
//----------------------------------------------------------------------------
//-------------------------------- C -------------------------------------------
procedure puntoC(var arch:archivo; var archtxt:text);
var
	n:novela;
begin
	assign(archtxt, 'novelas.txt');
	rewrite(archtxt);
	reset(arch);
	while not eof(arch) do begin
		read(arch,n);
		writeln(archtxt,'aca va todos los campos del registro actual');
	end;
	close(archtxt);
	close(arch);
end;

BEGIN
	
	
END.

