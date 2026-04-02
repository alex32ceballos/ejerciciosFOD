{Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
mismo (información guardada acerca de los movimientos que ocurren en el server) que se
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.
a. Realice el procedimiento necesario para actualizar la información del log en un
día particular. Defina las estructuras de datos que utilice su procedimiento.
b. Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX..............cantidadMensajesEnviados
.............
nro_usuarioX+n...........cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema. Considere la implementación de esta opción de las
siguientes maneras:
i- Como un procedimiento separado del punto a).
ii- En el mismo procedimiento de actualización del punto a). Qué cambios
se requieren en el procedimiento del punto a) para realizar el informe en
el mismo recorrido?
   
}


program untitled;
const valoralto = 9999;
type
	informacion = record
		nro_usuario:integer;
		nombreUsuario, nombre, apellido:string;
		cantidadMailEnviados:integer;
	end;
	
	infoD = record
		nro_usuario:integer;
		cuentaDestino, cuerpoMensaje:string;
	end;
	
	maestro = file of informacion;
	detalle = file of infoD;
	
procedure leerD(var det:detalle; var d:infoD);
begin
	if (not eof(det)) then
		read(det,d)
	else
		d.nro_usuario := valoralto;
end;

procedure leerM(var mae:maestro; var m:informacion);
begin
	if (not eof(mae)) then
		read(mae,m)
	else
		m.nro_usuario := valoralto;
end;


procedure actualizarTXT(var cantidad,nro:integer; var archtxt:text);
begin
	writeln(archtxt, nro, ' .......... ',cantidad);
end;


procedure actualizar(var mae:maestro; var det:detalle; var archtxt:text);
var m:informacion; d:infoD; cantidad: integer;
begin
	rewrite(archtxt);
	reset(mae);
	reset(det);
	leerM(mae,m);
	leerD(det,d);
	while (m.nro_usuario <> valoralto) do begin
		while (d.nro_usuario <> valoralto) and (d.nro_usuario < m.nro_usuario) do 
			leerD(det,d);
		cantidad := 0;
		while (d.nro_usuario <> valoralto) and (m.nro_usuario = d.nro_usuario) do begin
			cantidad := cantidad + 1;
			leerD(det,d)
		end;
		seek(mae,filepos(mae)-1);
		m.cantidadMailEnviados := m.cantidadMailEnviados + cantidad;
		actualizarTXT(cantidad,m.nro_usuario,archtxt);
		write(mae,m);
		leerM(mae,m);
	end;
	close(archtxt);
	close(mae);
	close(det);
end;

var
	mae:maestro; det:detalle; archtxt:text;
BEGIN
	assign(mae,'maestroP2_12'); //me falto la ruta zzzzzzzzzzzzzzzz
	assign(det, 'detalleP2_12'); //dia determinado
	assign(archtxt,'txtP2_12.txt');
	actualizar(mae,det,archtxt);
	
END.

