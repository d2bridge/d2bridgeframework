object Form_Menu: TForm_Menu
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Invent'#225'rio TI'
  ClientHeight = 507
  ClientWidth = 365
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 96
    Width = 312
    Height = 64
    Alignment = taCenter
    Caption = 'Controle de Equipamentos e Licen'#231'as'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 24
    Top = 10
    Width = 312
    Height = 59
    Caption = 'INVENT'#193'RIO TI'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -43
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cxButton1: TBitBtn
    Left = 112
    Top = 211
    Width = 145
    Height = 65
    Caption = 'Equipamentos'
    TabOrder = 0
    OnClick = cxButton1Click
  end
  object cxButton2: TBitBtn
    Left = 112
    Top = 307
    Width = 145
    Height = 65
    Caption = 'Softwares'
    TabOrder = 1
    OnClick = cxButton2Click
  end
  object cxButton3: TBitBtn
    Left = 112
    Top = 403
    Width = 145
    Height = 65
    Caption = 'Equip e Software'
    TabOrder = 2
    OnClick = cxButton3Click
  end
end
