unit D2BridgeFormTemplate;

interface

Uses
 System.Classes,
 D2Bridge.Prism.Form,
 Unit_Menu;


type
 TD2BridgeFormTemplate = class(TD2BridgePrismForm)
  private
   procedure ProcessHTML(Sender: TObject; var AHTMLText: string);
   procedure ProcessTagHTML(const TagString: string; var ReplaceTag: string);
   function AbreDashboard(EventParams: TStrings): String;
   function AbreMenu(EventParams: TStrings): String;
   function Logout(EventParams: TStrings): String;
   function MontaMenu: String;
  public
   constructor Create(AOwner: TComponent; D2BridgePrismFramework: TObject); override;
   destructor Destroy; override;
 end;


implementation

uses
 Unit_Dashboard, D2Bridge.Instance, ServerController,
 Unit_Cadastro_Cliente, System.SysUtils, Vcl.Menus, Vcl.Forms;


{ TD2BridgeFormTemplate }

function TD2BridgeFormTemplate.AbreDashboard(EventParams: TStrings): String;
begin
 if Form_Dashboard = nil then
  TForm_Dashboard.CreateInstance;
 Form_Dashboard.Show;
end;

function TD2BridgeFormTemplate.AbreMenu(EventParams: TStrings): String;
begin
 if EventParams.Strings[0] = 'Cliente' then
 begin
  if Form_Cadastro_Cliente = nil then
  TForm_Cadastro_Cliente.CreateInstance;
  Form_Cadastro_Cliente.Show;
 end;

end;

constructor TD2BridgeFormTemplate.Create(AOwner: TComponent;
  D2BridgePrismFramework: TObject);
begin
 inherited;

 //Events
 OnProcessHTML:= ProcessHTML;
 OnTagHTML:= ProcessTagHTML;

 //Declarando CallBack Modo 1
 CallBacks.Register('AbreDashboard', AbreDashboard);
 CallBacks.Register('AbreMenu', AbreMenu);
 CallBacks.Register('Logout', Logout);

 //Declarando CallBack Modo 2 - (Modo 1 Menu Estático)
 CallBacks.Register('AbreMenuCliente',
   function(EventParams: TStrings): string
   begin
    if Form_Cadastro_Cliente = nil then
     TForm_Cadastro_Cliente.CreateInstance;
    Form_Cadastro_Cliente.Show;
   end);
end;

destructor TD2BridgeFormTemplate.Destroy;
begin
 inherited;
end;

function TD2BridgeFormTemplate.Logout(EventParams: TStrings): String;
begin
 Session.Close;
end;

function TD2BridgeFormTemplate.MontaMenu: String;
var
 I, J: Integer;
 vCallBackName: string;
 vMenuItem: TMenuItem;
begin
 Result:= '';

 vCallBackName:= 'CallBackEventAutoMenu';
 CallBacks.Register(vCallBackName,
   function(EventParams: TStrings): String
   var x,y: Integer;
   begin
    for X := 0 to Form_Menu.MainMenu1.Items.Count-1 do
    for Y := 0 to Form_Menu.MainMenu1.Items[X].Count-1 do
    if Form_Menu.MainMenu1.Items[X].Items[Y].Name = EventParams.Strings[0] then
    if (Form_Menu.MainMenu1.Items[X].Items[Y].Visible) and (Form_Menu.MainMenu1.Items[X].Items[Y].Enabled) then
    begin
     Form_Menu.MainMenu1.Items[X].Items[Y].Click;
     Break;
    end;
   end);


 Result:= Result + '<li class="nav-item"><!-- Begin Auto Menu Nav -->' + sLineBreak;

 for I := 0 to Form_Menu.MainMenu1.Items.Count-1 do
 begin
  Result:= Result + '<a class="nav-link collapsed" data-bs-target="#components-nav_'+IntToStr(I)+'" data-bs-toggle="collapse" href="#">' + sLineBreak;
  Result:= Result + '    <i class="bi bi-menu-button-wide"></i><span>'+ StringReplace(Form_Menu.MainMenu1.Items[I].Caption, '&', '', [rfReplaceAll]) +'</span><i class="bi bi-chevron-down ms-auto"></i>' + sLineBreak;
  Result:= Result + '</a>' + sLineBreak;
  Result:= Result + '<ul id="components-nav_'+IntToStr(I)+'" class="nav-content collapse " data-bs-parent="#sidebar-nav">' + sLineBreak;

  for J := 0 to Form_Menu.MainMenu1.Items[I].Count-1 do
  begin
   Result:= Result + '  <li>' + sLineBreak;
   Result:= Result + '    <a href="#" onclick="'+ Session.CallBacks.CallBackJS(vCallBackName, Session.ActiveForm.FormUUID, QuotedStr(Form_Menu.MainMenu1.Items[I].Items[J].Name)) +'">' + sLineBreak;
   Result:= Result + '      <i class="bi bi-circle"></i><span>' + StringReplace(Form_Menu.MainMenu1.Items[I].Items[J].Caption, '&', '', [rfReplaceAll]) + '</span>' + sLineBreak;
   Result:= Result + '    </a>' + sLineBreak;
   Result:= Result + '  </li>' + sLineBreak;
  end;

  Result:= Result + '</ul>' + sLineBreak;
 end;

 Result:= Result + '</li><!-- End Auto Menu Nav -->' + sLineBreak;
end;


procedure TD2BridgeFormTemplate.ProcessHTML(Sender: TObject;
  var AHTMLText: string);
begin
 //Intercep HTML Code

end;

procedure TD2BridgeFormTemplate.ProcessTagHTML(const TagString: string;
  var ReplaceTag: string);
begin
 if TagString = 'UserName' then
  ReplaceTag := UserSession.FUserName;

 if TagString = 'Name' then
  ReplaceTag := UserSession.FName;

 if TagString = 'Profile' then
  ReplaceTag := UserSession.FUserProfile;

 //Modo 2 - Menu Dinâmico
 if Pos('AbreMenu=', TagString) > 0 then
  ReplaceTag := Session.CallBacks.CallBackJS('AbreMenu', FormUUID, QuotedStr(Copy(TagString, 10, MaxInt)));

 //Modo 3 - Menu Automático
 if TagString = 'MontaMenu' then
  ReplaceTag := MontaMenu;
end;

end.
