unit Unit_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ACBrBase, ACBrDFe, ACBrNFe,
  ACBrDFeReport, ACBrDFeDANFeReport, ACBrNFeDANFEClass, ACBrNFeDANFeRLClass, D2Bridge.Forms;

type
  TForm_Principal = class(TD2BridgeForm)
    ACBrNFe1: TACBrNFe;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    ACBrNFeDANFeRL1: TACBrNFeDANFeRL;
    procedure Button1Click(Sender: TObject);
  private
    procedure ProcessXML(AXMLFile: String);
    procedure Upload(AFiles: TStrings; Sender: TObject);
  protected
    procedure ExportD2Bridge; override;
   public
    { Public declarations }
  end;

Function Form_Principal: TForm_Principal;

implementation

{$R *.dfm}

uses Unit_Download_NFE;

Function Form_Principal: TForm_Principal;
begin
 result:= TForm_Principal(TForm_Principal.GetInstance);
end;

procedure TForm_Principal.Button1Click(Sender: TObject);
begin
 if OpenDialog1.Execute then
 begin
  ProcessXML(OpenDialog1.FileName);
 end;
end;

procedure TForm_Principal.ExportD2Bridge;
begin
 inherited;

 OnUpload:= Upload;

 if Form_Download_NFe = nil then
 TForm_Download_NFe.CreateInstance;
 D2Bridge.AddNested(Form_Download_NFe);

 with D2Bridge.Items.Add do
 begin
  with row.Items.Add do
   Upload;

  with Popup('PopupDownloadNFe', 'NFe').Items.Add do
   Nested(Form_Download_NFe.Name);
 end;
end;

procedure TForm_Principal.ProcessXML(AXMLFile: String);
begin
 if Form_Download_NFe = nil then
  TForm_Download_NFe.CreateInstance;

 ACBrNFe1.NotasFiscais.Clear;
 ACBrNFe1.NotasFiscais.LoadFromFile(AXMLFile);

 Form_Download_NFe.Edit_NFe_Num.Text:= IntToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.nNF);
 Form_Download_NFe.Edit_NFe_Chave.Text:= ACBrNFe1.NotasFiscais.Items[0].NFe.procNFe.chNFe;
 Form_Download_NFe.Edit_NFe_Emissao.Text:= DateToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Ide.dEmi);
 Form_Download_NFe.Edit_NFe_Fornecedor.Text:= ACBrNFe1.NotasFiscais.Items[0].NFe.Emit.xNome;
 Form_Download_NFe.Edit_NFe_Cliente.Text:= ACBrNFe1.NotasFiscais.Items[0].NFe.Dest.xNome;
 Form_Download_NFe.Edit_NFe_Valor.Text:= FloatToStr(ACBrNFe1.NotasFiscais.Items[0].NFe.Total.ICMSTot.vNF);

 if IsD2BridgeContext then
  ShowPopup('PopupDownloadNFe')
 else
  Form_Download_NFe.ShowModal;
end;

procedure TForm_Principal.Upload(AFiles: TStrings; Sender: TObject);
begin
 ProcessXML(AFiles[0]);
end;

end.
