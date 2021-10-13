unit Configuracion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Menus, StdCtrls, cxButtons, cxCheckBox, ExtCtrls, IniFiles, Registry;

type
  TMConfiguracion = class(TForm)
    pnl1: TPanel;
    chkEjecutarInicio: TcxCheckBox;
    btnAceptar: TcxButton;
    procedure btnAceptarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure EjecutarInicio;
    procedure QuitarEjecutarInicio;
    procedure GuardarConfiguracion;
    procedure CargarConfiguracion;
  public
    { Public declarations }
  end;

var
  MConfiguracion: TMConfiguracion;

implementation


{$R *.dfm}

procedure TMConfiguracion.btnAceptarClick(Sender: TObject);
begin
  Close;
end;

procedure TMConfiguracion.CargarConfiguracion;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create (ChangeFileExt(Application.ExeName, '.ini'));
  with Ini do
  begin
    try
      chkEjecutarInicio.Checked :=  ReadBool('Configuración',
      'Ejecutar al iniciar Windows', false);

    finally
      Free;
    end;
  end;
end;

procedure TMConfiguracion.EjecutarInicio;
var
  reg : tregistry;
begin
  Reg := TRegistry.Create(KEY_WRITE);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.Access := KEY_WRITE;
    if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) then
    begin
      try
        Reg.WriteString(Application.Title,
            ExtractFilePath(ParamStr(0)) + ExtractFileName(ParamStr(0)));
      except
        Reg.CloseKey;
        raise;
      end;
    end;
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;
{
procedure TMConfiguracion.EjecutarInicio2;
var
  reg : tregistry;
begin
//  Reg := TRegistry.Create(KEY_WRITE);
  Reg := TRegistry.Create(KEY_WRITE OR KEY_WOW64_64KEY);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.Access := KEY_ALL_ACCESS;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', True) then
    begin
      try
        Reg.WriteString(Application.Title,
            ExtractFilePath(ParamStr(0)) + ExtractFileName(ParamStr(0)));
      except
        Reg.CloseKey;
        raise;
      end;
    end;
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;
}
procedure TMConfiguracion.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if chkEjecutarInicio.Checked then
    EjecutarInicio
  else
    QuitarEjecutarInicio;

  GuardarConfiguracion;
end;

procedure TMConfiguracion.FormCreate(Sender: TObject);
begin
  CargarConfiguracion;
end;

procedure TMConfiguracion.GuardarConfiguracion;
var
   Ini: TIniFile;
begin
 Ini := TIniFile.Create (ChangeFileExt(Application.ExeName, '.ini'));
 with Ini do
  begin
    try
      WriteBool('Configuración', 'Ejecutar al iniciar Windows',
         chkEjecutarInicio.Checked);
    finally
      free;
    end;
  end;
end;

procedure TMConfiguracion.QuitarEjecutarInicio;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create(KEY_WRITE);
  reg.RootKey := HKEY_LOCAL_MACHINE;

  reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', false);
  reg.DeleteValue(Application.Title);
  reg.CloseKey;
  reg.Free;
end;
{
procedure TMConfiguracion.QuitarEjecutarInicio2;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create(KEY_WRITE);
  reg.RootKey := HKEY_CURRENT_USER;
  reg.Access := KEY_ALL_ACCESS;
  reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', false);
  reg.DeleteValue(Application.Title);
  reg.CloseKey;
  reg.Free;
end;
}
end.
