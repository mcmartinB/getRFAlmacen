object FAlmacenes: TFAlmacenes
  Left = 735
  Top = 118
  Caption = '    RF ALMACENES'
  ClientHeight = 588
  ClientWidth = 444
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblMsg: TLabel
    Left = 16
    Top = 185
    Width = 330
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Barra de estado'
  end
  object btnRF: TButton
    Left = 17
    Top = 19
    Width = 160
    Height = 25
    Caption = 'Traer RF Almacenes'
    TabOrder = 0
    OnClick = btnRFClick
  end
  object chkChanita: TCheckBox
    Left = 16
    Top = 50
    Width = 201
    Height = 17
    TabStop = False
    Caption = 'Chanita (F17 y 050 Centro 4)'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object chkP4H: TCheckBox
    Left = 16
    Top = 73
    Width = 201
    Height = 17
    TabStop = False
    Caption = 'P4H (F18 y 050 Centro 3)'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object chkTenerife: TCheckBox
    Left = 16
    Top = 96
    Width = 201
    Height = 17
    TabStop = False
    Caption = 'Tenerife (F23)'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object chkLlanos: TCheckBox
    Left = 16
    Top = 118
    Width = 201
    Height = 17
    TabStop = False
    Caption = 'Llanos (050 Centro 1)'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object btnClose: TButton
    Left = 263
    Top = 19
    Width = 160
    Height = 25
    Caption = 'Cerrar Aplicaci'#243'n'
    TabOrder = 1
    OnClick = btnCloseClick
  end
  object pbBar: TProgressBar
    Left = 16
    Top = 168
    Width = 330
    Height = 16
    TabOrder = 9
  end
  object chkConsumidos: TCheckBox
    Left = 263
    Top = 50
    Width = 154
    Height = 17
    TabStop = False
    Caption = 'Consumidos/Proveedor'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object chkConfeccionados: TCheckBox
    Left = 263
    Top = 72
    Width = 97
    Height = 17
    TabStop = False
    Caption = 'Confeccionados'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object mmoMsg: TMemo
    Left = 0
    Top = 196
    Width = 444
    Height = 392
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'mmoMsg')
    ParentFont = False
    TabOrder = 10
    ExplicitWidth = 356
  end
  object btnIniciarResidente: TButton
    Left = 263
    Top = 134
    Width = 160
    Height = 25
    Caption = 'Iniciar Residente'
    TabOrder = 7
    OnClick = btnIniciarResidenteClick
  end
  object chkSevilla: TCheckBox
    Left = 16
    Top = 142
    Width = 201
    Height = 17
    TabStop = False
    Caption = 'F24 Sevilla'
    TabOrder = 11
  end
  object IdSMTP: TIdSMTP
    Host = 'smtp.exchange2007.es'
    Password = 'Bonnysa9359'
    SASLMechanisms = <>
    Username = 'USRAD00087416'
    Left = 248
    Top = 105
  end
  object IdMessage: TIdMessage
    AttachmentEncoding = 'MIME'
    BccList = <>
    CCList = <>
    Encoding = meMIME
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 280
    Top = 105
  end
  object mm1: TMainMenu
    Left = 344
    Top = 104
    object mnuConfiguracion: TMenuItem
      Caption = 'Configuraci'#243'n'
      Enabled = False
      Visible = False
      OnClick = mnuConfiguracionClick
    end
  end
end
