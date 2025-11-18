object Form_Download_NFe: TForm_Download_NFe
  Left = 0
  Top = 0
  Caption = 'Form_Download_NFe'
  ClientHeight = 317
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 48
    Height = 15
    Caption = 'NF Num:'
  end
  object Label2: TLabel
    Left = 26
    Top = 88
    Width = 46
    Height = 15
    Caption = 'Emiss'#227'o:'
  end
  object Label3: TLabel
    Left = 26
    Top = 117
    Width = 40
    Height = 15
    Caption = 'Cliente:'
  end
  object Label4: TLabel
    Left = 26
    Top = 149
    Width = 63
    Height = 15
    Caption = 'Fornecedor:'
  end
  object Label5: TLabel
    Left = 26
    Top = 180
    Width = 57
    Height = 15
    Caption = 'Valor Total:'
  end
  object Label6: TLabel
    Left = 24
    Top = 56
    Width = 36
    Height = 15
    Caption = 'Chave:'
  end
  object Edit_NFe_Num: TEdit
    Left = 104
    Top = 24
    Width = 121
    Height = 23
    Enabled = False
    ReadOnly = True
    TabOrder = 0
  end
  object Edit_NFe_Emissao: TEdit
    Left = 104
    Top = 85
    Width = 121
    Height = 23
    Enabled = False
    ReadOnly = True
    TabOrder = 1
  end
  object Edit_NFe_Cliente: TEdit
    Left = 104
    Top = 114
    Width = 345
    Height = 23
    Enabled = False
    ReadOnly = True
    TabOrder = 2
  end
  object Edit_NFe_Fornecedor: TEdit
    Left = 104
    Top = 146
    Width = 345
    Height = 23
    Enabled = False
    ReadOnly = True
    TabOrder = 3
  end
  object Edit_NFe_Valor: TEdit
    Left = 104
    Top = 175
    Width = 121
    Height = 23
    Enabled = False
    ReadOnly = True
    TabOrder = 4
  end
  object Button_Download: TButton
    Left = 150
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Download'
    TabOrder = 5
    OnClick = Button_DownloadClick
  end
  object Button_Close: TButton
    Left = 256
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 6
    OnClick = Button_CloseClick
  end
  object Edit_NFe_Chave: TEdit
    Left = 104
    Top = 53
    Width = 345
    Height = 23
    Enabled = False
    ReadOnly = True
    TabOrder = 7
  end
end
