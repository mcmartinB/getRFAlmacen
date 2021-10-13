unit SincroMainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ComCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP, IdMessage;

type
  TFSincroMain = class(TForm)
    btnRF: TButton;
    btnClose: TButton;
    IdSMTP: TIdSMTP;
    IdMessage: TIdMessage;
    procedure btnRFClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

    procedure EnviarMsg;
  public
    { Public declarations }
  end;

var
  FSincroMain: TFSincroMain;

implementation

uses CDAlmacenes;

{$R *.dfm}

procedure TFSincroMain.FormCreate(Sender: TObject);
begin
  DAlmacenes:= TDAlmacenes.Create( self );
end;

procedure TFSincroMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil( DAlmacenes );
end;

procedure TFSincroMain.btnRFClick(Sender: TObject);
var
  sMsg: string;
  dIni, dGlobal: TDateTime;
begin
  dGlobal:= Now;
  try
    dIni:= Now;
    DAlmacenes.GetRFPaletsPB( 'F17', sMsg );
    //mmoMsg.Lines.Add( FormatDateTime( 'hh:nn:ss', dIni - Now) + ' -> ' + sMsg );

    dIni:= Now;
    DAlmacenes.GetRFPaletsPC( 'F17', sMsg );
    //mmoMsg.Lines.Add( FormatDateTime( 'hh:nn:ss', dIni - Now) + ' -> ' + sMsg );
  finally
    //mmoMsg.Lines.Add( FormatDateTime( 'dd/mm/yy hh:nn:ss', Now ) + ' -> Proceso Finalizado [' + FormatDateTime( 'hh:nn:ss', dGlobal - Now) + ']' );
    //lblMsg.Caption:= 'Enviando mensaje';


    EnviarMsg;
    //lblMsg.Caption:= 'Proceso finalizado';
  end;
end;

procedure TFSincroMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFSincroMain.EnviarMsg;
begin
  IdSMTP.Host:= 'smtp.exchange2007.es';
  IdSMTP.Username:= 'USRAD00087416';
  IdSMTP.Password:= 'Pb123456';
  IdSMTP.Port:= 25;  // IdSMTP.Port:= 257;
  try
    try
      Screen.Cursor := crHourGlass;
      IdSMTP.Connect;
      IdMessage.From.Name := 'RF Almacenes';
      IdMessage.From.Address := 'pepebrotons@bonnysa.es';
      IdMessage.ReplyTo.EMailAddresses:= 'pepebrotons@bonnysa.es';
      IdMessage.Recipients.Add.Address := 'pepebrotons@bonnysa.es';
      IdMessage.Subject := 'RF Almacenes ' + DateToStr( date );
      IdMessage.Body.Clear;
      //IdMessage.Body.AddStrings( mmoMsg.Lines );
      IdSMTP.Send(IdMessage);
      Screen.Cursor := crArrow;
    finally
      IdSMTP.Disconnect;
    end;
  except
    //Igonramos el error si no podemos enviar el correo
    //por lo meos el programa sigue ejecutandos
  end;
end;



end.
