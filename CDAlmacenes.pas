unit CDAlmacenes;

interface

uses
  SysUtils, Classes, DB, DBTables, StdCtrls, ComCtrls, Forms ;

type
  TDAlmacenes = class(TDataModule)
    dbCentral: TDatabase;
    dbChanita: TDatabase;
    dbFrutibon: TDatabase;
    dbTenerife: TDatabase;
    dbSevilla: TDatabase;
    QCentral: TQuery;
    QAlmacen: TQuery;
    QAux: TQuery;
    QOrden: TQuery;
    QProductoBase: TQuery;
    QDetalleCentral: TQuery;
    QProductoEnvase: TQuery;
    QDetalleAlmacen: TQuery;
    DSAlmacen: TDataSource;
    QProductoEan: TQuery;
    dbLlanos: TDatabase;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    dMarca: TDateTime;
    bParar: boolean;

    procedure GetRFPaletsPB_( const APlanta: string );
    procedure GetRFPaletsPB_2_( const APlanta2, ACentro2: string );
    procedure PaletsProveedorSQL;
    procedure PaletsProveedorSQL_2;
    function  ExistePaletProveedor( const AEmpresa, ASSCC: string ): boolean;
    function  ExistePaletProveedor_2( const AEmpresa, ACentro, ASSCC: string ): boolean;
    procedure BorrarPaletProveedor;
    procedure TraerPaletProveedor;
    procedure OrdenDeCargaProveedor;

    procedure GetRFPaletsPC_( const APlanta: string );
    procedure GetRFPaletsPC_2_( const APlanta2, ACentro2: string );
    procedure PaletsConfeccionadosSQL( const APlanta: string );
    procedure PaletsConfeccionadosSQL_2( const APlanta2, ACentro2: string );
    function  ExistePaletConfeccionado( const AEmpresa, AEan128: string ): boolean;
    function  ExistePaletConfeccionado_2( const AEmpresa, ACentro, AEan128: string ): boolean;
    procedure BorrarPaletConfeccionado;
    procedure TraerPaletConfeccionado;
    procedure TraerPaletConfeccionadoCab;
    procedure TraerPaletConfeccionadoDet;
    procedure OrdenDeCargaConfeccionado;

    function  GetProductoBase( const AEmpresa, AProducto: string; var AProductoBase: integer ): boolean;
    function  GetProductoEnvase( const AEmpresa, AEnvase, AEan13: string; var VUnidades, VProductoBase: integer;
                                 var VEnvase, VProducto: string ): boolean;


  public
    { Public declarations }
    sPalet: string;
    pbBarra: TProgressBar;
    lblMsg: TLabel;

    (*
    function  ExisteTabla( const ATabName: string ): boolean;
    procedure BorrarSiExisteTabla( const ATabName: string );
    *)

    procedure PararProceso;
    procedure GetRFPaletsPB( const APlanta: string; var VMsg: string );
    procedure GetRFPaletsPC( const APlanta: string; var VMsg: string );
end;

var
  DAlmacenes: TDAlmacenes;

implementation

uses
  dialogs, variants;

{$R *.dfm}

(*
function TDAlmacenes.ExisteTabla( const ATabName: string ): boolean;
begin
  with QCentral do
  begin
    SQL.Clear;
    SQL.Add('select * from systables where tabname = :tabname ');
    ParamByName('tabname').AsString:= ATabName;
    Open;
    result:= not IsEmpty;
    Close;
  end;
end;

procedure TDAlmacenes.BorrarSiExisteTabla( const ATabName: string );
begin
  If ExisteTabla(ATabName) then
  begin
    with QCentral do
    begin
      SQL.Clear;
      SQL.Add('drop table ' +  ATabName );
      ExecSQL;
    end;
  end;
end;
*)


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

procedure TDAlmacenes.PararProceso;
begin
  bParar:= true;
end;

procedure TDAlmacenes.GetRFPaletsPB( const APlanta: string; var VMsg: string );
var APlanta2, ACentro2: string;
begin
  try
    try
      dbCentral.Connected:= True;
      if APlanta = 'F17' then
      begin
        APlanta2 := '050';
        ACentro2 := '4';
        QAlmacen.DatabaseName:= dbChanita.DatabaseName;
        dbChanita.Connected:= True;
      end
      else
      if APlanta = 'F18' then
      begin
        APlanta2 := '050';
        ACentro2 := '3';
        QAlmacen.DatabaseName:= dbFrutibon.DatabaseName;
        dbFrutibon.Connected:= True;
      end
      else
      if APlanta = 'F23' then
      begin
        QAlmacen.DatabaseName:= dbTenerife.DatabaseName;
        dbTenerife.Connected:= True;
      end
      else
      if APlanta = 'F24' then
      begin
        QAlmacen.DatabaseName:= dbSevilla.DatabaseName;
        dbSevilla.Connected:= True;
      end
      else
      if APlanta = '050' then
      begin
        APlanta2 := '050';
        ACentro2 := '1';
        QAlmacen.DatabaseName:= dbLlanos.DatabaseName;
        dbLlanos.Connected:= True;
      end;
      QOrden.DatabaseName:= QAlmacen.DatabaseName;

      if APlanta <> '050' then
        GetRFPaletsPB_( APlanta );      // solo mira por planta    todo lo de F17, F18 y F23

      if (APlanta = 'F17') or (APlanta = 'F18') or (APlanta = '050') then    //mira por planta y centro
        GetRFPaletsPB_2_(  APlanta2, ACentro2 );        //Nos traemos RF de la empresa 050


      VMsg:= lblMsg.Caption;
    finally

      QCentral.Close;
      QAlmacen.Close;
      if APlanta = 'F17' then
      begin
        dbChanita.Close;
        dbChanita.Connected:= False;
      end
      else
      if APlanta = 'F18' then
      begin
        dbFrutibon.Close;
        dbFrutibon.Connected:= False;
      end
      else
      if APlanta = 'F23' then
      begin
        dbTenerife.Close;
        dbTenerife.Connected:= False;
      end
      else
      if APlanta = 'F24' then
      begin
        dbSevilla.Close;
        dbSevilla.Connected:= False;
      end;
      dbCentral.Connected:= False;
    end;
  except
    on e: exception do
    begin
      VMsg:= lblMsg.Caption + ' (' + sPalet + ')' + #13 + #10 + e.Message;
    end;
  end;
end;

procedure TDAlmacenes.GetRFPaletsPB_( const APlanta: string );
var
  sAux: string;
begin
  bParar:= False;
  pbBarra.Min:= 0;
  pbBarra.Max:= 1;
  pbBarra.Step:= 1;
  pbBarra.Position:= 0;

  lblMsg.Caption:= 'PB ' + APlanta + ' -> Obtener marca central' ;
  Application.ProcessMessages;

  //Obtener maxima fecha recibida
  with QAux do
  begin
    SQL.Clear;
    SQL.Add(' select max(fecha_marca_apb) marca ');
    SQL.Add(' from alm_palet_pb where empresa_apb = :planta ');
    ParamByName('planta').AsString:= APlanta;
    Open;
    if fieldByName('marca').value = null then
      dMarca:= EncodeDate(2000,1,1)
    else
      dMarca:= fieldByName('marca').AsDateTime;
    Close;
  end;

  lblMsg.Caption:= 'PB ' + APlanta + ' (' + DateTimeToStr( dMarca )  + ') -> Obtener palets' ;
  Application.ProcessMessages;

  //Seleccionamos registros a traer
  if not bParar then
  with QAlmacen do
  begin
    SQL.Clear;
    SQL.Add(' select count(*) registros');
    SQL.Add(' from rf_palet_pb ');
    SQL.Add(' where empresa = :planta ');
    SQL.Add(' and ( case when fechamarca < :fechacorte then fecha_alta else fechamarca end ) >= :fecha_marca ');
    ParamByName('fecha_marca').AsDateTime:= dMarca;
    ParamByName('planta').AsString:= APlanta;
    ParamByName('fechacorte').AsDateTime:= StrToDate( '1/5/2012' );
    Open;

    if FieldByName('registros').AsInteger > 0 then
    begin
      PaletsProveedorSQL;

      lblMsg.Caption:= 'PB ' + APlanta + ' (' + DateTimeToStr( dMarca ) + ') consumidos ' + FieldByName('registros').AsString;
      pbBarra.Max:= FieldByName('registros').AsInteger;
      Application.ProcessMessages;
      Close;

      if not bParar then
      begin
        SQL.Clear;
        SQL.Add(' select *, ');
        SQL.Add('        case when fechamarca < :fechacorte then fecha_alta else fechamarca end marca, ');
        SQL.Add('        ( select unidades_caja_pp from frf_productos_proveedor ');
        SQL.Add('          where proveedor_pp = proveedor ');
        SQL.Add('            and producto_pp = producto and variedad_pp = variedad ) * cajas unidades');
        SQL.Add(' from rf_palet_pb ');
        SQL.Add(' where empresa = :planta ');
        SQL.Add(' and ( case when fechamarca < :fechacorte then fecha_alta else fechamarca end ) >= :fecha_marca ');
        SQL.Add(' order by marca ');
        ParamByName('fecha_marca').AsDateTime:= dMarca;
        ParamByName('planta').AsString:= APlanta;
        ParamByName('fechacorte').AsDateTime:= StrToDate( '1/5/2012' );


        Open;

        sAux:= lblMsg.Caption + ' / ';
        while ( not Eof ) and ( not bParar )  do
        begin
          sPalet:= FieldByname('sscc').AsString;
          lblMsg.Caption:= 'Existe palet ' + sPalet;
          if ExistePaletProveedor( FieldByname('empresa').AsString,
                          FieldByname('sscc').AsString )then
          begin
            lblMsg.Caption:= 'Borrar Palet' + sPalet;
            BorrarPaletProveedor;
          end;
          lblMsg.Caption:= 'Traer Palet' + sPalet;
          TraerPaletProveedor;

          pbBarra.StepIt;
          lblMsg.Caption:= sAux + IntToStr( pbBarra.Position );
          Application.ProcessMessages;
          Next;
        end;

        Close;
        if bParar then
          lblMsg.Caption:= lblMsg.Caption + ' STOP'
        else
          lblMsg.Caption:= lblMsg.Caption + ' FIN';
      end
      else
      begin
        lblMsg.Caption:= lblMsg.Caption + ' STOP';
      end;
    end
    else
    begin
       lblMsg.Caption:= lblMsg.Caption + ' sin consumo ';
    end;
  end
  else
  begin
    lblMsg.Caption:= lblMsg.Caption + ' STOP';
  end;
end;

procedure TDAlmacenes.GetRFPaletsPB_2_( const APlanta2, ACentro2: string );
var
  sAux: string;
begin
  bParar:= False;
  pbBarra.Min:= 0;
  pbBarra.Max:= 1;
  pbBarra.Step:= 1;
  pbBarra.Position:= 0;

  lblMsg.Caption:= 'PB ' + APlanta2 + ' / ' + ACentro2 + ' -> Obtener marca central' ;
  Application.ProcessMessages;

  //Obtener maxima fecha recibida
  with QAux do
  begin
    SQL.Clear;
    SQL.Add(' select max(fecha_marca_apb) marca ');
    SQL.Add(' from alm_palet_pb where empresa_apb = :planta and centro_apb = :centro ');
    ParamByName('planta').AsString:= APlanta2;
    ParamByName('centro').AsString:= ACentro2;
    Open;
    if fieldByName('marca').value = null then
      dMarca:= EncodeDate(2000,1,1)
    else
      dMarca:= fieldByName('marca').AsDateTime;
    Close;
  end;

  lblMsg.Caption:= 'PB ' + APlanta2 + ' / ' + ACentro2 + ' (' + DateTimeToStr( dMarca )  + ') -> Obtener palets' ;
  Application.ProcessMessages;

  //Seleccionamos registros a traer
  if not bParar then
  with QAlmacen do
  begin
    SQL.Clear;
    SQL.Add(' select count(*) registros');
    SQL.Add(' from rf_palet_pb ');
    SQL.Add(' where empresa = :planta ');
    SQL.Add('  and centro = :centro ');
    SQL.Add(' and ( case when fechamarca < :fechacorte then fecha_alta else fechamarca end ) >= :fecha_marca ');
    ParamByName('fecha_marca').AsDateTime:= dMarca;
    ParamByName('planta').AsString:= APlanta2;
    ParamByName('centro').AsString:= ACentro2;
    ParamByName('fechacorte').AsDateTime:= StrToDate( '1/5/2012' );
    Open;

    if FieldByName('registros').AsInteger > 0 then
    begin
      PaletsProveedorSQL_2;

      lblMsg.Caption:= 'PB ' + APlanta2 + ' / ' + ACentro2 + ' (' + DateTimeToStr( dMarca ) + ') consumidos ' + FieldByName('registros').AsString;
      pbBarra.Max:= FieldByName('registros').AsInteger;
      Application.ProcessMessages;
      Close;

      if not bParar then
      begin
        SQL.Clear;
        SQL.Add(' select *, ');
        SQL.Add('        case when fechamarca < :fechacorte then fecha_alta else fechamarca end marca, ');
        SQL.Add('        ( select unidades_caja_pp from frf_productos_proveedor ');
        SQL.Add('          where proveedor_pp = proveedor ');
        SQL.Add('            and producto_pp = producto and variedad_pp = variedad ) * cajas unidades');
        SQL.Add(' from rf_palet_pb ');
        SQL.Add(' where empresa = :planta ');
        SQL.Add(' and centro = :centro ');
        SQL.Add(' and ( case when fechamarca < :fechacorte then fecha_alta else fechamarca end ) >= :fecha_marca ');
        SQL.Add(' order by marca ');
        ParamByName('fecha_marca').AsDateTime:= dMarca;
        ParamByName('planta').AsString:= APlanta2;
        ParamByName('centro').AsString:= ACentro2;
        ParamByName('fechacorte').AsDateTime:= StrToDate( '1/5/2012' );


        Open;

        sAux:= lblMsg.Caption + ' / ';
        while ( not Eof ) and ( not bParar )  do
        begin
          sPalet:= FieldByname('sscc').AsString;
          lblMsg.Caption:= 'Existe palet ' + sPalet;
          if ExistePaletProveedor_2( FieldByname('empresa').AsString, FieldByName('centro').AsString,
                          FieldByname('sscc').AsString )then
          begin
            lblMsg.Caption:= 'Borrar Palet' + sPalet;
            BorrarPaletProveedor;
          end;
          lblMsg.Caption:= 'Traer Palet' + sPalet;
          TraerPaletProveedor;        //Al hacer un Insert, no hace falta duplicar para introducir el centro

          pbBarra.StepIt;
          lblMsg.Caption:= sAux + IntToStr( pbBarra.Position );
          Application.ProcessMessages;
          Next;
        end;

        Close;
        if bParar then
          lblMsg.Caption:= lblMsg.Caption + ' STOP'
        else
          lblMsg.Caption:= lblMsg.Caption + ' FIN';
      end
      else
      begin
        lblMsg.Caption:= lblMsg.Caption + ' STOP';
      end;
    end
    else
    begin
       lblMsg.Caption:= lblMsg.Caption + ' sin consumo ';
    end;
  end
  else
  begin
    lblMsg.Caption:= lblMsg.Caption + ' STOP';
  end;
end;

procedure TDAlmacenes.PaletsProveedorSQL;
begin
  with QCentral do
  begin
    SQL.Clear;
    SQL.Add(' select * ');
    SQL.Add(' from alm_palet_pb ');
    SQL.Add(' where empresa_apb = :empresa ');
    SQL.Add(' and sscc_apb = :sscc ');
  end;
end;

procedure TDAlmacenes.PaletsProveedorSQL_2;
begin
  with QCentral do
  begin
    SQL.Clear;
    SQL.Add(' select * ');
    SQL.Add(' from alm_palet_pb ');
    SQL.Add(' where empresa_apb = :empresa ');
    SQL.Add('   and centro_apb = :centro ');
    SQL.Add('   and sscc_apb = :sscc ');
  end;
end;

function  TDAlmacenes.ExistePaletProveedor( const AEmpresa, ASSCC: string ): boolean;
begin
  with QCentral do
  begin
    if Active then
      Close;
    ParamByName('empresa').AsString:= AEmpresa;
    ParamByName('sscc').AsString:= ASSCC;
    Open;
    result:= not isEmpty;
  end;
end;

function  TDAlmacenes.ExistePaletProveedor_2( const AEmpresa, ACentro, ASSCC: string ): boolean;
begin
  with QCentral do
  begin
    if Active then
      Close;
    ParamByName('empresa').AsString:= AEmpresa;
    ParamByName('centro').AsString:= ACentro;
    ParamByName('sscc').AsString:= ASSCC;
    Open;
    result:= not isEmpty;
  end;
end;

procedure TDAlmacenes.BorrarPaletProveedor;
begin
  with QCentral do
  begin
    Delete;
  end;
end;

procedure TDAlmacenes.TraerPaletProveedor;
var
 auxField: TField;
 iAux: integer;
begin
  with QCentral do
  begin
    Insert;
    FieldByName('empresa_apb').Value:= QAlmacen.FieldByName('empresa').Value;
    FieldByName('centro_apb').Value:= QAlmacen.FieldByName('centro').Value;
    FieldByName('sscc_apb').Value:= QAlmacen.FieldByName('sscc').Value;

    auxField:= QAlmacen.FindField('paletorigen');
    if auxField <> nil then
    begin
      FieldByName('sscc_origen_apb').Value:= auxField.Value;
    end
    else
    begin
      auxField:= QAlmacen.FindField('sscc_origen');
      if auxField <> nil then
      begin
        FieldByName('sscc_origen_apb').Value:= auxField.Value;
      end;
    end;

    FieldByName('lote_apb').Value:= QAlmacen.FieldByName('lote').Value;
    FieldByName('es_pico_apb').Value:= QAlmacen.FieldByName('espico').Value;
    FieldByName('calidad_apb').Value:= QAlmacen.FieldByName('calidad').Value;

    auxField:= QAlmacen.FindField('tipo_destrio');
    if auxField <> nil then
      FieldByName('tipo_destrio_apb').Value:= auxField.Value;

    FieldByName('status_apb').Value:= QAlmacen.FieldByName('status').Value;
    if QAlmacen.FieldByName('fecha_status').Value <> null then
    begin
      FieldByName('fecha_apb').AsDateTime:= QAlmacen.FieldByName('fecha_status').AsDateTime;
      FieldByName('hora_apb').Value:= QAlmacen.FieldByName('fecha_status').Value;
    end;
    FieldByName('terminal_status_apb').Value:= QAlmacen.FieldByName('terminal_status').Value;

    FieldByName('proveedor_apb').Value:= QAlmacen.FieldByName('proveedor').Value;
    FieldByName('entrega_apb').Value:= QAlmacen.FieldByName('entrega').Value;
    FieldByName('producto_apb').Value:= QAlmacen.FieldByName('producto').Value;

    if GetProductoBase( QAlmacen.FieldByName('empresa').AsString, QAlmacen.FieldByName('producto').AsString, iAux ) then
      FieldByName('producto_base_apb').AsInteger:= iAux;

    auxField:= QAlmacen.FindField('pais');
    if auxField <> nil then
    begin
      FieldByName('pais_producto_apb').AsString:= auxField.AsString;
    end;

    FieldByName('variedad_apb').Value:= QAlmacen.FieldByName('variedad').Value;
    FieldByName('calibre_apb').Value:= QAlmacen.FieldByName('calibre').Value;
    FieldByName('categoria_apb').Value:= QAlmacen.FieldByName('categoria').Value;
    FieldByName('cajas_apb').Value:= QAlmacen.FieldByName('cajas').Value;
    if Abs(QAlmacen.FieldByName('unidades').AsInteger ) < 32000 then
      FieldByName('unidades_apb').Value:= QAlmacen.FieldByName('unidades').Value;

    FieldByName('transito_apb').Value:= QAlmacen.FieldByName('transito').Value;
    OrdenDeCargaProveedor;

    FieldByName('peso_apb').Value:= QAlmacen.FieldByName('peso').Value;
    FieldByName('peso_bruto_apb').Value:= QAlmacen.FieldByName('peso_bruto').Value;
    FieldByName('peso_aprovechado_apb').Value:= QAlmacen.FieldByName('peso_aprovechado').Value;
    FieldByName('tipo_palet_apb').Value:= QAlmacen.FieldByName('tipo_palet').Value;

    FieldByName('anulacion_bloqueo_apb').Value:= QAlmacen.FieldByName('anulacionbloqueo').Value;
    FieldByName('bloqueo').Value:= QAlmacen.FieldByName('bloqueo').Value;
    FieldByName('fecha_recoleccion_apb').Value:= QAlmacen.FieldByName('fecha_recoleccion').Value;
    FieldByName('fecha_alta_apb').Value:= QAlmacen.FieldByName('fecha_alta').Value;
    FieldByName('terminal_alta_apb').Value:= QAlmacen.FieldByName('terminal_alta').Value;
    FieldByName('idcamara_apb').Value:= QAlmacen.FieldByName('idcamara').Value;
    FieldByName('camara_apb').Value:= QAlmacen.FieldByName('camara').Value;
    FieldByName('linea_volcado_apb').Value:= QAlmacen.FieldByName('linea_volcado').Value;
    FieldByName('inventario_apb').Value:= QAlmacen.FieldByName('inventario').Value;
    FieldByName('observaciones_apb').Value:= QAlmacen.FieldByName('observaciones').Value;
    FieldByName('fecha_marca_apb').Value:= QAlmacen.FieldByName('marca').Value;
    try
      Post;
    except
      Cancel;
      raise;
    end;
  end;
end;

procedure TDAlmacenes.OrdenDeCargaProveedor;
begin
  with QCentral do
  begin
    if QAlmacen.FieldByName('orden_carga').Value <> null then
    begin
      QOrden.ParamByName('orden').AsInteger:= QAlmacen.FieldByName('orden_carga').AsInteger;
      QOrden.Open;

      try
        FieldByName('orden_carga_apb').Value:= QOrden.FieldByName('orden_occ').Value;
        FieldByName('empresa_albaran_apb').Value:= QOrden.FieldByName('empresa_occ').Value;
        FieldByName('centro_albaran_apb').Value:= QOrden.FieldByName('centro_salida_occ').Value;
        FieldByName('fecha_albaran_apb').Value:= QOrden.FieldByName('fecha_occ').Value;
        FieldByName('n_albaran_apb').Value:= QOrden.FieldByName('n_albaran_occ').Value;
        FieldByName('empresa_origen_apb').Value:= QOrden.FieldByName('planta_origen_occ').Value;

        //if ( QAlmacen.FieldByName('es_venta_occ').AsInteger = 1 ) or
        if   ( QOrden.FieldByName('cliente_sal_occ').Value <> null ) then
        begin
          FieldByName('cliente_albaran_apb').Value:= QOrden.FieldByName('cliente_sal_occ').Value;
          FieldByName('suministro_apb').Value:= QOrden.FieldByName('dir_sum_occ').Value;
        end
        else
        begin
          FieldByName('empresa_destino_apb').Value:= QOrden.FieldByName('planta_destino_occ').Value;
          FieldByName('centro_destino_apb').Value:= QOrden.FieldByName('centro_destino_occ').Value;
        end;
      finally
        QOrden.Close;
      end;
    end;
  end;
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

procedure TDAlmacenes.GetRFPaletsPC( const APlanta: string; var VMsg: string );
var APlanta2, ACentro2: string;
begin
  try
    try
      dbCentral.Connected:= True;
      if APlanta = 'F17' then
      begin
        APlanta2 := '050';
        ACentro2 := '4';
        QAlmacen.DatabaseName:= dbChanita.DatabaseName;
        dbChanita.Connected:= True;
      end
      else
      if APlanta = 'F18' then
      begin
        APlanta2 := '050';
        ACentro2 := '3';
        QAlmacen.DatabaseName:= dbFrutibon.DatabaseName;
        dbFrutibon.Connected:= True;
      end
      else
      if APlanta = 'F23' then
      begin
        QAlmacen.DatabaseName:= dbTenerife.DatabaseName;
        dbTenerife.Connected:= True;
      end
      else
      if APlanta = 'F24' then
      begin
        QAlmacen.DatabaseName:= dbSevilla.DatabaseName;
        dbSevilla.Connected:= True;
      end;
      QOrden.DatabaseName:= QAlmacen.DatabaseName;
      QDetalleAlmacen.DatabaseName:= QAlmacen.DatabaseName;
      QProductoEan.DatabaseName:= QAlmacen.DatabaseName;

      GetRFPaletsPC_( APlanta );
      if (APlanta = 'F17') or (APlanta = 'F18') then
        GetRFPaletsPC_2_(  APlanta2, ACentro2 );        //Nos traemos RF de la empresa 050

      VMsg:= lblMsg.Caption;
    finally

      QDetalleCentral.Close;
      QDetalleAlmacen.Close;
      QCentral.Close;
      QAlmacen.Close;

      if APlanta = 'F17' then
      begin
        dbChanita.Close;
        dbChanita.Connected:= False;
      end
      else
      if APlanta = 'F18' then
      begin
        dbFrutibon.Close;
        dbFrutibon.Connected:= False;
      end
      else
      if APlanta = 'F23' then
      begin
        dbTenerife.Close;
        dbTenerife.Connected:= False;
      end
      else
      if APlanta = 'F24' then
      begin
        dbSevilla.Close;
        dbSevilla.Connected:= False;
      end;
      dbCentral.Connected:= False;
    end;
  except
    on e: exception do
    begin
      VMsg:= lblMsg.Caption + #13 + #10 + e.Message;
    end;
  end;
end;


procedure TDAlmacenes.GetRFPaletsPC_( const APlanta: string );
var
  sAux: string;
begin
  bParar:= False;
  pbBarra.Min:= 0;
  pbBarra.Max:= 1;
  pbBarra.Step:= 1;
  pbBarra.Position:= 0;

  lblMsg.Caption:= 'PC ' + APlanta + ' Obtener marca central.';
  Application.ProcessMessages;

  //Obtener maxima fecha recibida
  with QAux do
  begin
    SQL.Clear;
    SQL.Add(' select max(case when fecha_marca_apcc < ( select max( fecha_marca_apcd ) from  alm_palet_pc_d ');
    SQL.Add('                                          where empresa_apcc = empresa_apcd ');
    SQL.Add('                                          and centro_apcc = centro_apcd ');
    SQL.Add('                                          and ean128_apcc = ean128_apcd ) ');
    SQL.Add('                 then ( select max( fecha_marca_apcd ) from  alm_palet_pc_d ');
    SQL.Add('                       where empresa_apcc = empresa_apcd ');
    SQL.Add('                       and centro_apcc = centro_apcd ');
    SQL.Add('                       and ean128_apcc = ean128_apcd ) ');
    SQL.Add('                 else fecha_marca_apcc ');
    SQL.Add('            end ) fecha_marca ');
    SQL.Add(' from alm_palet_pc_c ');
    SQL.Add(' where empresa_apcc = :planta ');
    ParamByName('planta').AsString:= APlanta;
    Open;
    if fieldByName('fecha_marca').value = null then
      dMarca:= EncodeDate(2000,1,1)
    else
      dMarca:= fieldByName('fecha_marca').AsDateTime;
    Close;
  end;

  lblMsg.Caption:= 'PC ' + APlanta + ' (' + DateTimeToStr( dMarca ) + ')';
  Application.ProcessMessages;


  //Seleccionamos registros a traer
  if not bParar then
  with QAlmacen do
  begin
    SQL.Clear;
    {
    SQL.Add(' select count(*) registros');
    SQL.Add(' from rf_palet_pc_cab ');
    SQL.Add(' where empresa_cab = :planta ');
    SQL.Add(' and case when fechamarca < ( select max(d.fechamarca) ');
    SQL.Add('                              from rf_palet_pc_det d ');
    SQL.Add('                              where ean128_cab = d.ean128_det ) ');
    SQL.Add('          then ( select max(d.fechamarca) ');
    SQL.Add('                 from rf_palet_pc_det d ');
    SQL.Add('                 where ean128_cab = d.ean128_det ) ');
    SQL.Add('          else fechamarca ');
    SQL.Add('     end >= :fecha_marca ');
    }
    SQL.Add(' select count(*) registros ');
    SQL.Add(' from rf_palet_pc_cab c ');
    SQL.Add(' where c.empresa_cab = :planta ');

    SQL.Add(' and ( case when fechamarca < :fechacorte then fecha_alta_cab else fechamarca end ) >= :fecha_marca ');

    ParamByName('planta').AsString:= APlanta;
    ParamByName('fecha_marca').AsDateTime:= dMarca;
    ParamByName('fechacorte').AsDateTime:= StrToDate( '1/5/2012' );
    Open;

    if FieldByName('registros').AsInteger > 0 then
    begin
      PaletsConfeccionadosSQL( APlanta );

      lblMsg.Caption:= 'PC ' + APlanta + ' (' + DateTimeToStr( dMarca ) + ') confeccionados ' + FieldByName('registros').AsString;
      pbBarra.Max:= FieldByName('registros').AsInteger;
      Application.ProcessMessages;
      Close;

      if not bParar then
      begin
        SQL.Clear;
        {
        SQL.Add(' select *, case when fechamarca < ( select max(d.fechamarca) ');
        SQL.Add('                                 from rf_palet_pc_det d ');
        SQL.Add('                                 where ean128_cab = d.ean128_det ) ');
        SQL.Add('                then ( select max(d.fechamarca) ');
        SQL.Add('                         from rf_palet_pc_det d ');
        SQL.Add('                         where ean128_cab = d.ean128_det ) ');
        SQL.Add('                else fechamarca ');
        SQL.Add('           end marca ');
        SQL.Add(' from rf_palet_pc_cab ');
        SQL.Add(' where empresa_cab = :planta ');
        SQL.Add(' and case when fechamarca < ( select max(d.fechamarca) ');
        SQL.Add('                              from rf_palet_pc_det d ');
        SQL.Add('                              where ean128_cab = d.ean128_det ) ');
        SQL.Add('          then ( select max(d.fechamarca) ');
        SQL.Add('                 from rf_palet_pc_det d ');
        SQL.Add('                 where ean128_cab = d.ean128_det ) ');
        SQL.Add('          else fechamarca ');
        SQL.Add('     end >= :fecha_marca ');
        SQL.Add(' order by fecha_alta_cab ');
        }



        SQL.Add(' select c.*, case when fechamarca < :fechacorte then fecha_alta_cab else fechamarca  end marca ');
        SQL.Add(' from rf_palet_pc_cab c ');
        SQL.Add(' where c.empresa_cab = :planta ');
        SQL.Add(' and ( case when fechamarca < :fechacorte then fecha_alta_cab else fechamarca end ) >= :fecha_marca ');
        SQL.Add(' order by marca ');
        ParamByName('planta').AsString:= APlanta;
        ParamByName('fecha_marca').AsDateTime:= dMarca;
        ParamByName('fechacorte').AsDateTime:= StrToDate( '1/5/2012' );
        Open;
        QDetalleAlmacen.Open;

        sAux:= lblMsg.Caption + ' / ';
        while ( not Eof ) and ( not bParar )  do
        begin
          sPalet:= FieldByname('ean128_cab').AsString;
          lblMsg.Caption:= 'Existe palet ' + sPalet;
          if ExistePaletConfeccionado( FieldByname('empresa_cab').AsString,
                          FieldByname('ean128_cab').AsString )then
          begin
            lblMsg.Caption:= 'Borrar palet ' + sPalet;
            BorrarPaletConfeccionado;
          end;
          lblMsg.Caption:= 'Traer palet ' + sPalet;
          TraerPaletConfeccionado;

          pbBarra.StepIt;
          lblMsg.Caption:= sAux + IntToStr( pbBarra.Position );
          Application.ProcessMessages;
          Next;
        end;

        QDetalleAlmacen.Close;
        Close;
        if bParar then
          lblMsg.Caption:= lblMsg.Caption + ' STOP'
        else
          lblMsg.Caption:= lblMsg.Caption + ' FIN';
      end
      else
      begin
        lblMsg.Caption:= lblMsg.Caption + ' STOP';
      end;
    end
    else
    begin
       lblMsg.Caption:= lblMsg.Caption + ' sin confección ';
    end;
  end
  else
  begin
    lblMsg.Caption:= lblMsg.Caption + ' STOP';
  end;
end;

procedure TDAlmacenes.GetRFPaletsPC_2_( const APlanta2, ACentro2: string );
var
  sAux: string;
begin
  bParar:= False;
  pbBarra.Min:= 0;
  pbBarra.Max:= 1;
  pbBarra.Step:= 1;
  pbBarra.Position:= 0;

  lblMsg.Caption:= 'PC ' + APlanta2 + ' / ' + ACentro2 + ' Obtener marca central.';
  Application.ProcessMessages;

  //Obtener maxima fecha recibida
  with QAux do
  begin
    SQL.Clear;
    SQL.Add(' select max(case when fecha_marca_apcc < ( select max( fecha_marca_apcd ) from  alm_palet_pc_d ');
    SQL.Add('                                          where empresa_apcc = empresa_apcd ');
    SQL.Add('                                          and centro_apcc = centro_apcd ');
    SQL.Add('                                          and ean128_apcc = ean128_apcd ) ');
    SQL.Add('                 then ( select max( fecha_marca_apcd ) from  alm_palet_pc_d ');
    SQL.Add('                       where empresa_apcc = empresa_apcd ');
    SQL.Add('                       and centro_apcc = centro_apcd ');
    SQL.Add('                       and ean128_apcc = ean128_apcd ) ');
    SQL.Add('                 else fecha_marca_apcc ');
    SQL.Add('            end ) fecha_marca ');
    SQL.Add(' from alm_palet_pc_c ');
    SQL.Add(' where empresa_apcc = :planta ');
    SQL.Add('   and centro_apcc = :centro ');
    ParamByName('planta').AsString:= APlanta2;
    ParamByName('centro').AsString:= ACentro2;
    Open;
    if fieldByName('fecha_marca').value = null then
      dMarca:= EncodeDate(2000,1,1)
    else
      dMarca:= fieldByName('fecha_marca').AsDateTime;
    Close;
  end;

  lblMsg.Caption:= 'PC ' + APlanta2 + ' / ' + ACentro2 + ' (' + DateTimeToStr( dMarca ) + ')';
  Application.ProcessMessages;


  //Seleccionamos registros a traer
  if not bParar then
  with QAlmacen do
  begin
    SQL.Clear;
    SQL.Add(' select count(*) registros ');
    SQL.Add(' from rf_palet_pc_cab c ');
    SQL.Add(' where c.empresa_cab = :planta ');
    SQL.Add('  and c.centro_cab = :centro ');
    SQL.Add(' and ( case when fechamarca < :fechacorte then fecha_alta_cab else fechamarca end ) >= :fecha_marca ');

    ParamByName('planta').AsString:= APlanta2;
    ParamByName('centro').AsString:= ACentro2;
    ParamByName('fecha_marca').AsDateTime:= dMarca;
    ParamByName('fechacorte').AsDateTime:= StrToDate( '1/5/2012' );
    Open;

    if FieldByName('registros').AsInteger > 0 then
    begin
      PaletsConfeccionadosSQL_2( APlanta2, ACentro2 );

      lblMsg.Caption:= 'PC ' + APlanta2 + ' / ' + ACentro2 + ' (' + DateTimeToStr( dMarca ) + ') confeccionados ' + FieldByName('registros').AsString;
      pbBarra.Max:= FieldByName('registros').AsInteger;
      Application.ProcessMessages;
      Close;

      if not bParar then
      begin
        SQL.Clear;
        SQL.Add(' select c.*, case when fechamarca < :fechacorte then fecha_alta_cab else fechamarca  end marca ');
        SQL.Add(' from rf_palet_pc_cab c ');
        SQL.Add(' where c.empresa_cab = :planta ');
        SQL.Add(' and c.centro_cab = :centro ');
        SQL.Add(' and ( case when fechamarca < :fechacorte then fecha_alta_cab else fechamarca end ) >= :fecha_marca ');
        SQL.Add(' order by marca ');
        ParamByName('planta').AsString:= APlanta2;
        ParamByName('centro').AsString:= ACentro2;
        ParamByName('fecha_marca').AsDateTime:= dMarca;
        ParamByName('fechacorte').AsDateTime:= StrToDate( '1/5/2012' );
        Open;
        QDetalleAlmacen.Open;

        sAux:= lblMsg.Caption + ' / ';
        while ( not Eof ) and ( not bParar )  do
        begin
          sPalet:= FieldByname('ean128_cab').AsString;
          lblMsg.Caption:= 'Existe palet ' + sPalet;
          if ExistePaletConfeccionado_2( FieldByname('empresa_cab').AsString, FieldByName('centro_cab').AsString,
                          FieldByname('ean128_cab').AsString )then
          begin
            lblMsg.Caption:= 'Borrar palet ' + sPalet;
            BorrarPaletConfeccionado;
          end;
          lblMsg.Caption:= 'Traer palet ' + sPalet;
          TraerPaletConfeccionado;

          pbBarra.StepIt;
          lblMsg.Caption:= sAux + IntToStr( pbBarra.Position );
          Application.ProcessMessages;
          Next;
        end;

        QDetalleAlmacen.Close;
        Close;
        if bParar then
          lblMsg.Caption:= lblMsg.Caption + ' STOP'
        else
          lblMsg.Caption:= lblMsg.Caption + ' FIN';
      end
      else
      begin
        lblMsg.Caption:= lblMsg.Caption + ' STOP';
      end;
    end
    else
    begin
       lblMsg.Caption:= lblMsg.Caption + ' sin confección ';
    end;
  end
  else
  begin
    lblMsg.Caption:= lblMsg.Caption + ' STOP';
  end;
end;

procedure TDAlmacenes.PaletsConfeccionadosSQL( const APlanta: string );
begin
  with QCentral do
  begin
    SQL.Clear;
    SQL.Add(' select * ');
    SQL.Add(' from alm_palet_pc_c ');
    SQL.Add(' where empresa_apcc = :empresa ');
    SQL.Add(' and ean128_apcc = :ean128 ');
  end;
  with QDetalleCentral do
  begin
    SQL.Clear;
    SQL.Add(' select * ');
    SQL.Add(' from alm_palet_pc_d ');
    SQL.Add(' where empresa_apcd = :empresa ');
    SQL.Add(' and ean128_apcd = :ean128 ');
  end;
  with QDetalleAlmacen do
  begin
    SQL.Clear;
    SQL.Add(' select * ');
    SQL.Add(' from rf_palet_pc_det ');
    SQL.Add(' where ean128_det = :ean128_cab ');
  end;
end;

procedure TDAlmacenes.PaletsConfeccionadosSQL_2( const APlanta2, ACentro2: string );
begin
  with QCentral do
  begin
    SQL.Clear;
    SQL.Add(' select * ');
    SQL.Add(' from alm_palet_pc_c ');
    SQL.Add(' where empresa_apcc = :empresa ');
    SQL.Add(' and centro_apcc = :centro ');
    SQL.Add(' and ean128_apcc = :ean128 ');
  end;
  with QDetalleCentral do
  begin
    SQL.Clear;
    SQL.Add(' select * ');
    SQL.Add(' from alm_palet_pc_d ');
    SQL.Add(' where empresa_apcd = :empresa ');
    SQL.Add(' and centro_apcd = :centro ');
    SQL.Add(' and ean128_apcd = :ean128 ');
  end;
  with QDetalleAlmacen do
  begin
    SQL.Clear;
    SQL.Add(' select * ');
    SQL.Add(' from rf_palet_pc_det ');
    SQL.Add(' where ean128_det = :ean128_cab ');
  end;
end;

function  TDAlmacenes.ExistePaletConfeccionado( const AEmpresa, AEan128: string ): boolean;
begin
  if QDetalleCentral.Active then
    QDetalleCentral.Close;

  with QCentral do
  begin
    if Active then
      Close;
    ParamByName('empresa').AsString:= AEmpresa;
    ParamByName('ean128').AsString:= AEan128;
    Open;
    result:= not isEmpty;
  end;
  with QDetalleCentral do
  begin
    if Active then
      Close;
    ParamByName('empresa').AsString:= AEmpresa;
    ParamByName('ean128').AsString:= AEan128;
    Open;
    result:= ( not isEmpty ) or result;
  end;
end;

function  TDAlmacenes.ExistePaletConfeccionado_2( const AEmpresa, ACentro, AEan128: string ): boolean;
begin
  if QDetalleCentral.Active then
    QDetalleCentral.Close;

  with QCentral do
  begin
    if Active then
      Close;
    ParamByName('empresa').AsString:= AEmpresa;
    ParamByName('centro').AsString:= ACentro;
    ParamByName('ean128').AsString:= AEan128;
    Open;
    result:= not isEmpty;
  end;
  with QDetalleCentral do
  begin
    if Active then
      Close;
    ParamByName('empresa').AsString:= AEmpresa;
    ParamByName('centro').AsString:= ACentro;
    ParamByName('ean128').AsString:= AEan128;
    Open;
    result:= ( not isEmpty ) or result;
  end;
end;

procedure TDAlmacenes.BorrarPaletConfeccionado;
begin
  with QDetalleCentral do
  begin
    First;
    while not Eof do
    begin
      Delete;
    end;
  end;

  with QCentral do
  begin
    Delete;
  end;
end;

procedure TDAlmacenes.TraerPaletConfeccionado;
begin
  //dentro de una trasaccion
  try
    dbCentral.StartTransaction;
    TraerPaletConfeccionadoCab;
    QDetalleAlmacen.First;
    while not QDetalleAlmacen.Eof do
    begin
     TraerPaletConfeccionadoDet;
     QDetalleAlmacen.Next;
    end;
    dbCentral.Commit;
  except
    dbCentral.Rollback;
    raise;
  end;
end;

procedure TDAlmacenes.TraerPaletConfeccionadoCab;
var
 auxField: TField;
begin
  with QCentral do
  begin
    Insert;
    FieldByName('empresa_apcc').Value:= QAlmacen.FieldByName('empresa_cab').Value;
    FieldByName('centro_apcc').Value:= QAlmacen.FieldByName('centro_cab').Value;
    FieldByName('ean128_apcc').Value:= QAlmacen.FieldByName('ean128_cab').Value;
    FieldByName('status_apcc').Value:= QAlmacen.FieldByName('status_cab').Value;

    FieldByName('terminal_apcc').Value:= QAlmacen.FieldByName('terminal_cab').Value;
    FieldByName('fecha_alta_apcc').Value:= QAlmacen.FieldByName('fecha_alta_cab').Value;
    FieldByName('previsto_carga_apcc').Value:= QAlmacen.FieldByName('previsto_carga').Value;
    FieldByName('fecha_carga_apcc').Value:= QAlmacen.FieldByName('fecha_carga_cab').Value;
    FieldByName('terminal_carga_apcc').Value:= QAlmacen.FieldByName('terminal_carga_cab').Value;
    FieldByName('tipo_palet_apcc').Value:= QAlmacen.FieldByName('tipo_palet_cab').Value;
    FieldByName('cliente_apcc').Value:= QAlmacen.FieldByName('cliente_cab').Value;
    FieldByName('dirsum_apcc').Value:= QAlmacen.FieldByName('dirsum_cab').Value;
    FieldByName('ref_transito_apcc').Value:= QAlmacen.FieldByName('ref_transito').Value;
    FieldByName('fecha_transito_apcc').Value:= QAlmacen.FieldByName('fecha_transito').Value;

    OrdenDeCargaConfeccionado;

    FieldByName('fecha_volcado_apcc').Value:= QAlmacen.FieldByName('fecha_volcado_cab').Value;
    FieldByName('le_volcado_apcc').Value:= QAlmacen.FieldByName('le_volcado_cab').Value;
    FieldByName('terminal_volcado_apcc').Value:= QAlmacen.FieldByName('terminal_volcado_cab').Value;
    FieldByName('fecha_borrado_apcc').Value:= QAlmacen.FieldByName('fecha_borrado_cab').Value;
    FieldByName('terminal_borrado_apcc').Value:= QAlmacen.FieldByName('terminal_borrado_cab').Value;
    FieldByName('eti_conserva_apcc').Value:= QAlmacen.FieldByName('eti_conserva').Value;
    FieldByName('observaciones_apcc').Value:= QAlmacen.FieldByName('observaciones').Value;
    FieldByName('inventario_apcc').Value:= QAlmacen.FieldByName('inventario').Value;
    FieldByName('fecha_horno_apcc').Value:= QAlmacen.FieldByName('fecha_horno').Value;
    FieldByName('bloqueo_apcc').Value:= QAlmacen.FieldByName('bloqueo').Value;
    FieldByName('fecha_alta_real_apcc').Value:= QAlmacen.FieldByName('fecha_alta_real_cab').Value;
    FieldByName('fecha_marca_apcc').Value:= QAlmacen.FieldByName('marca').Value;

    auxField:= QAlmacen.FindField('albaran_campo_tfe');
    if auxField <> nil then
    begin
      FieldByName('albaran_campo_tfe_apcc').Value:= auxField.Value;
    end;

    try
      Post;
    except
      Cancel;
      raise;
    end;
  end;
end;
procedure TDAlmacenes.OrdenDeCargaConfeccionado;
begin
  with QCentral do
  begin
    if QAlmacen.FieldByName('orden_carga_cab').Value <> null then
    begin
      QOrden.ParamByName('orden').AsInteger:= QAlmacen.FieldByName('orden_carga_cab').AsInteger;
      QOrden.Open;

      try
        FieldByName('orden_apcc').Value:= QOrden.FieldByName('orden_occ').Value;
        FieldByName('empresa_albaran_apcc').Value:= QOrden.FieldByName('empresa_occ').Value;
        FieldByName('centro_albaran_apcc').Value:= QOrden.FieldByName('centro_salida_occ').Value;
        FieldByName('fecha_albaran_apcc').Value:= QOrden.FieldByName('fecha_occ').Value;
        FieldByName('n_albaran_apcc').Value:= QOrden.FieldByName('n_albaran_occ').Value;
        FieldByName('empresa_origen_apcc').Value:= QOrden.FieldByName('planta_origen_occ').Value;

        //if ( QAlmacen.FieldByName('es_venta_occ').AsInteger = 1 ) or
        if   ( QOrden.FieldByName('cliente_sal_occ').Value <> null ) then
        begin
          FieldByName('cliente_albaran_apcc').Value:= QOrden.FieldByName('cliente_sal_occ').Value;
          FieldByName('suministro_apcc').Value:= QOrden.FieldByName('dir_sum_occ').Value;
        end
        else
        begin
          FieldByName('empresa_destino_apcc').Value:= QOrden.FieldByName('planta_destino_occ').Value;
          FieldByName('centro_destino_apcc').Value:= QOrden.FieldByName('centro_destino_occ').Value;
        end;
      finally
        QOrden.Close;
      end;
    end;
  end;
end;

procedure TDAlmacenes.TraerPaletConfeccionadoDet;
var
  iUnidades, iProductoBase: integer;
  sEnvase, sProducto: string;
  auxField: TField;
begin
  with QDetalleCentral do
  begin
    Insert;
    FieldByName('empresa_apcd').Value:= QAlmacen.FieldByName('empresa_cab').Value;
    FieldByName('centro_apcd').Value:= QAlmacen.FieldByName('centro_cab').Value;
    FieldByName('ean128_apcd').Value:= QDetalleAlmacen.FieldByName('ean128_det').Value;
    FieldByName('ean13_apcd').Value:= QDetalleAlmacen.FieldByName('ean13_det').Value;

    FieldByName('fecha_alta_apcd').Value:= QDetalleAlmacen.FieldByName('fecha_alta_det').Value;
    FieldByName('le_apcd').Value:= QDetalleAlmacen.FieldByName('le_det').Value;
    FieldByName('formato_apcd').Value:= QDetalleAlmacen.FieldByName('formato_det').Value;
    FieldByName('lote_apcd').Value:= QDetalleAlmacen.FieldByName('lote').Value;
    FieldByName('calibre_apcd').Value:= QDetalleAlmacen.FieldByName('calibre_det').Value;
    FieldByName('color_apcd').Value:= QDetalleAlmacen.FieldByName('color_det').Value;
    FieldByName('cajas_apcd').Value:= QDetalleAlmacen.FieldByName('unidades_det').Value;
    FieldByName('peso_apcd').Value:= QDetalleAlmacen.FieldByName('peso_det').Value;
    FieldByName('peso_bruto_apcd').Value:= QDetalleAlmacen.FieldByName('peso_bruto_det').Value;

    if GetProductoEnvase( QAlmacen.FieldByName('empresa_cab').AsString,
                          QDetalleAlmacen.FieldByName('envase_det').AsString,
                          QDetalleAlmacen.FieldByName('ean13_det').AsString,
                          iUnidades, iProductoBase, sEnvase, sProducto ) then
    begin
      FieldByName('unidades_apcd').AsInteger:= iUnidades * QDetalleAlmacen.FieldByName('unidades_det').AsInteger;
      FieldByName('producto_base_apcd').AsInteger:= iProductoBase;
      FieldByName('producto_apcd').AsString:= sProducto;
    end
    else
    begin
      FieldByName('unidades_apcd').AsInteger:= 0;
    end;
    if sEnvase <> '' then
      FieldByName('envase_apcd').AsString:= sEnvase;

    FieldByName('peso_destarado_apcd').Value:= QDetalleAlmacen.FieldByName('peso_destarado').Value;
    FieldByName('ean128_orig_apcd').Value:= QDetalleAlmacen.FieldByName('ean128_orig_det').Value;
    FieldByName('ean128_dest_apcd').Value:= QDetalleAlmacen.FieldByName('ean128_dest_det').Value;
    FieldByName('terminal_apcd').Value:= QDetalleAlmacen.FieldByName('terminal_det').Value;
    FieldByName('turno_apcd').Value:= QDetalleAlmacen.FieldByName('turno').Value;
    FieldByName('caducidad_apcd').Value:= QDetalleAlmacen.FieldByName('caducidad').Value;
    FieldByName('fecha_marca_apcd').Value:= QDetalleAlmacen.FieldByName('fechamarca').Value;

    auxField:= QDetalleAlmacen.FindField('fecha_alta_real_cab');
    if auxField <> nil then
    begin
      FieldByName('fecha_alta_real_apcc').Value:= auxField.Value;
    end;
    auxField:= QDetalleAlmacen.FindField('bloqueo');
    if auxField <> nil then
    begin
      FieldByName('bloqueo_apcc').Value:= auxField.Value;
    end;
    auxField:= QDetalleAlmacen.FindField('fecha_horno');
    if auxField <> nil then
    begin
      FieldByName('fecha_horno_apcc').Value:= auxField.Value;
    end;
    auxField:= QDetalleAlmacen.FindField('horas_horno');
    if auxField <> nil then
    begin
      FieldByName('horas_horno_apcd').Value:= auxField.Value;
    end;

    try
      Post;
    except
      Cancel;
      raise;
    end;
  end;
end;


(*
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*)

function TDAlmacenes.GetProductoBase( const AEmpresa, AProducto: string; var AProductoBase: integer ): boolean;
begin
  AProductoBase:= -1;
  result:= false;

  with QProductoBase do
  begin
    ParamByName('producto').AsString:= AProducto;
    Open;
    if not IsEmpty then
    begin
      result:= True;
      AProductoBase:= FieldByname('producto_base_p').AsInteger;
    end;
    Close;
  end;
end;

function  TDAlmacenes.GetProductoEnvase( const AEmpresa, AEnvase, AEan13: string; var VUnidades, VProductoBase: integer;
                                         var VEnvase, VProducto: string ): boolean;
begin
  VUnidades:= 0;
  VProductoBase:= -1;
  VProducto:= '';
  VEnvase:= AEnvase;
  result:= false;

  if AEnvase <> '' then
  with QProductoEnvase do
  begin
    ParamByName('envase').AsString:= AEnvase;
    Open;
    if not IsEmpty then
    begin
      result:= True;
      VUnidades:= FieldByname('unidades_e').AsInteger;
      VProductoBase:= FieldByname('producto_base_e').AsInteger;
      VProducto:= FieldByname('producto_p').AsString;
    end;
    Close;
  end;

  if not Result then
  with QProductoEan do
  begin
    ParamByName('empresa').AsString:= AEmpresa;
    ParamByName('ean').AsString:= AEan13;
    Open;
    if not IsEmpty then
    begin
      result:= True;
      VUnidades:= FieldByname('unidades_e').AsInteger;
      VProductoBase:= FieldByname('producto_base_e').AsInteger;
      VProducto:= FieldByname('producto_p').AsString;
      if AEnvase = '' then
      begin
        VEnvase:=  FieldByname('envase_e').AsString;
      end;
    end;
    Close;
  end;

end;

procedure TDAlmacenes.DataModuleCreate(Sender: TObject);
begin
  with QOrden do
  begin
    SQL.Clear;
    SQL.Add(' select orden_occ, empresa_occ, centro_salida_occ, n_albaran_occ, fecha_occ, ');
           SQL.Add(' planta_origen_occ, planta_destino_occ, centro_destino_occ, ');
    SQL.Add('        cliente_sal_occ, dir_sum_occ, traspasada_occ es_venta_occ ');
    SQL.Add(' from frf_orden_carga_c ');
    SQL.Add(' where orden_occ = :orden ');
  end;

  with QProductoBase do
  begin
    SQL.Clear;
    SQL.Add(' select producto_base_p ');
    SQL.Add(' from frf_productos ');
    SQL.Add(' where producto_p = :producto ');
  end;

  with QProductoEnvase do
  begin
    SQL.Clear;
    SQL.Add(' select unidades_e, producto_base_e, producto_p ');
    SQL.Add(' from frf_envases, frf_productos ');
    SQL.Add(' where envase_e = :envase ');
    SQL.Add('   and producto_e = producto_p ');
  end;

  (*TODO*)(*preconficionado*)
  with QProductoEan do
  begin
    SQL.Clear;
    SQL.Add(' select nvl(en.unidades_e,1) unidades_e, ea.producto_e producto_base_e, producto_p, ea.envase_e ');
    SQL.Add(' from  frf_ean13 ea  left join frf_envases en on en.envase_e = ea.envase_e ');
    SQL.Add('                     left join frf_productos on  producto_p = ea.productop_e ');
    SQL.Add(' where ea.codigo_e = :ean ');
    SQL.Add(' and ea.empresa_e = :empresa ');
  end;
end;

end.
