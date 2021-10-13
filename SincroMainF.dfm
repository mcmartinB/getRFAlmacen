object FSincroMain: TFSincroMain
  Left = 735
  Top = 118
  Width = 511
  Height = 383
  Caption = '    SINCRONIZAR MAESTROS COMERCIALES'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnRF: TButton
    Left = 16
    Top = 42
    Width = 160
    Height = 25
    Caption = 'Comprobar Albaranes de Venta'
    TabOrder = 0
    OnClick = btnRFClick
  end
  object btnClose: TButton
    Left = 15
    Top = 10
    Width = 458
    Height = 25
    Caption = 'Cerrar Aplicaci'#243'n'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object IdSMTP: TIdSMTP
    MaxLineAction = maException
    ReadTimeout = 0
    Host = 'smtp.exchange2007.es'
    Port = 25
    AuthenticationType = atLogin
    Password = 'Pb123456'
    Username = 'USRAD00087416'
    Left = 368
    Top = 9
  end
  object IdMessage: TIdMessage
    AttachmentEncoding = 'MIME'
    BccList = <>
    CCList = <>
    Encoding = meMIME
    Recipients = <>
    ReplyTo = <>
    Left = 400
    Top = 9
  end
end
