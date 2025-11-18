object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 357
  ClientWidth = 786
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 76
    Height = 13
    Caption = 'Demo Validation'
  end
  object Label2: TLabel
    Left = 24
    Top = 35
    Width = 215
    Height = 13
    Caption = 'This app is created with D2Bridge Framework'
  end
  object Label3: TLabel
    Left = 24
    Top = 54
    Width = 115
    Height = 13
    Caption = 'by Talis Jonatas  Gomes'
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 89
    Width = 215
    Height = 224
    Caption = 'Requerido 1'
    TabOrder = 0
    object Label4: TLabel
      Left = 16
      Top = 24
      Width = 55
      Height = 13
      Caption = 'First Name:'
    end
    object Label5: TLabel
      Left = 16
      Top = 56
      Width = 54
      Height = 13
      Caption = 'Last Name:'
    end
    object Edit_FirstName: TEdit
      Left = 77
      Top = 21
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Edit_LastName: TEdit
      Left = 77
      Top = 52
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object Button_CheckName: TButton
      Left = 64
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Check Name'
      TabOrder = 2
      OnClick = Button_CheckNameClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 272
    Top = 89
    Width = 215
    Height = 224
    Caption = 'Requerido 2'
    TabOrder = 1
    object Label6: TLabel
      Left = 16
      Top = 24
      Width = 52
      Height = 13
      Caption = 'Car brand:'
    end
    object Label7: TLabel
      Left = 17
      Top = 55
      Width = 32
      Height = 13
      Caption = 'Model:'
    end
    object Edit_CarBrand: TEdit
      Left = 77
      Top = 21
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Edit_CarModel: TEdit
      Left = 77
      Top = 52
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object Button_CheckCar: TButton
      Left = 64
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Check Car'
      TabOrder = 2
      OnClick = Button_CheckCarClick
    end
  end
  object GroupBox3: TGroupBox
    Left = 512
    Top = 89
    Width = 215
    Height = 224
    Caption = 'Server Validation'
    TabOrder = 2
    object Label8: TLabel
      Left = 16
      Top = 24
      Width = 63
      Height = 13
      Caption = 'Number < 10'
    end
    object Label9: TLabel
      Left = 17
      Top = 55
      Width = 63
      Height = 13
      Caption = 'Number > 10'
    end
    object Edit_NumberMinor: TEdit
      Left = 88
      Top = 21
      Width = 110
      Height = 21
      NumbersOnly = True
      TabOrder = 0
    end
    object Edit_NumberBigger: TEdit
      Left = 88
      Top = 52
      Width = 110
      Height = 21
      NumbersOnly = True
      TabOrder = 1
    end
    object Button_CheckNumber: TButton
      Left = 64
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Check Number'
      TabOrder = 2
      OnClick = Button_CheckNumberClick
    end
  end
end
