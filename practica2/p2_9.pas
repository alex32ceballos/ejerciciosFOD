{Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad
 Total de Votos
................................
 ......................
................................
 ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad
 Total de Votos
................................
 ......................
Total de Votos Provincia: ___
....................................................................
Total General de Votos: ___
NOTA: La información está ordenada por código de provincia y código de localidad.
   
}


program untitled;
const valoralto = 9999;
type
	mesa = record
		codProvincia: integer;
		codLocalidad: integer;
		numeroMesa: integer;
		cantVotos: integer;
	end;
	
	maestro = file of mesa;
	
procedure leer(var mae:maestro; var m:mesa);
begin
	if (not eof(mae)) then
		read(mae,m)
	else m.codProvincia := valoralto;
end;

procedure imprimir(var mae:maestro);
var
	m:mesa; totalVotosLocalidad,totalVotosProvincia,totalVotos,provActual,localidadActual:integer;
begin
	reset(mae);
	leer(mae,m);
	totalVotos := 0;
	while (m.codProvincia <> valoralto) do begin
		totalVotosProvincia := 0;
		provActual := m.codProvincia;
		writeln('codigo de provincia: ', provActual);
		while (m.codProvincia = provActual) do begin
			localidadActual := m.codLocalidad;
			totalVotosLocalidad := 0;
			writeln('codigo de localidad: ',localidadActual);
			while (m.codProvincia = provActual) and (m.codLocalidad = localidadActual) do begin
				totalVotosLocalidad := totalVotosLocalidad + m.cantVotos;
				totalVotosProvincia := totalVotosProvincia + m.cantVotos;
				totalVotos := totalVotos + m.cantVotos;
				leer(mae,m);
			end;
			writeln('total de votos de la localidad: ', totalVotosLocalidad);
		end;
		writeln('total de votos de la provincia: ', totalVotosProvincia);	
	end;
	writeln('total de votos en general: ', totalVotos);
	close(mae);
end;


var
	mae: maestro;

BEGIN
	assign(mae, 'maestrop2_9');
	imprimir(mae);
END.

