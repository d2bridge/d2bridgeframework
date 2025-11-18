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

unit D2Bridge.Camera.Image;

interface

Uses
 Classes, SysUtils, Generics.Collections,
{$IFnDEF FPC}
 {$IFnDEF FMX}
 ExtCtrls,
 {$ELSE}
 FMX.ExtCtrls,
 {$ENDIF}
{$ELSE}
 ExtCtrls,
{$ENDIF}
 D2Bridge.Interfaces, D2Bridge.Camera,
 Prism.Types, Prism.Interfaces;


type
 TD2BridgeCameraImage = class(TD2BridgeCamera, ID2BridgeCameraImage)
  private
   FOnChangeDevices: TNotifyEvent;
   FImageUploadNum: integer;
   FVideoUploadNum: integer;
  protected
   procedure DoChangeDevices; override;
   procedure SetPrismControl(const Value: IPrismControl); override;
  public
   constructor Create(ASession: IPrismSession; APrismControl: IPrismControl);
   destructor Destroy; override;

   function Started: boolean;

   function Start: boolean;
   function Stop: boolean;

   procedure TakePicture;

   procedure RecordVideo;
   function SaveVideo: boolean;
   function CancelVideo: boolean;

   property OnChangeDevices: TNotifyEvent read FOnChangeDevices write FOnChangeDevices;
 end;


implementation

Uses
 Prism.Camera;


{ TD2BridgeCameraImage }

function TD2BridgeCameraImage.Started: boolean;
var
 vResp: string;
begin
 result:= false;

 vResp:=
  PrismControl.Session.ExecJSResponse(
   '('+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement && !'+
      AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.paused && !'+
      AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.ended && '+
      AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.readyState >= 2) === true'
  );

 TryStrToBool(vResp, Result);
end;

function TD2BridgeCameraImage.Stop: boolean;
var
 vJS: TStrings;
 vResponseStr: string;
 I: integer;
begin
 result:= false;

 if Allowed then
 begin
  vJS:= TStringList.Create;

  with vJS do
  begin
   Add('$(document).ready(async function() {');
   Add('  if ('+AnsiUpperCase(PrismControl.NamePrefix)+'mediaStream) {');
   Add('    '+AnsiUpperCase(PrismControl.NamePrefix)+'mediaStream.getTracks().forEach(track => track.stop());');
   Add('    '+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.pause();');
   Add('    '+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.srcObject = null;');
   Add('    '+AnsiUpperCase(PrismControl.NamePrefix)+'mediaStream = null;');
   Add('  }');
   Add('   $('+AnsiUpperCase(PrismControl.NamePrefix)+'videoIndicator).hide();');
   Add('   '+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.style.height = (('+
              AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.offsetWidth / 16) * 9) + "px";');
   Add('});');
  end;

  PrismControl.Session.ExecJS(vJS.Text);

  vJS.Free;

  I:= 0;
  vResponseStr:= '';
  repeat
   Inc(I);

   Sleep(500);

   vResponseStr:= PrismControl.Session.ExecJSResponse(
     '('+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement && '+
     '!'+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.paused && '+
     '!'+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.ended && '+
     ''+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.readyState >= 2);'
   );
  until (I >= 5) or
        (vResponseStr = 'false');

  TryStrToBool(vResponseStr, result);
 end;
end;

function TD2BridgeCameraImage.CancelVideo: boolean;
var
 vJS: TStrings;
begin

 vJS:= TStringList.Create;

 with vJS do
 begin
  Add('$(document).ready(function() {');
  Add(' if ('+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder && '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder.state !== "inactive") {');
  Add('   '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder.stop();');
  Add('   '+ AnsiUpperCase(PrismControl.NamePrefix) +'recordedChunks = [];');
  Add(' }');
  Add(' $('+AnsiUpperCase(PrismControl.NamePrefix)+'videoIndicator).hide();');
  Add('});');
 end;

 PrismControl.Session.ExecJS(vJS.Text);

 vJS.Free;
end;

constructor TD2BridgeCameraImage.Create(ASession: IPrismSession; APrismControl: IPrismControl);
begin
 inherited Create(ASession);

 PrismControl:= APrismControl;

 FImageUploadNum:= 0;
 FVideoUploadNum:= 0;
end;

destructor TD2BridgeCameraImage.Destroy;
begin
 inherited;
end;

procedure TD2BridgeCameraImage.DoChangeDevices;
begin
 inherited;

 if Assigned(FOnChangeDevices) then
  if Assigned(PrismControl) then
   FOnChangeDevices(PrismControl.VCLComponent);
end;

procedure TD2BridgeCameraImage.RecordVideo;
var
 vJS: TStrings;
begin

 vJS:= TStringList.Create;

 with vJS do
 begin
  Add('$(document).ready(async function() {');
  Add(' try {');
  Add('   if (D2BridgeCameraAllowedAudio === true) {');
  Add('     try {');
  Add('       '+ AnsiUpperCase(PrismControl.NamePrefix) +'mediaStream = await navigator.mediaDevices.getUserMedia({');
  Add('         video: { deviceId: "' + CurrentDeviceId + '"' +',');
  Add('                  width: { max: 1920 },');
  Add('                  height: { max: 1080 }');
  Add('                },');
  Add('         audio: { echoCancellation: false, noiseSuppression: false }');
  Add('       });');
  Add('     } catch (e2) {');
  Add('       '+ AnsiUpperCase(PrismControl.NamePrefix) +'mediaStream = await navigator.mediaDevices.getUserMedia({');
  Add('         video: { deviceId: "' + CurrentDeviceId + '"' +',');
  Add('                  width: { max: 1920 },');
  Add('                  height: { max: 1080 }');
  Add('                },');
  Add('       });');
  Add('     }');
  Add('   } else {');
  Add('     '+ AnsiUpperCase(PrismControl.NamePrefix) +'mediaStream = await navigator.mediaDevices.getUserMedia({');
  Add('         video: { deviceId: "' + CurrentDeviceId + '"' +',');
  Add('                  width: { max: 1920 },');
  Add('                  height: { max: 1080 }');
  Add('                },');
  Add('     });');
  Add('   }');
  Add('   '+ AnsiUpperCase(PrismControl.NamePrefix) +'videoElement.srcObject = '+ AnsiUpperCase(PrismControl.NamePrefix) +'mediaStream;');
  Add('');
  Add('   '+ AnsiUpperCase(PrismControl.NamePrefix) +'recordedChunks = [];');

  Add('   if (MediaRecorder.isTypeSupported("video/webm;codecs=vp9")) {');
  Add('     '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder = new MediaRecorder('+ AnsiUpperCase(PrismControl.NamePrefix) +'mediaStream, { mimeType: "video/webm;codecs=vp9" });');
  Add('   } else if (MediaRecorder.isTypeSupported("video/webm;codecs=h264")) {');
  Add('     '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder = new MediaRecorder('+ AnsiUpperCase(PrismControl.NamePrefix) +'mediaStream, { mimeType: "video/webm;codecs=h264" });');
  Add('   } else if (MediaRecorder.isTypeSupported("video/webm")) {');
  Add('     '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder = new MediaRecorder('+ AnsiUpperCase(PrismControl.NamePrefix) +'mediaStream, { mimeType: "video/webm" });');
  Add('   } else if (MediaRecorder.isTypeSupported("video/mp4")) {');
  Add('     '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder = new MediaRecorder('+ AnsiUpperCase(PrismControl.NamePrefix) +'mediaStream, { mimeType: "video/mp4" });');
  Add('   } else if (MediaRecorder.isTypeSupported("video/mp4;codecs=avc1.64001f,mp4a.40.2")) {');
  Add('     '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder = new MediaRecorder('+ AnsiUpperCase(PrismControl.NamePrefix) +'mediaStream, { mimeType: "video/mp4;codecs=avc1.64001f,mp4a.40.2" });');
  Add('   } else {');
  Add('     '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder = new MediaRecorder('+ AnsiUpperCase(PrismControl.NamePrefix) +'mediaStream);');
  Add('   }');

  Add('   '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder.ondataavailable = e => '+ AnsiUpperCase(PrismControl.NamePrefix) +'recordedChunks.push(e.data);');
  Add('   '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder.start();');
  Add('   $('+AnsiUpperCase(PrismControl.NamePrefix)+'videoIndicator).show();');
  Add('');
  Add(' } catch (e3) {');
  Add(' }');
  Add('});');
 end;

 PrismControl.Session.ExecJS(vJS.Text);

 vJS.Free;

end;

function TD2BridgeCameraImage.SaveVideo: boolean;
var
 vJS: TStrings;
 vUUID, vToken, vFormUUID: String;
begin
 vUUID:= PrismControl.Session.UUID;
 vToken:= PrismControl.Session.Token;
 vFormUUID:= PrismControl.Form.FormUUID;

 Inc(FVideoUploadNum);

 vJS:= TStringList.Create;

 with vJS do
 begin
  Add('$(document).ready(function() {');
  Add(' if ('+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder && '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder.state !== "inactive") {');
  Add('   '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder.onstop = function() {');
  Add('     const blob = new Blob('+ AnsiUpperCase(PrismControl.NamePrefix) +'recordedChunks, { type: "video/webm" });');
  Add('     const formData = new FormData();');
  Add('     formData.append("file", blob, "video'+ IntToStr(FVideoUploadNum) +'.webm");');
  add('     var appBase = window.location.pathname.replace(/\/$/, "");');
  Add('     $.ajax({');
  Add('       url: appBase + "/d2bridge/upload?token='+ vToken +
                   '&formuuid='+ vFormUUID +'&prismsession='+ vUUID +
                   '&origin=camera&sender='+ AnsiUpperCase(PrismControl.NamePrefix) +'",');
  Add('       method: "POST",');
  Add('       data: formData,');
  Add('       processData: false,');
  Add('       contentType: false,');
  Add('       success: function () {');
  Add('       },');
  Add('       error: function () {');
  Add('       }');
  Add('     });');
  Add('   }');
  Add('   '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder.requestData();');
  Add('   setTimeout(() => {');
  Add('     if ('+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder.state !== "inactive") {');
  Add('       '+ AnsiUpperCase(PrismControl.NamePrefix) +'recorder.stop();');
  Add('     }');
  Add('   }, 2500);');
  Add('   $('+AnsiUpperCase(PrismControl.NamePrefix)+'videoIndicator).hide();');
  Add(' }');
  Add('});');
 end;
 PrismControl.Session.ExecJS(vJS.Text);

 vJS.Free;

 Sleep(2600);
end;

procedure TD2BridgeCameraImage.SetPrismControl(const Value: IPrismControl);
begin
 inherited;

 if Assigned(PrismControl) then
  (PrismControl as TPrismCamera).D2BridgeImageCamera:= self;
end;

function TD2BridgeCameraImage.Start: boolean;
var
 vJS: TStrings;
 vResponseStr: string;
 I: integer;
begin
 result:= false;

 if Allowed then
 begin
  vJS:= TStringList.Create;

  with vJS do
  begin
   Add('$(document).ready(async function() {');
   Add(' try {');
   Add('   '+AnsiUpperCase(PrismControl.NamePrefix)+'mediaStream = await navigator.mediaDevices.getUserMedia({');
   Add('     video: { deviceId: "' + CurrentDeviceId + '" }');
   Add('   });');
   Add('   '+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.srcObject = '+AnsiUpperCase(PrismControl.NamePrefix)+'mediaStream;');
   Add('   '+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.style.removeProperty("height");');
   Add(' } catch (e) {');
   Add('   //alert("Error accessing camera: " + e.message);');
   Add(' }');
   Add(' const isFirefox = navigator.userAgent.toLowerCase().includes("firefox");');
   Add(' if (isFirefox)');
   Add('   D2BridgeSaveCameraListToCookie();');
   Add('});');
  end;

  PrismControl.Session.ExecJS(vJS.Text);

  vJS.Free;

  I:= 0;
  vResponseStr:= '';
  repeat
   Inc(I);

   Sleep(500);

   vResponseStr:= PrismControl.Session.ExecJSResponse(
     '('+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement && '+
     '!'+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.paused && '+
     '!'+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.ended && '+
     ''+AnsiUpperCase(PrismControl.NamePrefix)+'videoElement.readyState >= 2) === true;'
   );
  until (I >= 5) or
        (vResponseStr = 'true');

  TryStrToBool(vResponseStr, result);
 end;
end;

procedure TD2BridgeCameraImage.TakePicture;
var
 vJS: TStrings;
 vUUID, vToken, vFormUUID: String;
begin
 vUUID:= PrismControl.Session.UUID;
 vToken:= PrismControl.Session.Token;
 vFormUUID:= PrismControl.Form.FormUUID;

 Inc(FImageUploadNum);

 vJS:= TStringList.Create;

 with vJS do
 begin
  Add('$(document).ready(function() {');
  Add(' function TakePicture() {');
  Add('   const canvas = document.createElement("canvas");');
  Add('   canvas.width = '+ AnsiUpperCase(PrismControl.NamePrefix) +'videoElement.videoWidth;');
  Add('   canvas.height = '+ AnsiUpperCase(PrismControl.NamePrefix) +'videoElement.videoHeight;');
  Add('');
  Add('   const ctx = canvas.getContext("2d");');
  Add('   ctx.drawImage('+ AnsiUpperCase(PrismControl.NamePrefix) +'videoElement, 0, 0, canvas.width, canvas.height);');
  Add('');
  Add('   canvas.toBlob(function (blob) {');
  Add('     const formData = new FormData();');
  Add('     formData.append("file", blob, "campicture' + IntToStr(FImageUploadNum) + '.png");');
  Add('');
  Add('     $.ajax({');
  Add('       url: appBaseD2Bridge + "/d2bridge/upload?token='+ vToken +
                   '&formuuid='+ vFormUUID +'&prismsession='+ vUUID +
                   '&origin=camera&sender='+ AnsiUpperCase(PrismControl.NamePrefix) +'",');
  Add('       method: "POST",');
  Add('       data: formData,');
  Add('       processData: false,');
  Add('       contentType: false,');
  Add('       success: function () {');
  Add('       },');
  Add('       error: function () {');
  Add('       }');
  Add('     });');
  Add('   }, "image/png");');
  Add(' }');
  Add(' TakePicture();');
  Add('});');
 end;

 PrismControl.Session.ExecJS(vJS.Text);

 vJS.Free;
end;

end.