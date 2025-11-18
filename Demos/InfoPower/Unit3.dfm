object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object wwButton1: TwwButton
    Left = 32
    Top = 48
    Width = 185
    Height = 49
    Caption = 'Nice, go back'
    Color = clBtnFace
    DitherColor = clWhite
    DitherStyle = wwdsDither
    ShadeStyle = wwbsNormal
    TabOrder = 0
    TextOptions.Alignment = taCenter
    TextOptions.VAlignment = vaVCenter
    OnClick = wwButton1Click
    ImageIndex = -1
  end
  object Edit1: TEdit
    Left = 344
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
end
