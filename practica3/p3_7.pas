{
  Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000
   
   
}


program untitled;
type
	peligro = record
		cod:integer;
		especie:string;
		familiaAve:string;
		descripcion:string;
		zonaGeografica:string;
	end;
	
	archivo = file of peligro;
	
procedure marcarAborrar(var arch:archivo);
var
	borrar:integer; p:peligro;
begin
	reset(arch);
	readln(borrar);
	while(borrar <> 5000) do begin
		while not eof(arch) do begin
			read(arch,p);			
			if p.cod = borrar then	begin
				p.cod := -1;
				seek(arch,filepos(arch)-1);
				write(arch,p);
			end;
		end;
		seek(arch,0);
		readln(borrar);
	end;
	close(arch);
end;
			
			
procedure eliminarRegistros(var arch:archivo);
var
	p,ultimo:peligro; pos,posUlt:integer;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,p);
		if (p.cod = -1) then begin
			pos:=filepos(arch)-1;
			posUlt := filesize(arch) - 1;
			
			if pos <> posUlt then begin // si no es el ultimo reemplazo, sino se borra y listo
				seek(arch,posUlt);
				read(arch,ultimo);
				seek(arch,pos);
				write(arch,ultimo);
			end;
			
			seek(arch,filesize(arch)-1);
			truncate(arch);
			seek(arch,pos);
		end;
	end;
	close(arch);
end;
	


var

BEGIN
	
	
END.

