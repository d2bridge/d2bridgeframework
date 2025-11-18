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

unit Prism.Server.HTML.Headers;

interface

uses
  Classes, Generics.Collections, SysUtils, DateUtils, Rtti,
  Prism.Interfaces, Prism.Types, Prism.Session, Prism.Server.HTTP.Commom;


type
 TPrismServerHTMLHeaders = class(TDataModule)
  strict private
   //Thread Exec
   procedure Exec_LoadPageHTMLFromSession(varRequest, varResponse, varSession: TValue);
  private
   function AddHeadsIncludes(var HTMLText: string; host: string; port: integer; urlpath: string; Session: IPrismSession): string;
   function AddVariables(Session: IPrismSession): string;
   function AddJSPrismWS: string;
   function AddOnLoad(host: string; port: integer; urlpath: string; Session: IPrismSession): string;
   function AddPrismMethods: string;
   function AddControlEvents(Session: IPrismSession): string;
   function AddJSCallBackPrismMethods(Session: IPrismSession): string;
//   function AddPageUnload(Session: IPrismSession): string;
   function AddError500(Session: IPrismSession): string;
  public
   FCoreVariable: string;
   FCorePrismMethods: string;
   FCoreSetConnection: string;
   FCorePrismWS: string;
   FCoreCallBackPrismMethods: string;
   FCoreD2BridgeKanban: string;
   procedure ProcessHTMLHeaderIncludes(const Request: TPrismHTTPRequest; var HTMLText: string; Session: IPrismSession);
   procedure ProcessHTMLBodyIncludes(const Request: TPrismHTTPRequest; var HTMLText: string; Session: IPrismSession);
   Procedure LoadPageHTMLFromSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
   procedure ReloadPage(Session: TPrismSession);
 end;


implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  TypInfo, D2Bridge.JSON, Variants,
  D2Bridge.BaseClass, D2Bridge.Manager,
  Prism.Forms, Prism.Forms.Controls, Prism.Util, Prism.BaseClass, Prism.Session.Helper;

{ TPrismServerHTMLHeaders }

function TPrismServerHTMLHeaders.AddJSCallBackPrismMethods(Session: IPrismSession): string;
begin
 Result:= FCoreCallBackPrismMethods;
 Result:= StringReplace(Result, '{{UUID}}', Session.UUID, [rfReplaceAll, rfIgnoreCase]);
 Result:= StringReplace(Result, '{{Token}}', Session.Token, [rfReplaceAll, rfIgnoreCase]);
 Result:= StringReplace(Result, '{{FormUUID}}', Session.ActiveForm.FormUUID, [rfReplaceAll, rfIgnoreCase]);
 Result:= StringReplace(Result, '{{ControlID}}', Session.ActiveForm.FormUUID, [rfReplaceAll, rfIgnoreCase]);
end;


function TPrismServerHTMLHeaders.AddControlEvents(Session: IPrismSession): string;
var
 HTMLCodeString: TStringList;
 I, Z: Integer;
 APrismForm: TPrismForm;
 PrismComponentsJSONArray: TJSONArray;
 PrismComponentJSON: TJSONObject;
begin
 Result:= '';
 PrismComponentsJSONArray:= TJSONArray.Create;
 HTMLCodeString:= TStringList.Create;
 APrismForm:= (Session.ActiveForm as TPrismForm);

 with HTMLCodeString do
 begin
  add('<script type="text/javascript">');
  add('function d2bridgeRegisterEvents() {');

  //Loaded complete
  add('if (d2bridgeLoadedComplete) return;');

  //Eventos do Componente
  for I := 0 to APrismForm.Controls.Count - 1 do
  begin
   PrismComponentJSON:= TJSONObject.Create;
   PrismComponentJSON.AddPair('id', AnsiUpperCase(APrismForm.Controls[I].NamePrefix));
   PrismComponentJSON.AddPair('PrismType', (APrismForm.Controls[I] as TPrismControl).ClassName);
   PrismComponentsJSONArray.Add(PrismComponentJSON.NewClone as TJSONObject);
   PrismComponentJSON.Free;

   add('if (document.querySelector("[id='+ AnsiUpperCase(APrismForm.Controls[I].NamePrefix) +' i]") !== null) {');
   add('var ' + '_EV'+AnsiUpperCase(APrismForm.Controls[I].NamePrefix) + ' = document.querySelector("[id=' + AnsiUpperCase(APrismForm.Controls[I].NamePrefix) + ' i]");');
   //add('var worker'+AnsiUpperCase(APrismForm.Controls[I].Name)+' = null;');

   for Z := 0 to APrismForm.Controls[I].Events.Count - 1 do
   begin
    if APrismForm.Controls[I].Updatable then
    if (APrismForm.Controls[I].Events.Item(Z).AutoPublishedEvent) or
       (APrismForm.Controls[I].Events.Item(Z).EventType in [EventOnKeyDown, EventOnKeyUp, EventOnKeyPress]) then
    begin
     add('_EV'+AnsiUpperCase(APrismForm.Controls[I].NamePrefix) + '.addEventListener("' + EventJSName(APrismForm.Controls[I].Events.Item(Z).EventType) + '", function(event) {');

     //checkRequired
     if (APrismForm.Controls[I].NeedCheckValidation) then
     begin
      add('var validationgroup = this.getAttribute("validationgroup");');
      add('if (validationgroup !== null) { ');
      add('if (!checkRequired(validationgroup)) {');
     end;

     if APrismForm.Controls[I].Events.Item(Z).EventType in [EventOnKeyDown, EventOnKeyUp, EventOnKeyPress] then
      add(APrismForm.Controls[I].Events.Item(Z).EventJS(ExecEventProc, '"PrismComponentsStatus=" + GetComponentsStates([PrismComponents.find(obj => obj.id === "' + AnsiUpperCase(APrismForm.Controls[I].NamePrefix) + '")]) + "&" + "key=" + event.key', false))
     else
     begin
      add(APrismForm.Controls[I].Events.Item(Z).EventJS(ExecEventProc, '"PrismComponentsStatus=" + GetComponentsStates(PrismComponents)', true));
     end;

     //checkRequired
     if (APrismForm.Controls[I].NeedCheckValidation) then
     begin
      add('}');
      add('}');
      add('else {');
     end;

     if (APrismForm.Controls[I].NeedCheckValidation) then
     if APrismForm.Controls[I].Events.Item(Z).EventType in [EventOnKeyDown, EventOnKeyUp, EventOnKeyPress] then
      add(APrismForm.Controls[I].Events.Item(Z).EventJS(ExecEventProc, '"PrismComponentsStatus=" + GetComponentsStates([PrismComponents.find(obj => obj.id === "' + AnsiUpperCase(APrismForm.Controls[I].NamePrefix) + '")]) + "&" + "key=" + event.key', false))
     else
     begin
      add(APrismForm.Controls[I].Events.Item(Z).EventJS(ExecEventProc, '"PrismComponentsStatus=" + GetComponentsStates(PrismComponents)', true));
     end;

     //checkRequired
     if (APrismForm.Controls[I].NeedCheckValidation) then
     begin
      add('}');
     end;


     add('});');
    end;
   end;

   add('}');
  end;



  //Focused
  add('var elementsfirefocus = document.querySelectorAll(''input, select, textarea, button, .d2bridgedbgrid'');');
  add('elementsfirefocus.forEach(function(elementfocused) {');
  add(' if (!elementfocused.hasAttribute(''nofocused'')) {');
  add('  elementfocused.addEventListener(''focus'', function(event) {');
  add('    if (event.target !== focusedElement) {');
  add('      focusedElement = event.target;');
  add('      PrismServer().ExecEvent("'+Session.UUID+'", "'+ Session.Token +'", "'+ APrismForm.FormUUID +'", "' + APrismForm.FormUUID + '", "'+ 'ComponentFocused' + '", "PrismComponentsStatus=" + GetComponentsStates(PrismComponents) + "&" + "FocusedID=" + event.target.id, false); }');
  for I := 0 to Pred(APrismForm.Controls.Count) do
   if Supports(APrismForm.Controls[I], IPrismGrid) then
   begin
    Add('     try {');
    Add('         nextEditRowID'+AnsiUpperCase(APrismForm.Controls[I].NamePrefix)+' !== null;');
    Add('         $("#'+ AnsiUpperCase(APrismForm.Controls[I].NamePrefix) +'").saveRow($("#'+ AnsiUpperCase(APrismForm.Controls[I].NamePrefix) +'").getGridParam("selrow"));');
    Add('     } catch (error) {');
    Add('     }');
   end;
  add('  });');
  add(' };');
  add('});');


  //DOMContentLoade
  add('}');


  //Var PrismComponentes
  add('var PrismComponents = PrismComponents = '+ PrismComponentsJSONArray.ToJSON+';');


  add('if (document.readyState === "loading") {');
  add('   document.addEventListener("DOMContentLoaded", d2bridgeRegisterEvents);');
  add('}');


  add('</script>');

 end;

 Result:= HTMLCodeString.Text;

 PrismComponentsJSONArray.Free;
 HTMLCodeString.free;
end;

function TPrismServerHTMLHeaders.AddError500(Session: IPrismSession): string;
begin
 Result:= '';

 if PrismBaseClass.Options.ShowError500Page then
 begin
  Result:= Result + sLineBreak + '<div id="overlayerror" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.7); z-index: 999999999;">';
  Result:= Result + sLineBreak + '  <iframe id="iframeoverlayerror" src="error500.html" style="width: 100%; height: 100%; border: none; background-color: white;"></iframe>';
  Result:= Result + sLineBreak + '</div>';
 end else
 begin
  Result:= Result + sLineBreak + '<div id="overlayerror" style="display: none;">';
  Result:= Result + sLineBreak + '</div>';
 end;
end;

function TPrismServerHTMLHeaders.AddHeadsIncludes(var HTMLText: string; host: string; port: integer; urlpath: string; Session: IPrismSession): string;
var
 FPathJS, FPathCSS: string;
begin
 FPathJS:= PrismBaseClass.Options.PathJS;
 FPathCSS:= PrismBaseClass.Options.PathCSS;

 Result:= '';

 Result:= Result + AddOnLoad(Host, port, urlpath, Session);

// Result:= Result + sLineBreak + '<script type="text/javascript" src="'+FPathJS+'/prismserver.js"></script>';
 if PrismBaseClass.Options.IncludeJQuery then
  Result:= Result + sLineBreak + '<script type="text/javascript" src="'+ FPathJS +'/jquery-3.6.4.js"></script>';

 Result:= Result + sLineBreak + '<script type="text/javascript" src="'+FPathJS+'/prismserver.js"></script>';

 Result:= Result + sLineBreak + AddJSPrismWS;

 Result:= Result + sLineBreak + '<script>startPrismServer();</script>';

 //Camera and QRCode Readser
 if (Pos('d2bridgecamera', HTMLText) > 0) or (Pos('d2bridgeqrcodereader', HTMLText) > 0) then
 begin
  Result:= Result + sLineBreak + '<script type="text/javascript" src="'+ FPathJS +'/d2bridgecamera.js"></script>';
 end;

 Result:= Result + sLineBreak + '<script type="text/javascript" src="'+FPathJS+'/d2bridgeloader.js"></script>';

 if PrismBaseClass.Options.IncludeSweetAlert2 then
 begin
  Result:= Result + sLineBreak + '<link rel="stylesheet" type="text/css" href="'+ FPathCSS +'/sweetalert2.css"/>';
  Result:= Result + sLineBreak + '<script type="text/javascript" src="'+FPathJS+'/sweetalert2.js"></script>';
 end;

 if PrismBaseClass.Options.IncludeStyle then
  Result:= Result + sLineBreak + '<link rel="stylesheet" type="text/css" href="'+ FPathCSS +'/d2bridge.css"/>';


 //Editor
 if (Pos('d2bridgemarkdowneditor', HTMLText) > 0) or (Pos('d2bridgewysiwygeditor', HTMLText) > 0) then
  Result:= Result + sLineBreak + '<script type="text/javascript" src="'+ FPathJS +'/highlight.min.js"></script>';


 //Markdown Editor
 if (Pos('d2bridgemarkdowneditor', HTMLText) > 0) then
 begin
  Result:= Result + sLineBreak + '<script type="text/javascript" src="'+ FPathJS +'/easymde.min.js"></script>';
  Result:= Result + sLineBreak + '<link rel="stylesheet" type="text/css" href="'+ FPathCSS +'/easymde.min.css"/>';
//  Result:= Result + sLineBreak + '<script>hljs.highlightAll();</script>';
 end;


 //WYSIWYG Editor
 if (Pos('d2bridgewysiwygeditor', HTMLText) > 0) then
 begin
  Result:= Result + sLineBreak + '<script type="text/javascript" src="'+ FPathJS +'/summernote-bs5.js"></script>';
  Result:= Result + sLineBreak + '<script type="text/javascript" src="'+ FPathJS +'/summernote-ext-highlight.js"></script>';
  Result:= Result + sLineBreak + '<link rel="stylesheet" type="text/css" href="'+ FPathCSS +'/summernote-bs5.css"/>';
 end;

 //QRCode Readser
 if (Pos('d2bridgeqrcodereader', HTMLText) > 0) then
 begin
  Result:= Result + sLineBreak + '<script type="text/javascript" src="'+ FPathJS +'/zxing.browser.min.js"></script>';
 end;

end;

function TPrismServerHTMLHeaders.AddJSPrismWS: string;
var
 vTimeHeartBeat: integer;
begin
 vTimeHeartBeat:= Round(PrismBaseClass.Options.HeartBeatTime * 0.7);
 if vTimeHeartBeat < 5 then
  vTimeHeartBeat:= 5;

 Result:= FCorePrismWS;
 Result:= StringReplace(Result, '{{TimeHeartBeat}}', IntToStr(vTimeHeartBeat), [rfReplaceAll, rfIgnoreCase]);
end;

function TPrismServerHTMLHeaders.AddOnLoad(host: string; port: integer; urlpath: string; Session: IPrismSession): string;
begin
 Result:= FCoreSetConnection;

 if PrismBaseClass.Options.SSL then
  Result:= StringReplace(Result, '{{protocol}}', 'wss', [rfIgnoreCase])
 else
  Result:= StringReplace(Result, '{{protocol}}', 'ws', [rfIgnoreCase]);
 Result:= StringReplace(Result, '{{host}}', host, [rfIgnoreCase]);
 Result:= StringReplace(Result, '{{port}}', IntToStr(Port), [rfIgnoreCase]);
 Result:= StringReplace(Result, '{{urlpath}}', urlpath, [rfIgnoreCase]);
 Result:= StringReplace(Result, '{{Token}}', Session.Token, [rfReplaceAll, rfIgnoreCase]);
 Result:= StringReplace(Result, '{{UUID}}', Session.UUID, [rfReplaceAll, rfIgnoreCase]);
 Result:= StringReplace(Result, '{{ChannelName}}', 'PrismCallBack', [rfReplaceAll, rfIgnoreCase]);

end;

//function TPrismServerHTMLHeaders.AddPageUnload(Session: IPrismSession): string;
//begin
// Result:= JSPageUnload.HTMLDoc.Text;
//
// Result:= StringReplace(Result, '{{UUID}}', Session.UUID, [rfReplaceAll, rfIgnoreCase]);
// Result:= StringReplace(Result, '{{Token}}', Session.Token, [rfReplaceAll, rfIgnoreCase]);
// Result:= StringReplace(Result, '{{FormUUID}}', Session.ActiveForm.FormUUID, [rfReplaceAll, rfIgnoreCase]);
//
//end;

function TPrismServerHTMLHeaders.AddPrismMethods: string;
begin
 Result:= FCorePrismMethods;

 Result:= StringReplace(Result, '{{version}}', D2BridgeManager.Version, [rfReplaceAll, rfIgnoreCase]);
 Result:= StringReplace(Result, '{{servername}}', D2BridgeManager.ServerController.ServerName, [rfReplaceAll, rfIgnoreCase]);
 Result:= StringReplace(Result, '{{serverdescription}}', D2BridgeManager.ServerController.ServerDescription, [rfReplaceAll, rfIgnoreCase]);
end;

function TPrismServerHTMLHeaders.AddVariables(Session: IPrismSession): string;
var
 FPathJS, FPathCSS: string;
begin
 FPathJS:= PrismBaseClass.Options.PathJS;
 FPathCSS:= PrismBaseClass.Options.PathCSS;

 Result:= FCoreVariable;

 Result:= StringReplace(Result, '{{pathcss}}', Quotedstr(FPathCSS), [rfIgnoreCase]);
 Result:= StringReplace(Result, '{{pathjs}}', Quotedstr(FPathJS), [rfIgnoreCase]);

 if TD2BridgeClass(Session.D2BridgeBaseClassActive).D2BridgeManager.Prism.Options.Loading then
  Result:= StringReplace(Result, '{{d2bridgeloader}}', 'true', [rfIgnoreCase])
 else
  Result:= StringReplace(Result, '{{d2bridgeloader}}', 'false', [rfIgnoreCase]);
end;



procedure TPrismServerHTMLHeaders.Exec_LoadPageHTMLFromSession(varRequest, varResponse, varSession: TValue);
var
 vMakeHTMLText: TStrings;
 HTMLText: String;
 HTMLBodyText: String;
 HTMLTemplateFile, HTMLFile: TStringStream;
 vRequest: TPrismHTTPRequest;
 vResponse: TPrismHTTPResponse;
 vSession: TPrismSession;
begin
 HTMLText:= '';
 HTMLBodyText:= '';

 try
  //Process Var
  vRequest:= varRequest.AsObject as TPrismHTTPRequest;
  vResponse:= varResponse.AsObject as TPrismHTTPResponse;
  vSession:= varSession.AsObject as TPrismSession;


  vSession.ActiveForm.OnBeforePageLoad;

  if (vSession.ActiveForm.TemplateMasterHTMLFile <> '') and (FileExists('wwwroot' + PathDelim + vSession.ActiveForm.TemplateMasterHTMLFile)) then
  begin
   HTMLTemplateFile:= TStringStream.Create('', TEncoding.UTF8);
   HTMLTemplateFile.LoadFromFile('wwwroot' + PathDelim + vSession.ActiveForm.TemplateMasterHTMLFile);

   HTMLText:= HTMLTemplateFile.DataString;

   HTMLText:= StringReplace(HTMLText, '</head>', sLineBreak +'$_prismheader'+ sLineBreak +'</head>', [rfIgnoreCase]);

   if vSession.ActiveForm.TemplatePageHTMLFile <> '' then
   begin
    HTMLFile:= TStringStream.Create('', TEncoding.UTF8);
    HTMLFile.LoadFromFile('wwwroot' + PathDelim + vSession.ActiveForm.TemplatePageHTMLFile);

    HTMLText:= StringReplace(HTMLText, '</prismpage>', '</prismpage>$prismpage', [rfIgnoreCase]);
    HTMLText:= StringReplace(HTMLText, '$prismpage', HTMLFile.DataString, [rfIgnoreCase]);

    HTMLFile.Free;
   end;

   HTMLText:= StringReplace(HTMLText, '</body>', sLineBreak +'$_prismbody'+ sLineBreak +'</body>', [rfIgnoreCase]);

   HTMLTemplateFile.Free;
  end else
  begin
   if vSession.ActiveForm.TemplatePageHTMLFile <> '' then
   begin
    HTMLFile:= TStringStream.Create('', TEncoding.UTF8);
    HTMLFile.LoadFromFile('wwwroot' + PathDelim + vSession.ActiveForm.TemplatePageHTMLFile);

    HTMLText:= HTMLFile.DataString;

    HTMLText:= StringReplace(HTMLText, '</head>', sLineBreak +'$_prismheader'+ sLineBreak +'</head>', [rfIgnoreCase]);

    HTMLText:= StringReplace(HTMLText, '</body>', sLineBreak +'$_prismbody'+ sLineBreak +'</body>', [rfIgnoreCase]);

    HTMLFile.Free;
   end else
   begin
    with TD2BridgeClass(vSession.D2BridgeBaseClassActive).HTML.Options do
    begin
     IncluseHTMLTags:= true;
     IncluseBootStrap:= true;
     IncludeCharSet:= true;
     IncludeViewPort:= true;
     IncludeDIVContainer:= true;
    end;

    vMakeHTMLText:= TD2BridgeClass(vSession.D2BridgeBaseClassActive).HTML.Render.HTMLText;
    HTMLText:= vMakeHTMLText.Text;
    vMakeHTMLText.Free;

    HTMLText:= StringReplace(HTMLText, '</head>', sLineBreak +'$_prismheader'+ sLineBreak +'</head>', [rfIgnoreCase]);

    HTMLText:= StringReplace(HTMLText, '</body>', sLineBreak +'$_prismbody'+ sLineBreak +'</body>', [rfIgnoreCase]);

   end;
  end;
  //Guarda o HTML Original
  vSession.ActiveForm.FormHTMLText:= HTMLText;

  //Chama o evento para Processar o HTML inteiro
  if Assigned((vSession.ActiveForm as TPrismForm).OnProcessHTML) then
  (vSession.ActiveForm as TPrismForm).OnProcessHTML((vSession.ActiveForm as TPrismForm), HTMLText);

  //Chama o Inicio da Tradução
  (vSession.ActiveForm as TPrismForm).DoBeginTranslate;

  //Part I
  //Chama o evento para processar os Controles do Form
  //Session.ActiveForm.ProcessControlsToHTML(HTMLText);

  //Processa $prismbody
  HTMLBodyText:= TD2BridgeClass(vSession.D2BridgeBaseClassActive).HTML.Render.Body.Text;
  //Retirado a Parte I porque quando usa template mas não tem os elementos declarados
  //ao entrar uma segunda vez os elementos não atualizam
  //Part I - Processa o Body
  //Session.ActiveForm.ProcessControlsToHTML(HTMLBodyText);
  HTMLText:= StringReplace(HTMLText, '$prismbody', HTMLBodyText, [rfIgnoreCase]);

  //Processa $d2bridgepopup
  vSession.ActiveForm.ProcessPopup(HTMLText);

  //Processa Nested Forms
  vSession.ActiveForm.ProcessNested(HTMLText);

  //On BeginTagHTML
  vSession.ActiveForm.DoBeginTagHTML;

  //Processa $prismtag
  vSession.ActiveForm.ProcessTags(HTMLText);

  //Processa os TAGs HTML {{Texto}}
  vSession.ActiveForm.ProcessTagHTML(HTMLText);

  //On EndTagHTML
  vSession.ActiveForm.DoEndTagHTML;

  //Initialize Form
  (vSession.ActiveForm as TPrismForm).Initialize;

  //Parte II - Processa todo HTML (Experimental)
  vSession.ActiveForm.ProcessControlsToHTML(HTMLText);

  //Processa **PARTE II** os TAGs HTML {{Texto}}
  vSession.ActiveForm.ProcessTagHTML(HTMLText);

  //Processa as CallBack TAGs HTML {{Texto}}
  vSession.ActiveForm.ProcessCallBackTagHTML(HTMLText);

  //FIX - Corrige a renderização do GridDataModel
  //Session.ActiveForm.ProcessControlsToHTML(HTMLText);

  //Translate
  vSession.ActiveForm.ProcessTagTranslate(HTMLText);

  //Processa os Includes
  ProcessHTMLHeaderIncludes(vRequest, HTMLText, vSession);

  //Process Body
  ProcessHTMLBodyIncludes(vRequest, HTMLText, vSession);

  //Guarda o Arquivo processado no Cache
  vSession.ActiveForm.FormCacheHTMLText:= HTMLText;

  //Retorna HTML
  vResponse.Content:= HTMLText;
 except
  try
   vSession.Destroy;
  except
  end;
 end;
end;

Procedure TPrismServerHTMLHeaders.LoadPageHTMLFromSession(const Request: TPrismHTTPRequest; Response: TPrismHTTPResponse; Session: TPrismSession);
begin
 //Obrigatório rodar dentro da Thread
 Session.ExecThread(True,
  Exec_LoadPageHTMLFromSession,
  TValue.From<TPrismHTTPRequest>(Request),
  TValue.From<TPrismHTTPResponse>(Response),
  TValue.From<TPrismSession>(Session));
// Exec_LoadPageHTMLFromSession(Request, Response, Session);
end;

procedure TPrismServerHTMLHeaders.ProcessHTMLBodyIncludes(const Request: TPrismHTTPRequest; var HTMLText: string;
  Session: IPrismSession);
var
 HTMLCodeString: TStringList;
 FPathJS, FPathCSS: string;
begin
 FPathJS:= PrismBaseClass.Options.PathJS;
 FPathCSS:= PrismBaseClass.Options.PathCSS;

 HTMLCodeString:= TStringList.Create;

 with HTMLCodeString do
 begin
  //Prismserver
  //Add('<script type="text/javascript" src="'+FPathJS+'/prismserver.js"></script>');
  //d2bridgeloader
  //Add('<script type="text/javascript" src="'+FPathJS+'/d2bridgeloader.js"></script>');

  //Font
  Add('<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css"/>');

  //JQGrid
  if PrismBaseClass.Options.IncludeJQGrid then
  begin
   if (Pos('d2bridgedbgrid', HTMLText) > 0) or (Pos('d2bridgestringgrid', HTMLText) > 0) then
   begin
    Add('<script type="text/javascript" src="'+ FPathJS +'/jquery.jqgrid.min.js"></script>');
    Add('<link rel="stylesheet" type="text/css" href="'+ FPathCSS +'/ui.jqgrid-bootstrap5.css"/>');
   end;
  end;

  //JQuery Input
  if PrismBaseClass.Options.IncludeInputMask then
   Add('<script type="text/javascript" src="'+ FPathJS +'/jquery.inputmask.js"></script>');
  Add('<script type="text/javascript">');
  Add(' $(document).ready(function(){');
  Add('  Inputmask().mask(document.querySelectorAll("input"));');
  Add('  Inputmask().mask(document.querySelectorAll("textarea"));');
  Add(' });');
  Add('</script>');

  //Error 500
  Add(AddError500(Session));

  //Load Complete
  Add('<script type="text/javascript">');
  Add(' $(document).ready(function(){');
  Add('  if (typeof D2BridgeCameraAllowed !== "undefined" && D2BridgeCameraAllowed !== -1) {');
  Add('    requestAnimationFrame(async () => {');
  Add('      await WaitForCameraPermission();');
  Add('      PageLoadComplete();');
  Add('    });');
  Add('  } else {');
//  Add('    setTimeout(() => {');
  Add('      PageLoadComplete();');
//  Add('    }, 100);');
  Add('  }');
  Add(' });');
  Add('</script>');
 end;

 HTMLText:= StringReplace(HTMLText, '$_prismbody', HTMLCodeString.Text, [rfIgnoreCase]);

 HTMLCodeString.Free;
end;

procedure TPrismServerHTMLHeaders.ProcessHTMLHeaderIncludes(const Request: TPrismHTTPRequest; var HTMLText: string;
  Session: IPrismSession);
var
 HTMLCodeString: TStringList;
begin
 HTMLCodeString:= TStringList.Create;

 with HTMLCodeString do
 begin
  Add(AddVariables(Session));
  Add(AddHeadsIncludes(HTMLText, Request.Header.Host, Request.Header.ServerPort, Request.Header.PathWithoutParams, Session));
  //Add(AddJSPrismWS);
  //Add(AddOnLoad(Request.Header.Host, Request.Header.ServerPort, Request.Header.PathWithoutParams, Session));
  Add(AddPrismMethods);
  Add(AddControlEvents(Session));
  add(AddJSCallBackPrismMethods(Session));
  Add(Session.ActiveForm.HeadHTMLPrism);
//  Add(AddPageUnload(Session));
 end;

 HTMLText:= StringReplace(HTMLText, '$_prismheader', HTMLCodeString.Text, [rfIgnoreCase]);

 HTMLCodeString.Free;
end;

procedure TPrismServerHTMLHeaders.ReloadPage(Session: TPrismSession);
begin
 //Session.ExecJS('window.location.href = ''reloadpage?token='+ Session.Token +'&prismsession='+ Session.UUID +''';');
// Session.ExecJS(JSReloadPage.HTMLDoc.Text);

 // Obtenha a URL atual
 //Session.ExecJS('window.location.href = window.location.href + ''reloadpage?token='+ Session.Token +'&prismsession='+ Session.UUID +''';');

 Session.SetReloading(true);

 Session.ExecJS
 (
  'if (window.location.href.indexOf(''#'') > -1) {'+ sLineBreak +
  '  history.replaceState({}, document.title, window.location.pathname);'+ sLineBreak +
  '}'+ sLineBreak +
  'var currentPath = window.location.pathname;'+ sLineBreak +
  'document.cookie = "D2Bridge_Token = ' + Session.Token + '; path=" + currentPath;'+ sLineBreak +
  'document.cookie = "D2Bridge_PrismSession = ' + Session.UUID + '; path=" + currentPath;'+ sLineBreak +
  'document.cookie = "D2Bridge_ReloadPage = true; path=" + currentPath;'+ sLineBreak +
  'isReloadPage = true;' + sLineBreak +
  'location.reload(true);'
 );
end;

end.

