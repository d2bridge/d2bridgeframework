object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 401
  ClientWidth = 807
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
    Width = 99
    Height = 13
    Caption = 'HTML Element DEMO'
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
  object LabelHTMLElement2: TLabel
    Left = 24
    Top = 119
    Width = 669
    Height = 39
    Caption = 
      '<div class="progress mt2">'#13#10'  <div class="progress-bar" role="pr' +
      'ogressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0' +
      '" aria-valuemax="100">0%</div>'#13#10'</div>'
  end
  object LabelHTMLElement_WithCallBack: TLabel
    Left = 30
    Top = 183
    Width = 769
    Height = 13
    Caption = 
      '<input type="range" class="form-range" min="0" max="10" step="1"' +
      ' value="0" id="customRangeCallBack" onclick="{{CallBack=GetValue' +
      'Test([this.value])}}">'
  end
  object Label_ResultCallBack: TLabel
    Left = 24
    Top = 202
    Width = 137
    Height = 19
    Caption = 'Result CallBack = 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Memo_ListGroup: TMemo
    Left = 24
    Top = 278
    Width = 273
    Height = 121
    Lines.Strings = (
      '<ul class="list-group">'
      '  <li class="list-group-item">An item</li>'
      '  <li class="list-group-item">A second item</li>'
      '  <li class="list-group-item">A third item</li>'
      '  <li class="list-group-item">A fourth item</li>'
      '  <li class="list-group-item">And a fifth one</li>'
      '</ul>')
    TabOrder = 0
  end
  object Button_Step: TButton
    Left = 24
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Step +'
    TabOrder = 1
    OnClick = Button_StepClick
  end
end
