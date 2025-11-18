unit Unit_Equipamento_Licenca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.ExtCtrls,
  Vcl.Menus, D2Bridge.Forms,
  Vcl.Buttons;

type
  TForm_Equipamento_Licenca = class(TD2BridgeForm)
    Label1: TLabel;
    Panel1: TPanel;
    DBLookupComboBox_Licenca: TDBLookupComboBox;
    cxButton_Salvar: TBitBtn;
    cxButton_Excluir: TBitBtn;
    cxButton_Sair: TBitBtn;
    procedure cxButton_ExcluirClick(Sender: TObject);
    procedure cxButton_SairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cxButton_SalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Procedure Abre_Software_Licenca;

  protected
    procedure ExportD2Bridge; override;

  public
    Auto_Codigo_Software_Licenca_Selecionado: Integer;
  end;

//var
//  Form_Equipamento_Licenca: TForm_Equipamento_Licenca;

 function Form_Equipamento_Licenca: TForm_Equipamento_Licenca;

implementation

Uses
 Unit_DM, Unit_Equipamento;

{$R *.dfm}

function Form_Equipamento_Licenca: TForm_Equipamento_Licenca;
begin
 Result:= TForm_Equipamento_Licenca(TForm_Equipamento_Licenca.GetInstance);
end;

procedure TForm_Equipamento_Licenca.Abre_Software_Licenca;
begin
 With DM.Software_Licenca do
 begin
  active:= false;
  sql.Text:=
    'Select * from Software_Licenca                                                       '+
    'Where Auto_Codigo                                                                    '+
    '			not in (Select Auto_Codigo_Software_Licenca from AUX_EQUIPAMENTO_LICENCA)         '+
    '		or Auto_Codigo = '+QuotedStr(IntToStr(Auto_Codigo_Software_Licenca_Selecionado))+' '+
    'Order by Nome, Chave                                                                 ';
  active:= true;
 end;
end;

procedure TForm_Equipamento_Licenca.cxButton_ExcluirClick(Sender: TObject);
begin
 if messagedlg('Deseja realmente apagar este lançamento?', mtconfirmation, [mbyes,mbno], 0) = mryes then
 begin
  DM.Aux_Equipamento_Licenca.Edit;
  DM.Aux_Equipamento_Licenca.Delete;

  Self.Close;
 end;
end;

procedure TForm_Equipamento_Licenca.cxButton_SairClick(Sender: TObject);
begin
 DM.Aux_Equipamento_Licenca.Edit;
 DM.Aux_Equipamento_Licenca.Cancel;
 Self.Close;
end;

procedure TForm_Equipamento_Licenca.cxButton_SalvarClick(Sender: TObject);
begin
 DM.Aux_Equipamento_Licenca.Edit;
 DM.Aux_Equipamento_Licenca.FieldByName('Auto_Codigo_Equipamento').AsInteger:= DM.Equipamento.FieldByName('Auto_Codigo').AsInteger;
 DM.Aux_Equipamento_Licenca.FieldByName('Auto_Codigo_Software').AsInteger:= DM.Software_Licenca.FieldByName('Auto_Codigo_Software').AsInteger;

 DM.Aux_Equipamento_Licenca.Post;
 Self.Close;
end;

procedure TForm_Equipamento_Licenca.ExportD2Bridge;
begin
 inherited;

 with D2Bridge.Items.add do
 begin
  with row.Items.Add do
  with FormGroup(Panel1.Caption, CSSClass.Col.colsize12) do
  AddVCLObj(DBLookupComboBox_Licenca);

  with HTMLDIV(CSSClass.DivHtml.Align_Right).Items.Add do
  begin
   VCLObj(cxButton_Salvar, CSSClass.Button.save);
   VCLObj(cxButton_Excluir, CSSClass.Button.delete);
   VCLObj(cxButton_Sair, CSSClass.Button.close);
  end;

 end;
end;

procedure TForm_Equipamento_Licenca.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Form_Equipamento.Abre_Aux_Equipamento_Licenca;
end;

procedure TForm_Equipamento_Licenca.FormShow(Sender: TObject);
begin
 Auto_Codigo_Software_Licenca_Selecionado:= DM.Aux_Equipamento_Licenca.FieldByName('Auto_Codigo_Software_Licenca').AsInteger;

 Abre_Software_Licenca;
end;

end.
