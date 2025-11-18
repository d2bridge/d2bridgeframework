object Form_Menu: TForm_Menu
  Left = 0
  Top = 0
  Caption = 'D2Bridge - Menu'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  Position = poScreenCenter
  TextHeight = 15
  object MainMenu1: TMainMenu
    Left = 280
    Top = 104
    object Cadastro1: TMenuItem
      Caption = 'Cadastro'
      object Cliente1: TMenuItem
        Caption = 'Cliente'
        OnClick = Cliente1Click
      end
      object Cidade1: TMenuItem
        Caption = 'Cidade'
      end
    end
    object Manuteno1: TMenuItem
      Caption = 'Manuten'#231#227'o'
      object Vendas1: TMenuItem
        Caption = 'Vendas'
      end
      object Financeiro1: TMenuItem
        Caption = 'Financeiro'
      end
      object Faturamento1: TMenuItem
        Caption = 'Faturamento'
      end
    end
  end
end
