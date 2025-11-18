unit Unit_Equipamento_e_Software;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, D2Bridge.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TForm_Equipamento_e_Software = class(TD2BridgeForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel_Form_Equipamento_Busca: TPanel;
    Panel_Form_Software_Busca: TPanel;
    procedure FormCreate(Sender: TObject);
  private

  protected
   procedure ExportD2Bridge; override;

  public

  end;

Function Form_Equipamento_e_Software: TForm_Equipamento_e_Software;

implementation

{$R *.dfm}

Uses
 Unit_Equipamento_Busca, Unit_Software_Busca;


function Form_Equipamento_e_Software: TForm_Equipamento_e_Software;
begin
 Result:= TForm_Equipamento_e_Software(TForm_Equipamento_e_Software.GetInstance);
end;


{ TForm_Equipamento_e_Software }

procedure TForm_Equipamento_e_Software.ExportD2Bridge;
begin
 inherited;

 if Form_Equipamento_Busca = nil then
 TForm_Equipamento_Busca.CreateInstance;
 D2Bridge.AddNested(Form_Equipamento_Busca);

 if Form_Software_Busca = nil then
 TForm_Software_Busca.CreateInstance;
 D2Bridge.AddNested(Form_Software_Busca);


 with D2Bridge.Items.Add do
 begin
  with Row.Items.Add do
   with PanelGroup('Form Busca de Equipamento').Items.Add do
    Nested(Form_Equipamento_Busca.Name);

  with Row.Items.Add do
   with PanelGroup('Form Busca de Software').Items.Add do
    Nested(Form_Software_Busca.Name);
 end;
end;

procedure TForm_Equipamento_e_Software.FormCreate(Sender: TObject);
begin
 {$IFDEF D2BRIDGE}

 {$ELSE}
 if Form_Equipamento_Busca = nil then
 TForm_Equipamento_Busca.CreateInstance;

 Form_Equipamento_Busca.Parent:= Panel_Form_Equipamento_Busca;
 Form_Equipamento_Busca.Align:= alClient;
 Form_Equipamento_Busca.BorderStyle:= bsNone;
 Form_Equipamento_Busca.show;



 if Form_Software_Busca = nil then
 TForm_Software_Busca.CreateInstance;

 Form_Software_Busca.Parent:= Panel_Form_Software_Busca;
 Form_Software_Busca.Align:= alClient;
 Form_Software_Busca.BorderStyle:= bsNone;
 Form_Software_Busca.show;
 {$ENDIF}
end;

end.
