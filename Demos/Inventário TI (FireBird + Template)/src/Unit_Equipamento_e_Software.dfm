object Form_Equipamento_e_Software: TForm_Equipamento_e_Software
  Left = 0
  Top = 0
  Caption = 'Exemplo de Nested'
  ClientHeight = 672
  ClientWidth = 969
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 969
    Height = 672
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Equipamento'
      ExplicitLeft = 2
      ExplicitTop = 22
      ExplicitWidth = 965
      ExplicitHeight = 648
      object Panel_Form_Equipamento_Busca: TPanel
        Left = 0
        Top = 0
        Width = 961
        Height = 642
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 965
        ExplicitHeight = 649
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Software'
      ImageIndex = 1
      ExplicitLeft = 2
      ExplicitTop = 22
      ExplicitWidth = 965
      ExplicitHeight = 648
      object Panel_Form_Software_Busca: TPanel
        Left = 0
        Top = 0
        Width = 957
        Height = 630
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
  end
end
