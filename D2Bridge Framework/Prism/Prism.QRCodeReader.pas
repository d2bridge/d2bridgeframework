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

unit Prism.QRCodeReader;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
{$IFDEF FMX}
  FMX.StdCtrls, FMX.Edit, FMX.Memo,
{$ELSE}
  StdCtrls, DBCtrls,
{$ENDIF}
{$IFDEF DEVEXPRESS_AVAILABLE}
  cxTextEdit, cxMemo, cxLabel, cxDBEdit, cxDBLabel,
{$ENDIF}
  D2Bridge.QRCodeReader.Image,
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types, D2Bridge.Forms;

type
 TPrismQRCodeReader = class(TPrismControl, IPrismQRCodeReader)
  private
   FBorderShaders: Boolean;
   FContinuousScan: Boolean;
   FD2BridgeImageQRCodeReader: TD2BridgeQRCodeReaderImage;
   FPressReturnKey: Boolean;
   FTextVCLComponent: TComponent;
   FEnableQRCODE: boolean;
   FEnableAZTEC: boolean;
   FEnableCODABAR: boolean;
   FEnableCODE39: boolean;
   FEnableCODE93: boolean;
   FEnableCODE128: boolean;
   FEnableDATAMATRIX: boolean;
   FEnableMAXICODE: boolean;
   FEnableITF: boolean;
   FEnableEAN13: boolean;
   FEnableEAN8: boolean;
   FEnablePDF417: boolean;
   FEnableRSS14: boolean;
   FEnableRSSEXPANDED: boolean;
   FEnableUPCA: boolean;
   FEnableUPCE: boolean;
   FEnableUPCEANEXTENSION: boolean;
   FOnRead: TNotifyEventStr;
   function GetTextVCLComponent: TComponent;
   procedure SetTextVCLComponent(AComponent: TComponent);
   function GetBorderShaders: Boolean;
   procedure SetBorderShaders(const Value: Boolean);
   function GetPressReturnKey: Boolean;
   procedure SetPressReturnKey(const Value: Boolean);
   procedure SetContinuousScan(const Value: Boolean);
   function GetContinuousScan: Boolean;
   function GetOnRead: TNotifyEventStr;
   procedure SetOnRead(const Value: TNotifyEventStr);
   function GetEnableAZTEC: boolean;
   function GetEnableCODABAR: boolean;
   function GetEnableCODE128: boolean;
   function GetEnableCODE39: boolean;
   function GetEnableCODE93: boolean;
   function GetEnableDATAMATRIX: boolean;
   function GetEnableEAN13: boolean;
   function GetEnableEAN8: boolean;
   function GetEnableITF: boolean;
   function GetEnableMAXICODE: boolean;
   function GetEnablePDF417: boolean;
   function GetEnableQRCODE: boolean;
   function GetEnableRSS14: boolean;
   function GetEnableRSSEXPANDED: boolean;
   function GetEnableUPCA: boolean;
   function GetEnableUPCE: boolean;
   function GetEnableUPCEANEXTENSION: boolean;
   procedure SetEnableAZTEC(const Value: boolean);
   procedure SetEnableCODABAR(const Value: boolean);
   procedure SetEnableCODE128(const Value: boolean);
   procedure SetEnableCODE39(const Value: boolean);
   procedure SetEnableCODE93(const Value: boolean);
   procedure SetEnableDATAMATRIX(const Value: boolean);
   procedure SetEnableEAN13(const Value: boolean);
   procedure SetEnableEAN8(const Value: boolean);
   procedure SetEnableITF(const Value: boolean);
   procedure SetEnableMAXICODE(const Value: boolean);
   procedure SetEnablePDF417(const Value: boolean);
   procedure SetEnableQRCODE(const Value: boolean);
   procedure SetEnableRSS14(const Value: boolean);
   procedure SetEnableRSSEXPANDED(const Value: boolean);
   procedure SetEnableUPCA(const Value: boolean);
   procedure SetEnableUPCE(const Value: boolean);
   procedure SetEnableUPCEANEXTENSION(const Value: boolean);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   procedure DoRead(EventParams: TStrings);
   function IsQRCodeReader: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;

   //procedure DoFormLoadComplete; override;

   property D2BridgeImageQRCodeReader: TD2BridgeQRCodeReaderImage read FD2BridgeImageQRCodeReader write FD2BridgeImageQRCodeReader;
   property TextVCLComponent: TComponent read GetTextVCLComponent write SetTextVCLComponent;

   procedure EnableAllCodesFormat;
   procedure DisableAllCodesFormat;

   property EnableQRCODE: boolean read GetEnableQRCODE write SetEnableQRCODE;
   property EnableAZTEC: boolean read GetEnableAZTEC write SetEnableAZTEC;
   property EnableCODABAR: boolean read GetEnableCODABAR write SetEnableCODABAR;
   property EnableCODE39: boolean read GetEnableCODE39 write SetEnableCODE39;
   property EnableCODE93: boolean read GetEnableCODE93 write SetEnableCODE93;
   property EnableCODE128: boolean read GetEnableCODE128 write SetEnableCODE128;
   property EnableDATAMATRIX: boolean read GetEnableDATAMATRIX write SetEnableDATAMATRIX;
   property EnableMAXICODE: boolean read GetEnableMAXICODE write SetEnableMAXICODE;
   property EnableITF: boolean read GetEnableITF write SetEnableITF;
   property EnableEAN13: boolean read GetEnableEAN13 write SetEnableEAN13;
   property EnableEAN8: boolean read GetEnableEAN8 write SetEnableEAN8;
   property EnablePDF417: boolean read GetEnablePDF417 write SetEnablePDF417;
   property EnableRSS14: boolean read GetEnableRSS14 write SetEnableRSS14;
   property EnableRSSEXPANDED: boolean read GetEnableRSSEXPANDED write SetEnableRSSEXPANDED;
   property EnableUPCA: boolean read GetEnableUPCA write SetEnableUPCA;
   property EnableUPCE: boolean read GetEnableUPCE write SetEnableUPCE;
   property EnableUPCEANEXTENSION: boolean read GetEnableUPCEANEXTENSION write SetEnableUPCEANEXTENSION;

   property ContinuousScan: Boolean read GetContinuousScan write SetContinuousScan;
   property PressReturnKey: Boolean read GetPressReturnKey write SetPressReturnKey;
   property BorderShaders: Boolean read GetBorderShaders write SetBorderShaders;

   property OnRead: TNotifyEventStr read GetOnRead write SetOnRead;
 end;

implementation

Uses
 Prism.Events;

{ TPrismQRCodeReader }

constructor TPrismQRCodeReader.Create(AOwner: TObject);
var
 EventRead: TPrismControlEvent;
begin
 inherited;

 EventRead := TPrismControlEvent.Create(self, EventOnRead);
 EventRead.AutoPublishedEvent:= false;
 EventRead.SetOnEvent(DoRead);
 Events.Add(EventRead);

 FContinuousScan:= true;
 FBorderShaders:= true;
 FPressReturnKey:= false;
 FEnableQRCODE:= true;
 FEnableAZTEC:= true;
 FEnableCODABAR:= true;
 FEnableCODE39:= true;
 FEnableCODE93:= true;
 FEnableCODE128:= true;
 FEnableDATAMATRIX:= true;
 FEnableMAXICODE:= true;
 FEnableITF:= true;
 FEnableEAN13:= true;
 FEnableEAN8:= true;
 FEnablePDF417:= true;
 FEnableRSS14:= true;
 FEnableRSSEXPANDED:= true;
 FEnableUPCA:= true;
 FEnableUPCE:= true;
 FEnableUPCEANEXTENSION:= true;
end;

function TPrismQRCodeReader.GetEnableAZTEC: boolean;
begin
 result:= FEnableAZTEC;
end;

function TPrismQRCodeReader.GetEnableCODABAR: boolean;
begin
 result:= FEnableCODABAR;
end;

function TPrismQRCodeReader.GetEnableCODE128: boolean;
begin
 result:= FEnableCODE128;
end;

function TPrismQRCodeReader.GetEnableCODE39: boolean;
begin
 result:= FEnableCODE39;
end;

function TPrismQRCodeReader.GetEnableCODE93: boolean;
begin
 result:= FEnableCODE93;
end;

function TPrismQRCodeReader.GetEnableComponentState: Boolean;
begin

end;

function TPrismQRCodeReader.GetEnableDATAMATRIX: boolean;
begin
 result:= FEnableDATAMATRIX;
end;

function TPrismQRCodeReader.GetEnableEAN13: boolean;
begin
 result:= FEnableEAN13;
end;

function TPrismQRCodeReader.GetEnableEAN8: boolean;
begin
 result:= FEnableEAN8;
end;

function TPrismQRCodeReader.GetEnableITF: boolean;
begin
 result:= FEnableITF;
end;

function TPrismQRCodeReader.GetEnableMAXICODE: boolean;
begin
 result:= FEnableMAXICODE;
end;

function TPrismQRCodeReader.GetEnablePDF417: boolean;
begin
 result:= FEnablePDF417;
end;

function TPrismQRCodeReader.GetEnableQRCODE: boolean;
begin
 result:= FEnableQRCODE;
end;

function TPrismQRCodeReader.GetEnableRSS14: boolean;
begin
 result:= FEnableRSS14;
end;

function TPrismQRCodeReader.GetEnableRSSEXPANDED: boolean;
begin
 result:= FEnableRSSEXPANDED;
end;

function TPrismQRCodeReader.GetEnableUPCA: boolean;
begin
 result:= FEnableUPCA;
end;

function TPrismQRCodeReader.GetEnableUPCE: boolean;
begin
 result:= FEnableUPCE;
end;

function TPrismQRCodeReader.GetEnableUPCEANEXTENSION: boolean;
begin
 result:= FEnableUPCEANEXTENSION;
end;

function TPrismQRCodeReader.GetTextVCLComponent: TComponent;
begin
 result:= FTextVCLComponent;
end;

procedure TPrismQRCodeReader.Initialize;
begin
  inherited;

end;

function TPrismQRCodeReader.IsQRCodeReader: Boolean;
begin
 result:= true;
end;

procedure TPrismQRCodeReader.DisableAllCodesFormat;
begin
 EnableQRCODE:= false;
 EnableAZTEC:= false;
 EnableCODABAR:= false;
 EnableCODE39:= false;
 EnableCODE93:= false;
 EnableCODE128:= false;
 EnableDATAMATRIX:= false;
 EnableMAXICODE:= false;
 EnableITF:= false;
 EnableEAN13:= false;
 EnableEAN8:= false;
 EnablePDF417:= false;
 EnableRSS14:= false;
 EnableRSSEXPANDED:= false;
 EnableUPCA:= false;
 EnableUPCE:= false;
 EnableUPCEANEXTENSION:= false;
end;

procedure TPrismQRCodeReader.DoRead(EventParams: TStrings);
var
 vBarCodeStr: string;
begin
 vBarCodeStr:= '';

 if Assigned(EventParams) then
  vBarCodeStr:= EventParams[0];

 if (vBarCodeStr <> '') then
 begin
  if FPressReturnKey then
   vBarCodeStr:= vBarCodeStr + sLineBreak;

  if Assigned(FTextVCLComponent) then
  begin
   if not FContinuousScan then
    D2BridgeImageQRCodeReader.Stop;

   if (TextVCLComponent is TLabel) //Label's
 {$IFDEF DEVEXPRESS_AVAILABLE}
    or (TextVCLComponent is TcxLabel)
    or (TextVCLComponent is TcxDBLabel)
 {$ENDIF}
 {$IFNDEF FMX} or (TextVCLComponent is TDBText){$ENDIF} then
    TLabel(TextVCLComponent).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}:= vBarCodeStr
   else
   if (TextVCLComponent is TEdit) //Edit's
 {$IFDEF DEVEXPRESS_AVAILABLE}
    or (TextVCLComponent is TcxTextEdit)
    or (TextVCLComponent is TcxDBTextEdit)
 {$ENDIF}
 {$IFNDEF FMX} or (TextVCLComponent is TDBEdit){$ENDIF} then
    TEdit(TextVCLComponent).Text:= vBarCodeStr
   else
   if (TextVCLComponent is TMemo) //Memo's
 {$IFDEF DEVEXPRESS_AVAILABLE}
    or (TextVCLComponent is TcxMemo)
    or (TextVCLComponent is TcxDBMemo)
 {$ENDIF}
 {$IFNDEF FMX} or (TextVCLComponent is TDBMemo){$ENDIF} then
    TMemo(TextVCLComponent).Text:= vBarCodeStr;
  end;

  if Assigned(FOnRead) then
   FOnRead(StringReplace(vBarCodeStr, sLineBreak, '', [rfReplaceAll]));
 end;
end;

procedure TPrismQRCodeReader.EnableAllCodesFormat;
begin
 EnableQRCODE:= true;
 EnableAZTEC:= true;
 EnableCODABAR:= true;
 EnableCODE39:= true;
 EnableCODE93:= true;
 EnableCODE128:= true;
 EnableDATAMATRIX:= true;
 EnableMAXICODE:= true;
 EnableITF:= true;
 EnableEAN13:= true;
 EnableEAN8:= true;
 EnablePDF417:= true;
 EnableRSS14:= true;
 EnableRSSEXPANDED:= true;
 EnableUPCA:= true;
 EnableUPCE:= true;
 EnableUPCEANEXTENSION:= true;
end;

function TPrismQRCodeReader.GetBorderShaders: Boolean;
begin
 Result := FBorderShaders;
end;

function TPrismQRCodeReader.GetContinuousScan: Boolean;
begin
 Result := FContinuousScan;
end;

function TPrismQRCodeReader.GetOnRead: TNotifyEventStr;
begin
 Result := FOnRead;
end;

function TPrismQRCodeReader.GetPressReturnKey: Boolean;
begin
 Result := FPressReturnKey;
end;

procedure TPrismQRCodeReader.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
  inherited;

end;

procedure TPrismQRCodeReader.ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismQRCodeReader.ProcessHTML;
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
//  Add('<div '+HTMLCore+'>');
  Add('<video '+HTMLCore+'>');
  Add('</video>');
//  Add('</div>');

  Add('<script>');

  Add('var '+AnsiUpperCase(NamePrefix)+'QRCodeReader = null;');
  Add('const '+AnsiUpperCase(NamePrefix)+'Element = document.getElementById("'+AnsiUpperCase(NamePrefix)+'");');
  //Add('const '+AnsiUpperCase(NamePrefix)+'videoElement = document.getElementById("'+AnsiUpperCase(NamePrefix)+'preview");');

  Add('function '+AnsiUpperCase(NamePrefix)+'onScanSuccess(decodedText, decodedResult) {');
  if Assigned(Events.Item(EventOnRead)) then
   Add(Events.Item(EventOnRead).EventJS(ExecEventProc, 'decodedText', false));
  Add('}');

  Add('function '+AnsiUpperCase(NamePrefix)+'onScanFailure(error) {');
  Add('}');

//  if FD2BridgeImageQRCodeReader.IsRectangular then
//   Add(AnsiUpperCase(NamePrefix)+'Element.style.height = Math.floor((('+AnsiUpperCase(NamePrefix)+'Element.offsetWidth / 16) * 9) * 0.40) + "px";')
//  else
//   Add(AnsiUpperCase(NamePrefix)+'Element.style.height = Math.floor(('+AnsiUpperCase(NamePrefix)+'Element.offsetWidth / 16) * 9) + "px";');

  Add('</script>');
 end;

 HTMLControl:= vHTMLContent.Text;

 vHTMLContent.Free;
end;

procedure TPrismQRCodeReader.SetBorderShaders(const Value: Boolean);
begin
 FBorderShaders := Value;
end;

procedure TPrismQRCodeReader.SetContinuousScan(const Value: Boolean);
begin
 FContinuousScan := Value;
end;

procedure TPrismQRCodeReader.SetEnableAZTEC(const Value: boolean);
begin
 FEnableAZTEC:= Value;
end;

procedure TPrismQRCodeReader.SetEnableCODABAR(const Value: boolean);
begin
 FEnableCODABAR:= Value;
end;

procedure TPrismQRCodeReader.SetEnableCODE128(const Value: boolean);
begin
 FEnableCODE128:= Value;
end;

procedure TPrismQRCodeReader.SetEnableCODE39(const Value: boolean);
begin
 FEnableCODE39:= Value;
end;

procedure TPrismQRCodeReader.SetEnableCODE93(const Value: boolean);
begin
 FEnableCODE93:= Value;
end;

procedure TPrismQRCodeReader.SetEnableDATAMATRIX(const Value: boolean);
begin
 FEnableDATAMATRIX:= Value;
end;

procedure TPrismQRCodeReader.SetEnableEAN13(const Value: boolean);
begin
 FEnableEAN13:= Value;
end;

procedure TPrismQRCodeReader.SetEnableEAN8(const Value: boolean);
begin
 FEnableEAN8:= Value;
end;

procedure TPrismQRCodeReader.SetEnableITF(const Value: boolean);
begin
 FEnableITF:= Value;
end;

procedure TPrismQRCodeReader.SetEnableMAXICODE(const Value: boolean);
begin
 FEnableMAXICODE:= Value;
end;

procedure TPrismQRCodeReader.SetEnablePDF417(const Value: boolean);
begin
 FEnablePDF417:= Value;
end;

procedure TPrismQRCodeReader.SetEnableQRCODE(const Value: boolean);
begin
 FEnableQRCODE:= Value;
end;

procedure TPrismQRCodeReader.SetEnableRSS14(const Value: boolean);
begin
 FEnableRSS14:= Value;
end;

procedure TPrismQRCodeReader.SetEnableRSSEXPANDED(const Value: boolean);
begin
 FEnableRSSEXPANDED:= Value;
end;

procedure TPrismQRCodeReader.SetEnableUPCA(const Value: boolean);
begin
 FEnableUPCA:= Value;
end;

procedure TPrismQRCodeReader.SetEnableUPCE(const Value: boolean);
begin
 FEnableUPCE:= Value;
end;

procedure TPrismQRCodeReader.SetEnableUPCEANEXTENSION(const Value: boolean);
begin
 FEnableUPCEANEXTENSION:= Value;
end;

procedure TPrismQRCodeReader.SetOnRead(const Value: TNotifyEventStr);
begin
 FOnRead := Value;
end;

procedure TPrismQRCodeReader.SetPressReturnKey(const Value: Boolean);
begin
 FPressReturnKey := Value;
end;

procedure TPrismQRCodeReader.SetTextVCLComponent(AComponent: TComponent);
begin
 FTextVCLComponent:= AComponent;
end;

procedure TPrismQRCodeReader.UpdateServerControls(var ScriptJS: TStrings;
  AForceUpdate: Boolean);
begin
  inherited;

end;

end.
