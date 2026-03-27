{Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado. Presentar en pantalla un listado con el
siguiente formato:
Departamento
División
Número de Empleado
 Total de Hs. Importe a cobrar
......
 ..........
 .........
......
 ..........
 .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____
Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.
}


program untitled;
const valoralto=9999;
type
	empleado = record
		departamento: integer;
		division: integer;
		nroEmpleado: integer;
		categoria: integer;
		horasExtras: integer;
	end;
	 maestro = file of empleado;

	 
	 arregloHoras = array[1..15] of integer; //arreglo de montos por hora segun categoria

	 
procedure cargarArreglo(var h:text; var v:arregloHoras);
var
	hora:integer; categoria:integer;
begin
	reset(h);
	while (not eof(h)) do begin
		readln(h,categoria,hora);
		v[categoria] := hora;
	end;
	close(h);
end;
	
procedure leer(var mae:maestro; var m:empleado);
begin
	if (not eof(mae)) then
		read(mae, m)
	else
		m.departamento := valoralto;
end;

procedure imprimir(var mae:maestro; v:arregloHoras); //arreglo de montos por hora segun categoria
var
	m:empleado; departamentoAct,divisionAct,nroEmpleadoAct:integer;
	totalHorasDivision,totalMontoDivision:integer;
	totalHorasDepartamento,totalMontoDepartamento:integer;
	totalHorasEmpleado,totalMontoEmpleado:integer;
begin
	reset(mae);
	leer(mae,m);
	while (m.departamento <> valoralto) do begin
		departamentoAct := m.departamento;
		totalHorasDepartamento := 0;
		totalMontoDepartamento := 0;
		writeln('departamento: ',departamentoAct);
		while (departamentoAct = m.departamento) do begin
			divisionAct := m.division;
			totalHorasDivision := 0;
			totalMontoDivision := 0;
			writeln('division: ',divisionAct);
			while (departamentoAct = m.departamento) and (divisionAct = m.division) do begin
				nroEmpleadoAct := m.nroEmpleado;
				totalHorasEmpleado:=0;
				totalMontoEmpleado:=0;
				writeln('numero de empleado: ',nroEmpleadoAct);
				while (departamentoAct = m.departamento) and (divisionAct = m.division) and (nroEmpleadoAct = m.nroEmpleado) do begin
					totalHorasDepartamento := totalHorasDepartamento + m.horasExtras;
					totalMontoDepartamento := totalMontoDepartamento + (m.horasExtras * v[m.categoria]);
					totalHorasDivision := totalHorasDivision + m.horasExtras;
					totalMontoDivision := totalMontoDivision + (m.horasExtras * v[m.categoria]);
					totalHorasEmpleado := totalHorasEmpleado + m.horasExtras;
					totalMontoEmpleado := totalMontoEmpleado + (m.horasExtras * v[m.categoria]);
					leer(mae,m);
				end;
				writeln('total de hs: ',totalHorasEmpleado);
				writeln('total de monto: ',totalMontoEmpleado);
			end;
			writeln('total de horas division: ',totalHorasDivision);
			writeln('total de monto division: ',totalMontoDivision);
		end;
		writeln('total horas departamento: ',totalHorasDepartamento);
		writeln('total monto departamento: ',totalMontoDepartamento);
	end;
	close(mae);	
end;

var
	mae:maestro;
	h:text;
	v:arregloHoras;
BEGIN
	assign(mae,'maestro_p2_10');
	assign(h, 'montoPorHoras_p2_10');
	cargarArreglo(h,v);
	imprimir(mae,v);
END.

