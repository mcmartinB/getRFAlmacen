unit UActualizarFechaLlegada;

interface

Procedure ActualizarFechaLlegada;

implementation

uses
  SysUtils, CDAlmacenes;

procedure SQLCentral;
begin
  with DAlmacenes.QCentral do
  begin
    SQL.clear;
    SQL.Add(' select * ');
    SQL.Add(' from frf_entregas_c ');
    SQL.Add(' where empresa_ec = :empresa ');
    SQL.Add(' and fecha_origen_ec > :fecha ');
    SQL.Add(' order by codigo_ec ');
  end;
end;

procedure SQLAlmacen;
begin
  with DAlmacenes.QAlmacen do
  begin
    SQL.clear;
    SQL.Add(' select * ');
    SQL.Add(' from frf_entregas_c ');
    SQL.Add(' where codigo_ec = :codigo ');
  end;
end;

Procedure ActualizarEntregasAux;
begin
  with DAlmacenes do
  begin
    QAlmacen.ParamByName('codigo').AsString:= QCentral.FieldByName('codigo_ec').AsString;
    QAlmacen.Open;
    if not QAlmacen.IsEmpty then
    begin
      if QAlmacen.FieldByName('fecha_llegada_ec').Value <> QCentral.FieldByName('fecha_llegada_ec').Value then
      begin
        QCentral.Edit;
        QCentral.FieldByName('fecha_llegada_ec').Value:= QAlmacen.FieldByName('fecha_llegada_ec').Value;
        QCentral.Post;
      end;
    end;
    QAlmacen.Close;
  end;
end;

Procedure ActualizarEntregas( const ADataBase: string );
begin
  DAlmacenes.QAlmacen.DatabaseName:= ADataBase;
  with DAlmacenes.QCentral do
  begin
    ParamByName('empresa').AsString:= CDAlmacenes.GetPlanta( ADataBase );
    ParamByName('fecha').AsDate:= Date - 30;
    Open;
    while Not Eof do
    begin
      ActualizarEntregasAux;
      Next;
    end;
    Close;
  end;
end;

Procedure ActualizarFechaLlegada;
begin
  SQLCentral;
  SQLAlmacen;

  ActualizarEntregas( 'dbAlzira' );
  ActualizarEntregas( 'dbChanita' );
  ActualizarEntregas( 'dbFrutibon' );
  ActualizarEntregas( 'dbTenerife' );
  ActualizarEntregas( 'dbSevilla' );

end;

end.
