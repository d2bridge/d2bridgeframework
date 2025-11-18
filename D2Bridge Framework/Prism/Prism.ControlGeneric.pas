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

unit Prism.ControlGeneric;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismControlGeneric = class(TPrismControl, IPrismControlGeneric)
  private

  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsControlGeneric: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
 end;



implementation

uses
  Prism.Util;


constructor TPrismControlGeneric.Create(AOwner: TObject);
begin
 inherited;
end;

function TPrismControlGeneric.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

procedure TPrismControlGeneric.Initialize;
begin
 inherited;
end;

function TPrismControlGeneric.IsControlGeneric: Boolean;
begin
 result:= true;
end;

procedure TPrismControlGeneric.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismControlGeneric.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismControlGeneric.ProcessHTML;
begin
 inherited;

end;

procedure TPrismControlGeneric.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
begin
 inherited;

end;

end.
