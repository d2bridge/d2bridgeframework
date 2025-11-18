unit Unit_Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, D2Bridge.Forms,
  Vcl.ExtCtrls, Vcl.Buttons;

type
  TForm_Menu = class(TD2BridgeForm)
    cxButton1: TBitBtn;
    cxButton2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    cxButton3: TBitBtn;
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FLogado: Boolean;
  protected
   procedure ExportD2Bridge; override;
  public
    { Public declarations }
  end;


{$IFDEF D2BRIDGE}
 function Form_Menu: TForm_Menu;
{$ELSE}
 var
   Form_Menu: TForm_Menu;
{$ENDIF}


implementation

{$R *.dfm}

uses Unit_Equipamento, Unit_Software, Unit_Equipamento_Busca,
  Unit_Software_Busca, Unit_DM, Unit_Equipamento_e_Software, Unit_Login;


{$IFDEF D2BRIDGE}
 function Form_Menu: TForm_Menu;
 begin
  result:= TForm_Menu(TForm_Menu.GetInstance);
 end;
{$ELSE}

{$ENDIF}


procedure TForm_Menu.cxButton1Click(Sender: TObject);
begin
 if Form_Equipamento_Busca = nil then
 TForm_Equipamento_Busca.CreateInstance;
 //Form_Equipamento_Busca:= TForm_Equipamento_Busca.Create(Application);
 Form_Equipamento_Busca.Showmodal;
 //messagedlg('teste', mtwarning, [mbyes,mbno], 0);
end;

procedure TForm_Menu.cxButton2Click(Sender: TObject);
begin
 if Form_Software_Busca = nil then
 TForm_Software_Busca.CreateInstance;
 Form_Software_Busca.Showmodal;
end;

procedure TForm_Menu.cxButton3Click(Sender: TObject);
begin
 if Form_Equipamento_e_Software = nil then
  TForm_Equipamento_e_Software.CreateInstance;
 Form_Equipamento_e_Software.Show;
end;

procedure TForm_Menu.ExportD2Bridge;
begin
 inherited;

 with D2Bridge.Items.Add do
 begin
  VCLObj(cxButton1);
  VCLObj(cxButton2);
  VCLObj(cxButton3);
 end;
end;



procedure TForm_Menu.FormActivate(Sender: TObject);
begin
 if not FLogado then
 begin
  if Form_Login = nil then
   TForm_Login.CreateInstance;

  Form_Login.Showmodal;
 end;
end;

procedure TForm_Menu.FormCreate(Sender: TObject);
begin
 FLogado:= false;

 if DM = nil then
  CreateInstance(TDM);
end;

end.
