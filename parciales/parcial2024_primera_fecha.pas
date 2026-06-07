const
	valoralto=9999;
type
	prestamo = record
		numSucursal:integer;
		dniEmpleado:integer;
		numPrestamo:integer;
		fecha:integer;
		monto:real;
	end;
	
	archivo = file of prestamo;


procedure leerArch(var arch:archivo; var p:prestamo);
begin
	if not eof(arch) then
		read(arch,p)
	else
		p.numSucursal:=valoralto;
end;


procedure informe(var arch:archivo);
var
	numSucAct,dniEmpleadoAct,anio,anioAct:integer;
	p:prestamo;
	cantSucursalVentas:integer; cantMontoSucursal:real;
	cantVentasEmpleado:integer; cantMontoEmpleado:real;
	cantVentas: integer; montoVentas: real;
	cantTotalVentas:integer; montoTotalEmpresa:real;
begin
	reset(arch);
	leerArch(arch,p);
	cantTotalVentas:=0;
	montoTotalEmpresa:=0;
	
	while (p.numSucursal <> valoralto) do begin
		numSucAct:=p.numSucursal;
		cantSucursalVentas:=0;
		cantMontoSucursal:=0;
		while (p.numSucursal <> valoralto) and (p.numSucursal = numSucAct) do begin
			cantVentasEmpleado:=0;
			cantMontoEmpleado:=0;
			dniEmpleadoAct:=p.dniEmpleado;
			writeln(dniEmpleadoAct);
			while (p.numSucursal <> valoralto) and (p.numSucursal = numSucAct) and (p.dniEmpleado = dniEmpleadoAct) do begin
				anioAct:= extraerAnio(p.fecha);
				cantVentas:=0;
				montoVentas:=0;
				while (p.numSucursal <> valoralto) and (p.numSucursal = numSucAct) and (p.dniEmpleado = dniEmpleadoAct) and (anioAct = extraerAnio(p.fecha)) do begin
					cantVentas:=cantVentas+1;
					montoVentas:=montoVentas+p.monto;
					leerArch(arch,p);
				end;
				cantVentasEmpleado:=cantVentasEmpleado+cantVentas;
				cantMontoEmpleado:=cantMontoEmpleado+montoVentas;
				writeln(anioAct,cantVentas,montoVentas);
			end;
			writeln(cantVentasEmpleado,cantMontoEmpleado);
			cantSucursalVentas:=cantSucursalVentas+cantVentasEmpleado;
			cantMontoSucursal:=cantMontoSucursal+cantMontoEmpleado;
		end;
		writeln(cantSucursalVentas,cantMontoSucursal);
		cantTotalVentas:=cantTotalVentas+cantSucursalVentas;
		montoTotalEmpresa:=montoTotalEmpresa+cantMontoSucursal;
	end;
	writeln(cantTotalVentas,montoTotalEmpresa);
	close(arch);
end;
