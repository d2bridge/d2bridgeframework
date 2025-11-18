unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, D2Bridge.Forms,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel_Card1: TPanel;
    Label_Card1_Text: TLabel;
    Label_Card1_Title: TLabel;
    Panel4: TPanel;
    Label_Card3_Text: TLabel;
    Panel6: TPanel;
    Button_Card3: TButton;
    Image_Card3: TImage;
    Panel_Card2: TPanel;
    Label_Card2_Text: TLabel;
    Label_Card2_Title: TLabel;
    Label_Card2_SubTitle: TLabel;
    Panel7: TPanel;
    Label_Card2_Header: TLabel;
    Edit_Card2: TEdit;
    Panel8: TPanel;
    Button_Card2: TButton;
    Panel_Card4: TPanel;
    Image_Card4: TImage;
    Label_Card4_Text: TLabel;
    Panel_Card5: TPanel;
    Image_Card5: TImage;
    Label_Card5_Text: TLabel;
    Button_Example2: TButton;
    Button_Example3: TButton;
    Button_Example4: TButton;
    procedure Button_Card1Click(Sender: TObject);
    procedure Button_Example2Click(Sender: TObject);
    procedure Button_Example3Click(Sender: TObject);
    procedure Button_Example4Click(Sender: TObject);
  private

  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

Function Form1: TForm1;

implementation

uses Unit2, Unit3, Unit4;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.Button_Card1Click(Sender: TObject);
begin
 Showmessage(Edit_Card2.Text);
end;

procedure TForm1.Button_Example2Click(Sender: TObject);
begin
 if Form2 = nil then
  TForm2.CreateInstance;
 Form2.Show;
end;

procedure TForm1.Button_Example3Click(Sender: TObject);
begin
 if Form3 = nil then
  TForm3.CreateInstance;
 Form3.Show;

end;

procedure TForm1.Button_Example4Click(Sender: TObject);
begin
 if Form4 = nil then
  TForm4.CreateInstance;
 Form4.Show;
end;

procedure TForm1.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Application';


 D2Bridge.HTML.Render.BodyStyle:= 'background-color: #e3e3e7;';

 //TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
  VCLObj(Label1, CSSClass.Text.Size.fs2 + ' ' + CSSClass.Text.Style.bold);
  VCLObj(Label2, CSSClass.Text.Size.fs3);
  VCLObj(Label3, CSSClass.Text.Size.fs4);

  with Row.Items.Add do
  with HTMLDIV.Items.Add do
  begin
   VCLObj(Button_Example2);
   VCLObj(Button_Example3);
   VCLObj(Button_Example4);
  end;

  with Row.Items.Add do
  begin
   Card(Label_Card1_Title.Caption, CSSClass.Col.colsize2, Label_Card1_Text.Caption);

   {$REGION 'Card2'}
    with Card do
     begin
      ColSize:= CSSClass.Col.colsize2;

      Header.Text:= Label_Card2_Header.Caption;

      Title:= Label_Card2_Title.Caption;
      Text:= Label_Card2_Text.Caption;
      SubTitle:= Label_Card2_SubTitle.Caption;

      with Items.Add do
      begin
       VCLObj(Edit_Card2);
      end;

      with Footer.Items.Add do
       VCLObj(Button_Card2);
     end;
   {$ENDREGION}

   {$REGION 'Card3'}
    with Card do
     begin
      ColSize:= CSSClass.Col.colsize2;

      Text:= Label_Card3_Text.Caption;

      Image.Image.Picture:= Image_Card3.Picture;
     end;
   {$ENDREGION}

   {$REGION 'Card4'}
    with Card do
     begin
      ColSize:= CSSClass.Col.colsize2;

      Text:= Label_Card4_Text.Caption;

      Image(TD2BridgeCardImagePosition.D2BridgeCardImagePositionBottom, Image_Card4);
     end;
   {$ENDREGION}

   {$REGION 'Card5'}
    with Card do
     begin
      ColSize:= CSSClass.Col.colsize4;

      Text:= Label_Card5_Text.Caption;

      Image(TD2BridgeCardImagePosition.D2BridgeCardImagePositionLeft, Image_Card5);
     end;
   {$ENDREGION}

  end;
 end;
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TForm1.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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
