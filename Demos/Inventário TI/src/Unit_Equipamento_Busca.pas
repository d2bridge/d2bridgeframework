unit Unit_Equipamento_Busca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, D2Bridge.Forms, Vcl.Buttons;

type
  TForm_Equipamento_Busca = class(TD2BridgeForm)
    Panel1: TPanel;
    Edit_Buscar: TEdit;
    cxButton_Buscar: TBitBtn;
    cxButton_Opcoes: TBitBtn;
    cxButton_Novo: TBitBtn;
    cxButton3: TBitBtn;
    cxButton4: TBitBtn;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    PopupMenu_Opcoes: TPopupMenu;
    MensagemOk1: TMenuItem;
    Mensagem21: TMenuItem;
    cxButton_Sair: TBitBtn;
    procedure cxButton_NovoClick(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure cxButton_BuscarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure MensagemOk1Click(Sender: TObject);
    procedure Mensagem21Click(Sender: TObject);
    procedure cxButton_OpcoesClick(Sender: TObject);
    procedure cxButton_SairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Procedure Abre_Equipamento;

   protected
    procedure ExportD2Bridge; override;

  public
    { Public declarations }
  end;

//var
//  Form_Equipamento_Busca: TForm_Equipamento_Busca;


Function Form_Equipamento_Busca: TForm_Equipamento_Busca;


implementation

Uses
 Unit_DM, Unit_Equipamento;

{$R *.dfm}

{ TForm_Equipamento_Busca }


Function Form_Equipamento_Busca: TForm_Equipamento_Busca;
begin
 result:= TForm_Equipamento_Busca(TForm_Equipamento_Busca.GetInstance);
end;

procedure TForm_Equipamento_Busca.Abre_Equipamento;
begin
 With DM.Equipamento do
 begin
  active:= false;
  sql.text:=
     'Select * from Equipamento                                                  '+
     'Where nome like '+QuotedStr('%'+ Edit_Buscar.Text +'%')+'                  '+
     'Order by Nome                                                              ';
  active:= true;
 end;
end;

procedure TForm_Equipamento_Busca.cxButton3Click(Sender: TObject);
begin
 if DM.Equipamento.IsEmpty then
 begin
  MessageDlg('Nenhum lançamento para ser editado!', mtwarning, [mbok], 0);
  abort;
 end;

 if Form_Equipamento = nil then
  TForm_Equipamento.CreateInstance;
 Form_Equipamento.Showmodal;

 Abre_Equipamento;
end;

procedure TForm_Equipamento_Busca.cxButton4Click(Sender: TObject);
begin
 if DM.Software.IsEmpty then
 begin
  MessageDlg('Nenhum lançamento para ser excluído!', mtwarning, [mbok], 0);
  abort;
 end;

 if Form_Equipamento = nil then
  TForm_Equipamento.CreateInstance;
 Form_Equipamento.cxButton_ExcluirClick(Sender);
end;

procedure TForm_Equipamento_Busca.cxButton_BuscarClick(Sender: TObject);
begin
 Abre_Equipamento;
end;

procedure TForm_Equipamento_Busca.cxButton_NovoClick(Sender: TObject);
begin
 if not DM.Equipamento.IsEmpty then
 DM.Equipamento.Insert;

 DM.Equipamento.Edit;

 if Form_Equipamento = nil then
  TForm_Equipamento.CreateInstance;
 Form_Equipamento.Showmodal;
end;

procedure TForm_Equipamento_Busca.cxButton_OpcoesClick(Sender: TObject);
begin
 if not IsD2BridgeContext then
 with cxButton_Opcoes.ClientToScreen(point(0, 1 + cxButton_Opcoes.Height)) do
  PopupMenu_Opcoes.Popup(x, Y)
end;

procedure TForm_Equipamento_Busca.cxButton_SairClick(Sender: TObject);
begin
 self.Close;
end;

procedure TForm_Equipamento_Busca.DBGrid1DblClick(Sender: TObject);
begin
 cxButton3.Click;
end;

procedure TForm_Equipamento_Busca.ExportD2Bridge;
begin
 inherited;

 //D2Bridge.BaseClass.FrameworkExportType.TemplateMasterHTMLFile:= 'index.html';

 with D2Bridge.Items.Add do
 begin
  with row.Items.Add do
  begin
   with FormGroup(Panel1.Caption) do
   AddVCLObj(Edit_Buscar);

   with FormGroup do
   AddVCLObj(cxButton_Buscar, CSSClass.Button.search);

   with FormGroup do
   AddVCLObj(cxButton_Opcoes, PopupMenu_Opcoes, CSSClass.Button.options);

   with FormGroup do
   AddVCLObj(cxButton_Novo, CSSClass.Button.add);

   with FormGroup do
   AddVCLObj(cxButton3, CSSClass.Button.view);

   with FormGroup do
   AddVCLObj(cxButton_Sair, CSSClass.Button.close);

  end;

  with row.Items.Add do
  VCLObj(DBGrid1);
 end;
end;

procedure TForm_Equipamento_Busca.FormCreate(Sender: TObject);
begin
 Abre_Equipamento;
end;

procedure TForm_Equipamento_Busca.Mensagem21Click(Sender: TObject);
begin
 messagedlg('Mensagem 2', mtwarning, [mbCancel], 0);
end;

procedure TForm_Equipamento_Busca.MensagemOk1Click(Sender: TObject);
begin
 messagedlg('Mensagem 1', mtinformation, [mbok], 0);
end;

end.
