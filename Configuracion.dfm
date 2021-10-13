object MConfiguracion: TMConfiguracion
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Mantenimiento de Configuracion'
  ClientHeight = 129
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 304
    Height = 129
    Align = alClient
    TabOrder = 0
    object chkEjecutarInicio: TcxCheckBox
      Left = 29
      Top = 33
      Caption = '  Ejecutar Al Iniciar Windows'
      Properties.Alignment = taLeftJustify
      TabOrder = 0
      Width = 164
    end
    object btnAceptar: TcxButton
      Left = 176
      Top = 82
      Width = 109
      Height = 31
      Hint = 'Aceptar'
      Caption = 'Aceptar y Salir'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = False
      OnClick = btnAceptarClick
      LookAndFeel.Kind = lfFlat
      LookAndFeel.NativeStyle = False
      OptionsImage.ImageIndex = 10
    end
  end
end
