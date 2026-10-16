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

unit Prism.Editor.MarkDown;

interface

uses
 Classes, SysUtils, Types, StrUtils, D2Bridge.JSON,
{$IFDEF FMX}
  FMX.StdCtrls, FMX.Edit, FMX.Memo,
{$ELSE}
  StdCtrls, DBCtrls,
{$ENDIF}
{$IFDEF DEVEXPRESS_AVAILABLE}
 cxTextEdit, cxMemo, cxLabel, cxDBEdit, cxDBLabel,
{$ENDIF}
 Prism.Forms.Controls, Prism.Interfaces, Prism.Types,
 Prism.Editor;

type
 TPrismMarkDownEditor = class(TPrismEditor, IPrismMarkDownEditor)
  private
   FShowButtonPreview: Boolean;
   FShowButtonQuote: Boolean;
   FShowButtonSplit: Boolean;
   FShowButtonUpload: Boolean;
   function GetShowButtonPreview: Boolean;
   function GetShowButtonQuote: Boolean;
   function GetShowButtonSplit: Boolean;
   function GetShowButtonUpload: Boolean;
   procedure SetShowButtonPreview(const Value: Boolean);
   procedure SetShowButtonQuote(const Value: Boolean);
   procedure SetShowButtonSplit(const Value: Boolean);
   procedure SetShowButtonUpload(const Value: Boolean);
  protected
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;

   function IsMarkDownEditor: boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   property ShowButtonPreview: Boolean read GetShowButtonPreview write SetShowButtonPreview;
   property ShowButtonQuote: Boolean read GetShowButtonQuote write SetShowButtonQuote;
   property ShowButtonSplit: Boolean read GetShowButtonSplit write SetShowButtonSplit;
   property ShowButtonUpload: Boolean read GetShowButtonUpload write SetShowButtonUpload;
 end;

implementation

Uses
 Prism.Util, Prism.Forms;

{ TPrismMarkDownEditor }

constructor TPrismMarkDownEditor.Create(AOwner: TObject);
begin
 inherited;

 FShowButtonPreview:= true;
 FShowButtonQuote:= true;
 FShowButtonSplit:= true;
 FShowButtonUpload:= true;
end;

destructor TPrismMarkDownEditor.Destroy;
begin
 inherited;
end;

function TPrismMarkDownEditor.GetShowButtonPreview: Boolean;
begin
 Result := FShowButtonPreview;
end;

function TPrismMarkDownEditor.GetShowButtonQuote: Boolean;
begin
 Result := FShowButtonQuote;
end;

function TPrismMarkDownEditor.GetShowButtonSplit: Boolean;
begin
 Result := FShowButtonSplit;
end;

function TPrismMarkDownEditor.GetShowButtonUpload: Boolean;
begin
 Result := FShowButtonUpload;
end;

function TPrismMarkDownEditor.IsMarkDownEditor: boolean;
begin
 result:= true;
end;

procedure TPrismMarkDownEditor.ProcessHTML;
var
 vHTMLContent: TStrings;
 vUUID, vToken, vFormUUID: String;
begin
 vUUID:= Session.UUID;
 vToken:= Session.Token;
 vFormUUID:= Form.FormUUID;

 vHTMLContent:= TStringList.Create;

 with vHTMLContent do
 begin
  Add('<div '+HTMLCore+' divmarkdowneditor>');
  Add('<textarea class="textareamarkdowneditor ' + IfThen(not Self.Enabled, 'invisible') + '" id="'+AnsiUpperCase(NamePrefix)+'TEXTAREA">');
  Add('</textarea>');
  Add('<div class="markdowneditorpreview editor-preview" id="'+AnsiUpperCase(NamePrefix)+'PREVIEW" ' + IfThen(Self.Enabled, 'invisible') + ' for="'+AnsiUpperCase(NamePrefix)+'TEXTAREA">');
  Add('</div>');
  Add('<script>');
  Add('let _'+AnsiUpperCase(NamePrefix)+'PREVIEW = document.getElementById("' + AnsiUpperCase(NamePrefix)+'PREVIEW' + '");');
  Add('let _'+AnsiUpperCase(NamePrefix)+'ELEMENT = null;');
  Add('_' + AnsiUpperCase(NamePrefix)+'PREVIEW' + '.innerHTML = ""');
  Add('_'+AnsiUpperCase(NamePrefix)+'ELEMENT = new EasyMDE({');
  Add(' element: document.getElementById("'+AnsiUpperCase(NamePrefix)+'TEXTAREA"),');
  Add(' autosave: {');
  Add('  enabled: false,');
  Add(' },');
  Add(' renderingConfig: {');
  Add('  singleLineBreaks: true,');
  Add('  codeSyntaxHighlighting: true,');
  Add(' },');
  if Height > 0 then
   Add(' maxHeight: "' + IntToStr(Height) + 'px",');
  Add(' toolbar: [');
  if ShowButtonBold then
   Add('   "bold",');
  if ShowButtonItalic then
   Add('   "italic",');
  if ShowButtonHeading then
   Add('   "heading",');
  if ShowButtonStrikethrough then
   Add('   "strikethrough",');
  Add('   "|",');
  if ShowButtonCode then
   Add('   "code",');
  if FShowButtonQuote then
   Add('   "quote",');
  if ShowButtonList then
   Add('   "unordered-list",');
  if ShowButtonNumList then
   Add('   "ordered-list",');
  Add('   "|",');
  if ShowButtonRule then
   Add('   "horizontal-rule",');
  if ShowButtonLink then
   Add('   "link",');
  if ShowButtonImage then
   Add('   "image",');
  if FShowButtonUpload then
  begin
   Add('   {');
   Add('     name: "upload-image",');
   Add('     action: EasyMDE.drawUploadedImage,');
   Add('     className: "fa fa-upload",');
   Add('     title: "Upload File and Image"');
   Add('   },');
  end;
  if ShowButtonTable then
   Add('   "table",');
  Add('   "|",');
  if FShowButtonPreview then
   Add('   "preview",');
  if FShowButtonSplit then
   Add('   "side-by-side",');
  if ShowButtonFullScrean then
   Add('   "fullscreen",');
  Add('   "|",');
  if ShowButtonHelp then
   Add('   "guide"');
  Add(' ],');
  Add(' spellChecker: false,');
  Add(' status: [],');
  Add(' styleSelectedText: true,');
  Add(' sideBySideFullscreen: false,');
  Add(' syncSideBySidePreviewScroll: false,');
  Add(' toolbarButtonClassPrefix: "d2bridgemdbt",');
  if FShowButtonUpload then
   Add(' uploadImage: true,');
  Add(' imageUploadEndpoint: appBaseD2Bridge + "/d2bridge/upload?token='+ vToken +'&formuuid='+ vFormUUID +'&prismsession='+ vUUID +'&origin=editor'+'&sender='+ Uppercase(NamePrefix) +'",');
  if Session.LangNav.Language.IsRTL then
   Add(' direction: "rtl",');
  Add('});');

  //Save instance
  Add('prismobjs["_'+AnsiUpperCase(NamePrefix)+'ELEMENT"] = _'+AnsiUpperCase(NamePrefix)+'ELEMENT;');

  Add('_'+AnsiUpperCase(NamePrefix)+'ELEMENT.value('+ FormatValueHTML(FStoredText) +');');

  //Container
  Add('_'+AnsiUpperCase(NamePrefix)+'CONTAINER = document.getElementById("'+AnsiUpperCase(NamePrefix)+'").getElementsByClassName("EasyMDEContainer")[0];');

  if not Self.Enabled then
  begin
   Add('_'+AnsiUpperCase(NamePrefix)+'CONTAINER.classList.add("invisible");');
   Add('_' + AnsiUpperCase(NamePrefix)+'PREVIEW' + '.innerHTML = _'+AnsiUpperCase(NamePrefix)+'ELEMENT.options.previewRender(_'+AnsiUpperCase(NamePrefix)+'ELEMENT.value());');
  end;

  //Focus
  Add('_'+AnsiUpperCase(NamePrefix)+'ELEMENT.codemirror.on("focus", () => {');
  add(' focusedElement = document.getElementById("' + AnsiUpperCase(NamePrefix) + '");');
  add(' PrismServer().ExecEvent("'+Session.UUID+'", "'+ Session.Token +'", "'+ vFormUUID +'", "' + vFormUUID + '", "'+ 'ComponentFocused' + '", "PrismComponentsStatus=" + GetComponentsStates(PrismComponents.filter(item => item.id === "' + AnsiUpperCase(NamePrefix) + '")) + "&" + "FocusedID=' + AnsiUpperCase(NamePrefix) + '", false);');
  Add('});');

  //Blur
  Add('_'+AnsiUpperCase(NamePrefix)+'ELEMENT.codemirror.on("blur", () => {');
  add(' PrismServer().ExecEvent("'+Session.UUID+'", "'+ Session.Token +'", "'+ vFormUUID +'", "' + vFormUUID + '", "'+ 'ComponentFocused' + '", "PrismComponentsStatus=" + GetComponentsStates(PrismComponents.filter(item => item.id === "' + AnsiUpperCase(NamePrefix) + '")) + "&" + "FocusedID=' + AnsiUpperCase(NamePrefix) + '", false);');
  Add('});');

  Add('</script>');
  Add('</div>');
 end;

 HTMLControl:= vHTMLContent.Text;

 vHTMLContent.Free;
end;

procedure TPrismMarkDownEditor.SetShowButtonPreview(const Value: Boolean);
begin
 FShowButtonPreview := Value;
end;

procedure TPrismMarkDownEditor.SetShowButtonQuote(const Value: Boolean);
begin
 FShowButtonQuote := Value;
end;

procedure TPrismMarkDownEditor.SetShowButtonSplit(const Value: Boolean);
begin
 FShowButtonSplit := Value;
end;

procedure TPrismMarkDownEditor.SetShowButtonUpload(const Value: Boolean);
begin
 FShowButtonUpload := Value;
end;

procedure TPrismMarkDownEditor.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
var
 vNewText: string;
 vNewEnabled: Boolean;
begin
 vNewText:= Text;
 if FStoredText <> vNewText then
 begin
  FStoredText := vNewText;

  ScriptJS.Add('_'+AnsiUpperCase(NamePrefix)+'ELEMENT.value(' + FormatValueHTML(vNewText) + ');');
  ScriptJS.Add('_' + AnsiUpperCase(NamePrefix)+'PREVIEW' + '.innerHTML = _'+AnsiUpperCase(NamePrefix)+'ELEMENT.options.previewRender(_'+AnsiUpperCase(NamePrefix)+'ELEMENT.value());');
 end;


 vNewEnabled:= Enabled;
 if FStoredEnabled <> vNewEnabled then
 begin
  if not vNewEnabled then
  begin
   ScriptJS.Add('_'+AnsiUpperCase(NamePrefix)+'CONTAINER.classList.add("invisible");');
   ScriptJS.Add('_'+AnsiUpperCase(NamePrefix)+'PREVIEW.classList.remove("invisible");');

   ScriptJS.Add('_' + AnsiUpperCase(NamePrefix)+'PREVIEW' + '.innerHTML = _'+AnsiUpperCase(NamePrefix)+'ELEMENT.options.previewRender(_'+AnsiUpperCase(NamePrefix)+'ELEMENT.value());');
  end else
  begin
   ScriptJS.Add('_'+AnsiUpperCase(NamePrefix)+'CONTAINER.classList.remove("invisible");');
   ScriptJS.Add('_'+AnsiUpperCase(NamePrefix)+'PREVIEW.classList.add("invisible");');

   ScriptJS.Add('_' + AnsiUpperCase(NamePrefix)+'PREVIEW' + '.innerHTML = "";');
   ScriptJS.Add('_'+AnsiUpperCase(NamePrefix)+'ELEMENT.value(_'+AnsiUpperCase(NamePrefix)+'ELEMENT.value());');
  end;
 end;

 inherited;
end;

end.