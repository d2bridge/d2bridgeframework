unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, D2Bridge.Forms, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids;

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBGrid1: TDBGrid;
    procedure FormCreate(Sender: TObject);
  private
    FStaticImages: TStrings;
    procedure RemoveImage(Sender: TObject);
  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
   procedure Upload(AFiles: TStrings; Sender: TObject); override;
  end;

Function Form1: TForm1;

implementation

Uses
   ServerController, Unit_DM, D2Bridge.Instance;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Application';

 //TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
  VCLObj(Label1, CSSClass.Text.Size.fs3);
  VCLObj(Label2, CSSClass.Text.Size.fs4);
  VCLObj(Label3, CSSClass.Text.Size.fs5);

  with Row.Items.Add do
  begin
   //Static Images Carousel
   with HTMLDIV(CSSClass.Col.colsize3).Items.Add do
    with Card('Static Images').Items.Add do
     Carousel(FStaticImages);

   //DataWare Images Carousel
   with HTMLDIV(CSSClass.Col.colsize9).Items.Add do
   begin
    with Card('Images from DataBase').Items.Add do
    begin
     with Row.Items.Add do
     begin
      with HTMLDIV(CSSClass.Col.colsize3).Items.Add do
       Carousel(DM.DSImages, 'Path');

      with HTMLDIV(CSSClass.Col.colsize9).Items.Add do
      with Row.Items.Add do
      begin
       with HTMLDIV.Items.Add do
        Upload('Insert new Image', 'jpg,jpeg,png', '', 0, 0, false);

       VCLObj(DBGrid1);
      end;
     end;
    end;
   end;
  end;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 FStaticImages:= TStringList.Create;

 FStaticImages.Add('images\Image1.jpg');
 FStaticImages.Add('images\Image2.jpg');
 FStaticImages.Add('images\Image3.jpg');
 FStaticImages.Add('images\Image4.jpg');
 FStaticImages.Add('images\Image5.jpg');
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

 if PrismControl.IsDBGrid then
 with PrismControl.AsDBGrid do
 begin
  with Columns.Add do
  begin
   ColumnIndex:= 0;
   Width:= 30;
   Title:= D2Bridge.Lang.Button.CaptionOptions;

   with Buttons.Add do
   begin
    ButtonModel:= TButtonModel.Delete;
    Caption:= '';
    OnClick:= RemoveImage;
   end;
  end;
 end;

end;

procedure TForm1.RemoveImage(Sender: TObject);
begin
 DM.CDSImages.Delete;
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

procedure TForm1.Upload(AFiles: TStrings; Sender: TObject);
var
 I: integer;
begin
 for I := 0 to Pred(AFiles.Count) do
  DM.CDSImages.AppendRecord([ExtractFileName(AFiles[I]), AFiles[I]]);
end;

end.
