unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

Uses
 ServerController,
 Unit1;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
 D2BridgeServerController.PrimaryFormClass:= TForm1;

 D2BridgeServerController.Prism.Options.IncludeJQuery := true;

 D2BridgeServerController.Port:= StrToInt(Edit1.Text);
 D2BridgeServerController.StartServer;

 Button1.Enabled:= false;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
 D2BridgeServerController:= TD2BridgeServerController.Create(Application);

 Edit1.Text:= D2BridgeServerController.Prism.INIConfig.ServerPort(8888).ToString;
end;

end.
