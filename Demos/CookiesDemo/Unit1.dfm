object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 82
    Height = 25
    Caption = 'Cookies'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 39
    Width = 294
    Height = 18
    Caption = 'This app is created with D2Bridge Framework'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 65
    Width = 115
    Height = 13
    Caption = 'by Talis Jonatas  Gomes'
  end
  object Label4: TLabel
    Left = 8
    Top = 111
    Width = 66
    Height = 13
    Caption = 'Cookie Name:'
  end
  object Label5: TLabel
    Left = 8
    Top = 138
    Width = 65
    Height = 13
    Caption = 'Cookie Value:'
  end
  object Button1: TButton
    Left = 207
    Top = 133
    Width = 122
    Height = 25
    Caption = 'Set new value'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 162
    Width = 97
    Height = 25
    Caption = 'Get Value'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 111
    Top = 162
    Width = 97
    Height = 25
    Caption = 'Exclude Cookie'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 80
    Top = 108
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'D2Bridge Cookie Test'
  end
  object Edit2: TEdit
    Left = 80
    Top = 135
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object Button4: TButton
    Left = 207
    Top = 106
    Width = 122
    Height = 25
    Caption = 'Create Default Value'
    TabOrder = 5
    OnClick = Button4Click
  end
end
