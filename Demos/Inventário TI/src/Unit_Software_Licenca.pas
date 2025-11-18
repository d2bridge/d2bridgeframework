unit Unit_Software_Licenca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.Menus, D2Bridge.Forms, Vcl.Buttons;

type
  TForm_Software_Licenca = class(TD2BridgeForm)
    Label1: TLabel;
    Panel1: TPanel;
    DBEdit_Codigo: TDBEdit;
    Panel2: TPanel;
    DBEdit_Nome: TDBEdit;
    Panel7: TPanel;
    DBEdit_Chave: TDBEdit;
    Panel9: TPanel;
    DBComboBox_Status: TDBComboBox;
    Panel8: TPanel;
    DBMemo_Observacao: TDBMemo;
    Panel4: TPanel;
    Panel5: TPanel;
    cxButton_Salvar: TBitBtn;
    cxButton_Excluir: TBitBtn;
    cxButton_Sair: TBitBtn;
    GroupBox1: TGroupBox;
    Panel3: TPanel;
    Panel6: TPanel;
    DBText1: TDBText;
    DBText2: TDBText;
    DBDateEdit_Data_Compra: TDBEdit;
    DBDateEdit_Data_Suporte: TDBEdit;
    procedure cxButton_SalvarClick(Sender: TObject);
    procedure cxButton_SairClick(Sender: TObject);
    procedure cxButton_ExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Procedure Abre_Equipamento_Relacionado;

  protected
    procedure ExportD2Bridge; override;

  public
    { Public declarations }
  end;


Function Form_Software_Licenca: TForm_Software_Licenca;

implementation

Uses
 Unit_DM;

{$R *.dfm}


Function Form_Software_Licenca: TForm_Software_Licenca;
begin
 Result:= TForm_Software_Licenca(TForm_Software_Licenca.GetInstance)
end;

procedure TForm_Software_Licenca.Abre_Equipamento_Relacionado;
begin
 With DM.Equipamento do
 begin
  active:= false;
  sql.Text:=
   'Select E.* from Equipamento E                                                                                    '+
   'Join Aux_Equipamento_Licenca AEL on AEL.Auto_Codigo_Equipamento = E.Auto_Codigo                                  '+
   'Where AEL.Auto_Codigo_Software_Licenca = '+QuotedStr(DM.Software_Licenca.FieldByName('Auto_Codigo').AsString);
  active:= true;
 end;
end;

procedure TForm_Software_Licenca.cxButton_ExcluirClick(Sender: TObject);
begin
 //
end;

procedure TForm_Software_Licenca.cxButton_SairClick(Sender: TObject);
begin
 DM.Software_Licenca.Edit;
 DM.Software_Licenca.Cancel;
 Self.Close;
end;

procedure TForm_Software_Licenca.cxButton_SalvarClick(Sender: TObject);
begin
 DM.Software_Licenca.Edit;
 DM.Software_Licenca.FieldByName('Nome').AsString:= DM.Software.FieldByName('Nome').AsString;
 DM.Software_Licenca.FieldByName('Auto_Codigo_Software').AsInteger:= DM.Software.FieldByName('Auto_Codigo').AsInteger;

 DM.Software_Licenca.Post;
 Self.Close;
end;

procedure TForm_Software_Licenca.ExportD2Bridge;
begin
  inherited;

  with D2Bridge.Items.Add do
  begin
   with row.Items.Add do
   begin
    with FormGroup(Panel1.Caption, CSSClass.Col.colsize2) do
    AddVCLObj(DBEdit_Codigo);

    with FormGroup(Panel2.Caption, CSSClass.Col.colsize10) do
    AddVCLObj(DBEdit_Nome);
   end;

   with row.Items.Add do
   begin
    with FormGroup(Panel7.Caption, CSSClass.Col.colsize5) do
    AddVCLObj(DBEdit_Chave);

    with FormGroup(Panel4.Caption, CSSClass.Col.colsize2) do
    AddVCLObj(DBDateEdit_Data_Compra);

    with FormGroup(Panel5.Caption, CSSClass.Col.colsize2) do
    AddVCLObj(DBDateEdit_Data_Suporte);

    with FormGroup(Panel9.Caption, CSSClass.Col.colsize3) do
    AddVCLObj(DBComboBox_Status);
   end;

   with row.Items.Add do
   begin
    with FormGroup('Observação', CSSClass.Col.col) do
     AddVCLObj(DBMemo_Observacao);
   end;

   with row.Items.Add do
   with Accordion.AddAccordionItem(GroupBox1.Caption).Items.Add do
   begin
    with row.Items.Add do
    with FormGroup(Panel3.Caption) do
    AddVCLObj(DBText1);

    with row.Items.Add do
    with FormGroup(Panel6.Caption) do
    AddVCLObj(DBText2);
   end;

   with HTMLDIV(CSSClass.DivHtml.Align_Right).Items.Add do
   begin
    VCLObj(cxButton_Salvar, CSSClass.Button.save);
    VCLObj(cxButton_Excluir, CSSClass.Button.delete);
    VCLObj(cxButton_Sair, CSSClass.Button.close);
   end;

  end;

end;

procedure TForm_Software_Licenca.FormShow(Sender: TObject);
begin
 Abre_Equipamento_Relacionado;
end;

end.
