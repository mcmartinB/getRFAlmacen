unit SincroDataDM;

interface

uses
  SysUtils, Classes, DB, DBTables, StdCtrls, ComCtrls, Forms ;

type
  TDSincroData = class(TDataModule)
    dbSAT: TDatabase;
    dbBAGChanita: TDatabase;
    dbBAGP4H: TDatabase;
    dbBAGTenerife: TDatabase;
    dbBAGSevilla: TDatabase;
    qrySAT: TQuery;
    dbBAG: TDatabase;
    qryBAG: TQuery;
    qryBAGChanita: TQuery;
    qryBAGP4H: TQuery;
    qryBAGTenerife: TQuery;
    qryBAGSevilla: TQuery;
    dbSATTenerife: TDatabase;
    dbSATLlanos: TDatabase;
    qrySATLlanos: TQuery;
    qrySATTenerife: TQuery;
    dbCentral: TDatabase;
    qryCentral: TQuery;
    dbAlmacen: TDatabase;
    qryAlmacen: TQuery;
    dbRF: TDatabase;
    qryRF: TQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }

    procedure AlbaranesVenta( var VMsg: string );
    procedure TraerRf( var VMsg: string );
  public
    { Public declarations }

    (*
    function  ExisteTabla( const ATabName: string ): boolean;
    procedure BorrarSiExisteTabla( const ATabName: string );
    *)

    procedure AlbaranesVentaLlanos( var VMsg: string );
    procedure TraerRfChanita( var VMsg: string );
end;

var
  DSincroData: TDSincroData;

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

procedure TDSincroData.TraerRfChanita( var VMsg: string );
begin
  dbRF.Connected:= True;
  dbBAGChanita.Connected:= True;
  dbCentral:= dbSAT;
  dbAlmacen:= dbSATLlanos;

  try
    TraerRf( VMsg );
  finally
    dbRF.Connected:= True;
    dbBAGChanita.Connected:= True;
  end;
end;

procedure TDSincroData.TraerRf( var VMsg: string );
begin
  qryCentral.SQL.Clear;
  qryCentral.SQL.Add('delete from rf_palet_pb ');
  qryCentral.ExecSQL;

  qryCentral.SQL.Clear;
  qryCentral.SQL.Add('select * from rf_palet_pb ');
  qryCentral.Open;

  qryAlmacen.SQL.Clear;
  qryAlmacen.SQL.Add('select * from rf_palet_pb where date(fechamarca) < today - 365 ');
  qryAlmacen.Open;

end;

procedure TDSincroData.AlbaranesVentaLlanos( var VMsg: string );
begin
  dbSAT.Connected:= True;
  dbSATLlanos.Connected:= True;
  dbCentral:= dbSAT;
  dbAlmacen:= dbSATLlanos;

  try
    AlbaranesVenta( VMsg );
  finally
    dbSAT.Connected:= True;
    dbSATLlanos.Connected:= True;
  end;
end;

procedure TDSincroData.AlbaranesVenta( var VMsg: string );
begin
  qryAlmacen.SQL.Clear;
  //qryAlmacen.SQL.Add('select * from frf_salidas_c join frf_salidas_l where fecha_sc between '21/10/2014' and '21/10/2015');

end.
