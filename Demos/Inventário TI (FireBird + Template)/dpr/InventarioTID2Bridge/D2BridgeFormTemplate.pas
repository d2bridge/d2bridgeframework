unit D2BridgeFormTemplate;

interface

Uses
 System.Classes,
 D2Bridge.Prism.Form;


type
 TD2BridgeFormTemplate = class(TD2BridgePrismForm)
  private
   procedure ProcessHTML(Sender: TObject; var AHTMLText: string);
   procedure ProcessTagHTML(const TagString: string; var ReplaceTag: string);
   function OpenMenuEquipamento(EventParams: TStrings): String;
   function OpenMenuSoftware(EventParams: TStrings): String;
   function OpenMenuDashBoard(EventParams: TStrings): String;
  public
   constructor Create(AOwner: TComponent; D2BridgePrismFramework: TObject); override;

 end;


implementation

Uses
 Unit_Equipamento_Busca, Unit_Software_Busca, Unit_DashBoard;

{ TD2BridgeFormTemplate }

constructor TD2BridgeFormTemplate.Create(AOwner: TComponent;
  D2BridgePrismFramework: TObject);
begin
 inherited;

 //Events
 OnProcessHTML:= ProcessHTML;
 OnTagHTML:= ProcessTagHTML;


 //Yours CallBacks Ex:
 CallBacks.Register('OpenMenuSoftware', OpenMenuSoftware);
 CallBacks.Register('OpenMenuEquipamento', OpenMenuEquipamento);
 CallBacks.Register('OpenMenuDashBoard', OpenMenuDashBoard);


 //Other Example CallBack embed
 {
 Session.CallBacks.Register('OpenMenuItem',
   function(EventParams: TStrings): string
   begin
    if MyForm = nil then
     TMyForm.CreateInstance;
    MyForm.Show;
   end);
  }
end;

function TD2BridgeFormTemplate.OpenMenuDashBoard(EventParams: TStrings): String;
begin
 if Form_DashBoard =  nil then
  TForm_DashBoard.CreateInstance;
 Form_DashBoard.Show;
end;

function TD2BridgeFormTemplate.OpenMenuEquipamento(EventParams: TStrings): String;
begin
 if Form_Equipamento_Busca =  nil then
  TForm_Equipamento_Busca.CreateInstance;
 Form_Equipamento_Busca.Show;
end;

function TD2BridgeFormTemplate.OpenMenuSoftware(EventParams: TStrings): String;
begin
 if Form_Software_Busca =  nil then
  TForm_Software_Busca.CreateInstance;
 Form_Software_Busca.Show;
end;

procedure TD2BridgeFormTemplate.ProcessHTML(Sender: TObject;
  var AHTMLText: string);
begin
 //Intercep HTML Code

end;

procedure TD2BridgeFormTemplate.ProcessTagHTML(const TagString: string;
  var ReplaceTag: string);
begin
 //Process TAGs HTML {{TAGNAME}}
 if TagString = 'UserName' then
 begin
  ReplaceTag := 'Name of User';
 end;

end;

end.
