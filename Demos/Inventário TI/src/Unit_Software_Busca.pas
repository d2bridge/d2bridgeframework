unit Unit_Software_Busca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, D2Bridge.Forms, Vcl.Buttons;

type
  TForm_Software_Busca = class(TD2BridgeForm)
    Panel1: TPanel;
    Edit_Buscar: TEdit;
    cxButton_Buscar: TBitBtn;
    cxButton_Opcoes: TBitBtn;
    cxButton_Novo: TBitBtn;
    cxButton_Editar: TBitBtn;
    cxButton4: TBitBtn;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    procedure cxButton_NovoClick(Sender: TObject);
    procedure cxButton_EditarClick(Sender: TObject);
    procedure cxButton4Click(Sender: TObject);
    procedure cxButton_BuscarClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Abre_Software;

  protected
    procedure ExportD2Bridge; override;

  public
    { Public declarations }
  end;

//var
//  Form_Software_Busca: TForm_Software_Busca;


Function Form_Software_Busca: TForm_Software_Busca;


implementation

{$R *.dfm}

uses Unit_DM, Unit_Software;

Function Form_Software_Busca: TForm_Software_Busca;
begin
 Result:= TForm_Software_Busca(TForm_Software_Busca.GetInstance);
end;


procedure TForm_Software_Busca.Abre_Software;
begin
 With DM.Software do
 begin
  active:= false;
  sql.text:=
     'Select * from Software                                                     '+
     'Where nome like '+QuotedStr('%'+ Edit_Buscar.Text +'%')+'                  '+
     'Order by Nome                                                              ';
  active:= true;
 end;

end;

procedure TForm_Software_Busca.cxButton_EditarClick(Sender: TObject);
begin
 if DM.Software.IsEmpty then
 begin
  MessageDlg('Nenhum lançamento para ser editado!', mtwarning, [mbok], 0);
  abort;
 end;

 DM.Software.Edit;

 if Form_Software = nil then
  TForm_Software.CreateInstance;
 Form_Software.Showmodal;
end;

procedure TForm_Software_Busca.cxButton4Click(Sender: TObject);
begin
 if DM.Software.IsEmpty then
 begin
  MessageDlg('Nenhum lançamento para ser excluído!', mtwarning, [mbok], 0);
  abort;
 end;

 if Form_Software = nil then
  TForm_Software.CreateInstance;
 Form_Software.cxButton_ExcluirClick(Sender);
end;

procedure TForm_Software_Busca.cxButton_BuscarClick(Sender: TObject);
begin
 Abre_Software;
end;

procedure TForm_Software_Busca.cxButton_NovoClick(Sender: TObject);
begin
 if not DM.Software.IsEmpty then
 DM.Software.Insert;

 DM.Software.Edit;

 if Form_Software = nil then
    TForm_Software.CreateInstance;
 Form_Software.Showmodal;
end;

procedure TForm_Software_Busca.DBGrid1DblClick(Sender: TObject);
begin
 cxButton_Editar.Click;
end;

procedure TForm_Software_Busca.ExportD2Bridge;
begin
  inherited;

  with D2Bridge.Items.Add do
  begin
   with row.Items.Add do
   begin
    with FormGroup(Panel1.Caption) do
    AddVCLObj(Edit_Buscar);

    with FormGroup do
    AddVCLObj(cxButton_Buscar, CSSClass.Button.search);

    with FormGroup do
    AddVCLObj(cxButton_Novo, CSSClass.Button.add);
   end;

   with row.Items.Add do
   VCLObj(DBGrid1);
  end;
end;

procedure TForm_Software_Busca.FormShow(Sender: TObject);
begin
 Abre_Software;
end;

end.
