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

{$I D2Bridge.inc}

unit D2Bridge.Camera;

interface

Uses
 Classes, SysUtils, Generics.Collections, Rtti,
{$IFnDEF FPC}
 {$IFnDEF FMX}
 ExtCtrls,
 {$ELSE}
 FMX.ExtCtrls,
 {$ENDIF}
{$ELSE}
 ExtCtrls,
{$ENDIF}
 D2Bridge.Interfaces, D2Bridge.JSON,
 Prism.Interfaces, Prism.Types;

type
 TD2BridgeCamera = class(TInterfacedPersistent, ID2BridgeCamera)
  private
   FCurrentDevice: ID2BridgeCameraDevice;
   FDevices: ID2BridgeCameraDeviceItems;
   FAllowed: boolean;
   FUpdating: boolean;
   FSession: IPrismSession;
   FCameraListStr: string;
   FStoredCameraInfoStr: string;
   FPrismControl: IPrismControl;
  strict protected
   function GetCurrentDevice: ID2BridgeCameraDevice;
   procedure SetCurrentDevice(const Value: ID2BridgeCameraDevice);
   function GetAllowed: boolean;
   procedure SetAllowed(const Value: boolean);
   procedure ProcessCameraInfoJSON(ACameraInfoValue: TValue);
  protected
   procedure OnPageLoad(EventParams: TStrings); virtual;
   procedure OnOrientationChange(EventParams: TStrings); virtual;
   procedure OnCameraInitialize(EventParams: TStrings); virtual;
   procedure DoChangeDevices; virtual;
   procedure SetPrismControl(const Value: IPrismControl); virtual;
   function GetPrismControl: IPrismControl; virtual;
  public
   constructor Create(ASession: IPrismSession);
   destructor Destroy; override;

   function Devices: ID2BridgeCameraDeviceItems;

   function CurrentDeviceId: string;
   function CurrentDeviceName: string;
   function CurrentDeviceIndex: integer;

   function Updating: Boolean;

   function RequestPermission(AAudio: boolean = true): boolean;

   procedure UpdateCameraInfo;

   procedure BeginUpdate;
   procedure EndUpdate;

   property CurrentDevice: ID2BridgeCameraDevice read GetCurrentDevice write SetCurrentDevice;
   property Allowed: boolean read GetAllowed write SetAllowed;
   property PrismControl: IPrismControl read GetPrismControl write SetPrismControl;
 end;

implementation

Uses
 D2Bridge.Camera.Device, D2Bridge.Camera.Device.Items, D2Bridge.Util,
 Prism.Session.Thread.Proc;

{ TD2BridgeCamera }

procedure TD2BridgeCamera.BeginUpdate;
begin
 FUpdating:= true;
end;

constructor TD2BridgeCamera.Create(ASession: IPrismSession);
begin
 inherited Create;

 FSession:= ASession;

 FDevices:= TD2BridgeCameraDeviceItems.Create;

 FStoredCameraInfoStr:= '';
 FCurrentDevice:= nil;
 FAllowed:= false;
 FUpdating:= false;

{$IFDEF D2BRIDGE}
 FSession.RegisterEventOnPageLoad(OnPageLoad);
 FSession.RegisterEventOnOrientationChange(OnOrientationChange);
 FSession.RegisterEventOnCameraInitialize(OnCameraInitialize);
{$ENDIF}
// UpdateCameraInfo;
end;

function TD2BridgeCamera.CurrentDeviceId: string;
begin
 result:= '';

 if Assigned(FCurrentDevice) then
  result:= FCurrentDevice.id;

end;

function TD2BridgeCamera.CurrentDeviceIndex: integer;
begin
 result:= -1;

 if Assigned(FCurrentDevice) then
  result:= FCurrentDevice.Index;
end;

function TD2BridgeCamera.CurrentDeviceName: string;
begin
 result:= '';

 if Assigned(FCurrentDevice) then
  result:= FCurrentDevice.Name;

end;

destructor TD2BridgeCamera.Destroy;
var
 vD2BridgeDevices: TD2BridgeCameraDeviceItems;
begin
 vD2BridgeDevices:= FDevices as TD2BridgeCameraDeviceItems;
 FDevices:= nil;
 vD2BridgeDevices.Free;

{$IFDEF D2BRIDGE}
 FSession.UnRegisterEventOnPageLoad(OnPageLoad);
 FSession.UnRegisterEventOnOrientationChange(OnOrientationChange);
 FSession.UnRegisterEventOnCameraInitialize(OnCameraInitialize);
{$ENDIF}

 inherited;
end;

function TD2BridgeCamera.Devices: ID2BridgeCameraDeviceItems;
begin
 result:= FDevices;
end;

procedure TD2BridgeCamera.DoChangeDevices;
begin

end;

procedure TD2BridgeCamera.EndUpdate;
begin
 FUpdating:= false;
end;

function TD2BridgeCamera.GetAllowed: boolean;
begin
 if Devices.Count > 0 then
  result:= true
 else
  result:= FAllowed;

end;

function TD2BridgeCamera.GetCurrentDevice: ID2BridgeCameraDevice;
begin
 Result := FCurrentDevice;
end;

function TD2BridgeCamera.GetPrismControl: IPrismControl;
begin
 result:= FPrismControl;
end;

procedure TD2BridgeCamera.OnPageLoad(EventParams: TStrings);
begin

end;

procedure TD2BridgeCamera.OnCameraInitialize(EventParams: TStrings);
var
 vCameraInfoStr: string;
 vProc: TPrismSessionThreadProc;
begin
 if Assigned(EventParams) then
 begin
  vCameraInfoStr:= EventParams.Values['camerainfo'];

  if (vCameraInfoStr <> '') and (Assigned(FSession)) then
  begin
//   TThread.CreateAnonymousThread(
//    procedure
//    begin
//    ProcessCameraInfoJSON(vCameraInfoStr);
//    end
//   ).Start;
   //FSession.ExecThread(false,
   vProc:= TPrismSessionThreadProc.Create(FSession,
    ProcessCameraInfoJSON,
    TValue.From<string>(vCameraInfoStr),
    false,
    false
   );

   vProc.Exec;
  end;
 end;

end;

procedure TD2BridgeCamera.OnOrientationChange(EventParams: TStrings);
begin

end;

procedure TD2BridgeCamera.ProcessCameraInfoJSON(ACameraInfoValue: TValue);
var
 vCameraInfoStr: string;
 vCameraInfoJSON: TJSONObject;
 vJSONDevices: TJSONArray;
 vCurrentDeviceID: string;
 vAllowedAudio: boolean;
 vAllowed: string;
 vResponse: string;
 I: integer;
begin
 try
  vCameraInfoStr:= ACameraInfoValue.AsString;

  if vCameraInfoStr <> '' then
  begin
   vCameraInfoJSON:= TJSONObject.ParseJSONValue(vCameraInfoStr) as TJSONObject;

   if Assigned(vCameraInfoJSON) then
   begin
    vAllowed:= vCameraInfoJSON.GetValue('allowed', '-1');

    if Not ((vAllowed = '1') or (vAllowed = '0')) then
    begin
     I:= 0;
     repeat
      Inc(I);

      vAllowed:= FSession.ExecJSResponse('D2BridgeCameraAllowed');

      if I < 5 then
       sleep(500)
      else
       sleep(1000);
     until (I >= 15) or
           ((vAllowed = '1') or (vAllowed = '0'));
    end;


    vCurrentDeviceID:= vCameraInfoJSON.GetValue('id', '');

    vJSONDevices := vCameraInfoJSON.GetValue('items') as TJSONArray;;

    if Assigned(vJSONDevices) then
    begin
     for I := 0 to Pred(vJSONDevices.Count) do
     begin
      with (FDevices.Add as TD2BridgeCameraDevice) do
      begin
       id:= TJSONObject(vJSONDevices.Items[I]).GetValue('id','');
       Index:= TJSONObject(vJSONDevices.Items[I]).GetValue('index',-1);
       name:= TJSONObject(vJSONDevices.Items[I]).GetValue('name','Camera ' + IntToStr(Index));

       if (vCurrentDeviceID <> '') and (vCurrentDeviceID = id) then
       begin
        FCurrentDevice:= this;
       end;
      end;
     end;
    end;

    vAllowedAudio:= vCameraInfoJSON.GetValue('allowedaudio', false) = true;

    vCameraInfoJSON.Free;
   end;
  end;

  if FStoredCameraInfoStr <> vCameraInfoStr then
  begin
   FStoredCameraInfoStr:= vCameraInfoStr;
   DoChangeDevices;
  end;
 except
 end;
end;

function TD2BridgeCamera.RequestPermission(AAudio: boolean): boolean;
var
 vJS: TStrings;
 vResponseStr: string;
 I: integer;
begin
 result:= false;
 FAllowed:= false;
 FCurrentDevice:= nil; { #todo -c'Fix Lazarus RefCount' :  }
 Devices.Clear;

 vJS:= TStringList.Create;

 with vJS do
 begin
//  Add('$(document).ready(async function() {');
  Add('D2BridgeCameraPermission();');
//  Add('});');
 end;

 FSession.ExecJS(vJS.Text);
 vJS.Free;

 I:= 0;
 vResponseStr:= '';
 repeat
  Inc(I);

  if I < 5 then
   sleep(500)
  else
   sleep(1000);

  vResponseStr:= FSession.ExecJSResponse('D2BridgeCameraAllowed');
 until (I >= 15) or
       ((vResponseStr = '1') or (vResponseStr = '0'));

 TryStrToBool(vResponseStr, result);

 FAllowed:= result;

 UpdateCameraInfo;
end;

procedure TD2BridgeCamera.SetAllowed(const Value: boolean);
begin
 FAllowed:= Value;
end;

procedure TD2BridgeCamera.SetCurrentDevice(const Value: ID2BridgeCameraDevice);
var
 vOLDCurrentID: string;
begin
 vOLDCurrentID:= '';

 if Assigned(FCurrentDevice) and Assigned(Value) then
  vOLDCurrentID:= CurrentDeviceId;

 FCurrentDevice := Value;

 if Assigned(FCurrentDevice) then
  if (not FUpdating) and
     (vOLDCurrentID <> FCurrentDevice.id) then
  begin
   FSession.ExecJS('D2BridgeCurrentCameraId = "' + FCurrentDevice.id + '";');
  end;
end;

procedure TD2BridgeCamera.SetPrismControl(const Value: IPrismControl);
begin
 FPrismControl:= Value;
end;

procedure TD2BridgeCamera.UpdateCameraInfo;
var
 vResponse: string;
begin
 inherited;

 vResponse:= FSession.ExecJSResponse('D2BridgeCameraInfo();');

 if (vResponse <> '') then
 begin
  processCameraInfoJSON(vResponse);
 end;
end;

function TD2BridgeCamera.Updating: Boolean;
begin
 result:= FUpdating;
end;

end.