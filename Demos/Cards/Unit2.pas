unit Unit2;

{ Copyright 2024 / 2025 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  D2Bridge.Forms, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TForm2 = class(TD2BridgeForm)
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Panel_Card1: TPanel;
    Label_Card1_Text: TLabel;
    Image_Card1: TImage;
    Panel6: TPanel;
    Button_Card1: TButton;
    Panel1: TPanel;
    Label_Card2_Text: TLabel;
    Image_Card2: TImage;
    Panel2: TPanel;
    Button_Card2: TButton;
    Panel3: TPanel;
    Label_Card3_Text: TLabel;
    Image_Card3: TImage;
    Panel4: TPanel;
    Button_Card3: TButton;
    Panel5: TPanel;
    Label_Card4_Text: TLabel;
    Image_Card4: TImage;
    Panel7: TPanel;
    Button_Card4: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
    procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
    procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

function Form2:TForm2;

implementation

{$R *.dfm}

function Form2:TForm2;
begin
  result:= TForm2(TForm2.GetInstance);
end;

procedure TForm2.ExportD2Bridge;
begin
  inherited;

  Title:= 'My D2Bridge Form';

  D2Bridge.HTML.Render.BodyStyle:= 'background-color: #e3e3e7;';

  //TemplateClassForm:= TD2BridgeFormTemplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

  with D2Bridge.Items.add do
  begin
   VCLObj(Label5, CSSClass.Text.Size.fs2 + ' ' + CSSClass.Text.Style.bold);
   VCLObj(Label6, CSSClass.Text.Size.fs3);
   VCLObj(Label7, CSSClass.Text.Size.fs4);

   with CardGroup do
   begin
    {$REGION 'Card1'}
     with AddCard do
      begin
       Text:= Label_Card1_Text.Caption;

       Image(TD2BridgeCardImagePosition.D2BridgeCardImagePositionTop, Image_Card1, CSSClass.Col.colsize2);

       with Footer.Items.Add do
        VCLObj(Button_Card1);
      end;
    {$ENDREGION}

    {$REGION 'Card2'}
     with AddCard do
      begin
       Text:= Label_Card2_Text.Caption;

       Image(TD2BridgeCardImagePosition.D2BridgeCardImagePositionTop, Image_Card2, CSSClass.Col.colsize2);

       with Footer.Items.Add do
        VCLObj(Button_Card2);
      end;
    {$ENDREGION}

    {$REGION 'Card3'}
     with AddCard do
      begin
       Text:= Label_Card3_Text.Caption;

       Image(TD2BridgeCardImagePosition.D2BridgeCardImagePositionTop, Image_Card3, CSSClass.Col.colsize2);

       with Footer.Items.Add do
        VCLObj(Button_Card3);
      end;
    {$ENDREGION}

    {$REGION 'Card4'}
     with AddCard do
      begin
       Text:= Label_Card4_Text.Caption;

       Image(TD2BridgeCardImagePosition.D2BridgeCardImagePositionTop, Image_Card4, CSSClass.Col.colsize2);

       with Footer.Items.Add do
        VCLObj(Button_Card4);
      end;
    {$ENDREGION}
   end;
  end;

end;

procedure TForm2.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

 //Change Init Property of Prism Controls
 {
  if PrismControl.VCLComponent = Edit1 then
   PrismControl.AsEdit.DataType:= TPrismFieldType.PrismFieldTypeInteger;

  if PrismControl.IsDBGrid then
  begin
   PrismControl.AsDBGrid.RecordsPerPage:= 10;
   PrismControl.AsDBGrid.MaxRecords:= 2000;
  end;
 }
end;

procedure TForm2.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
begin
 inherited;

 //Intercept HTML
 {
  if PrismControl.VCLComponent = Edit1 then
  begin
   HTMLControl:= '</>';
  end;
 }
end;

end.