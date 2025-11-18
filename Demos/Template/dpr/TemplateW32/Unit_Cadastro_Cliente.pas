unit Unit_Cadastro_Cliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, D2Bridge.Forms;

type
  TForm_Cadastro_Cliente = class(TD2BridgeForm)
    Label1: TLabel;
    Panel1: TPanel;
    Edit_Nome: TEdit;
    Panel2: TPanel;
    Edit_Telefone: TEdit;
    Button_Salvar: TButton;
    procedure Button_SalvarClick(Sender: TObject);
  private

  protected
    procedure ExportD2Bridge; override;
  public

  end;


Function Form_Cadastro_Cliente: TForm_Cadastro_Cliente;

implementation

Uses
 D2BridgeFormTemplate;

{$R *.dfm}

Function Form_Cadastro_Cliente: TForm_Cadastro_Cliente;
begin
 Result:= TForm_Cadastro_Cliente(TForm_Cadastro_Cliente.GetInstance);
end;


procedure TForm_Cadastro_Cliente.Button_SalvarClick(Sender: TObject);
begin
 self.Close;
end;

procedure TForm_Cadastro_Cliente.ExportD2Bridge;
begin
 inherited;

 //Acopla o Template a este Form
 TemplateClassForm:= TD2BridgeFormTemplate;

 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile := 'template.html';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := 'itemtemplate.html';

 Title:= 'Cadastro de Cliente';

 with D2Bridge.Items.Add do
 begin
  with Row.Items.Add do
  FormGroup(Panel1.Caption, CSSClass.Col.colsize12).AddVCLObj(Edit_Nome);

  with Row.Items.Add do
  FormGroup(Panel2.Caption).AddVCLObj(Edit_Telefone);

  with Row.Items.Add do
  FormGroup.AddVCLObj(Button_Salvar);

 end;
end;

end.
