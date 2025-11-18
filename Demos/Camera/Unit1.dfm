object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 493
  ClientWidth = 710
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
    Width = 218
    Height = 25
    Caption = 'Camera/Video Demo'
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
  object Button1: TButton
    Left = 104
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 185
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 283
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Take Picture'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 379
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Rec Video'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 460
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Save Video'
    TabOrder = 5
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 541
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Cancel Video'
    TabOrder = 6
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 24
    Top = 432
    Width = 75
    Height = 25
    Caption = 'Permission'
    TabOrder = 7
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 487
    Top = 390
    Width = 34
    Height = 25
    TabOrder = 8
    OnClick = Button8Click
  end
end
