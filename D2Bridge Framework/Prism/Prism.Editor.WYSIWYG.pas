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

unit Prism.Editor.WYSIWYG;

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
 TPrismWYSIWYGEditor = class(TPrismEditor, IPrismWYSIWYGEditor)
  private
   FAirMode: Boolean;
   FShowButtonColor: Boolean;
   FShowButtonFontName: Boolean;
   FShowButtonFontSize: Boolean;
   FShowButtonHTMLPreview: Boolean;
   FShowButtonUnderline: Boolean;
   FShowButtonVideo: Boolean;
   function GetAirMode: Boolean;
   function GetShowButtonColor: Boolean;
   function GetShowButtonFontName: Boolean;
   function GetShowButtonFontSize: Boolean;
   function GetShowButtonHTMLPreview: Boolean;
   function GetShowButtonUnderline: Boolean;
   function GetShowButtonVideo: Boolean;
   procedure SetAirMode(const Value: Boolean);
   procedure SetShowButtonColor(const Value: Boolean);
   procedure SetShowButtonFontName(const Value: Boolean);
   procedure SetShowButtonFontSize(const Value: Boolean);
   procedure SetShowButtonHTMLPreview(const Value: Boolean);
   procedure SetShowButtonUnderline(const Value: Boolean);
   procedure SetShowButtonVideo(const Value: Boolean);
   function RenderWYSIWYGHTML: string;
  protected
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   function IsWYSIWYGEditor: boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   property AirMode: Boolean read GetAirMode write SetAirMode;
   property ShowButtonColor: Boolean read GetShowButtonColor write SetShowButtonColor;
   property ShowButtonFontName: Boolean read GetShowButtonFontName write SetShowButtonFontName;
   property ShowButtonFontSize: Boolean read GetShowButtonFontSize write SetShowButtonFontSize;
   property ShowButtonHTMLPreview: Boolean read GetShowButtonHTMLPreview write SetShowButtonHTMLPreview;
   property ShowButtonUnderline: Boolean read GetShowButtonUnderline write SetShowButtonUnderline;
   property ShowButtonVideo: Boolean read GetShowButtonVideo write SetShowButtonVideo;
 end;

implementation

Uses
 D2Bridge.Util, Prism.Util;

{ TPrismWYSIWYGEditor }

constructor TPrismWYSIWYGEditor.Create(AOwner: TObject);
begin
 inherited;

 FAirMode:= false;
 FShowButtonColor:= True;
 FShowButtonFontName:= True;
 FShowButtonFontSize:= True;
 FShowButtonHTMLPreview:= True;
 FShowButtonUnderline:= True;
 FShowButtonVideo:= True;

 ShowButtonHelp:= false;
end;

destructor TPrismWYSIWYGEditor.Destroy;
begin

 inherited;
end;

function TPrismWYSIWYGEditor.GetAirMode: Boolean;
begin
 Result := FAirMode;
end;

function TPrismWYSIWYGEditor.GetShowButtonColor: Boolean;
begin
 Result := FShowButtonColor;
end;

function TPrismWYSIWYGEditor.GetShowButtonFontName: Boolean;
begin
 Result := FShowButtonFontName;
end;

function TPrismWYSIWYGEditor.GetShowButtonFontSize: Boolean;
begin
 Result := FShowButtonFontSize;
end;

function TPrismWYSIWYGEditor.GetShowButtonHTMLPreview: Boolean;
begin
 Result := FShowButtonHTMLPreview;
end;

function TPrismWYSIWYGEditor.GetShowButtonUnderline: Boolean;
begin
 Result := FShowButtonUnderline;
end;

function TPrismWYSIWYGEditor.GetShowButtonVideo: Boolean;
begin
 Result := FShowButtonVideo;
end;

function TPrismWYSIWYGEditor.IsWYSIWYGEditor: boolean;
begin
 result:= true;
end;

procedure TPrismWYSIWYGEditor.ProcessHTML;
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
  Add('<div '+HTMLCore+' divwysiwygeditor>');
  Add('<div class="textareawysiwygeditor ' + IfThen(not Self.Visible, 'invisible') + '" id="'+AnsiUpperCase(NamePrefix)+'PREVIEW">');
  Add('</div>');
  Add('<script>');
  Add('let _'+AnsiUpperCase(NamePrefix)+'PREVIEW = document.getElementById("' + AnsiUpperCase(NamePrefix)+'PREVIEW' + '");');
  Add('let _'+AnsiUpperCase(NamePrefix)+'ELEMENT = null;');
  Add(RenderWYSIWYGHTML);

  Add('function '+AnsiUpperCase(NamePrefix)+'sendFile(file) {');
  Add('    let data = new FormData();');
  Add('    data.append("upload", file);');
  Add('');
  Add('    $.ajax({');
  Add('        url: "/d2bridge/upload?token='+ vToken +'&formuuid='+ vFormUUID +'&prismsession='+ vUUID +'&origin=editor'+'&sender='+ Uppercase(NamePrefix) +'",');
  Add('        data: data,');
  Add('        cache: false,');
  Add('        contentType: false,');
  Add('        processData: false,');
  Add('        type: "POST",');
  Add('        success: function(data) {');
  Add('            _'+AnsiUpperCase(NamePrefix)+'ELEMENT.summernote("editor.restoreRange");');
  Add('            _'+AnsiUpperCase(NamePrefix)+'ELEMENT.summernote("editor.pasteHTML", "<br>");');
  Add('            _'+AnsiUpperCase(NamePrefix)+'ELEMENT.summernote("editor.restoreRange");');
  Add('            _'+AnsiUpperCase(NamePrefix)+'ELEMENT.summernote("insertImage", JSON.parse(data).data.filePath);');
  Add('        },');
  Add('        error: function(jqXHR, textStatus, errorThrown) {');
  Add('            console.log(textStatus + " " + errorThrown);');
  Add('        },');
  Add('    });');
  Add('}');
  Add('</script>');
  Add('</div>');
 end;


 HTMLControl:= vHTMLContent.Text;

 vHTMLContent.Free;
end;

function TPrismWYSIWYGEditor.RenderWYSIWYGHTML: string;
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
  if Enabled then
  begin
   Add('$(document).ready(function() {');
   Add('_' + AnsiUpperCase(NamePrefix)+'PREVIEW' + '.innerHTML = ""');
   Add('_'+AnsiUpperCase(NamePrefix)+'ELEMENT = ');
   Add('  $("#'+AnsiUpperCase(NamePrefix)+'PREVIEW").summernote({');
   if FAirMode then
    Add('    airMode: true,');
   Add('    placeholder: "' + Placeholder + '",');
   Add('    prettifyHtml:false,');
   if Height > 0 then
    Add('    height: ' + IntToStr(Height) + ',');
   if FAirMode then
   begin
    Add('      popover: {');
    Add('       air: [');
   end else
    Add('      toolbar: [');
   Add('        ["style", ["style", "clear"]],');
   Add('        ["font", [');
   if ShowButtonBold then
    Add('          "bold",');
   if ShowButtonItalic then
    Add('          "italic",');
   if ShowButtonUnderline then
    Add('          "underline",');
   if ShowButtonStrikethrough then
    Add('          "strikethrough",');
   if ShowButtonFontName then
    Add('          "fontname",');
   if ShowButtonFontSize then
    Add('          "fontsize",');
   Add('          "paragraph"');
   Add('        ]],');
   if ShowButtonColor then
    Add('        ["color", ["color"]],');
   Add('        ["para", [');
   if ShowButtonNumList then
   Add('          "ul",');
   if ShowButtonList then
   Add('          "ol"');
   Add('        ]],');
   if ShowButtonTable then
    Add('        ["table", ["table"]],');
   Add('        ["insert", [');
   if ShowButtonLink then
    Add('            "link",');
   if ShowButtonImage then
    Add('            "picture",');
   if ShowButtonVideo then
    Add('            "video"');
   Add('       ]],');
   if ShowButtonCode then
    Add('        ["highlight", ["highlight"]],');
   Add('        ["view", [');
   if ShowButtonFullScrean then
    Add('              "fullscreen",');
   if ShowButtonHTMLPreview then
    Add('              "codeview",');
   if ShowButtonHelp then
    Add('              "help"');
    Add('       ]]');
   if FAirMode then
   begin
    Add('      ]');
    Add('     },');
   end else
    Add('      ],');
   Add('      focus: false,');
   //Focus Event
   Add('      callbacks: {');
   Add('       onBlur: function() {');
   add('         PrismServer().ExecEvent("'+Session.UUID+'", "'+ Session.Token +'", "'+ vFormUUID +'", "' + vFormUUID + '", "'+ 'ComponentFocused' + '", "PrismComponentsStatus=" + GetComponentsStates(PrismComponents.filter(item => item.id === "' + AnsiUpperCase(NamePrefix) + '")) + "&" + "FocusedID=' + AnsiUpperCase(NamePrefix) + '", false);');
   add('       },');
   Add('       onFocus: function() {');
//   add('         focusedElement = document.getElementById("' + AnsiUpperCase(NamePrefix) + '");');
//   add('         PrismServer().ExecEvent("'+Session.UUID+'", "'+ Session.Token +'", "'+ vFormUUID +'", "' + vFormUUID + '", "'+ 'ComponentFocused' + '", "PrismComponentsStatus=" + GetComponentsStates(PrismComponents.filter(item => item.id === "' + AnsiUpperCase(NamePrefix) + '")) + "&" + "FocusedID=' + AnsiUpperCase(NamePrefix) + '", false);');
   add('       },');
   Add('       onImageUpload: function(files) {');
   Add('         for (var i = files.length - 1; i >= 0; i--) {');
   Add('          '+AnsiUpperCase(NamePrefix)+'sendFile(files[i]);');
   Add('         }');
   Add('       },');
   add('      },');
   Add('  });');
   //Content
   Add('  _'+AnsiUpperCase(NamePrefix)+'ELEMENT.summernote("code", '+ FormatValueHTML(FStoredText) +'.replace(/\r?\n/g, "<br>"));');
   //Save instance
   Add('  prismobjs["_'+AnsiUpperCase(NamePrefix)+'ELEMENT"] = _'+AnsiUpperCase(NamePrefix)+'ELEMENT;');
   Add('});');
  end else
  begin
   Add('_' + AnsiUpperCase(NamePrefix)+'PREVIEW' + '.innerHTML = ' + FormatValueHTML(FStoredText));
  end;
 end;

 result:= vHTMLContent.Text;

 vHTMLContent.Free;
end;

procedure TPrismWYSIWYGEditor.SetAirMode(const Value: Boolean);
begin
 FAirMode := Value;
end;

procedure TPrismWYSIWYGEditor.SetShowButtonColor(const Value: Boolean);
begin
 FShowButtonColor := Value;
end;

procedure TPrismWYSIWYGEditor.SetShowButtonFontName(const Value: Boolean);
begin
 FShowButtonFontName := Value;
end;

procedure TPrismWYSIWYGEditor.SetShowButtonFontSize(const Value: Boolean);
begin
 FShowButtonFontSize := Value;
end;

procedure TPrismWYSIWYGEditor.SetShowButtonHTMLPreview(const Value: Boolean);
begin
 FShowButtonHTMLPreview := Value;
end;

procedure TPrismWYSIWYGEditor.SetShowButtonUnderline(const Value: Boolean);
begin
 FShowButtonUnderline := Value;
end;

procedure TPrismWYSIWYGEditor.SetShowButtonVideo(const Value: Boolean);
begin
 FShowButtonVideo := Value;
end;

procedure TPrismWYSIWYGEditor.UpdateServerControls(var ScriptJS: TStrings;
  AForceUpdate: Boolean);
var
 vNewText: string;
 vNewEnabled: Boolean;
begin
 vNewText:= Text;
 vNewEnabled:= Enabled;

 if FStoredText <> vNewText then
 begin
  FStoredText := vNewText;

  if FStoredEnabled then
  begin
   ScriptJS.Add('_'+AnsiUpperCase(NamePrefix)+'ELEMENT.summernote("code", '+ FormatValueHTML(FStoredText) +'.replace(/\r?\n/g, "<br>"));');
  end else
  begin
   ScriptJS.Add('_' + AnsiUpperCase(NamePrefix)+'PREVIEW' + '.innerHTML = ' + FormatValueHTML(FStoredText));
  end;
 end;

 if FStoredEnabled <> vNewEnabled then
 begin
  if not vNewEnabled then
  begin
   ScriptJS.Add('_'+AnsiUpperCase(NamePrefix)+'ELEMENT.summernote("destroy");');
  end else
  begin
   ScriptJS.Add(RenderWYSIWYGHTML);
  end;
 end;

 inherited;
end;

end.
