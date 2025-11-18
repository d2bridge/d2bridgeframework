unit Unit_Menu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus;

type
  TForm_Menu = class(TForm)
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Cliente1: TMenuItem;
    Manuteno1: TMenuItem;
    Vendas1: TMenuItem;
    Financeiro1: TMenuItem;
    Cidade1: TMenuItem;
    Faturamento1: TMenuItem;
    procedure Cliente1Click(Sender: TObject);
  private

  public
   //destructor Destroy; override;
    { Public declarations }
  end;

Function Form_Menu: TForm_Menu;

implementation

Uses
 Unit_Cadastro_Cliente,
 D2Bridge.Instance;

{$R *.dfm}

Function Form_Menu: TForm_Menu;
begin
 Result:= TForm_Menu(D2BridgeInstance.GetInstance(TForm_Menu));
end;

procedure TForm_Menu.Cliente1Click(Sender: TObject);
begin
 if Form_Cadastro_Cliente = nil then
  TForm_Cadastro_Cliente.CreateInstance;
 Form_Cadastro_Cliente.ShowModal;
end;

//destructor TForm_Menu.Destroy;
//begin
// inherited;
//end;

end.
