program fod_1ra_fecha_2025;
const
	valoralto=9999;
type
	infoPresentacion = record
		codArtista:integer;
		nombreArtista:string;
		anio:integer;
		codEvento:integer;
		nombreEvento:string;
		cantLikes:integer;
		cantDislikes:integer;
		puntaje:real;
	end;
	
	archivo = file of infoPresentacion;
	


procedure leer(var arch:archivo; var ip:infoPresentacion);
begin
	if not eof(arch) then
		read(arch, ip)
	else ip.anio := valoralto;
end;

procedure menosInfluyente(var nombreMenosInfluyente:string; nombreArtistaAct: string; var puntajeMin: real; puntajeAct:real; var dislikesMin:integer; dislikesAct:integer);
begin
	if (puntajeMin = puntajeAct) then begin
		if (dislikesMin = dislikesAct) then begin
			nombreMenosInfluyente:=nombreArtistaAct; //Elijo cualquiera
			dislikesMin:=dislikesAct;
			puntajeMin:=puntajeAct;
		end
		else
			if (dislikesAct < dislikesMin) then begin
				nombreMenosInfluyente:=nombreArtistaAct;
				dislikesMin:=dislikesAct;
				puntajeMin:=puntajeAct;
			end;
	end
	else if (puntajeAct < puntajeMin) then begin
		nombreMenosInfluyente:=nombreArtistaAct;
		puntajeMin := puntajeAct;
		dislikesMin := dislikesAct;
	end;
end;

procedure informe(var arch:archivo);
var
	anioActual,codEventoActual,codArtistaActual:integer;
	ip:infoPresentacion;
	totalLikes,totalDislikes,diferencia:integer;
	puntajeTotal:real;
	nombreMenosInfluyente:string;
	puntajeMin:real;
	dislikesMin:integer;
	nombreArtistaAct:string;
	totalPresentaciones:integer;
	totalCantAnios:integer;
	promedioPresentacionesPorAnio:real;
	totalPresentacionesTodosLosAnios:integer;
begin
	reset(arch);
	leer(arch,ip);
	totalPresentacionesTodosLosAnios:=0;
	totalCantAnios:=0;
	while (ip.anio <> valoralto) do begin
		anioActual:=ip.anio;
		writeln('Anio: ', anioActual);
		totalPresentaciones:=0;
		totalCantAnios:=totalCantAnios+1;
		while (anioActual = ip.anio) do begin
			codEventoActual := ip.codEvento;
			writeln('Evento: ',ip.nombreEvento, '(Codigo: ', ip.codEvento,')');
			nombreMenosInfluyente:='nadie';
			puntajeMin:=9999;
			dislikesMin:=9999;
			while (anioActual = ip.anio) and (codEventoActual = ip.codEvento) do begin
				codArtistaActual := ip.codArtista;
				nombreArtistaAct:=ip.nombreArtista;
				writeln('Artista: ', nombreArtistaAct,' (Codigo: ',codArtistaActual,')');
				totalLikes:=0;
				totalDislikes:=0;
				puntajeTotal:=0;
				while (anioActual = ip.anio) and (codEventoActual = ip.codEvento) and (codArtistaActual = ip.codArtista) do begin
					totalLikes := totalLikes + ip.cantLikes;
					totalDislikes := totalDislikes + ip.cantDislikes;
					puntajeTotal := puntajeTotal + ip.puntaje;
					totalPresentaciones:=totalPresentaciones+1;
					leer(arch,ip);
				end;
				diferencia:=totalLikes-totalDislikes;
				writeln(totalLikes);
				writeln(totalDislikes);
				writeln(diferencia);
				writeln(puntajeTotal);
				menosInfluyente(nombreMenosInfluyente,nombreArtistaAct,puntajeMin,puntajeTotal,dislikesMin,totalDislikes)
			end;
			writeln(nombreMenosInfluyente);
		end;
		writeln(totalPresentaciones);//para ese anio
		totalPresentacionesTodosLosAnios:=totalPresentacionesTodosLosAnios+totalPresentaciones;
	end;
	promedioPresentacionesPorAnio:=totalPresentacionesTodosLosAnios/totalCantAnios;
	writeln(promedioPresentacionesPorAnio);
end;

//ppal
var
	arch:archivo;
begin
	assign(arch,'presentaciones');
	informe(arch);
end.
	
