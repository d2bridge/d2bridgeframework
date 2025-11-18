{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is distributed under the terms of the
  GNU Lesser General Public License (LGPL) version 2.1.

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License as published by
  the Free Software Foundation; either version 2.1 of the License, or
  (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with this library; if not, see <https://www.gnu.org/licenses/>.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit Prism.Camera;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
{$IFDEF FMX}

{$ELSE}

{$ENDIF}
  D2Bridge.Camera.Image,
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types;


type
 TPrismCamera = class(TPrismControl, IPrismCamera)
  private
   FD2BridgeImageCamera: TD2BridgeCameraImage;
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsCamera: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;

   procedure DoFormLoadComplete; override;

   property D2BridgeImageCamera: TD2BridgeCameraImage read FD2BridgeImageCamera write FD2BridgeImageCamera;
 end;



implementation

uses
  Prism.Util, Prism.Events;


constructor TPrismCamera.Create(AOwner: TObject);
begin
 inherited;
end;

procedure TPrismCamera.DoFormLoadComplete;
begin
 inherited;

 //FD2BridgeImageCamera.UpdateCameraInfo;

// if FCallOnChangeDevices then
//  if Assigned(FD2BridgeImageCamera.OnChangeDevices) then
//  begin
//   FD2BridgeImageCamera.OnChangeDevices(VCLComponent);
//  end;
end;

function TPrismCamera.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

procedure TPrismCamera.Initialize;
begin
 inherited;
end;

function TPrismCamera.IsCamera: Boolean;
begin
 result:= true;
end;

procedure TPrismCamera.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismCamera.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
 inherited;

end;

procedure TPrismCamera.ProcessHTML;
var
 vHTMLContent: TStrings;
 vUUID, vToken, vFormUUID: String;
begin
 inherited;

 vUUID:= Session.UUID;
 vToken:= Session.Token;
 vFormUUID:= Form.FormUUID;

 vHTMLContent:= TStringList.Create;

 with vHTMLContent do
 begin
  Add('<div '+HTMLCore+'>');
  Add('<video class="d2bridgecamerapreview rounded border" id="'+AnsiUpperCase(NamePrefix)+'preview" autoplay playsinline muted></video>');
  Add('<div class="d2bridgecameraindicator" id="'+AnsiUpperCase(NamePrefix)+'indicator"></div>');
  Add('</div>');

  Add('<script>');

  Add('let '+AnsiUpperCase(NamePrefix)+'mediaStream = null;');
  Add('let '+AnsiUpperCase(NamePrefix)+'recorder = null;');
  Add('let '+AnsiUpperCase(NamePrefix)+'recordedChunks = [];');
  Add('const '+AnsiUpperCase(NamePrefix)+'videoElement = document.getElementById("'+AnsiUpperCase(NamePrefix)+'preview");');
  Add('const '+AnsiUpperCase(NamePrefix)+'videoIndicator = document.getElementById("'+AnsiUpperCase(NamePrefix)+'indicator");');
  Add(AnsiUpperCase(NamePrefix)+'videoElement.style.height = (('+AnsiUpperCase(NamePrefix)+'videoElement.offsetWidth / 16) * 9) + "px";');

  Add('</script>');
 end;

 HTMLControl:= vHTMLContent.Text;

 vHTMLContent.Free;
end;

procedure TPrismCamera.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
begin
 inherited;

end;

end.