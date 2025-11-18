unit Unit_Software;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.Menus,
  Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, D2Bridge.Forms,
  Vcl.Buttons;

type
  TForm_Software = class(TD2BridgeForm)
    Label1: TLabel;
    cxButton_Salvar: TBitBtn;
    cxButton_Excluir: TBitBtn;
    cxButton_Sair: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    DBEdit_Codigo: TDBEdit;
    Panel2: TPanel;
    DBEdit_Nome: TDBEdit;
    DBComboBox_Tipo_Software: TDBComboBox;
    Panel3: TPanel;
    DBComboBox_Tipo_Licenca: TDBComboBox;
    Panel4: TPanel;
    Panel5: TPanel;
    DBEdit_Marca: TDBEdit;
    Panel8: TPanel;
    DBMemo_Observacao: TDBMemo;
    Panel9: TPanel;
    DBComboBox_Status: TDBComboBox;
    cxButton_Novo: TBitBtn;
    cxButton_Editar: TBitBtn;
    cxButton4: TBitBtn;
    Label2: TLabel;
    DBGrid1: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure cxButton_SalvarClick(Sender: TObject);
    procedure cxButton_SairClick(Sender: TObject);
    procedure cxButton_ExcluirClick(Sender: TObject);
    procedure cxButton_NovoClick(Sender: TObject);
    procedure cxButton_EditarClick(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    Procedure Abre_Software_Licenca;

  protected
    procedure ExportD2Bridge; override;

  public
    { Public declarations }
  end;

//var
//  Form_Software: TForm_Software;

Function Form_Software: TForm_Software;

implementation

Uses
 Unit_DM, Unit_Software_Licenca, D2BridgeFormTemplate;

{$R *.dfm}

Function Form_Software: TForm_Software;
begin
 Result:= TForm_Software(TForm_Software.GetInstance);
end;

procedure TForm_Software.Abre_Software_Licenca;
begin
 With DM.Software_Licenca do
 begin
  active:= false;
  sql.text:=
     'Select * from Software_Licenca                                                                          '+
     'Where Auto_Codigo_Software = '+QuotedStr(DM.Software.FieldByName('Auto_Codigo').AsString)+'             '+
     'Order by Nome, Chave                                                                                    ';
  active:= true;
 end;

end;

procedure TForm_Software.cxButton_EditarClick(Sender: TObject);
begin
 if DM.Software_Licenca.IsEmpty then
 begin
  MessageDlg('Nenhum lançamento para ser editado!', mtwarning, [mbok], 0);
  abort;
 end;

 DM.Software_Licenca.Edit;

 if Form_Software_Licenca = nil then
  TForm_Software_Licenca.CreateInstance;
 Form_Software_Licenca.Showmodal;
end;

procedure TForm_Software.cxButton4Click(Sender: TObject);
begin
 if DM.Software_Licenca.IsEmpty then
 begin
  MessageDlg('Nenhum lançamento para ser excluído!', mtwarning, [mbok], 0);
  abort;
 end;

 Form_Software_Licenca.cxButton_ExcluirClick(Sender);
end;

procedure TForm_Software.cxButton_ExcluirClick(Sender: TObject);
begin
 if not DM.Software_Licenca.IsEmpty then
 begin
  MessageDlg('Este lançamento não pode ser excluído pois existem licenças ligadas a ele!', mtwarning, [mbok], 0);
  abort;
 end;

 DM.Software.Edit;
 DM.Software.Delete;
 Self.Close;
end;

procedure TForm_Software.cxButton_NovoClick(Sender: TObject);
begin
 if DM.Software.FieldByName('Auto_Codigo').AsInteger <= 0 then
 begin
  DM.Software.Edit;
  DM.Software.Post;
  DM.Software.Edit;
 end;

 if Form_Software_Licenca = nil then
  TForm_Software_Licenca.CreateInstance;
 Form_Software_Licenca.Showmodal;
end;

procedure TForm_Software.cxButton_SairClick(Sender: TObject);
begin
 DM.Software.Edit;
 DM.Software.Cancel;
 Self.Close;
end;

procedure TForm_Software.cxButton_SalvarClick(Sender: TObject);
begin
 DM.Software.Edit;
 DM.Software.Post;
 Self.Close;
end;

procedure TForm_Software.DBGrid1DblClick(Sender: TObject);
begin
 cxButton_Editar.Click;
end;

procedure TForm_Software.ExportD2Bridge;
begin
 inherited;

 Title:= 'Software';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= 'pages\template.html';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := 'pages\itemtemplate.html';

 with D2Bridge.Items.Add do
 begin
  with Tabs do
  begin
   with AddTab(TabSheet1.Caption).Items.Add do
   begin
    with Row.Items.Add do
    begin
     with FormGroup(Panel1.Caption, CSSClass.Col.colsize3) do
     AddVCLObj(DBEdit_Codigo);

     with FormGroup(Panel2.Caption, CSSClass.Col.colsize9) do
     AddVCLObj(DBEdit_Nome);
    end;

    with row.Items.Add do
    begin
     with FormGroup(Panel3.Caption, CSSClass.Col.colsize4) do
     AddVCLObj(DBComboBox_Tipo_Software);

     with FormGroup(Panel4.Caption, CSSClass.Col.colsize4) do
     AddVCLObj(DBComboBox_Tipo_Licenca);

     with FormGroup(Panel5.Caption, CSSClass.Col.colsize4) do
     AddVCLObj(DBEdit_Marca);
    end;

    with row.Items.Add do
    with FormGroup(Panel9.Caption) do
    AddVCLObj(DBComboBox_Status);

    with row.Items.Add do
    with FormGroup(Panel8.Caption) do
    AddVCLObj(DBMemo_Observacao);


    with HTMLDIV(CSSClass.DivHtml.Align_Right).Items.Add do
    begin
     VCLObj(cxButton_Salvar, CSSClass.Button.save);
     VCLObj(cxButton_Excluir, CSSClass.Button.delete);
     VCLObj(cxButton_Sair, CSSClass.Button.close);
    end;
   end;

   with AddTab(TabSheet2.Caption).Items.Add do
   begin
    with Row.Items.Add do
    VCLObj(cxButton_Novo, CSSClass.Button.add+' '+CSSClass.Col.colsize2);

    with Row.Items.Add do
    VCLObj(DBGrid1);
   end;
  end;
 end;
end;

procedure TForm_Software.FormShow(Sender: TObject);
begin
 PageControl1.ActivePageIndex:= 0;

 Abre_Software_Licenca;
end;

end.
