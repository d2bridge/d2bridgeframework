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

{$I D2Bridge.inc}

unit D2Bridge.Item.HTML.Upload;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Interfaces;


type
  TReaderNotify = procedure of object;

  TD2BridgeItemHTMLUpload = class(TD2BridgeItem, ID2BridgeItemHTMLInput)
  private
   FBaseClass: TD2BridgeClass;
   FD2BridgeItem: TD2BridgeItem;
   FOnBeginReader: TReaderNotify;
   FOnEndReader: TReaderNotify;
   FCaptionUpload: String;
   FMaxFiles: Integer;
   FRenderized: Boolean;
   FAllowedFileTypes: TStrings;
   FMaxFileSize: integer;
   FMaxUploadSize: integer;
   FInputVisible: Boolean;
   FCSSInput: String;
   FCSSButtonClear: String;
   FCSSButtonUpload: String;
   FIconButtonClear: String;
   FIconButtonUpload: String;
   FShowFinishMessage: Boolean;
   function GetCaptionUpload: string;
   procedure SetCaptionUpload(ACaptionUpload: string);
   function GetMaxFiles: integer;
   procedure SetMaxFiles(AValue: Integer);
   function AllowedFileTypesToJSVar: string;
   function AllowedFileTypesToInput: string;
   function MaxFilesToInput: String;
   function GetMaxFileSize: integer;
   function GetMaxUploadSize: integer;
   procedure SetMaxFileSize(const Value: integer);
   procedure SetMaxUploadSize(const Value: integer);
   function GetInputVisible: Boolean;
   procedure SetInputVisible(const Value: Boolean);
   procedure SetCSSInput(AValue: string);
   function GetCSSInput: String;
   procedure SetCSSButtonClear(AValue: string);
   function GetCSSButtonClear: String;
   procedure SetCSSButtonUpload(AValue: string);
   function GetCSSButtonUpload: String;
   procedure SetIconButtonUpload(AValue: string);
   function GetIconButtonUpload: String;
   procedure SetIconButtonClear(AValue: string);
   function GetIconButtonClear: String;
   function GetShowFinishMessage: Boolean;
   procedure SetShowFinishMessage(const Value: Boolean);
  protected

  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   function AllowedFileTypes: TStrings;
  published
   property BaseClass: TD2BridgeClass read FBaseClass;
   property Renderized: boolean read FRenderized write FRenderized;
   property ItemID: string read GetItemID write SetItemID;
   property ItemPrefixID: string read GetItemPrefixID;
   property CaptionUpload: string read GetCaptionUpload write SetCaptionUpload;
   property MaxFiles: Integer read GetMaxFiles write SetMaxFiles;
   property MaxUploadSize: integer read GetMaxUploadSize write SetMaxUploadSize;
   property MaxFileSize: integer read GetMaxFileSize write SetMaxFileSize;
   property InputVisible: Boolean read GetInputVisible write SetInputVisible;
   property ShowFinishMessage: Boolean read GetShowFinishMessage write SetShowFinishMessage;
   property CSSInput: string read GetCSSInput write SetCSSInput;
   property CSSButtonClear: string read GetCSSButtonClear write SetCSSButtonClear;
   property CSSButtonUpload: string read GetCSSButtonUpload write SetCSSButtonUpload;
   property IconButtonClear: string read GetIconButtonClear write SetIconButtonClear;
   property IconButtonUpload: string read GetIconButtonUpload write SetIconButtonUpload;
   property OnBeginReader: TReaderNotify read FOnBeginReader write FOnBeginReader;
   property OnEndReader: TReaderNotify read FOnEndReader write FOnEndReader;
  end;



implementation

uses
  Prism.Forms.Controls,
  Prism.Session, Prism.ControlGeneric,
  D2Bridge.Forms;


{ TD2BridgeItemHTMLUpload }

function TD2BridgeItemHTMLUpload.AllowedFileTypes: TStrings;
begin
 Result:= FAllowedFileTypes;
end;

function TD2BridgeItemHTMLUpload.AllowedFileTypesToInput: string;
var
 I: integer;
begin
 result:= '';

 if FAllowedFileTypes.Count > 0 then
 begin
  for I := 0 to Pred(FAllowedFileTypes.Count) do
  begin
   if I > 0 then
   result:= result + ', ';
   result:= result + '.'+FAllowedFileTypes[I];
  end;
  result:= 'accept="'+result+'"';
 end else
 result:= '';
end;

function TD2BridgeItemHTMLUpload.AllowedFileTypesToJSVar: string;
var
 I: integer;
begin
 result:= '';

 if FAllowedFileTypes.Count > 0 then
 begin
  for I := 0 to Pred(FAllowedFileTypes.Count) do
  begin
   if I > 0 then
   result:= result + ', ';
   result:= result + quotedStr(FAllowedFileTypes[I]);
  end;
 end else
 Result:= '';
end;

constructor TD2BridgeItemHTMLUpload.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FRenderized:= false;
 FBaseClass:= AOwner;
 FAllowedFileTypes:= TStringList.Create;
 FAllowedFileTypes.LineBreak:= ',';
 FAllowedFileTypes.Text:= 'jpg,jpeg,png,pdf';
 FMaxFiles:= 12;
 FMaxFileSize:= 20;
 FMaxUploadSize:= 128;
 FInputVisible:= true;
 FShowFinishMessage:= false;

 FCaptionUpload:= FBaseClass.LangNav.Upload.CaptionInput;

 FPrismControl:= TPrismControlGeneric.Create(nil);
end;

destructor TD2BridgeItemHTMLUpload.Destroy;
var
 vPrismControl: TPrismControl;
begin
 try
  if Assigned(FPrismControl) then
   if not Assigned(FPrismControl.Form) then
   begin
    vPrismControl:= (FPrismControl as TPrismControl);
    FPrismControl:= nil;
    vPrismControl.Free;
   end;
 except
 end;

 FAllowedFileTypes.Free;

 inherited;
end;

function TD2BridgeItemHTMLUpload.GetCSSButtonClear: String;
begin
 Result:= FCSSButtonClear;
end;

function TD2BridgeItemHTMLUpload.GetCSSButtonUpload: String;
begin
 Result:= FCSSButtonUpload;
end;

function TD2BridgeItemHTMLUpload.GetCSSInput: String;
begin
 Result:= FCSSInput;
end;

function TD2BridgeItemHTMLUpload.GetIconButtonClear: String;
begin
 Result:= FIconButtonClear;
end;

function TD2BridgeItemHTMLUpload.GetIconButtonUpload: String;
begin
 Result:= FIconButtonUpload;
end;

function TD2BridgeItemHTMLUpload.GetInputVisible: Boolean;
begin
 Result:= FInputVisible;
end;

function TD2BridgeItemHTMLUpload.GetMaxFiles: integer;
begin
 Result:= FMaxFiles;
end;

function TD2BridgeItemHTMLUpload.GetMaxFileSize: integer;
begin
 Result:= FMaxFileSize;
end;

function TD2BridgeItemHTMLUpload.GetMaxUploadSize: integer;
begin
 Result:= FMaxUploadSize;
end;

function TD2BridgeItemHTMLUpload.GetShowFinishMessage: Boolean;
begin
 Result:= FShowFinishMessage;
end;

function TD2BridgeItemHTMLUpload.GetCaptionUpload: string;
begin
 Result:= FCaptionUpload;
end;

function TD2BridgeItemHTMLUpload.MaxFilesToInput: String;
begin
 result:= '';

 if MaxFiles <> 1 then
 result:= 'multiple';
end;

procedure TD2BridgeItemHTMLUpload.PreProcess;
begin

end;

procedure TD2BridgeItemHTMLUpload.Render;
begin

end;

procedure TD2BridgeItemHTMLUpload.RenderHTML;
var
 vUUID, vToken, vFormUUID: String;
 vPrismSession: TPrismSession;
begin
 vPrismSession:= FD2BridgeItem.BaseClass.PrismSession;
 vUUID:= vPrismSession.UUID;
 vToken:= vPrismSession.Token;
 vFormUUID:= FD2BridgeItem.BaseClass.FormUUID;

 with BaseClass.HTML.Render.Body do
 begin
  add('<div class="d2bridgeinput">');
  add('  <form id="'+AnsiUpperCase(ItemPrefixID)+'Form" enctype="multipart/form-data">');
  add('    <div class="input-group ' + CSSClasses + '" id="'+AnsiUpperCase(ItemPrefixID)+'" style="'+ HtmlStyle +'" '+ HtmlExtras +'>');
  if not FInputVisible then
  begin
   add('      <input type="file" class="' + CSSInput + '" id="'+AnsiUpperCase(ItemPrefixID)+'input" name="'+AnsiUpperCase(ItemPrefixID)+'input" '+MaxFilesToInput+' '+AllowedFileTypesToInput+' style="display: none;">');
   add('    <div class="input-group-append">');
   add('       <label for="'+AnsiUpperCase(ItemPrefixID)+'input" class="' + CSSButtonUpload + '" id="'+AnsiUpperCase(ItemPrefixID)+'fileInputButton"><i class="' + IconButtonUpload + '" aria-hidden="true"></i>' + CaptionUpload + '</label>');
   add('       <button type="button" class="' + CSSButtonUpload + '" id="'+AnsiUpperCase(ItemPrefixID)+'uploadButton" style="display: none;"><i class="' + IconButtonUpload + '" aria-hidden="true"></i>' + CaptionUpload + '</button>');
   add('    </div>');
  end else
  begin
   add('      <input type="file" class="' + CSSInput + '" id="'+AnsiUpperCase(ItemPrefixID)+'input" name="'+AnsiUpperCase(ItemPrefixID)+'input" '+MaxFilesToInput+' '+AllowedFileTypesToInput+' style="height: 38px;">');
   add('      <div class="mx-1"></div>');
   add('    <div class="input-group-append">');
   add('     <button type="button" class="' + CSSButtonClear + '" id="'+AnsiUpperCase(ItemPrefixID)+'clearButton"><i class="' + IconButtonClear + '" aria-hidden="true"></i>' + FBaseClass.LangNav.Upload.ButtonClear + '</button>');
//   add('      <div class="mx-1"></div>');

   add('       <button type="button" class="' + CSSButtonUpload + '" id="'+AnsiUpperCase(ItemPrefixID)+'uploadButton"><i class="' + IconButtonUpload + '" aria-hidden="true"></i>' + CaptionUpload + '</button>');
   add('    </div>');
  end;
  add('    </div>');
  add('  </form>');
  add('</div>');
 end;


 with BaseClass.HTML.Render.Body do
 begin
  add('<script>');
  add('  $(document).ready(function(){');
  add('    var allowedFileTypes = ['+ AllowedFileTypesToJSVar +']; // Tipos de arquivo permitidos (deixe vazio para aceitar qualquer tipo)');
  add('    var maxFileCount = ' + IntToStr(MaxFiles) + '; // Quantidade máxima de arquivos (0 para sem limite)');
  add('    var maxFileSizePerFile = '+ IntToStr(MaxFileSize) +' * 1024 * 1024; // Tamanho máximo por arquivo (5 MB)');
  add('    var maxTotalFileSize = ' + IntToStr(MaxUploadSize) + ' * 1024 * 1024; // Tamanho total máximo (20 MB)');
  add('');
  if FInputVisible then
  begin
   add('  $(''#'+AnsiUpperCase(ItemPrefixID)+'clearButton'').on(''click'', function(){');
   add('      // Limpa a lista de arquivos selecionados');
   add('      $(''#'+AnsiUpperCase(ItemPrefixID)+'input'').val('''');');
   add('    });');
  end;
  add('');
  if not FInputVisible then
  begin
  add('   $(''#'+AnsiUpperCase(ItemPrefixID)+'input'').on(''change'', function () {');
  add('    $(''#'+AnsiUpperCase(ItemPrefixID)+'uploadButton'').click();');
  add('   });');
  end;
  add(' $(''#'+AnsiUpperCase(ItemPrefixID)+'uploadButton'').on(''click'', function(){');
  add('      // Obtenha os arquivos selecionados');
  add('      var files = $(''#'+AnsiUpperCase(ItemPrefixID)+'input'')[0].files;');
  add('');
  add('      if (files.length === 0) {');
  add('        swal.fire({ CaptionUpload: "", icon: "error", text : "' + FBaseClass.LangNav.Upload.MsgErrorNoFileSelect + '" });');
  add('        return;');
  add('      }');
  add('');
  add('      if (maxFileCount > 0 && files.length > maxFileCount) {');
  add('        swal.fire({ CaptionUpload: "", icon: "error", text : `' + FBaseClass.LangNav.Upload.MsgErrorManyFileSelected + '` });');
  add('        return;');
  add('      }');
  add('');
  add('      var totalSize = 0;');
  add('      for (var i = 0; i < files.length; i++) {');
  add('        totalSize += files[i].size;');
  add('');
  add('        if (maxFileSizePerFile > 0 && files[i].size > maxFileSizePerFile) {');
  add('          swal.fire({ CaptionUpload: "", icon: "error", text : `' + FBaseClass.LangNav.Upload.MsgErrorFileSize + '` });');
  add('          return;');
  add('        }');
  add('');
  add('        var fileExtension = files[i].name.split(''.'').pop().toLowerCase();');
  add('        if (allowedFileTypes.length > 0 && !allowedFileTypes.includes(fileExtension)) {');
  add('          swal.fire({ CaptionUpload: "", icon: "error", text : `' + FBaseClass.LangNav.Upload.MsgErrorFileType + '` });');
  add('          return;');
  add('        }');
  add('      }');
  add('');
  add('      if (maxTotalFileSize > 0 && totalSize > maxTotalFileSize) {');
  add('        swal.fire({ CaptionUpload: "", icon: "error", text : "' + FBaseClass.LangNav.Upload.MsgErrorTotalFilesSize + '" });');
  add('        return;');
  add('      }');
  add('');
  add('      var formData = new FormData($(''#'+AnsiUpperCase(ItemPrefixID)+'Form'')[0]);');
  add('   LockThreadClient();');
  add('');
  add('      $.ajax({');
  add('        url: ''/d2bridge/upload?token='+ vToken +'&formuuid='+ vFormUUID +'&prismsession='+ vUUID +'&origin=upload'+'&sender='+ Uppercase(ItemPrefixID) +''',');
  add('        type: ''POST'',');
  add('        data: formData,');
  add('        processData: false,');
  add('        contentType: false,');
  add('        success: function(response){');
  add('          $(''#'+AnsiUpperCase(ItemPrefixID)+'clearButton'').click();');
  add('     UnLockThreadClient();');
  if FShowFinishMessage then
  begin
   add('          swal.fire({ CaptionUpload: "", icon: "success", text : "' + FBaseClass.LangNav.Upload.MsgSuccessUpload + '" });');
  end;
  add('        },');
  add('        error: function(xhr, status, error) {');
  add('     UnLockThreadClient();');
  add('          swal.fire({ CaptionUpload: "", icon: "error", text : "' + FBaseClass.LangNav.Upload.MsgErrorOnUpload + '" });');
  add('        }');
  add('      });');
  add('    });');
  add('  });');
  add('</script>');
 end;

end;

procedure TD2BridgeItemHTMLUpload.SetCSSButtonClear(AValue: string);
begin
 FCSSButtonClear:= AValue;
end;

procedure TD2BridgeItemHTMLUpload.SetCSSButtonUpload(AValue: string);
begin
 FCSSButtonUpload:= AValue;
end;

procedure TD2BridgeItemHTMLUpload.SetCSSInput(AValue: string);
begin
 FCSSInput:= AValue;
end;

procedure TD2BridgeItemHTMLUpload.SetIconButtonClear(AValue: string);
begin
 FIconButtonClear:= AValue;
end;

procedure TD2BridgeItemHTMLUpload.SetIconButtonUpload(AValue: string);
begin
 FIconButtonUpload:= AValue;
end;

procedure TD2BridgeItemHTMLUpload.SetInputVisible(const Value: Boolean);
begin
 FInputVisible:= Value;
end;

procedure TD2BridgeItemHTMLUpload.SetMaxFiles(AValue: Integer);
begin
 FMaxFiles:= AValue;
end;

procedure TD2BridgeItemHTMLUpload.SetMaxFileSize(const Value: integer);
begin
 FMaxFileSize:= Value;
end;

procedure TD2BridgeItemHTMLUpload.SetMaxUploadSize(const Value: integer);
begin
 FMaxUploadSize:= Value;
end;

procedure TD2BridgeItemHTMLUpload.SetShowFinishMessage(const Value: Boolean);
begin
 FShowFinishMessage:= Value;
end;

procedure TD2BridgeItemHTMLUpload.SetCaptionUpload(ACaptionUpload: string);
begin
 FCaptionUpload:= ACaptionUpload;
end;

end.

