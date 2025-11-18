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

unit Prism.Card.Grid.DataModel;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils, D2Bridge.JSON, Generics.Collections, StrUtils,
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF FMX}

{$ELSE}
  DBCtrls, DB,
{$ENDIF}
  Prism.Forms.Controls, Prism.Interfaces, Prism.Types, Prism.DataLink.Core
  ;


type
 TPrismCardGridDataModel = class(TPrismControl, IPrismCardGridDataModel)
  private
   FRefreshData: Boolean;
   FCardClick: Boolean;
   FMaxRecords: integer;
   FCardDataModelHTML: string;
   FCardsHTML: TList<string>;
   FPrismControlIDS: TList<string>;
   FPrismControls: TList<IPrismControl>;
   FEventCardClick: string;
   FColSize: string;
   FCardClickCursor: Boolean;
   FCardDataModel: IPrismCard;
   FRow: integer;
{$IFNDEF FMX}
   FPrismDataLink: TPrismDataLinkCore;
   procedure SetDataSource(const Value: TDataSource);
   function GetDataSource: TDataSource;
{$ENDIF}
   function GetMaxRecords: integer;
   Procedure SetMaxRecords(AMaxRecords: Integer);
   function GetCardClick: boolean;
   procedure SetCardClick(const Value: boolean);
   procedure UpdateData;
   function RenderCardDataModelHTMLContent: string;
   function GetCardDataModelHTML: String;
   procedure SetCardDataModelHTML(const Value: String);
   procedure PopuleCards;
   procedure InitCardPrismControls;
   function GetColSize: string;
   procedure SetColSize(const Value: string);
   function GetCardClickCursor: boolean;
   procedure SetCardClickCursor(const Value: boolean);
   function GetCardDataModel: IPrismCard;
   procedure SetCardDataModel(const Value: IPrismCard);
   //Dataware Event
   procedure DataWareEvent(const ADataWareEvent: TPrismDataLinkEvent);
  protected
   procedure Initialize; override;
   procedure ProcessHTML; override;
   procedure UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean); override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function AlwaysInitialize: boolean; override;
   procedure OnCardClick(EventParams: TStrings);
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

   function PrismControlIDS: TList<string>;

   function Row: integer;

   //function ImageFiles: TList<string>;
   property CardClick: boolean read GetCardClick write SetCardClick;
   property CardClickCursor: boolean read GetCardClickCursor write SetCardClickCursor;
   property CardDataModelHTML: String read GetCardDataModelHTML write SetCardDataModelHTML;
   property CardDataModel: IPrismCard read GetCardDataModel write SetCardDataModel;
   property ColSize: string read GetColSize write SetColSize;
{$IFNDEF FMX}
   property DataSource: TDataSource read GetDataSource write SetDataSource;
{$ENDIF}
   property MaxRecords: Integer read GetMaxRecords write SetMaxRecords;
 end;



implementation

uses
  Prism.Util, Prism.Card.DataModel, D2Bridge.Util, Prism.Events, Prism.Forms;


function TPrismCardGridDataModel.AlwaysInitialize: boolean;
begin
 result:= true;
end;

constructor TPrismCardGridDataModel.Create(AOwner: TObject);
var
 EventCardClick: TPrismControlEvent;
begin
 inherited;

 FRefreshData:= false;
 FCardDataModelHTML:= '';
 FPrismControlIDS:= TList<string>.Create;
 FPrismControls:= TList<IPrismControl>.Create;
 FCardsHTML:= TList<string>.Create;
 FCardClick:= true;
 FCardClickCursor:= FCardClick;

 EventCardClick := TPrismControlEvent.Create(self, EventOnClick);
 EventCardClick.AutoPublishedEvent:= false;
 EventCardClick.SetOnEvent(OnCardClick);
 Events.Add(EventCardClick);

 FRow:= -1;

{$IFNDEF FMX}
 FPrismDataLink:= TPrismDataLinkCore.Create;
 FPrismDataLink.OnDataWareEvent:= DataWareEvent;
{$ENDIF}
 FMaxRecords:= 500;
end;

procedure TPrismCardGridDataModel.DataWareEvent(const ADataWareEvent: TPrismDataLinkEvent);
begin
 if Assigned(Form) then
  if Form.FormPageState in [PageStateLoaded, PageStateLoading] then
  begin
   //Active/Deactive
   if ADataWareEvent in [TPrismDataLinkEvent.Activate,
                         TPrismDataLinkEvent.Deactivate,
                         TPrismDataLinkEvent.NewRow,
                         TPrismDataLinkEvent.Deleted,
                         TPrismDataLinkEvent.Updated] then
   begin
    UpdateData;
   end;
  end;
end;

destructor TPrismCardGridDataModel.Destroy;
begin
 FreeAndNil(FPrismControlIDS);
 FreeAndNil(FCardsHTML);
 FreeAndNil(FPrismControls);

{$IFNDEF FMX}
 FreeAndNil(FPrismDataLink);
{$ENDIF}

 inherited;
end;

function TPrismCardGridDataModel.GetCardClick: boolean;
begin
 Result:= FCardClick;
end;


function TPrismCardGridDataModel.GetCardClickCursor: boolean;
begin
 result:= FCardClickCursor;
end;

function TPrismCardGridDataModel.GetCardDataModel: IPrismCard;
begin
 result:= FCardDataModel;
end;

{$IFNDEF FMX}
function TPrismCardGridDataModel.GetCardDataModelHTML: String;
begin
 result:= FCardDataModelHTML;
end;

function TPrismCardGridDataModel.GetColSize: string;
begin
 result:= FColSize;
end;

function TPrismCardGridDataModel.GetDataSource: TDataSource;
begin
 Result:= FPrismDataLink.DataSource;
end;
{$ENDIF}

function TPrismCardGridDataModel.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismCardGridDataModel.GetMaxRecords: integer;
begin
 result:= FMaxRecords;
end;

procedure TPrismCardGridDataModel.InitCardPrismControls;
var
 vPrismControl: IPrismControl;
 vStringTemp: TStrings;
begin
 try
  vStringTemp:= TStringList.Create;

  for vPrismControl in FPrismControls do
  begin
   vStringTemp.Clear;
   try
//    if not vPrismControl.Initilized then
    //vPrismControl.Initialize;
    if (vPrismControl as TPrismControl) <> self then
    begin
     try
      (Form as TPrismForm).D2BridgeForm.DoInitPrismControl(vPrismControl as TPrismControl);
     except on E: Exception do
    {$IFDEF MSWINDOWS}
       if IsDebuggerPresent then
         raise Exception.Create(E.Message);
    {$ENDIF}
     end;
     vPrismControl.UpdateServerControls(vStringTemp, true);
     vPrismControl.ProcessHTML;
    end;
   except
   end;
  end;

  vStringTemp.Free;
 except
 end;
end;

procedure TPrismCardGridDataModel.Initialize;
var
 I, X: integer;
begin
 inherited;

 try
  FPrismControls.Clear;

  if Assigned(Form) then
  begin
   for X := 0 to Pred(FPrismControlIDS.Count) do
   begin
    if FPrismControlIDS[X] = FCardDataModel.NamePrefix then
     continue;

    for I := 0 to Pred(Form.Controls.Count) do
    begin
     if SameText(Form.Controls[I].NamePrefix, FPrismControlIDS[X]) then
     begin
      Form.Controls[I].Updatable:= false;
      FPrismControls.Add(Form.Controls[I]);

      break;
     end;
    end;
   end;
  end;
 except
 end;
end;

procedure TPrismCardGridDataModel.OnCardClick(EventParams: TStrings);
var
 vRecNo: integer;
 vComponentName: string;
 vPrismControl: IPrismControl;
 i: integer;
begin
 System.Initialize(vPrismControl);

 if EventParams.Values['recno'] <> '' then
 begin
  if TryStrToInt(EventParams.Values['recno'], vRecNo) then
  begin
   FRow:= vRecNo;

   try
    if Assigned(FPrismDataLink.DataSource) then
    if Assigned(FPrismDataLink.DataSet) then
    if FPrismDataLink.DataSet.Active then
    begin
     FPrismDataLink.DataSet.RecNo:= vRecNo;
    end;
   except
   end;

   try
   if EventParams.Values['elementId'] <> '' then
   begin
    vComponentName:= EventParams.Values['elementId'];

    for i:= 0 to pred(FPrismControls.Count) do
     if SameText(FPrismControls[I].Name, vComponentName) then
     begin
      vPrismControl:= FPrismControls[I];

      break;
     end;

    if Assigned(vPrismControl) then
    begin
     (Form as TPrismForm).DoCardGridClick(vPrismControl as TPrismControl, vRecNo, self);

     if Assigned(vPrismControl.Events.Item(EventOnClick)) then
     begin
      if vPrismControl.Enabled and vPrismControl.Visible and (not vPrismControl.ReadOnly) then
       vPrismControl.Events.Item(EventOnClick).CallEvent(EventParams);
     end;
    end else
     (Form as TPrismForm).DoCardGridClick(self, vRecNo, self);
   end;
   except on E: Exception do
{$IFDEF MSWINDOWS}
   if IsDebuggerPresent then
    raise Exception.Create(E.Message);
{$ENDIF}
   end;

  end;
 end;
end;

procedure TPrismCardGridDataModel.PopuleCards;
var
 vPos: integer;
 vCardHTML: string;
 vDataModelProperty: string;
begin
{$IFNDEF FMX}
  FRow:= -1;
  FCardsHTML.Clear;
  FEventCardClick:= AnsiUpperCase(NamePrefix)+'_OnCardClick(event, this)';

  if Assigned(FPrismDataLink.DataSource) then
  if Assigned(FPrismDataLink.DataSet) then
  if FPrismDataLink.DataSet.Active then
  if not FPrismDataLink.DataSet.IsEmpty then
  begin
   vPos:= FPrismDataLink.DataSet.RecNo;
   FPrismDataLink.DataSet.DisableControls;
   FPrismDataLink.DataSet.First;

   try
    try
     repeat
      try
       FRow:= FPrismDataLink.DataSet.RecNo;
       vCardHTML:= FCardDataModelHTML;

       //DataModelProperty
       vDataModelProperty:= 'recno="' + IntToStr(FPrismDataLink.DataSet.RecNo) + '"';
       if FCardClick then
       begin
        vDataModelProperty:= vDataModelProperty + ' onclick="' + FEventCardClick + '"';
        if FCardClickCursor then
         vDataModelProperty:= vDataModelProperty + ' clickable';
       end;
       vCardHTML:= StringReplace(vCardHTML, 'DataModelProperty', vDataModelProperty, [rfReplaceAll]);

       (Form as TPrismForm).D2BridgeForm.DoInitPrismControl(CardDataModel as TPrismCardDataModel);
       InitCardPrismControls;
       Form.ProcessControlsToHTML(vCardHTML);
       //TPrismForm(Form).D2BridgeForm.DoRenderPrismControl(CardDataModel as TPrismControl, vCardHTML);

       FCardsHTML.Add(vCardHTML);
      except
      end;

      FPrismDataLink.DataSet.Next;
     until FPrismDataLink.DataSet.Eof or (FCardsHTML.Count = MaxRecords);
    except
    end;
   finally
    if Assigned(FPrismDataLink.DataSource) then
    if Assigned(FPrismDataLink.DataSet) then
    if FPrismDataLink.DataSet.Active then
    begin
     try
      FPrismDataLink.DataSet.RecNo:= vPos;
     except
     end;

     try
      FPrismDataLink.DataSet.EnableControls;
     except
     end;

     FRow:= FPrismDataLink.DataSet.RecNo;
    end;
   end;
  end;
{$ENDIF}
end;

function TPrismCardGridDataModel.PrismControlIDS: TList<string>;
begin
 result:= FPrismControlIDS;
end;

//procedure TPrismCardGridDataModel.PopuleImageFiles;
//var
// vPos: integer;
//begin
//{$IFNDEF FMX}
//  FImageFiles.Clear;
//
//  if Assigned(FDataLink.DataSource) then
//  if Assigned(FDataLink.DataSet) then
//  if FDataLink.DataSet.Active then
//  begin
//   vPos:= FDataLink.DataSet.RecNo;
//   FDataLink.DataSet.DisableControls;
//   FDataLink.DataSet.First;
//
//   try
//    try
//     repeat
//      FImageFiles.Add(FDataLink.Field.AsString);
//      FDataLink.DataSet.Next;
//     until FDataLink.DataSet.Eof or (FImageFiles.Count = MaxRecords);
//    except
//
//    end;
//   finally
//    if Assigned(FDataLink.DataSource) then
//    if Assigned(FDataLink.DataSet) then
//    if FDataLink.DataSet.Active then
//    begin
//     FDataLink.DataSet.RecNo:= vPos;
//
//     FDataLink.DataSet.EnableControls;
//    end;
//   end;
//  end;
//{$ENDIF}
//end;

procedure TPrismCardGridDataModel.ProcessComponentState(const ComponentStateInfo: TJSONObject);
begin
 inherited;

end;

procedure TPrismCardGridDataModel.ProcessEventParameters(Event: IPrismControlEvent;
  Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismCardGridDataModel.ProcessHTML;
var
 I: integer;
begin
 inherited;

{$IFNDEF FMX}
 PopuleCards;
{$ENDIF}

 HTMLControl:= '';

 if TRIM(FColSize) <> '' then
  HTMLControl:= HTMLControl + '<div class="' + FColSize +'" id="'+AnsiUpperCase(NamePrefix)+'container">';

 HTMLControl:= HTMLControl + '<div '+HTMLCore + '>';

 if FCardsHTML.Count > 0 then
  HTMLControl:= HTMLControl + sLineBreak;

// if AutoSlide then
//  HTMLControl:= HTMLControl + ' data-bs-ride="carousel"';
// if Interval > 0 then
//  HTMLControl:= HTMLControl + ' data-interval="' + IntToStr(Interval) + '"';

 //HTMLControl:= HTMLControl + '>' + sLineBreak;

 for I := 0 to Pred(FCardsHTML.Count) do
  HTMLControl:= HTMLControl + FCardsHTML[I] + sLineBreak;

 HTMLControl:= HTMLControl + '</div>';

 if TRIM(FColSize) <> '' then
  HTMLControl:= HTMLControl + '</div>';


 HTMLControl:= HTMLControl + sLineBreak;


 HTMLControl:= HTMLControl + '<script>' + sLineBreak;
 HTMLControl:= HTMLControl + '  function '+ AnsiUpperCase(NamePrefix)+'_OnCardClick' + '(event, cardElement) {' + sLineBreak;
 HTMLControl:= HTMLControl + '    var clickedElement = event.target;' + sLineBreak;
 HTMLControl:= HTMLControl + '    var elementId = clickedElement.id;' + sLineBreak;
 HTMLControl:= HTMLControl + '    if (!elementId || elementId === '''') {' + sLineBreak;
 HTMLControl:= HTMLControl + '      var buttonParent = clickedElement.closest(''button'');' + sLineBreak;
 HTMLControl:= HTMLControl + '      if (buttonParent) {' + sLineBreak;
 HTMLControl:= HTMLControl + '        elementId = buttonParent.id || '''';' + sLineBreak;
 HTMLControl:= HTMLControl + '      }' + sLineBreak;
 HTMLControl:= HTMLControl + '    }' + sLineBreak;
 HTMLControl:= HTMLControl + '    if (!clickedElement.classList.contains(''d2bridgecard-header-buttonclose'') && clickedElement !== event.target) {' + sLineBreak;
 HTMLControl:= HTMLControl + '       event.stopPropagation();' + sLineBreak;
 HTMLControl:= HTMLControl + '    }' + sLineBreak;
 HTMLControl:= HTMLControl + '    ' +
   Events.Item(EventOnClick).EventJS(
     ExecEventProc,
     '''recno='' + cardElement.getAttribute(''recno'') + ''&'' + ''elementId='' + elementId',
     true
   ) + sLineBreak;
 HTMLControl:= HTMLControl + '  }' + sLineBreak;
 HTMLControl:= HTMLControl + '</script>' + sLineBreak;
end;

function TPrismCardGridDataModel.RenderCardDataModelHTMLContent: string;
var
 I, X: integer;
begin
 try
  if Assigned(Form) then
  begin
   for X := 0 to Pred(FPrismControlIDS.Count) do
    for I := 0 to Pred(Form.Controls.Count) do
    begin
     if (Form.Controls[I] as TPrismControl) <> self then
      if SameText(Form.Controls[I].Name, FPrismControlIDS[X]) then
      begin
       Form.Controls[I].Initialize;
       Form.Controls[I].ProcessHTML;

       break;
      end;
    end;
  end;
 except
 end;

 Result:=
  FCardDataModelHTML + sLineBreak +
  FCardDataModelHTML + sLineBreak +
  FCardDataModelHTML + sLineBreak +
  FCardDataModelHTML;

 Form.ProcessControlsToHTML(Result);
end;

function TPrismCardGridDataModel.Row: integer;
begin
 result:= FRow;
end;

//function TPrismCardGridDataModel.RenderCardDataModelHTMLContent: string;
//var
// vHTMLContent: TStrings;
// I: integer;
//begin
// vHTMLContent:= TStringList.Create;
//
// with vHTMLContent do
// begin
//  if ShowIndicator and (QtyItems > 1) then
//  begin
//   Add('  <div id="'+AnsiUpperCase(NamePrefix)+'INDICATOR" class="d2bridgecarousel-indicators carousel-indicators">');
//   for I := 0 to Pred(QtyItems) do
//   begin
//    Add('    <button type="button" data-bs-target="#'+AnsiUpperCase(NamePrefix)+'" data-bs-slide-to="' + IntToStr(I) + '" ' + ifThen(I = 0, 'class="active" ') +'aria-current="true" aria-label="Slide ' + IntToStr(I+1) + '"></button>');
//   end;
//   Add('  </div>');
//  end;
//  Add('  <div class="carousel-inner">');
//  for I := 0 to Pred(QtyItems) do
//  begin
//   Add('    <div class="carousel-item ' + ifThen(I = 0, 'active') +'">');
//   Add('      <img src="' + D2Bridge.Util.Base64ImageFromFile(ImageFiles[I]) + '" class="d2bridgecarousel-image d-block w-100" alt="">');
//   Add('    </div>');
//  end;
//  Add('  </div>');
//  if ShowButtons and (QtyItems > 1) then
//  begin
//   Add('  <button id="'+AnsiUpperCase(NamePrefix)+'BUTTONPREV" class="carousel-control-prev" type="button" data-bs-target="#'+AnsiUpperCase(NamePrefix)+'" data-bs-slide="prev">');
//   Add('    <span class="carousel-control-prev-icon" aria-hidden="true"></span>');
//   Add('    <span class="visually-hidden">Previous</span>');
//   Add('  </button>');
//   Add('  <button id="'+AnsiUpperCase(NamePrefix)+'BUTTONNEXT" class="carousel-control-next" type="button" data-bs-target="#'+AnsiUpperCase(NamePrefix)+'" data-bs-slide="next">');
//   Add('    <span class="carousel-control-next-icon" aria-hidden="true"></span>');
//   Add('    <span class="visually-hidden">Next</span>');
//   Add('  </button>');
//  end;
// end;
//
// result:= vHTMLContent.Text;
//
// vHTMLContent.Free;
//end;

procedure TPrismCardGridDataModel.SetCardClick(const Value: boolean);
begin
 FCardClick:= Value;
end;

procedure TPrismCardGridDataModel.SetCardClickCursor(const Value: boolean);
begin
 FCardClickCursor:= Value;
end;

procedure TPrismCardGridDataModel.SetCardDataModel(const Value: IPrismCard);
begin
 FCardDataModel:= Value;
end;

{$IFNDEF FMX}
procedure TPrismCardGridDataModel.SetCardDataModelHTML(const Value: String);
begin
 FCardDataModelHTML:= Value;
end;

procedure TPrismCardGridDataModel.SetColSize(const Value: string);
begin
 FColSize:= Value;
end;

procedure TPrismCardGridDataModel.SetDataSource(const Value: TDataSource);
begin
 if FPrismDataLink.DataSource <> Value then
 begin
  FPrismDataLink.DataSource := Value;
 end;
end;
{$ENDIF}

procedure TPrismCardGridDataModel.SetMaxRecords(AMaxRecords: Integer);
begin
 FMaxRecords:= AMaxRecords;
end;

procedure TPrismCardGridDataModel.UpdateData;
begin
 if (Assigned(Form)) and (Form.FormPageState = PageStateLoaded) and (not Form.ComponentsUpdating) then
 begin
  FRefreshData:= true;
 end;
end;

procedure TPrismCardGridDataModel.UpdateServerControls(var ScriptJS: TStrings; AForceUpdate: Boolean);
begin
 inherited;

 if (FRefreshData) or (AForceUpdate) then
 begin
  FRefreshData:= false;

  ProcessHTML;

  if Trim(ColSize) <> '' then
   ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+'container i]").outerHTML = '+ FormatValueHTML(HTMLControl) +';')
  else
   ScriptJS.Add('document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]").outerHTML = '+ FormatValueHTML(HTMLControl) +';');

//  ScriptJS.Add('let temp'+AnsiUpperCase(NamePrefix)+' = document.querySelector("[id='+AnsiUpperCase(NamePrefix)+' i]");');
//  ScriptJS.Add('temp'+AnsiUpperCase(NamePrefix)+'.innerHTML = ' + FormatValueHTML(RenderCardDataModelHTMLContent) +';');
//
//  ScriptJS.Add('var carousel = new bootstrap.Carousel(temp'+AnsiUpperCase(NamePrefix)+');');
 end;
end;

{$ELSE}
implementation
{$ENDIF}

end.

