unit Unit_Login;

{ Copyright 2023 / 2024 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  D2Bridge.Forms, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm_Login = class(TD2BridgeForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Edit_Login: TEdit;
    Edit_Password: TEdit;
    Button_Logar: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button_LogarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure ExportD2Bridge; override;
  end;

function Form_Login:TForm_Login;

implementation

Uses
 Unit_DM, Unit_DashBoard;

{$R *.dfm}

function Form_Login:TForm_Login;
begin
  result:= TForm_Login(TForm_Login.GetInstance);
end;

procedure TForm_Login.Button2Click(Sender: TObject);
begin
 Halt(0);
end;

procedure TForm_Login.Button_LogarClick(Sender: TObject);
begin
 if Edit_Login.text = '' then
 begin
  showmessage('Enter with yout Login');
  abort;
 end;

 if Edit_Password.text = '' then
 begin
  showmessage('Password is Blank');
  abort;
 end;


 with DM.Login do
 begin
  active:=  false;
  sql.clear;
  sql.add('Select * from Login');
  sql.add('Where username = '+QuotedStr(Edit_Login.Text)+' and password = '+QuotedStr(Edit_Password.Text));
  active:= true;
 end;

 if DM.Login.IsEmpty then
 begin
  messagedlg('User not found or password incorrect', mterror, [mbok], 0);
 end else
 begin
  {$IFDEF D2BRIDGE}
  if Form_DashBoard =  nil then
   TForm_DashBoard.CreateInstance;
  Form_DashBoard.Show;
  {$ELSE}
  self.close;
  {$ENDIF}
 end;
end;

procedure TForm_Login.ExportD2Bridge;
begin
  inherited;

  Title:= 'D2Bridge Framework Application';

  //GetTemplateClassForm:= TD2BridgeFormTamplate;
  D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
  D2Bridge.FrameworkExportType.TemplatePageHTMLFile := 'pages\login.html';

  with D2Bridge.Items.add do
  begin
   VCLObj(Edit_Login);
   VCLObj(Edit_Password);
   VCLObj(Button_Logar);
  end;

end;

procedure TForm_Login.FormShow(Sender: TObject);
begin
 if IsDebuggerPresent then
 begin
  Edit_Login.Text:= 'admin';
  Edit_Password.Text:= 'admin';
 end;
end;

end.