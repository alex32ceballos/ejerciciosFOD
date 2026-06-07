const
	valoralto = 'ZZZZ';
type
	formato = record
		libreria: string;
		genero: string;
		nombreLibro:string;
		precio:real;
		cantVendida:integer;
	end;
	
	archivo = file of formato;
	

procedure leer(var arch:archivo; var f:formato);
begin
	if not eof(arch) then
		read(arch,f)
	else
		f.libreria := valoralto;
end;

procedure informar(var arch:archivo);
var
	f:formato;
	libreriaAct, generoAct, nombreLibroAct: string;
	montoGeneroAct: real; cantVendidaLibroAct: integer; montoTotalLibrerias: real;
	montoTotalLibreriaAct:real;
begin
	reset(arch);
	montoTotalLibrerias:=0;
	leer(arch,f);
	while (f.libreria <> valoralto) do begin
		libreriaAct := f.libreria;
		writeln(libreriaAct);
		montoTotalLibreriaAct:=0;
		while (f.libreria <> valoralto) and (f.libreria = libreriaAct) do begin
			generoAct := f.genero;
			writeln(generoAct);
			montoGeneroAct := 0;
			while (f.libreria <> valoralto) and (f.libreria = libreriaAct) and (f.genero = generoAct) do begin
				nombreLibroAct := f.nombreLibro;
				writeln(nombreLibroAct);
				cantVendidaLibroAct:=0;
				while (f.libreria <> valoralto) and (f.libreria = libreriaAct) and (f.genero = generoAct) and (f.nombreLibro = nombreLibroAct) do begin
					cantVendidaLibroAct:=cantVendidaLibroAct+f.cantVendida;
					montoGeneroAct:=montoGeneroAct+(f.precio * f.cantVendida);
					leer(arch,f);
				end;
				writeln(cantVendidaLibroAct);
			end;
			montoTotalLibreriaAct:=montoTotalLibreriaAct+montoGeneroAct;
			writeln(montoGeneroAct);
		end;
		writeln(montoTotalLibreriaAct);
		montoTotalLibrerias:=montoTotalLibrerias+montoTotalLibreriaAct;
	end;
	writeln(montoTotalLibrerias);
	close(arch);
end;

//ppal
var
	arch:archivo;
begin
	informar(arch);
end.
