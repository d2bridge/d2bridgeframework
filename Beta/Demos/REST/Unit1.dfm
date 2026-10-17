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
  TextHeight = 14
  object LabelTitle: TLabel
    Left = 16
    Top = 16
    Width = 220
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
    Width = 640
    Height = 14
    Caption = 'Open these routes with curl or Postman. The browser page is only the guide.'
  end
  object LabelLogin: TLabel
    Left = 16
    Top = 88
    Width = 680
    Height = 14
    Caption = 'POST /api/auth/login  user UserD2Bridge  password 123456  -> accessToken and refreshToken'
  end
  object LabelHealth: TLabel
    Left = 16
    Top = 116
    Width = 680
    Height = 14
    Caption = 'GET /api/health    GET /api/ping?message=hello    (no token)'
  end
  object LabelProducts: TLabel
    Left = 16
    Top = 144
    Width = 680
    Height = 14
    Caption = 'GET/POST /api/products    GET/PUT/DELETE /api/products/:id    (Bearer access token)'
  end
  object LabelDocs: TLabel
    Left = 16
    Top = 184
    Width = 680
    Height = 14
    Caption = 'Full examples: README.md (English) and README.pt-BR.md (Portuguese) in this demo folder.'
  end
end
