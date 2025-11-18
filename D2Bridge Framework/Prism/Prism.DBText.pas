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

unit Prism.DBText;

interface

{$IFNDEF FMX}
uses
  Classes, D2Bridge.JSON, SysUtils, DB,
  DBCtrls,
  Prism.Interfaces, Prism.Forms.Controls, Prism.Types, Prism.DataLink.Field;

type
 TPrismDBText = class(TPrismControl, IPrismDBText)
  private
   FRefreshData: Boolean;
   FStoredText: string;
   FDataType: TPrismFieldType;
   FDataLinkField: TPrismDataLinkField;
   FIsHTMLContent: Boolean;
   procedure UpdateData; override;
   procedure SetDataType(Value: TPrismFieldType);
   function GetDataType: TPrismFieldType;
   function GetIsHTMLContent: Boolean;
   procedure SetIsHTMLContent(const Value: Boolean);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function IsDBText: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function DataWare: TPrismDataLinkField;

   property DataType: TPrismFieldType read GetDataType write SetDataType;
   property IsHTMLContent: Boolean read GetIsHTMLContent write SetIsHTMLContent;
 end;


implementation

uses
  Prism.Util;

{ TPrismDBText }

constructor TPrismDBText.Create(AOwner: TObject);
begin
 inherited;

 FDataType:= PrismFieldTypeAuto;
 FRefreshData:= false;
 FDataLinkField:= TPrismDataLinkField.Create(Self);
 FDataLinkField.UseHTMLFormatSettings:= false;
 FIsHTMLContent:= false;
end;

function TPrismDBText.DataWare: TPrismDataLinkField;
begin
 result:= FDataLinkField;
end;

destructor TPrismDBText.Destroy;
begin
 FreeAndNil(FDataLinkField);

 inherited;
end;

function TPrismDBText.GetDataType: TPrismFieldType;
begin
 result:= FDataType;
end;

function TPrismDBText.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismDBText.GetIsHTMLContent: Boolean;
begin
 Result:= FIsHTMLContent;
end;

procedure TPrismDBText.Initialize;
begin
 inherited;

 FStoredText:= FDataLinkField.FieldText;
end;

function TPrismDBText.IsDBText: Boolean;
begin
 Result:= true;
end;

procedure TPrismDBText.ProcessComponentState(
  const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismDBText.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismDBText.ProcessHTML;
begin
 inherited;

 HTMLControl := '<span';
 HTMLControl := HTMLControl + ' ' + HTMLCore;
 HTMLControl := HTMLControl + '>';
 if FIsHTMLContent then
  HTMLControl := HTMLControl + FDataLinkField.ValueHTMLElement
 else
  HTMLControl := HTMLControl + FormatTextHTML(FDataLinkField.ValueHTMLElement);
 HTMLControl := HTMLControl + '</span>';
end;


procedure TPrismDBText.SetDataType(Value: TPrismFieldType);
begin
 FDataType:= Value;
end;

procedure TPrismDBText.SetIsHTMLContent(const Value: Boolean);
begin
 FIsHTMLContent:= Value;
end;

procedure TPrismDBText.UpdateData;
begin
 if (Form.FormPageState = PageStateLoaded) and (not Form.ComponentsUpdating) then
 FRefreshData:= true;
end;

procedure TPrismDBText.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 NewText: string;
begin
 inherited;

 NewText:= FDataLinkField.FieldText(AForceUpdate);
 if (FStoredText <> NewText) or (AForceUpdate) then
 begin
  FStoredText:= NewText;
  if FIsHTMLContent then
  begin
   //ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").value = "'+ FDataLinkField.ValueHTMLElement +'";');
   ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").innerHTML = `'+ FDataLinkField.ValueHTMLElement +'`;');
  end else
   ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").textContent = "'+ FDataLinkField.ValueHTMLElement +'";');
 end;

end;

{$ELSE}
implementation
{$ENDIF}

end.
