object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 461
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 237
    Height = 25
    Caption = 'Autentication Example'
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
  object Label_Name: TLabel
    Left = 148
    Top = 158
    Width = 56
    Height = 13
    Caption = 'User Name:'
  end
  object Label_Email: TLabel
    Left = 148
    Top = 177
    Width = 28
    Height = 13
    Caption = 'Email:'
  end
  object Label_ID: TLabel
    Left = 148
    Top = 139
    Width = 40
    Height = 13
    Caption = 'User ID:'
  end
  object Label_IDValue: TLabel
    Left = 221
    Top = 139
    Width = 24
    Height = 13
    Caption = '0001'
  end
  object Image_Photo: TImage
    Left = 8
    Top = 116
    Width = 105
    Height = 105
  end
  object Label_NameValue: TLabel
    Left = 221
    Top = 158
    Width = 84
    Height = 13
    Caption = 'Label_NameValue'
  end
  object Label_EmailValue: TLabel
    Left = 221
    Top = 177
    Width = 81
    Height = 13
    Caption = 'Label_EmailValue'
  end
  object Label_Mode: TLabel
    Left = 148
    Top = 120
    Width = 58
    Height = 13
    Caption = 'Login Mode:'
  end
  object Label_ModeValue: TLabel
    Left = 212
    Top = 120
    Width = 34
    Height = 13
    Caption = 'Manual'
  end
  object Button_Logout: TButton
    Left = 148
    Top = 196
    Width = 104
    Height = 25
    Caption = 'Logout'
    TabOrder = 0
    OnClick = Button_LogoutClick
  end
  object MainMenu1: TMainMenu
    Left = 376
    Top = 24
    object Module11: TMenuItem
      Caption = 'Main'
      OnClick = Module11Click
    end
    object AppModule21: TMenuItem
      Caption = 'App Module 2'
    end
    object CoreModules1: TMenuItem
      Caption = 'Core Modules'
      object CoreModule11: TMenuItem
        Caption = 'Core Module 1'
      end
      object CoreModule21: TMenuItem
        Caption = 'Core Module 2'
      end
    end
    object Modules1: TMenuItem
      Caption = 'Modules'
      object Module12: TMenuItem
        Caption = 'Module 1'
      end
      object Module21: TMenuItem
        Caption = 'Module 2'
      end
      object SubModules1: TMenuItem
        Caption = 'Sub Modules'
        object SubModule11: TMenuItem
          Caption = 'SubModule 1'
        end
        object SubModule21: TMenuItem
          Caption = 'SubModule 2'
        end
        object SubModule31: TMenuItem
          Caption = 'SubModule 3'
        end
      end
    end
  end
end
