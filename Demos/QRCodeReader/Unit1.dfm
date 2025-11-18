object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 592
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 263
    Height = 25
    Caption = 'QRCode/BarCode Reader'
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
  object Image1: TImage
    Left = 176
    Top = 96
    Width = 305
    Height = 281
  end
  object ComboBox1: TComboBox
    Left = 176
    Top = 392
    Width = 305
    Height = 21
    TabOrder = 0
    Text = 'ComboBox1'
  end
  object Button8: TButton
    Left = 487
    Top = 390
    Width = 34
    Height = 25
    TabOrder = 1
    OnClick = Button8Click
  end
  object Button7: TButton
    Left = 210
    Top = 419
    Width = 75
    Height = 25
    Caption = 'Permission'
    TabOrder = 2
    OnClick = Button7Click
  end
  object Button1: TButton
    Left = 291
    Top = 419
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 371
    Top = 419
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 80
    Top = 456
    Width = 545
    Height = 121
    ReadOnly = True
    TabOrder = 5
    OnChange = Memo1Change
  end
end
