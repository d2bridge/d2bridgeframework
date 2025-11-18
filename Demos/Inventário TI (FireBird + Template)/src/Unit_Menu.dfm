object Form_Menu: TForm_Menu
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Invent'#225'rio TI'
  ClientHeight = 1012
  ClientWidth = 722
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -24
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 192
  TextHeight = 32
  object Label1: TLabel
    Left = 48
    Top = 192
    Width = 613
    Height = 130
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Alignment = taCenter
    Caption = 'Controle de Equipamentos e Licen'#231'as'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -48
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 48
    Top = 20
    Width = 620
    Height = 114
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Caption = 'INVENT'#193'RIO TI'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -86
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object cxButton1: TBitBtn
    Left = 224
    Top = 422
    Width = 290
    Height = 130
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Caption = 'Equipamentos'
    TabOrder = 0
    OnClick = cxButton1Click
  end
  object cxButton2: TBitBtn
    Left = 224
    Top = 614
    Width = 290
    Height = 130
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Caption = 'Softwares'
    TabOrder = 1
    OnClick = cxButton2Click
  end
  object cxButton3: TBitBtn
    Left = 224
    Top = 806
    Width = 290
    Height = 130
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    Caption = 'Equip e Software'
    TabOrder = 2
    OnClick = cxButton3Click
  end
end
