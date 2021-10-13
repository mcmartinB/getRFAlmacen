unit CFAlmacenes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ComCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP, IdMessage,
  IdExplicitTLSClientServerBase, IdSMTPBase, Menus;

type
  TFAlmacenes = class(TForm)
    btnRF: TButton;
    chkChanita: TCheckBox;
    chkP4H: TCheckBox;
    chkTenerife: TCheckBox;
    chkLlanos: TCheckBox;
    btnClose: TButton;
    pbBar: TProgressBar;
    lblMsg: TLabel;
    IdSMTP: TIdSMTP;
    IdMessage: TIdMessage;
    chkConsumidos: TCheckBox;
    chkConfeccionados: TCheckBox;
    mmoMsg: TMemo;
    btnIniciarResidente: TButton;
    mm1: TMainMenu;
    mnuConfiguracion: TMenuItem;
    chkSevilla: TCheckBox;
    procedure btnRFClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnIniciarResidenteClick(Sender: TObject);
    procedure mnuConfiguracionClick(Sender: TObject);
  private
    { Private declarations }
    bFlag: boolean;
    bResidente: boolean;

    procedure EnviarMsg;
    procedure HabilitarBotones( const AHabilitar: boolean );
    procedure IniciarResidente;
    procedure PararResidente;
  public
    { Public declarations }
  end;

var
  FAlmacenes: TFAlmacenes;

implementation

uses CDAlmacenes, Configuracion;

{$R *.dfm}

procedure TFAlmacenes.FormCreate(Sender: TObject);
begin
  bFlag:= False;
  bResidente:= False;
  DAlmacenes:= TDAlmacenes.Create( self );
  DAlmacenes.pbBarra:= pbBar;
  DAlmacenes.lblMsg:= lblMsg;
end;

procedure TFAlmacenes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil( DAlmacenes );
end;

procedure TFAlmacenes.btnRFClick(Sender: TObject);
var
  sMsg: string;
  dIni, dGlobal: TDateTime;
begin
  bFlag:= True;
  btnRF.Enabled:= False;
  btnClose.Caption:= 'Parar Proceso';
  lblMsg.Caption:= 'Barra de estado';
  mmoMsg.Lines.Clear;


  dGlobal:= Now;
  mmoMsg.Lines.Clear;
  mmoMsg.Lines.Add( FormatDateTime('dd/mm/yy hh:nn:ss', Now ) + ' -> Iniciando Proceso' );

  Application.ProcessMessages;
  try
    if chkConsumidos.Checked and bFlag then
    begin
      if chkChanita.Checked and bFlag then
      begin
        dIni:= Now;
        DAlmacenes.GetRFPaletsPB( 'F17', sMsg );
        mmoMsg.Lines.Add( FormatDateTime( 'hh:nn:ss', dIni - Now) + ' -> ' + sMsg );
        Application.ProcessMessages;
      end;
      if chkP4H.Checked and bFlag then
      begin
        dIni:= Now;
        DAlmacenes.GetRFPaletsPB( 'F18', sMsg );
        mmoMsg.Lines.Add( FormatDateTime( 'hh:nn:ss', dIni - Now) + ' -> ' + sMsg );
        Application.ProcessMessages;
      end;
      if chkTenerife.Checked and bFlag then
      begin
        dIni:= Now;
        DAlmacenes.GetRFPaletsPB( 'F23', sMsg );
        mmoMsg.Lines.Add( FormatDateTime( 'hh:nn:ss', dIni - Now) + ' -> ' + sMsg );
        Application.ProcessMessages;
      end;
      if chkLlanos.Checked and bFlag then
      begin
        dIni:= Now;
        DAlmacenes.GetRFPaletsPB( '050', sMsg );
        mmoMsg.Lines.Add( FormatDateTime( 'hh:nn:ss', dIni - Now) + ' -> ' + sMsg );
        Application.ProcessMessages;
      end;
      if chkSevilla.Checked and bFlag then
      begin
        dIni:= Now;
        DAlmacenes.GetRFPaletsPB( 'F24', sMsg );
        mmoMsg.Lines.Add( FormatDateTime( 'hh:nn:ss', dIni - Now) + ' -> ' + sMsg );
        Application.ProcessMessages;
      end;
    end;

    if chkConfeccionados.Checked and bFlag then
    begin
      if chkChanita.Checked and bFlag then
      begin
        dIni:= Now;
        DAlmacenes.GetRFPaletsPC( 'F17', sMsg );
        mmoMsg.Lines.Add( FormatDateTime( 'hh:nn:ss', dIni - Now) + ' -> ' + sMsg );
        Application.ProcessMessages;
      end;
      if chkP4H.Checked and bFlag then
      begin
        dIni:= Now;
        DAlmacenes.GetRFPaletsPC( 'F18', sMsg );
        mmoMsg.Lines.Add( FormatDateTime( 'hh:nn:ss', dIni - Now) + ' -> ' + sMsg );
        Application.ProcessMessages;
      end;
      if chkTenerife.Checked and bFlag then
      begin
        dIni:= Now;
        DAlmacenes.GetRFPaletsPC( 'F23', sMsg );
        mmoMsg.Lines.Add( FormatDateTime( 'hh:nn:ss', dIni - Now) + ' -> ' + sMsg );
        Application.ProcessMessages;
      end;
      if chkSevilla.Checked and bFlag then
      begin
        dIni:= Now;
        DAlmacenes.GetRFPaletsPC( 'F24', sMsg );
        mmoMsg.Lines.Add( FormatDateTime( 'hh:nn:ss', dIni - Now) + ' -> ' + sMsg );
        Application.ProcessMessages;
      end;

      //De momento, no nos traemos el confeccionado de los llanos

    end;
  finally
    btnRF.Enabled:= True;
    btnClose.Caption:= 'Cerrar Aplicación';
    mmoMsg.Lines.Add( FormatDateTime( 'dd/mm/yy hh:nn:ss', Now ) + ' -> Proceso Finalizado [' + FormatDateTime( 'hh:nn:ss', dGlobal - Now) + ']' );
    lblMsg.Caption:= 'Enviando mensaje';
    Application.ProcessMessages;

    EnviarMsg;
    lblMsg.Caption:= 'Proceso finalizado';
    bFlag:= False;
  end;
end;

procedure TFAlmacenes.btnCloseClick(Sender: TObject);
begin
  if bFlag then
  begin
    DAlmacenes.PararProceso;
    bFlag:= False;
  end
  else
  begin
    Close;
  end;
end;

procedure TFAlmacenes.EnviarMsg;
begin
  IdSMTP.Host:= 'smtp.bonnysa.es';
  IdSMTP.Username:= 'bonnysa@bonnysa.es';
  IdSMTP.Password:= 'Bonnysa9359';
  IdSMTP.Port:= 25;  // IdSMTP.Port:= 257;
  try
    try
      Screen.Cursor := crHourGlass;
      IdSMTP.Connect;
      IdMessage.From.Name := 'RF Almacenes';
      IdMessage.From.Address := 'bonnysa@bonnysa.es';
      IdMessage.ReplyTo.EMailAddresses:= 'mcmartin@bonnysa.es';
      IdMessage.Recipients.Add.Address := 'mcmartin@bonnysa.es';
      IdMessage.Subject := 'RF Almacenes ' + DateToStr( date );
      IdMessage.Body.Clear;
      IdMessage.Body.AddStrings( mmoMsg.Lines );
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

procedure TFAlmacenes.HabilitarBotones( const AHabilitar: boolean );
begin
  btnRF.Enabled:= AHabilitar;
  btnClose.Enabled:= AHabilitar;
  chkChanita.Enabled:= AHabilitar;
  chkP4H.Enabled:= AHabilitar;
  chkTenerife.Enabled:= AHabilitar;
  chkSevilla.Enabled:= AHabilitar;
  chkLlanos.Enabled:=AHabilitar;
  chkConsumidos.Enabled:= AHabilitar;
  chkConfeccionados.Enabled:= AHabilitar;

  if AHabilitar then
    btnIniciarResidente.Caption:= 'Iniciar Residente'
  else
    btnIniciarResidente.Caption:= 'Parar Residente';

  Application.ProcessMessages;
end;

procedure TFAlmacenes.IniciarResidente;
var
  bTarde: boolean;
begin
  HabilitarBotones( False );
  bTarde:= not ( ( Time > StrToTime( '8:00') ) and ( Time < StrToTime( '20:00') ) );
  while bResidente do
  begin
    if bTarde then
    begin

      if not ( ( Time > StrToTime( '8:00') ) and ( Time < StrToTime( '20:00') ) ) then
      begin
        //ShowMessage('Por la tarde');
        btnRFClick( btnRF );
        bTarde:= False;
      end
      else
      begin
        sleep(1000);
        lblMsg.Caption:= 'Esperando a las 8 de la mañana';
      end;
    end
    else
    begin
      if ( Time > StrToTime( '8:00') ) and ( Time < StrToTime( '20:00') ) then
      begin
        //ShowMessage('Por la mañana');
        btnRFClick( btnRF );
        bTarde:= True;
      end
      else
      begin
        sleep(1000);
        lblMsg.Caption:= 'Esperando a las 8 de la tarde';
      end;
    end;
    Application.ProcessMessages;
  end;
  HabilitarBotones( True );
end;

procedure TFAlmacenes.mnuConfiguracionClick(Sender: TObject);
begin
//  MConfiguracion := TMConfiguracion.Create(Self);
  Application.CreateForm(TMConfiguracion, MConfiguracion);
  try
    MConfiguracion.ShowModal;

  finally
    FreeAndNil( MConfiguracion );
  end;
end;

procedure TFAlmacenes.PararResidente;
begin
  DAlmacenes.PararProceso;
  bFlag:= False;
end;

procedure TFAlmacenes.btnIniciarResidenteClick(Sender: TObject);
begin
  if bResidente then
  begin
    bResidente:= false;
    Application.ProcessMessages;
    PararResidente;
  end
  else
  begin
    bResidente:= True;
    Application.ProcessMessages;
    IniciarResidente;
  end;
end;

end.
