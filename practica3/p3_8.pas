{
    Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.
b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.
c. BajaDistribución: módulo que da de baja lógicamente una distribución
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.
   
}


program untitled;
type
	distribucion = record
		 nombre:string;
		 anioLanzamiento:integer;
		 versionKernel:real;
		 cantDesarrolladores:integer;
		 descripcion:string;
	end;
	
	archivo = file of distribucion;

procedure existeDistribucion(var arch:archivo; distribucion:string; var existe:boolean; var pos:integer);
var
	d:distribucion;
begin
	reset(arch);
	existe:=false;
	while (not eof(arch) and existe = false) do begin
		read(arch,d);
		if (d.nombre = distribucion) then begin
			existe:=true;
			pos:=filepos(arch)-1;
		end;
	end;
	close(arch);
end;


procedure altaDistribucion(var arch:archivo);
var
	nuevo:distribucion; existe:boolean; posExiste:integer;
	cab,reg:distribucion; pos:integeR;
begin
	readln(nuevo.nombre);
	existeDistribucion(arch,nuevo.nombre,existe,posExiste);
	if not existe then begin
		readln(nuevo.cantDesarrolladores);
		readln(nuevo.versionKernel);
		readln(nuevo.anioLanzamiento);
		readln(nuevo.descripcion);
		reset(arch);
		read(arch,cab);
		if (cab.cantDesarrolladores = 0) then begin
			seek(arch,filesize(arch));
		end
		else begin
			pos:=-cab.cantDesarrolladores;
			seek(arch,pos);
			read(arch,reg);
			cab.cantDesarrolladores:=reg.cantDesarrolladores;
			seek(arch,0);
			write(arch,cab);
			seek(arch,pos);
		end;
		write(arch,nuevo);
		close(arch);
	end
	else
		writeln('ya existe la distribucion');
end;

procedure bajaDistribucion(var arch:archivo);
var
	borrar:string; existe:boolean; posExiste:integer;
	cab,reg:distribucion;
begin
	readln(borrar);
	existeDistribucion(arch,borrar,existe,posExiste);
	if (existe) then begin
		reset(arch);
		read(arch,cab);
		seek(arch,posExiste);
		read(arch,reg);
		reg.cantDesarrolladores := cab.cantDesarrolladores;
		seek(arch,posExiste);
		write(arch,reg);
		cab.cantDesarrolladores:=-posExiste;
		seek(arch,0);
		write(arch,cab);
		close(arch);
	end
	else
		writeln('Distribución no existente');
end;



BEGIN
	
	
END.

