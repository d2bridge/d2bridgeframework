unit Unit_Equipamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls,
  Vcl.Mask, Vcl.ExtCtrls,
  Vcl.Menus, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Data.Win.ADODB, D2Bridge.Forms, Vcl.Buttons;



type
  TForm_Equipamento = class(TD2BridgeForm)
    Label1: TLabel;
    Panel1: TPanel;
    DBEdit_Codigo: TDBEdit;
    Panel2: TPanel;
    DBEdit_Nome: TDBEdit;
    Panel3: TPanel;
    DBComboBox_Tipo_Aquisicao: TDBComboBox;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    DBComboBox_Setor: TDBComboBox;
    Panel7: TPanel;
    DBEdit_Marca: TDBEdit;
    Panel8: TPanel;
    Panel9: TPanel;
    cxButton_Salvar: TBitBtn;
    cxButton_Excluir: TBitBtn;
    cxButton_Sair: TBitBtn;
    GroupBox1: TGroupBox;
    cxButton_Editar: TBitBtn;
    cxButton4: TBitBtn;
    cxButton_Novo: TBitBtn;
    DBGrid1: TDBGrid;
    Aux_Equipamento_Licenca: TADOQuery;
    DSAux_Equipamento_Licenca: TDataSource;
    DBMemo_Observacao: TDBMemo;
    DBCheckBox_Status: TDBCheckBox;
    DBEdit_Data_Compra: TDBEdit;
    DBEdit_Data_Garantia: TDBEdit;
    procedure cxButton_SalvarClick(Sender: TObject);
    procedure cxButton_SairClick(Sender: TObject);
    procedure cxButton_ExcluirClick(Sender: TObject);
    procedure cxButton_NovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxButton_EditarClick(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBCheckBox_StatusClick(Sender: TObject);
  private
    function EventOnShowPopup(APopupName: String): string;
    function EventOnClosePopup(APopupName: String): string;
  protected
   procedure ExportD2Bridge; override;


  public
    Procedure Abre_Aux_Equipamento_Licenca;
  end;

//var
//  Form_Equipamento: TForm_Equipamento;

Function Form_Equipamento: TForm_Equipamento;

implementation

Uses
 Unit_DM, Unit_Equipamento_Licenca;

{$R *.dfm}


Function Form_Equipamento: TForm_Equipamento;
begin
 result:= TForm_Equipamento(TForm_Equipamento.GetInstance);
end;


procedure TForm_Equipamento.Abre_Aux_Equipamento_Licenca;
begin
 With Aux_Equipamento_Licenca do
 begin
  active:= false;
  Parameters.ParamByName('Auto_Codigo_Equipamento').Value:= DM.Equipamento.FieldByName('Auto_Codigo').Asinteger;
  active:= true;
 end;

end;

procedure TForm_Equipamento.cxButton_EditarClick(Sender: TObject);
begin
 With DM.Aux_Equipamento_Licenca do
 begin
  active:= false;
  sql.text:=
     'Select * from Aux_Equipamento_Licenca AEL                                                         '+
     'Where Auto_Codigo = '+QuotedStr(Aux_Equipamento_Licenca.FieldByName('Auto_Codigo').AsString)+'    ';
  active:= true;
 end;

 if DM.Aux_Equipamento_Licenca.IsEmpty then
 begin
  MessageDlg('Nenhum lançamento para ser editado!', mtwarning, [mbok], 0);
  abort;
 end;

 DM.Aux_Equipamento_Licenca.Edit;

 if Form_Equipamento_Licenca = nil then
  TForm_Equipamento_Licenca.CreateInstance;

 if IsD2BridgeContext then
  ShowPopup('Popup'+Form_Equipamento_Licenca.Name)
 else
  Form_Equipamento_Licenca.Showmodal;
end;

procedure TForm_Equipamento.cxButton4Click(Sender: TObject);
begin
 With DM.Aux_Equipamento_Licenca do
 begin
  active:= false;
  sql.text:=
     'Select * from Aux_Equipamento_Licenca AEL                                                         '+
     'Where Auto_Codigo = '+QuotedStr(Aux_Equipamento_Licenca.FieldByName('Auto_Codigo').AsString)+'    ';
  active:= true;
 end;

 if DM.Aux_Equipamento_Licenca.IsEmpty then
 begin
  MessageDlg('Nenhum lançamento para ser excluído!', mtwarning, [mbok], 0);
  abort;
 end;

 if Form_Equipamento_Licenca = nil then
 TForm_Equipamento_Licenca.CreateInstance;
 Form_Equipamento_Licenca.cxButton_ExcluirClick(Sender);
end;

procedure TForm_Equipamento.cxButton_ExcluirClick(Sender: TObject);
begin
 if not DM.Aux_Equipamento_Licenca.IsEmpty then
 begin
  MessageDlg('Este lançamento não pode ser excluído pois existem licenças ligadas a ele!', mtwarning, [mbok], 0);
  abort;
 end;

 if messagedlg('Deseja Realmente excluir este lançcamento?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
 begin
  DM.Equipamento.Edit;
  DM.Equipamento.Delete;
  Self.Close;
 end;
end;

procedure TForm_Equipamento.cxButton_NovoClick(Sender: TObject);
begin
 With DM.Aux_Equipamento_Licenca do
 begin
  active:= false;
  sql.text:=
     'Select * from Aux_Equipamento_Licenca AEL            '+
     'Where Auto_Codigo < 0                                ';
  active:= true;
 end;


 if DM.Equipamento.FieldByName('Auto_Codigo').AsInteger <= 0 then
 begin
  DM.Equipamento.Edit;
  DM.Equipamento.Post;
  DM.Equipamento.Edit;
 end;


 if not DM.Aux_Equipamento_Licenca.IsEmpty then
 DM.Aux_Equipamento_Licenca.Insert;

 DM.Aux_Equipamento_Licenca.Edit;

 if Form_Equipamento_Licenca = nil then
  TForm_Equipamento_Licenca.CreateInstance;

 {$IFDEF D2BRIDGE}
 ShowPopup('Popup'+Form_Equipamento_Licenca.Name);
 {$ELSE}
 Form_Equipamento_Licenca.Showmodal;
 {$ENDIF}
end;

procedure TForm_Equipamento.cxButton_SairClick(Sender: TObject);
begin
 DM.Equipamento.Edit;
 DM.Equipamento.Cancel;
 Self.Close;
end;

procedure TForm_Equipamento.cxButton_SalvarClick(Sender: TObject);
begin
 DM.Equipamento.Edit;
 DM.Equipamento.Post;
 Self.Close;
end;

procedure TForm_Equipamento.DBCheckBox_StatusClick(Sender: TObject);
begin
 DBCheckBox_Status.Caption:= DM.Equipamento.FieldByName('Status').AsString;
end;

procedure TForm_Equipamento.DBGrid1DblClick(Sender: TObject);
begin
 cxButton_Editar.Click;
end;

function TForm_Equipamento.EventOnClosePopup(APopupName: String): string;
begin

end;

function TForm_Equipamento.EventOnShowPopup(APopupName: String): string;
begin

end;

procedure TForm_Equipamento.ExportD2Bridge;
begin
 inherited;

 OnShowPopup:= EventOnShowPopup;
 OnClosePopup:= EventOnClosePopup;

 if Form_Equipamento_Licenca = nil then
  TForm_Equipamento_Licenca.CreateInstance;

 D2Bridge.AddNested(Form_Equipamento_Licenca);

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
   with FormGroup(Panel7.Caption, CSSClass.Col.colsize2) do
   AddVCLObj(DBEdit_Marca);

   with FormGroup(Panel3.Caption, CSSClass.Col.colsize4) do
   AddVCLObj(DBComboBox_Tipo_Aquisicao);

   with FormGroup(Panel4.Caption, CSSClass.Col.colsize3) do
   AddVCLObj(DBEdit_Data_Compra);

   with FormGroup(Panel5.Caption, CSSClass.Col.colsize3) do
   AddVCLObj(DBEdit_Data_Garantia);
  end;

  with row.Items.Add do
  with FormGroup(Panel6.Caption, CSSClass.Col.colsize8) do
  AddVCLObj(DBComboBox_Setor);

  with row.Items.Add do
  With FormGroup(Panel9.Caption, CSSClass.Col.colsize6) do
  AddVCLObj(DBCheckBox_Status);

  with row.Items.Add do
  With FormGroup(Panel8.Caption, CSSClass.Col.col) do
  AddVCLObj(DBMemo_Observacao);

  with row.Items.Add do
  with PanelGroup(GroupBox1.Caption).Items.Add do
  begin
   with row.Items.Add do
   with HTMLDIV.Items.Add do
    VCLObj(cxButton_Novo, CSSClass.Button.add);

   with row.Items.Add do
   VCLObj(DBGrid1);
  end;

  //Add Form_Equipamento_Licenca do Popup with Nested
  Popup('Popup'+Form_Equipamento_Licenca.Name, 'Licença').Items.Add.Nested(Form_Equipamento_Licenca.Name);

  with HTMLDIV(CSSClass.DivHtml.Align_Right).Items.Add do
  begin
   VCLObj(cxButton_Salvar, CSSClass.Button.save);
   VCLObj(cxButton_Excluir, CSSClass.Button.delete);
   VCLObj(cxButton_Sair, CSSClass.Button.close);
  end;
 end;
end;

procedure TForm_Equipamento.FormShow(Sender: TObject);
begin
 Abre_Aux_Equipamento_Licenca;
end;


end.
