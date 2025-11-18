unit Unit_DashBoard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, D2Bridge.Forms, Vcl.StdCtrls;

type
  TForm_Dashboard = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
  private

  public

  protected
   procedure ExportD2Bridge; override;
  end;

Function Form_Dashboard: TForm_Dashboard;

implementation

Uses
 D2BridgeFormTemplate;

Function Form_Dashboard: TForm_Dashboard;
begin
 Result:= TForm_Dashboard(TForm_Dashboard.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm_Dashboard.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Application';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= 'pages\template.html';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := 'pages\dashboard.html';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
  VCLObj(Label1, CSSClass.Text.Size.fs2 + ' ' + CSSClass.Text.Style.bold);
  VCLObj(Label2, CSSClass.Text.Size.fs3);
  VCLObj(Label3, CSSClass.Text.Size.fs4);
 end;
end;

end.
