{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not be modified,
  distributed, or sublicensed without express written authorization from
  the author (Talis Jonatas Gomes). This includes creating derivative works
  or distributing the source code through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit Prism.ButtonedEdit;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils,
  Prism.Forms.Controls, Prism.Interfaces, Prism.Edit, Prism.Types;


type
 TPrismButtonedEdit = class(TPrismEdit, IPrismButtonedEdit)
  private
   FStoredButtonLeftVisible: Boolean;
   FStoredButtonRightVisible: Boolean;
   FStoredButtonLeftEnabled: Boolean;
   FStoredButtonRightEnabled: Boolean;
   FButtonLeftCSS: string;
   FButtonRightCSS: string;
   FButtonLeftText: string;
   FButtonRightText: string;
   FProcGetLeftButtonEnabled: TOnGetValue;
   FProcGetLeftButtonVisible: TOnGetValue;
   FProcGetRightButtonEnabled: TOnGetValue;
   FProcGetRightButtonVisible: TOnGetValue;
{$IFDEF FPC}
  protected
{$ENDIF}
   function GetButtonLeftVisible: boolean;
   function GetButtonLeftEnabled: boolean;
   procedure SetButtonLeftCSS(Value: String);
   function GetButtonLeftCSS: string;
   procedure SetButtonLeftText(Value: String);
   function GetButtonLeftText: string;
   function GetButtonRightVisible: boolean;
   function GetButtonRightEnabled: boolean;
   procedure SetButtonRightCSS(Value: String);
   function GetButtonRightCSS: string;
   procedure SetButtonRightText(Value: String);
   function GetButtonRightText: string;
  protected
   procedure ProcessHTML; override;
   procedure Initialize; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;

   function IsButtonedEdit: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;

   property ProcGetLeftButtonEnabled: TOnGetValue read FProcGetLeftButtonEnabled write FProcGetLeftButtonEnabled;
   property ProcGetLeftButtonVisible: TOnGetValue read FProcGetLeftButtonVisible write FProcGetLeftButtonVisible;
   property ProcGetRightButtonEnabled: TOnGetValue read FProcGetRightButtonEnabled write FProcGetRightButtonEnabled;
   property ProcGetRightButtonVisible: TOnGetValue read FProcGetRightButtonVisible write FProcGetRightButtonVisible;

   property ButtonLeftVisible: boolean read GetButtonLeftVisible;
   property ButtonLeftEnabled: boolean read GetButtonLeftEnabled;
   property ButtonLeftCSS: string read GetButtonLeftCSS write SetButtonLeftCSS;
   property ButtonLeftText: string read GetButtonLeftText write SetButtonLeftText;
   property ButtonRightVisible: boolean read GetButtonRightVisible;
   property ButtonRightEnabled: boolean read GetButtonRightEnabled;
   property ButtonRightCSS: string read GetButtonRightCSS write SetButtonRightCSS;
   property ButtonRightText: string read GetButtonRightText write SetButtonRightText;
 end;

implementation

uses
  D2Bridge.Util, D2Bridge.HTML.CSS, StrUtils;

{ TPrismButtonedEdit }

constructor TPrismButtonedEdit.Create(AOwner: TObject);
begin
 inherited;
end;

function TPrismButtonedEdit.GetButtonLeftCSS: string;
begin
 result:= FButtonLeftCSS;
end;

function TPrismButtonedEdit.GetButtonLeftEnabled: boolean;
begin
 if Assigned(FProcGetLeftButtonEnabled) then
  Result:= FProcGetLeftButtonEnabled
 else
  result:= FStoredButtonLeftEnabled;
end;

function TPrismButtonedEdit.GetButtonLeftText: string;
begin
 if (ButtonLeftCSS = '') and (FButtonLeftText = '') then
  result:= '...'
 else
  result:= FButtonLeftText;
end;

function TPrismButtonedEdit.GetButtonLeftVisible: boolean;
begin
 if Assigned(FProcGetLeftButtonVisible) then
  Result:= FProcGetLeftButtonVisible
 else
  result:= FStoredButtonLeftVisible;

 if result then
  result:= Visible;
end;

function TPrismButtonedEdit.GetButtonRightCSS: string;
begin
 result:= FButtonRightCSS;
end;

function TPrismButtonedEdit.GetButtonRightEnabled: boolean;
begin
 if Assigned(FProcGetRightButtonEnabled) then
  Result:= FProcGetRightButtonEnabled
 else
  result:= FStoredButtonRightEnabled;
end;

function TPrismButtonedEdit.GetButtonRightText: string;
begin
 if (ButtonRightCSS = '') and (FButtonRightText = '') then
  result:= '...'
 else
  result:= FButtonRightText;
end;

function TPrismButtonedEdit.GetButtonRightVisible: boolean;
begin
 if Assigned(FProcGetRightButtonVisible) then
  Result:= FProcGetRightButtonVisible
 else
  result:= FStoredButtonRightVisible;

 if result then
  result:= Visible;
end;

procedure TPrismButtonedEdit.Initialize;
begin
 inherited;

 FStoredButtonLeftVisible:= ButtonLeftVisible;
 FStoredButtonRightVisible:= ButtonRightVisible;

 FStoredButtonLeftEnabled:= ButtonLeftEnabled;
 FStoredButtonRightEnabled:= ButtonRightEnabled;
end;

function TPrismButtonedEdit.IsButtonedEdit: Boolean;
begin
 Result:= true;
end;

procedure TPrismButtonedEdit.ProcessHTML;
var
 vHTMLEdit: string;
 vHTMLButtonedEdit: string;
 vButtonLeftCSS, vButtonLeftFontClass, vButtonLeftIElement: string;
 vButtonLeftEvent: string;
 vButtonRightCSS, vButtonRightFontClass, vButtonRightIElement: string;
 vButtonRightEvent: string;
begin
 inherited;
 vHTMLButtonedEdit:= '';
 vButtonLeftEvent:= '';

 vHTMLEdit:= HTMLControl;


 vHTMLButtonedEdit:= '<div class="d2bridgebuttonededit input-group">';


 {$REGION 'Button Left'}
  if FButtonLeftCSS <> '' then
   CSSButtonFontToIelement(FButtonLeftCSS, vButtonLeftCSS, vButtonLeftFontClass, vButtonLeftIElement)
  else
   vButtonLeftCSS:= Button.TypeButton.Default.primary;

   if Assigned(Events.Item(EventOnLeftClick)) then
   vButtonLeftEvent:= Events.Item(EventOnLeftClick).EventJS(ExecEventProc, '''PrismComponentsStatus='' + GetComponentsStates(PrismComponents)', true);

  vHTMLButtonedEdit:= vHTMLButtonedEdit +
    '<button class="btn ' + vButtonLeftCSS + ' d2bridgebuttonededitbl' + ifthen(not ButtonLeftVisible, ' invisible') +
    '" type="button" id="' + UpperCase(NamePrefix) + 'buttonleft"' +
    ifthen(vButtonLeftEvent <> '', ' onclick="' + vButtonLeftEvent + '"') +
    ifthen(not ButtonLeftEnabled, ' disabled') +
    '>'+
    Trim(ifthen(vButtonLeftIElement <> '', vButtonLeftIElement + ' ') + ButtonLeftText) +
    '</button>';
 {$ENDREGION}

 //Input
 vHTMLButtonedEdit:= vHTMLButtonedEdit + vHTMLEdit;

 {$REGION 'Button Right'}
  if FButtonRightCSS <> '' then
   CSSButtonFontToIelement(FButtonRightCSS, vButtonRightCSS, vButtonRightFontClass, vButtonRightIElement)
  else
   vButtonRightCSS:= Button.TypeButton.Default.primary;

   if Assigned(Events.Item(EventOnRightClick)) then
   vButtonRightEvent:= Events.Item(EventOnRightClick).EventJS(ExecEventProc, '''PrismComponentsStatus='' + GetComponentsStates(PrismComponents)', true);

  vHTMLButtonedEdit:= vHTMLButtonedEdit +
    '<button class="btn ' + vButtonRightCSS + ' d2bridgebuttonededitbr' + ifthen(not ButtonrightVisible, ' invisible') +
    '" type="button" id="' + UpperCase(NamePrefix) + 'buttonright"' +
    ifthen(vButtonRightEvent <> '', ' onclick="' + vButtonRightEvent + '"') +
    ifthen(not ButtonrightEnabled, ' disabled') +
    '>'+
    Trim(ifthen(vButtonRightIElement <> '', vButtonRightIElement + ' ') + ButtonrightText) +
    '</button>';
 {$ENDREGION}

 vHTMLButtonedEdit:= vHTMLButtonedEdit + '</div>';

 HTMLControl:= vHTMLButtonedEdit;
end;

procedure TPrismButtonedEdit.SetButtonLeftCSS(Value: String);
begin
 FButtonLeftCSS := Value;
end;

procedure TPrismButtonedEdit.SetButtonLeftText(Value: String);
begin
 FButtonLeftText := Value;
end;

procedure TPrismButtonedEdit.SetButtonRightCSS(Value: String);
begin
 FButtonRightCSS := Value;
end;

procedure TPrismButtonedEdit.SetButtonRightText(Value: String);
begin
 FButtonRightText := Value;
end;


procedure TPrismButtonedEdit.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 vNewButtonLeftVisible, vNewButtonRightVisible: boolean;
 vNewButtonLeftEnabled, vNewButtonRightEnabled: boolean;
 NewText: string;
begin
 inherited;

 {$REGION 'Visible'}
  vNewButtonLeftVisible:= ButtonLeftVisible;
   if (vNewButtonLeftVisible <> FStoredButtonLeftVisible) then
   begin
    if vNewButtonLeftVisible then
    begin
     ScriptJS.Add('$("#' + UpperCase(NamePrefix) + 'buttonleft").show();');
     ScriptJS.Add('$("#' + UpperCase(NamePrefix) + 'buttonleft").removeClass("invisible");');
    end else
    begin
     ScriptJS.Add('$("#' + UpperCase(NamePrefix) + 'buttonleft").hide();');
     ScriptJS.Add('$("#' + UpperCase(NamePrefix) + 'buttonleft").addClass("invisible");');
    end;

    FStoredButtonLeftVisible:= vNewButtonLeftVisible;
   end;

   vNewButtonRightVisible:= ButtonRightVisible;
   if (vNewButtonRightVisible <> FStoredButtonrightVisible) then
   begin
    if vNewButtonRightVisible then
    begin
     ScriptJS.Add('$("#' + UpperCase(NamePrefix) + 'buttonright").show();');
     ScriptJS.Add('$("#' + UpperCase(NamePrefix) + 'buttonright").removeClass("invisible");');
    end else
    begin
     ScriptJS.Add('$("#' + UpperCase(NamePrefix) + 'buttonright").hide();');
     ScriptJS.Add('$("#' + UpperCase(NamePrefix) + 'buttonright").addClass("invisible");');
    end;

    FStoredButtonrightVisible:= vNewButtonRightVisible;
   end;
 {$ENDREGION}



 {$REGION 'Enabled'}
  vNewButtonLeftEnabled:= ButtonLeftEnabled;
  if (vNewButtonLeftEnabled <> FStoredButtonLeftEnabled) then
  begin
   if vNewButtonLeftEnabled then
    ScriptJS.Add('document.getElementById("' + UpperCase(NamePrefix) + 'buttonleft").disabled = false;')
   else
    ScriptJS.Add('document.getElementById("' + UpperCase(NamePrefix) + 'buttonleft").disabled = true;');

   FStoredButtonLeftEnabled:= vNewButtonLeftEnabled;
  end;

  vNewButtonRightEnabled:= ButtonRightEnabled;
  if (vNewButtonRightEnabled <> FStoredButtonrightEnabled) then
  begin
   if vNewButtonRightEnabled then
    ScriptJS.Add('document.getElementById("' + UpperCase(NamePrefix) + 'buttonright").disabled = false;')
   else
    ScriptJS.Add('document.getElementById("' + UpperCase(NamePrefix) + 'buttonright").disabled = true;');

   FStoredButtonrightEnabled:= vNewButtonRightEnabled;
  end;
 {$ENDREGION}
end;

{$ELSE}
implementation
{$ENDIF}

end.
