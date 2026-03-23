program crear_maestro;

type
    fecha = record
        dia: 1..31;
        mes: integer;
        anio: integer;
    end;

    cliente = record
        codigo: integer;
        nombre: string;
        apellido: string;
    end;

    venta = record
        c: cliente;
        f: fecha;
        monto: real;
    end;

    maestro = file of venta;

var
    mae: maestro;
    v: venta;

procedure cargarVenta(cod: integer; nom, ape: string; anio, mes, dia: integer; monto: real);
begin
    v.c.codigo := cod;
    v.c.nombre := nom;
    v.c.apellido := ape;
    v.f.anio := anio;
    v.f.mes := mes;
    v.f.dia := dia;
    v.monto := monto;
    write(mae, v);
end;

begin
    assign(mae, 'maestro');
    rewrite(mae);

    { CLIENTE 1 }
    cargarVenta(1, 'Juan', 'Perez', 2024, 1, 5, 1200);
    cargarVenta(1, 'Juan', 'Perez', 2024, 1, 10, 800);
    cargarVenta(1, 'Juan', 'Perez', 2024, 2, 3, 500);
    cargarVenta(1, 'Juan', 'Perez', 2024, 2, 15, 900);
    cargarVenta(1, 'Juan', 'Perez', 2024, 5, 20, 1500);

    { mismo cliente otro año }
    cargarVenta(1, 'Juan', 'Perez', 2025, 1, 7, 2000);
    cargarVenta(1, 'Juan', 'Perez', 2025, 3, 12, 700);

    { CLIENTE 2 }
    cargarVenta(2, 'Maria', 'Gomez', 2024, 1, 2, 300);
    cargarVenta(2, 'Maria', 'Gomez', 2024, 1, 25, 600);
    cargarVenta(2, 'Maria', 'Gomez', 2024, 4, 18, 1000);
    cargarVenta(2, 'Maria', 'Gomez', 2024, 6, 5, 750);

    { CLIENTE 3 }
    cargarVenta(3, 'Lucas', 'Martinez', 2023, 12, 30, 400);
    cargarVenta(3, 'Lucas', 'Martinez', 2024, 1, 1, 900);
    cargarVenta(3, 'Lucas', 'Martinez', 2024, 1, 9, 1100);
    cargarVenta(3, 'Lucas', 'Martinez', 2024, 2, 14, 650);
    cargarVenta(3, 'Lucas', 'Martinez', 2024, 7, 8, 2000);

    { CLIENTE 4 }
    cargarVenta(4, 'Ana', 'Lopez', 2024, 3, 3, 300);
    cargarVenta(4, 'Ana', 'Lopez', 2024, 3, 10, 500);
    cargarVenta(4, 'Ana', 'Lopez', 2024, 3, 21, 700);

    close(mae);

    writeln('Archivo maestro creado correctamente.');
end.
