unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, D2Bridge.Forms;

type
  TForm1 = class(TD2BridgeForm)
    LabelTitle: TLabel;
    LabelIntro: TLabel;
    LabelLogin: TLabel;
    LabelHealth: TLabel;
    LabelProducts: TLabel;
    LabelDocs: TLabel;
  private
  public
  protected
    procedure ExportD2Bridge; override;
  end;

function Form1: TForm1;

implementation

uses
  ServerController;

function Form1: TForm1;
begin
  Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

procedure TForm1.ExportD2Bridge;
begin
  inherited;
  Title:= 'D2Bridge REST Demo';
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

  with D2Bridge.Items.Add do
  begin
    VCLObj(LabelTitle);
    VCLObj(LabelIntro);
    VCLObj(LabelLogin);
    VCLObj(LabelHealth);
    VCLObj(LabelProducts);
    VCLObj(LabelDocs);
  end;
end;

end.
