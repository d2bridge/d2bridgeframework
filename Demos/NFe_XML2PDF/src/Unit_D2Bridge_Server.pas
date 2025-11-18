unit Unit_D2Bridge_Server;

interface

uses
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TForm_D2Bridge_Sever = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Edit_Port: TEdit;
    Label_Versao: TLabel;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_D2Bridge_Sever: TForm_D2Bridge_Sever;

implementation

Uses
 {$IFDEF MSWINDOWS}
  WinApi.Windows, Winapi.ShellApi,
 {$ENDIF}
 ServerController,
 Unit_Principal;

{$R *.dfm}



procedure TForm_D2Bridge_Sever.Button1Click(Sender: TObject);
begin
 D2BridgeServerController.PrimaryFormClass:= TForm_Principal;

 D2BridgeServerController.Prism.Options.IncludeJQuery:= true;

 D2BridgeServerController.Port:= StrToInt(Edit_Port.Text);

 D2BridgeServerController.StartServer;
end;

procedure TForm_D2Bridge_Sever.Button2Click(Sender: TObject);
begin
 D2BridgeServerController.StopServer;
end;

procedure TForm_D2Bridge_Sever.FormCreate(Sender: TObject);
begin
 D2BridgeServerController:= TD2BridgeServerController.Create(Application);

 Label_Versao.Caption:= 'Version: '+D2BridgeServerController.D2BridgeManager.Version;
end;

end.
