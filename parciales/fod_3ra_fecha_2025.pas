type
	mascota = record
		codigo:integer;
		nombre:string;
		especie:string;
		edad:integer;
		nombreDuenio:string;
		telefono:integer;
	end;		
	
	archivo = file of mascota;
	
procedure existeMascota(var arch:archivo; var pos:integer; codMascota:integer);
var
	reg:mascota;
begin
	pos:=0;
	reset(arch);
	while not eof(arch) and pos = 0 do begin
		read(arch,reg);
		if (reg.codigo = codMascota) then
			pos:=filePos(arch)-1;
	end;
	close(arch);
end;

procedure altaMascota(var arch:archivo);
var
	pos,codMascota:integer;
	cab,reg, nuevo:mascota;
begin
	readln(codMascota);
	existeMascota(arch,pos,codMascota);
	if (pos <> 0) then
		writeln('ya existe la mascota')
	else begin
		reset(arch);
		read(arch,cab);
		readln(leo todos los campos del registro en nuevo);
		if (cab.codigo = 0) then
			seek(arch,filesize(arch))
		else begin
			pos := -cab.codigo;
			seek(arch,pos);
			read(arch,reg);
			cab.codigo:=reg.codigo;
			seek(arch,0);
			write(arch,cab);
			seek(arch,pos);
		end;
		write(arch,nuevo);
		close(arch);
	end;
end;

procedure bajaMascota(var arch:archivo);
var
	cab,reg:mascota;
	pos,codMascota: integer;
begin
	readln(codMascota);
	existeMascota(arch,pos,codMascota);
	if pos = 0 then
		writeln('no existe la mascota a borrar')
	else begin
		reset(arch);
		read(arch,cab);
		seek(arch,pos);
		read(arch,reg);
		reg.codigo:=cab.codigo;
		seek(arch,pos);
		write(arch,reg);
		seek(arch,0);
		cab.codigo:=-pos;
		write(arch,cab);
		close(arch);
	end;
end;

//PPAL
var
	arch:archivo;
begin
	assign(arch,'archivo');
	altaMascota(arch);
	bajaMascota(arch);
end.
		
