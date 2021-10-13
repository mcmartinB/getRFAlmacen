unit UGetAlmacenRF;

interface

procedure TraerDatosAlmacenRF;

implementation

uses
  CDAlmacenes;

(*
STATUS PALETS PROVEEDOR
*******************************************************************************************
' '     Frutibon Sevilla     -> B
v       volcado (chanita)    -> V


*******************************************************************************************
No se usan, ignorar
N       chanita         Prueba

*******************************************************************************************
Usados, no traer
B       BORRADO         Error, palet no valido
S       STOCK           Producto para usar

*******************************************************************************************
Usados, duda que hacer
C       CARGADO         Venta directa a cliente o transito a otro almacen
                        fecha status + orden de carga
                        Venta directa, compra y venta en el mismo palet, no tene confeccionado
                        Transito, pasa a stock, volcado y confeccionado en otro almacen,
                                pero la entrega esta en primero ¿como valorar?
T       TRANSITO        transito pendiente de activar

*******************************************************************************************
Usados, traer
R       REGULARIZADO    Me falta el palet, es como si lo volcara ahora
V       VOLCADO         Producto usado en las lineas, produce los palets confeccionados
D       DESTRIO         Producto que tiro, lo resto de los volcados
*)

procedure PaletsProveedorSQL;
begin
  with DAlmacenes.QCentral do
  begin
    SQL.Clear;
    SQL.Add(' select * ');
    SQL.Add(' from frf_palet_pb ');
  end;
  with DAlmacenes.QAlmacen do
  begin
    SQL.Clear;
    SQL.Add(' select producto, ');
    SQL.Add('        date(fecha_status) fecha, ');
    SQL.Add('        fecha_status hora, ');
    SQL.Add('        empresa, ');
    SQL.Add('        centro, ');
    SQL.Add('        entrega, ');
    SQL.Add('        sscc, ');
    SQL.Add('        proveedor, ');
    SQL.Add('        variedad, ');
    SQL.Add('        calibre, ');
    SQL.Add('        cajas, ');
    SQL.Add('        peso, ');
    SQL.Add('        peso_bruto, ');
    SQL.Add('        status, ');
    SQL.Add('        ( select unidades_caja_pp from frf_productos_proveedor ');
    SQL.Add('          where empresa_pp = empresa and proveedor_pp = proveedor ');
    SQL.Add('            and producto_pp = producto and variedad_pp = variedad ) * cajas unidades');
    SQL.Add(' from rf_palet_pb ');
    SQL.Add(' where ( status = ''V'' or status = ''R'' or status = ''D'' ) ');
  end;
end;

procedure InsertarRFPaletPB;
begin
  DAlmacenes.QCentral.Insert;
  DAlmacenes.QCentral.FieldByName('empresa_pb').Value:= DAlmacenes.QAlmacen.FieldByName('empresa').Value;
  DAlmacenes.QCentral.FieldByName('centro_pb').Value:= DAlmacenes.QAlmacen.FieldByName('centro').Value;
  DAlmacenes.QCentral.FieldByName('sscc_pb').Value:= DAlmacenes.QAlmacen.FieldByName('sscc').Value;
  DAlmacenes.QCentral.FieldByName('status_pb').Value:= DAlmacenes.QAlmacen.FieldByName('status').Value;
  DAlmacenes.QCentral.FieldByName('fecha_pb').Value:= DAlmacenes.QAlmacen.FieldByName('fecha').Value;
  DAlmacenes.QCentral.FieldByName('hora_pb').Value:= DAlmacenes.QAlmacen.FieldByName('hora').Value;
  DAlmacenes.QCentral.FieldByName('proveedor_pb').Value:= DAlmacenes.QAlmacen.FieldByName('proveedor').Value;
  DAlmacenes.QCentral.FieldByName('entrega_pb').Value:= DAlmacenes.QAlmacen.FieldByName('entrega').Value;
  DAlmacenes.QCentral.FieldByName('producto_pb').Value:= DAlmacenes.QAlmacen.FieldByName('producto').Value;
  DAlmacenes.QCentral.FieldByName('variedad_pb').Value:= DAlmacenes.QAlmacen.FieldByName('variedad').Value;
  DAlmacenes.QCentral.FieldByName('calibre_pb').Value:= DAlmacenes.QAlmacen.FieldByName('calibre').Value;
  DAlmacenes.QCentral.FieldByName('cajas_pb').Value:= DAlmacenes.QAlmacen.FieldByName('cajas').Value;
  DAlmacenes.QCentral.FieldByName('unidades_pb').Value:= DAlmacenes.QAlmacen.FieldByName('unidades').Value;
  DAlmacenes.QCentral.FieldByName('peso_pb').Value:= DAlmacenes.QAlmacen.FieldByName('peso').Value;
  DAlmacenes.QCentral.FieldByName('peso_bruto_pb').Value:= DAlmacenes.QAlmacen.FieldByName('peso_bruto').Value;
  DAlmacenes.QCentral.Post;;
end;

procedure RFPaletPB;
begin
  PaletsProveedorSQL;
  DAlmacenes.QCentral.Open;
  with DAlmacenes.QAlmacen do
  begin
    Open;
    while not eof do
    begin
      InsertarRFPaletPB;
      next;
    end;
    close;
  end;
  DAlmacenes.QCentral.Close;
end;


(*
STATUS PALETS CONFECCIONADOS
*******************************************************************************************
No se usan, ignorar
P (PICKING)
X
F

*******************************************************************************************
Usados, no traer
R       REGULARIZADO    Palet que estaba en stock y no encontramos, error, -> SIMILAR BORRADO
B       BORRADO         Palet incorrecto, es como si no existiera
A       ANULADO         Palet que usamos para completar otro (valido para trazabilidad)
                        INICIAL: Palet 1 Status S Cajas  20

                        FINAL:   Palet 1 Status A Cajas  20
                                 Palet 1 Status A Cajas -20      -> Anulamos palet 1
                                 Palet X Status X Cajas  X + 20  -> Los ponemos en otro palet
S       STOCK           Palet preparado para usar

*******************************************************************************************
Usados, duda, no traer
V       VOLCADO         Preconfecionado vuelto a volcar a linea (similar palet proveedor)
                        Ejemplo:
                        Palet Proveedor Tomate -> Volcado a linea hornos ->
                        Palet Preconfecionado Tomate Seco -> Volcado a linea envasado ->
                        Palet Confeccionado en stock -> Cargado
                        ¿Esto tiene coste no tenido en cuenta en los costes de envasado final?
                        ¿los costes del tomate seco tienen en cuenta el preconfecionad?

*******************************************************************************************
Usados, traer
C       CARGADO         Palet usado (Todos los palets que salen tiene estado C)
*)

procedure PaletsConfeccionadosSQL;
begin
  with DAlmacenes.QCentral do
  begin
    SQL.Clear;
    SQL.Add(' select * ');
    SQL.Add(' from frf_palet_pc ');
  end;
  with DAlmacenes.QAlmacen do
  begin
    SQL.Clear;
    SQL.Add(' select ');
    SQL.Add('        ( select producto_base_e from frf_envases where empresa_e = empresa_cab  and envase_e = envase_det ) producto_base, ');
    SQL.Add('        date(fecha_alta_cab) fecha_alta, ');
    SQL.Add('        fecha_alta_cab hora_alta, ');
    SQL.Add('        date(fecha_carga_cab) fecha_carga, ');
    SQL.Add('        fecha_carga_cab hora_carga, ');
    SQL.Add('        empresa_cab empresa, ');
    SQL.Add('        centro_cab centro, ');
    SQL.Add('        orden_carga_cab orden, ');
    SQL.Add('        ean128_cab ean128, ');
    SQL.Add('        ean13_det ean13, ');
    SQL.Add('        formato_det formato, ');
    SQL.Add('        envase_det envase, ');
    SQL.Add('        unidades_det cajas, ');
    SQL.Add('        peso_det peso_real, ');
    SQL.Add('        ( select peso_neto_e from frf_envases where empresa_e = empresa_cab  and envase_e = envase_det ) *  unidades_det peso_teorico, ');
    SQL.Add('        ( select unidades_e from frf_envases where empresa_e = empresa_cab  and envase_e = envase_det ) *  unidades_det unidades, ');
    SQL.Add('        status_cab status');
    SQL.Add(' from rf_palet_pc_cab, rf_palet_pc_det ');
    SQL.Add(' where ean128_cab = ean128_det ');
    SQL.Add(' and status_cab = ''C'' ');
  end;
end;

procedure InsertarRFPaletPC;
begin
  with DAlmacenes do
  begin
    QCentral.Insert;
    QCentral.FieldByName('empresa_pc').Value:= QAlmacen.FieldByName('empresa').Value;
    QCentral.FieldByName('centro_pc').Value:= QAlmacen.FieldByName('centro').Value;
    QCentral.FieldByName('ean128_pc').Value:= QAlmacen.FieldByName('ean128').Value;
    QCentral.FieldByName('status_pc').Value:= QAlmacen.FieldByName('status').Value;
    QCentral.FieldByName('fecha_alta_pc').Value:= QAlmacen.FieldByName('fecha_alta').Value;
    QCentral.FieldByName('hora_alta_pc').Value:= QAlmacen.FieldByName('hora_alta').Value;
    QCentral.FieldByName('fecha_carga_pc').Value:= QAlmacen.FieldByName('fecha_carga').Value;
    QCentral.FieldByName('hora_carga_pc').Value:= QAlmacen.FieldByName('hora_carga').Value;
    QCentral.FieldByName('orden_pc').Value:= QAlmacen.FieldByName('orden').Value;
    QCentral.FieldByName('producto_base_pc').Value:= QAlmacen.FieldByName('producto_base').Value;
    QCentral.FieldByName('formato_pc').Value:= QAlmacen.FieldByName('formato').Value;
    QCentral.FieldByName('envase_pc').Value:= QAlmacen.FieldByName('envase').Value;
    QCentral.FieldByName('ean13_pc').Value:= QAlmacen.FieldByName('ean13').Value;
    QCentral.FieldByName('cajas_pc').Value:= QAlmacen.FieldByName('cajas').Value;
    QCentral.FieldByName('unidades_pc').Value:= QAlmacen.FieldByName('unidades').Value;
    QCentral.FieldByName('peso_real_pc').Value:= QAlmacen.FieldByName('peso_real').Value;
    QCentral.FieldByName('peso_teorico_pc').Value:= QAlmacen.FieldByName('peso_teorico').Value;
    QCentral.Post;;
  end;
end;

procedure RFPaletPC;
begin
  PaletsConfeccionadosSQL;
  DAlmacenes.QCentral.Open;
  with DAlmacenes.QAlmacen do
  begin
    Open;
    while not eof do
    begin
      InsertarRFPaletPC;
      next;
    end;
    close;
  end;
  DAlmacenes.QCentral.Close;
end;

(*******************************************************************************************************
********************************************************************************************************)


procedure TablaProveedores;
begin
  with DAlmacenes.QCentral do
  begin
    SQL.Clear;
    SQL.Add('create table frf_palet_pb( ');
    SQL.Add(' empresa_pb char(3), ');
    SQL.Add(' centro_pb CHAR(1), ');
    SQL.Add(' sscc_pb CHAR(20), ');
    SQL.Add(' status_pb CHAR(1), ');
    SQL.Add(' fecha_pb DATE, ');
    SQL.Add(' hora_pb DATETIME  YEAR TO SECOND, ');
    SQL.Add(' proveedor_pb CHAR(3), ');
    SQL.Add(' entrega_pb CHAR(12), ');
    SQL.Add(' producto_pb CHAR(3), ');
    SQL.Add(' variedad_pb INTEGER, ');
    SQL.Add(' calibre_pb CHAR(6), ');
    SQL.Add(' cajas_pb SMALLINT, ');
    SQL.Add(' unidades_pb SMALLINT,');
    SQL.Add(' peso_pb DECIMAL(6,2), ');
    SQL.Add(' peso_bruto_pb DECIMAL(6,2)');
    SQL.Add(') ');
    ExecSQL;
  end;
end;

procedure TablaConfeccionado;
begin
  with DAlmacenes.QCentral do
  begin
    SQL.Clear;
    SQL.Add('create table frf_palet_pc( ');
    SQL.Add('  empresa_pc char(3), ');
    SQL.Add('  centro_pc char(1), ');
    SQL.Add('  ean128_pc CHAR(20), ');
    SQL.Add('  status_pc CHAR(1),');
    SQL.Add('  fecha_alta_pc DATE, ');
    SQL.Add('  hora_alta_pc DATETIME  YEAR TO SECOND, ');
    SQL.Add('  fecha_carga_pc DATE, ');
    SQL.Add('  hora_carga_pc DATETIME  YEAR TO SECOND, ');
    SQL.Add('  orden_pc INTEGER, ');
    SQL.Add('  producto_base_pc INTEGER, ');
    SQL.Add('  formato_pc INTEGER, ');
    SQL.Add('  envase_pc char(3), ');
    SQL.Add('  ean13_pc CHAR(13), ');
    SQL.Add('  cajas_pc INTEGER, ');
    SQL.Add('  unidades_pc INTEGER, ');
    SQL.Add('  peso_real_pc DECIMAL(7,3), ');
    SQL.Add('  peso_teorico_pc DECIMAL(7,3) ');
    SQL.Add(') ');
    ExecSQL;
  end;
end;

procedure CrearTablas;
begin
  DAlmacenes.BorrarSiExisteTabla('frf_palet_pb');
  TablaProveedores;
  DAlmacenes.BorrarSiExisteTabla('frf_palet_pc');
  TablaConfeccionado;
end;

procedure TraerDatosAlmacenRF;
begin
  CrearTablas;

  DAlmacenes.QAlmacen.DatabaseName:= 'dbAlzira';
  RFPaletPB;
  RFPaletPC;

  DAlmacenes.QAlmacen.DatabaseName:= 'dbChanita';
  RFPaletPB;
  RFPaletPC;

  DAlmacenes.QAlmacen.DatabaseName:= 'dbFrutibon';
  RFPaletPB;
  RFPaletPC;

  DAlmacenes.QAlmacen.DatabaseName:= 'dbTenerife';
  RFPaletPB;
  RFPaletPC;

  DAlmacenes.QAlmacen.DatabaseName:= 'dbSevilla';
  RFPaletPB;
  RFPaletPC;
end;

end.
