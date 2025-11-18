unit Unit_Download_NFE;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellAPI, D2Bridge.Forms;

type
  TForm_Download_NFe = class(TD2BridgeForm)
    Label1: TLabel;
    Edit_NFe_Num: TEdit;
    Label2: TLabel;
    Edit_NFe_Emissao: TEdit;
    Label3: TLabel;
    Edit_NFe_Cliente: TEdit;
    Label4: TLabel;
    Edit_NFe_Fornecedor: TEdit;
    Label5: TLabel;
    Edit_NFe_Valor: TEdit;
    Button_Download: TButton;
    Button_Close: TButton;
    Label6: TLabel;
    Edit_NFe_Chave: TEdit;
    procedure Button_CloseClick(Sender: TObject);
    procedure Button_DownloadClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure ExportD2Bridge; override;
  public
    { Public declarations }
  end;


Function Form_Download_NFe: TForm_Download_NFe;

implementation

{$R *.dfm}

uses Unit_Principal;

Function Form_Download_NFe: TForm_Download_NFe;
begin
 Result:= TForm_Download_NFe(TForm_Download_NFe.GetInstance);
end;

procedure TForm_Download_NFe.Button_DownloadClick(Sender: TObject);
var
 PathNFeDownload: String;
begin
 Form_Principal.ACBrNFe1.NotasFiscais.Items[0].ImprimirPDF;

 PathNFeDownload:= 'pdf\'+Edit_NFe_Chave.Text+'-nfe.pdf';

 if IsD2BridgeContext then
  D2Bridge.PrismSession.SendFile(PathNFeDownload)
 else
  ShellExecute(0, 'open', PChar(PathNFeDownload), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm_Download_NFe.Button_CloseClick(Sender: TObject);
begin
 self.Close;
end;

procedure TForm_Download_NFe.ExportD2Bridge;
begin
 inherited;

 with D2Bridge.Items.Add do
 begin
  with Row.Items.Add do
  FormGroup('NFe Num:', CSSClass.Col.colsize4).AddVCLObj(Edit_NFe_Num);

  with Row.Items.Add do
  FormGroup('Chave:', CSSClass.Col.colsize12).AddVCLObj(Edit_NFe_Chave);

  with Row.Items.Add do
  FormGroup('Emissão:', CSSClass.Col.colsize4).AddVCLObj(Edit_NFe_Emissao);

  with Row.Items.Add do
  FormGroup('Cliente:', CSSClass.Col.colsize12).AddVCLObj(Edit_NFe_Cliente);

  with Row.Items.Add do
  FormGroup('Fornecedor:', CSSClass.Col.colsize12).AddVCLObj(Edit_NFe_Fornecedor);

  with Row.Items.Add do
  FormGroup('Valor:', CSSClass.Col.colsize4).AddVCLObj(Edit_NFe_Valor);

  with Row.Items.Add do
   with HTMLDIV(CSSClass.DivHtml.Align_Center).Items.Add do
   begin
    VCLObj(Button_Download, CSSClass.Button.download);
    VCLObj(Button_Close, CSSClass.Button.close);
   end;
 end;
end;

end.
