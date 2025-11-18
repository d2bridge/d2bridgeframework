unit D2BridgeFormTemplate;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

Uses
 Classes,
 D2Bridge.Prism.Form;


type
 { TD2BridgeFormTemplate }
 TD2BridgeFormTemplate = class(TD2BridgePrismForm)
  private
   procedure ProcessHTML(Sender: TObject; var AHTMLText: string);
   procedure ProcessTagHTML(const TagString: string; var ReplaceTag: string);
   procedure DoInitPrismControl(const PrismControl: TPrismControl); override;
   //function OpenMenuItem(EventParams: TStrings): String;
  public
   constructor Create(AOwner: TComponent; D2BridgePrismFramework: TObject); override;
 end;


implementation

Uses
 LazarusWebApp, UnitMenu;


{ TD2BridgeFormTemplate }

constructor TD2BridgeFormTemplate.Create(AOwner: TComponent; D2BridgePrismFramework: TObject);
begin
 inherited;

 //Events
 OnProcessHTML:= ProcessHTML;
 OnTagHTML:= ProcessTagHTML;

 if FormMenu = nil then
  TFormMenu.CreateInstance;

 with D2Bridge.Items.Add do
  SideMenu(FormMenu.MainMenu1);
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

procedure TD2BridgeFormTemplate.DoInitPrismControl(
 const PrismControl: TPrismControl);
begin
 inherited;

 FormMenu.InitControlsD2Bridge(PrismControl);
end;

end.
