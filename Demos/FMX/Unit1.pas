unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.Edit,
  FMX.Controls.Presentation;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  ServerController, Unit2;

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  D2BridgeServerController:= TD2BridgeServerController.Create(Application);

  Edit1.Text:= D2BridgeServerController.Prism.INIConfig.ServerPort(8888).ToString;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  D2BridgeServerController.PrimaryFormClass:= TForm2;

  D2BridgeServerController.Prism.Options.IncludeJQuery := true;

  D2BridgeServerController.Port:= StrToInt(Edit1.Text);
  D2BridgeServerController.StartServer;

  Button1.Enabled:= false;
end;

end.
