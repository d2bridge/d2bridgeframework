unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, D2Bridge.Forms;

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit_Test: TEdit;
    Label_Translated_by_Class: TLabel;
    Label_Translated_by_Form: TLabel;
  private

  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
   procedure BeginTranslate(const Language: TD2BridgeLang); override;
   procedure TagTranslate(const Language: TD2BridgeLang; const AContext: string; const ATerm: string; var ATranslated: string); override;
  end;

Function Form1: TForm1;

implementation

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.BeginTranslate(const Language: TD2BridgeLang);
begin
 inherited;

 //Example using translante Typed and JSON
 Edit_Test.Text:= D2Bridge.LangAPP.Context1.Test;
end;

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
  VCLObj(Label1, CSSClass.Text.Size.fs2 + ' ' + CSSClass.Text.Style.bold);
  VCLObj(Label2, CSSClass.Text.Size.fs3);
  VCLObj(Label3, CSSClass.Text.Size.fs4);
  VCLObj(Label_Translated_by_Class, CSSClass.Text.Size.fs4);
  VCLObj(Label_Translated_by_Form, CSSClass.Text.Size.fs4);
  VCLObj(Edit_Test);
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

procedure TForm1.TagTranslate(const Language: TD2BridgeLang; const AContext,
  ATerm: string; var ATranslated: string);
begin
 inherited;

 //Example using translante in FORM
 if AContext = '' then
 begin
   if ATerm = 'Phrase2' then
   begin
     case Language of
       TD2BridgeLang.Portuguese: ATranslated := 'Leve a sua aplicação para Web com Delphi';
       TD2BridgeLang.English: ATranslated := 'Take your application to the Web with Delphi';
       TD2BridgeLang.Spanish: ATranslated := 'Lleva tu aplicación a la Web con Delphi';
       TD2BridgeLang.Arabic: ATranslated := 'قم بتحويل تطبيقك إلى الويب باستخدام Delphi';
       TD2BridgeLang.Italian: ATranslated := 'Porta la tua applicazione sul Web con Delphi';
       TD2BridgeLang.French: ATranslated := 'Amenez votre application sur le Web avec Delphi';
       TD2BridgeLang.German: ATranslated := 'Bringen Sie Ihre Anwendung mit Delphi ins Web';
       TD2BridgeLang.Japanese: ATranslated := 'DelphiでアプリケーションをWebに持っていく';
       TD2BridgeLang.Russian: ATranslated := 'Переведите ваше приложение в Интернет с помощью Delphi';
       TD2BridgeLang.Chinese: ATranslated := '使用Delphi将您的应用程序推向Web';
     end;
   end;
 end;
end;

end.
