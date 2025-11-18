unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

Uses
 Unit_Menu,
 ServerController;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
 D2BridgeServerController.PrimaryFormClass:= TForm_Menu;

 D2BridgeServerController.Prism.Options.IncludeJQuery:= true;

 D2BridgeServerController.Port:= StrToInt(Edit1.Text);
 D2BridgeServerController.StartServer;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
 D2BridgeServerController:= TD2BridgeServerController.Create(Application);
end;

end.
