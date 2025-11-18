unit Unit_Dashboard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, D2Bridge.Forms;

type
  TForm_Dashboard = class(TD2BridgeForm)
  private
    procedure TagHTML(const TagString: string; var ReplaceTag: string);
  protected
    procedure ExportD2Bridge; override;
  public
    destructor Destroy; override;

  end;


Function Form_Dashboard: TForm_Dashboard;

implementation

uses
 D2BridgeFormTemplate;

{$R *.dfm}

Function Form_Dashboard: TForm_Dashboard;
begin
 result:= TForm_Dashboard(TForm_Dashboard.GetInstance);
end;

{ TForm_Dashboard }

destructor TForm_Dashboard.Destroy;
begin
  inherited;
end;

procedure TForm_Dashboard.ExportD2Bridge;
begin
 inherited;

 OnTagHTML:= TagHTML;

 //Acopla o Template a este Form
 TemplateClassForm:= TD2BridgeFormTemplate;

 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := 'template.html';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := 'dashboard.html';

 Title:= 'Dashboard';
end;

procedure TForm_Dashboard.TagHTML(const TagString: string;
  var ReplaceTag: string);
begin
 if TagString = 'QTYSALES' then
  ReplaceTag:= '145';

 if TagString = 'PERCENTSALES' then
  ReplaceTag:= '12%';
end;

end.
