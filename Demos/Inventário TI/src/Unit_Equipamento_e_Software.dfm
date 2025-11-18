object Form_Equipamento_e_Software: TForm_Equipamento_e_Software
  Left = 0
  Top = 0
  Caption = 'Exemplo de Nested'
  ClientHeight = 660
  ClientWidth = 965
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 965
    Height = 660
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Equipamento'
      object Panel_Form_Equipamento_Busca: TPanel
        Left = 0
        Top = 0
        Width = 957
        Height = 630
        Align = alClient
        TabOrder = 0
        ExplicitLeft = -572
        ExplicitTop = -382
        ExplicitWidth = 949
        ExplicitHeight = 633
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Software'
      ImageIndex = 1
      object Panel_Form_Software_Busca: TPanel
        Left = 0
        Top = 0
        Width = 957
        Height = 630
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitLeft = 384
        ExplicitTop = 296
        ExplicitWidth = 185
        ExplicitHeight = 41
      end
    end
  end
end
