object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'REST Demo'
  ClientHeight = 280
  ClientWidth = 720
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 14
  object LabelTitle: TLabel
    Left = 16
    Top = 16
    Width = 205
    Height = 23
    Caption = 'D2Bridge REST Demo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LabelIntro: TLabel
    Left = 16
    Top = 56
    Width = 428
    Height = 14
    Caption = 
      'Open these routes with curl or Postman. The browser page is only' +
      ' the guide.'
  end
  object LabelLogin: TLabel
    Left = 16
    Top = 88
    Width = 524
    Height = 14
    Caption = 
      'POST /api/auth/login  user UserD2Bridge  password 123456  -> acc' +
      'essToken and refreshToken'
  end
  object LabelHealth: TLabel
    Left = 16
    Top = 116
    Width = 340
    Height = 14
    Caption = 'GET /api/health    GET /api/ping?message=hello    (no token)'
  end
  object LabelProducts: TLabel
    Left = 16
    Top = 144
    Width = 482
    Height = 14
    Caption = 
      'GET/POST /api/products    GET/PUT/DELETE /api/products/:id    (B' +
      'earer access token)'
  end
  object LabelDocs: TLabel
    Left = 16
    Top = 184
    Width = 513
    Height = 14
    Caption = 
      'Full examples: README.md (English) and README.pt-BR.md (Portugue' +
      'se) in this demo folder.'
  end
  object ButtonHorse: TButton
    Left = 16
    Top = 224
    Width = 280
    Height = 32
    Caption = 'Endpoint data'
    TabOrder = 0
    OnClick = ButtonHorseClick
  end
end
