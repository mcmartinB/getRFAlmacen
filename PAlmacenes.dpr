program PAlmacenes;

uses
  Forms,
  CFAlmacenes in 'CFAlmacenes.pas' {FAlmacenes},
  CDAlmacenes in 'CDAlmacenes.pas' {DAlmacenes: TDataModule},
  Configuracion in 'Configuracion.pas' {MConfiguracion};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFAlmacenes, FAlmacenes);
  Application.Run;
end.
