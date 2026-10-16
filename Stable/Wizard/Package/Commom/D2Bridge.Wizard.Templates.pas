{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  Copyright (c) 2024 Talis Jonatas Gomes - talisjonatas@me.com
  Intellectual property of computer programs protected by international and
  brazilian (9.609/1998) laws.
  Software licensed under "opensource" license.

  Rules:
  Everone is permitted to copy and distribute verbatim copies of this license
  document, but changing it is not allowed.

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

unit D2Bridge.Wizard.Templates;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFDEF FPC}
 Generics.Collections, fpjson, jsonparser,
{$ELSE}
 System.Generics.Collections, System.JSON,
{$ENDIF}
 SysUtils, Variants, Classes;

type
 TD2BridgeTemplate = class;
 TD2BridgeTemplates = class;


 TD2BridgeTemplate = class
  strict private
   FName: String;
   FVersion: String;
   FSite: String;
   FLicence: String;
   FDescription: String;
   FPathImage: String;
   FMasterPageHTML: String;
   FPageHTML: String;
   FFilePath: String;
   FPathCSS: String;
   FPathJS: String;
   FMessageOnSelect: String;
   FZipped: Boolean;
  public
   property Name: String read FName write FName;
   property Version: String read FVersion write FVersion;
   property Site: String read FSite write FSite;
   property Licence: String read FLicence write FLicence;
   property Description: String read FDescription write FDescription;
   property PathImage: String read FPathImage write FPathImage;
   property MasterPageHTML: String read FMasterPageHTML write FMasterPageHTML;
   property PageHTML: String read FPageHTML write FPageHTML;
   property TemplateFilePath: String read FFilePath write FFilePath;
   property TemplatePathCSS: String read FPathCSS write FPathCSS;
   property TemplatePathJS: String read FPathJS write FPathJS;
   property MessageOnSelectTemplate: String read FMessageOnSelect write FMessageOnSelect;
   property Zipped: Boolean read FZipped write FZipped;
 end;


 { TD2BridgeTemplates }

 TD2BridgeTemplates = class
  private
   FTemplateJSONArray: TJSONArray;
   FItems: TList<TD2BridgeTemplate>;
   procedure CreateList;
  public
   property Items: TList<TD2BridgeTemplate> read FItems write FItems;

   constructor Create(TemplateJSONArray: TJSONArray);
   destructor Destroy; override;
 end;

implementation


{ TD2BridgeTemplates }

constructor TD2BridgeTemplates.Create(TemplateJSONArray: TJSONArray);
begin
 inherited Create;

 FItems:= TList<TD2BridgeTemplate>.Create;

 FTemplateJSONArray:= TemplateJSONArray;

 CreateList;
end;

destructor TD2BridgeTemplates.Destroy;
begin
 FItems.Free;
 inherited Destroy;
end;

procedure TD2BridgeTemplates.CreateList;
var
 I: Integer;
 vZippedStr: string;
begin
 //----- NONE
 FItems.Add(TD2BridgeTemplate.Create);
 with FItems.Last do
 begin
  Name:= 'None';
  Version:= '1.0';
  Site:= '';
  Licence:= 'Open Source (Embedded)';
  Description:= 'D2Bridge Framework create one Form example with 3 Labels and export to Web';
  PathImage:=  StringReplace('img\Template\None.png', '\', PathDelim, [rfReplaceAll]);
  TemplateFilePath:= '';
  MasterPageHTML:= '';
  PageHTML:= '';
  TemplatePathCSS:= '';
  TemplatePathJS:= '';
  MessageOnSelectTemplate:= '';
 end;


 for I := 0 to Pred(FTemplateJSONArray.Count) do
 begin
  FItems.Add(TD2BridgeTemplate.Create);
  with FItems.Last do
  begin
   Name:= TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('Name', '');
   Version:= TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('Version', '');
   Site:= TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('Site', '');
   Licence:= TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('Licence', '');
   Description:= TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('Description', '');
   PathImage:= StringReplace(TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('PathImage', ''), '\', PathDelim, [rfReplaceAll]);
   TemplateFilePath:= StringReplace(TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('TemplateFilePath', ''), '\', PathDelim, [rfReplaceAll]);
   vZippedStr:= TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('Zipped', 'false');
   Zipped:= SameText(vZippedStr, 'true');
   MasterPageHTML:= TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('MasterPageHTML', '');
   PageHTML:=  TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('PageHTML', '');
   TemplatePathCSS:= StringReplace(TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('PathCSS', ''), '\', PathDelim, [rfReplaceAll]);
   TemplatePathJS:= StringReplace(TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('PathJS', ''), '\', PathDelim, [rfReplaceAll]);
   MessageOnSelectTemplate:= TJSONObject(FTemplateJSONArray.Items[I]).{$IFDEF FPC}Get{$ELSE}GetValue{$ENDIF}('Message On Select', '');
  end;
 end;

end;

end.
