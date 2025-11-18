object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 595
  ClientWidth = 773
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 244
    Height = 25
    Caption = 'Kanban Board Example'
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
  object Panel1: TPanel
    Left = 32
    Top = 112
    Width = 185
    Height = 89
    TabOrder = 0
    object Label_CardStr: TLabel
      Left = 16
      Top = 40
      Width = 153
      Height = 41
      AutoSize = False
      Caption = 'This Card is item X for Column XYZ'
      WordWrap = True
    end
    object Label_Title: TLabel
      Left = 16
      Top = 8
      Width = 62
      Height = 13
      Caption = 'Label_Title'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Button_Config: TButton
      Left = 144
      Top = 9
      Width = 27
      Height = 25
      TabOrder = 0
    end
  end
  object MainMenu1: TMainMenu
    Left = 456
    Top = 32
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
