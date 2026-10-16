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

unit Prism.Grid.Columns.Buttons;

interface


uses
  Classes, Generics.Collections, SysUtils, D2Bridge.JSON,
  Prism.Interfaces, Prism.CSS.Bootstrap.Button, Prism.Font.Awesome, Prism.Types;


type
 TPrismGridColumnButton = class(TInterfacedPersistent, IPrismGridColumnButton)
  private
   FCaption: string;
   FCSS: string;
   FButtonType: string;
   FButtonIcon: string;
   FButtonWidth: string;
   FButtonHeigth: string;
   FName: string;
   FIdentify: string;
   FPrismGridColumn: IPrismGridColumn;
   FOnClick: TNotifyEvent;
   FProc: TProc;
   FButtons: TList<IPrismGridColumnButton>;
   FButtonModel: IButtonModel;
   FButtonParent: TPrismGridColumnButton;
   FEnabled: Boolean;
   FVisible: Boolean;
   function GetCaption: string;
   procedure SetCaption(const Value: string);
   function GetEnabled: boolean;
   procedure SetEnabled(const Value: boolean);
   function GetVisible: boolean;
   procedure SetVisible(const Value: boolean);
   function GetCSS: string;
   procedure SetCSS(const Value: string);
   function GetButtonType: string;
   procedure SetButtonType(const Value: string);
   function GetButtonHeigth: string;
   function GetButtonIcon: string;
   function GetButtonWidth: string;
   procedure SetButtonHeigth(const Value: string);
   procedure SetButtonIcon(const Value: string);
   procedure SetButtonWidth(const Value: string);
   function GetOnClick: TNotifyEvent;
   procedure SetOnClick(const Value: TNotifyEvent);
   function GetProc: TProc;
   procedure SetProc(const Value: TProc);
   function GetIdentify: string;
   procedure SetIdentify(const Value: string);
   function GetButtonModel: IButtonModel;
   procedure SetButtonModel(const Value: IButtonModel);
   function Buttons: TList<IPrismGridColumnButton>;
   function MakeHTML: string;
   function ElementID: string;
  public
   constructor Create(APrismGridColumn: IPrismGridColumn; AButtonParent: TPrismGridColumnButton = nil);
   destructor Destroy; override;

   Procedure Clear;
   function Add: IPrismGridColumnButton; overload;
   procedure Add(AButton: IPrismGridColumnButton); overload;

   property ButtonModel: IButtonModel read GetButtonModel write SetButtonModel;
   property Enabled: boolean read GetEnabled write SetEnabled;
   property Visible: boolean read GetVisible write SetVisible;
   property Caption: string read GetCaption write SetCaption;
   property Identify: string read GetIdentify write SetIdentify;
   property OnClick: TNotifyEvent read GetOnClick write SetOnClick;
   property ClickProc: TProc read GetProc write SetProc;
   property CSS: string read GetCSS write SetCSS;
   property CSSButtonType: string read GetButtonType write SetButtonType;
   property CSSButtonIcon: string read GetButtonIcon write SetButtonIcon;
   property CSSButtonWidth: string read GetButtonWidth write SetButtonWidth;
   property CSSButtonHeigth: string read GetButtonHeigth write SetButtonHeigth;
 end;



type
 TPrismGridColumnButtons = class(TInterfacedPersistent, IPrismGridColumnButtons)
  private
   FButtons: TList<IPrismGridColumnButton>;
   FPrismGridColumn: IPrismGridColumn;
   function MakeHTML: string;
   function GetButtons: TList<IPrismGridColumnButton>;
  public
   constructor Create(APrismGridColumn: IPrismGridColumn);
   destructor Destroy; override;

   Procedure Clear;
   function Add: IPrismGridColumnButton; overload;
   procedure Add(AButton: IPrismGridColumnButton); overload;

   property Items: TList<IPrismGridColumnButton> read GetButtons;
 end;




implementation

uses
  D2Bridge.Util,
  Prism.Events, StrUtils;

{ TPrismGridColumnButton }

function TPrismGridColumnButton.Add: IPrismGridColumnButton;
begin
 Result:= TPrismGridColumnButton.Create(FPrismGridColumn, self);
 Add(Result);
end;

procedure TPrismGridColumnButton.Add(AButton: IPrismGridColumnButton);
begin
 FButtons.Add(AButton);
end;

procedure TPrismGridColumnButton.Clear;
var
 vButtonIntf: IPrismGridColumnButton;
 vButton: TPrismGridColumnButton;
begin
 while FButtons.Count > 0 do
 begin
  vButtonIntf:= FButtons.Last;
  FButtons.Delete(Pred(FButtons.Count));

  vButton:= vButtonIntf as TPrismGridColumnButton;
  vButton.Free;
 end;
end;

constructor TPrismGridColumnButton.Create(APrismGridColumn: IPrismGridColumn; AButtonParent: TPrismGridColumnButton = nil);
begin
 inherited Create;

 FEnabled:= true;
 FVisible:= true;
 FPrismGridColumn:= APrismGridColumn;
 if Assigned(AButtonParent) then
  FName := 'Parent'+AButtonParent.FName+'_'+IntToStr(AButtonParent.Buttons.Count + 1)
 else
  FName := 'GridButton'+ IntToStr(FPrismGridColumn.Buttons.Items.Count + 1);
 FIdentify:= FName;
 FCaption:= '';
 FButtonType:= TCSSButtonType.Default.primary;
 FButtons:= TList<IPrismGridColumnButton>.Create;

// FPrismGridColumn.PrismGrid.Form.Session.CallBacks.

// FButtonIcon:= TPrismCSSFontAwesome.options;
// FButtonWidth: string;
// FButtonHeigth: string;
end;

destructor TPrismGridColumnButton.Destroy;
var
 vButtonModel: TButtonModel;
begin
 try
   if Assigned(FButtonModel) then
   begin
    vButtonModel:= (FButtonModel as TButtonModel);
    FButtonModel:= nil;
    vButtonModel.Free;
   end;
 except
 end;

 Clear;

 FreeAndNil(FButtons);

 inherited;
end;

function TPrismGridColumnButton.ElementID: string;
begin
 Result:= UpperCase(FPrismGridColumn.PrismGrid.NamePrefix)+FName;
end;

function TPrismGridColumnButton.GetButtonHeigth: string;
begin
 Result:= FButtonHeigth;
end;

function TPrismGridColumnButton.GetButtonIcon: string;
begin
 Result:= FButtonIcon;
end;

function TPrismGridColumnButton.GetButtonModel: IButtonModel;
begin
 result:= FButtonModel;
end;

function TPrismGridColumnButton.Buttons: TList<IPrismGridColumnButton>;
begin
 Result:= FButtons;
end;

function TPrismGridColumnButton.GetButtonType: string;
begin
 Result:= FButtonType;
end;

function TPrismGridColumnButton.GetButtonWidth: string;
begin
 Result:= FButtonWidth;
end;

function TPrismGridColumnButton.GetCaption: string;
begin
 Result:= FCaption;
end;

function TPrismGridColumnButton.GetCSS: string;
begin
 Result:= FCSS;
end;

function TPrismGridColumnButton.GetEnabled: boolean;
begin
 result:= FEnabled;
end;

function TPrismGridColumnButton.GetIdentify: string;
begin
 Result:= FIdentify;
end;

function TPrismGridColumnButton.GetOnClick: TNotifyEvent;
begin
 Result:= FOnClick;
end;

function TPrismGridColumnButton.GetProc: TProc;
begin
 Result:= FProc;
end;

function TPrismGridColumnButton.GetVisible: boolean;
begin
 Result:= FVisible;
end;

function TPrismGridColumnButton.MakeHTML: string;
var
 vCSSList: TStrings;
 I: Integer;
begin
 vCSSList:= TStringList.Create;

 if (FCaption = '') then
 begin
  FButtonIcon:= StringReplace(FButtonIcon, ' me-2', '', [rfReplaceAll]);
  FButtonIcon:= StringReplace(FButtonIcon, ' ms-2', '', [rfReplaceAll]);
 end else
 if (FButtonIcon <> '') and (FCaption <> '') then
  FButtonIcon:= FButtonIcon + ' me-2';

 if CSS <> '' then
 vCSSList.CommaText:= StringReplace(CSS, ' ', ',', [rfReplaceAll]);

 if FButtonType <> '' then
 if vCSSList.CommaText <> '' then
  vCSSList.CommaText:= vCSSList.CommaText + ',' + StringReplace(FButtonType, ' ', ',', [rfReplaceAll])
 else
  vCSSList.CommaText:= StringReplace(FButtonType, ' ', ',', [rfReplaceAll]);

 if FButtonWidth <> '' then
 if vCSSList.CommaText <> '' then
  vCSSList.CommaText:= vCSSList.CommaText + ',' + StringReplace(FButtonWidth, ' ', ',', [rfReplaceAll])
 else
  vCSSList.CommaText:= StringReplace(FButtonWidth, ' ', ',', [rfReplaceAll]);

 if FButtonHeigth <> '' then
 if vCSSList.CommaText <> '' then
  vCSSList.CommaText:= vCSSList.CommaText + ',' + StringReplace(FButtonHeigth, ' ', ',', [rfReplaceAll])
 else
  vCSSList.CommaText:= vCSSList.CommaText + StringReplace(FButtonHeigth, ' ', ',', [rfReplaceAll]);

// vCSSList.Add(FButtonIcon);

// <button type="button" class="btn btn-primary" id="BUTTON1"><i class="fe fe-share fa fa-share me-2" aria-hidden="true"></i>Button1</button>
//  ' onclick=' + StringReplace(FEventButtonClick.EventJS(ExecEventProc, 'null', true), '''', '', [rfReplaceAll]) + '' +

 result:= '';

 if FButtons.Count > 0 then
  result:= result + '<div class="d2bridgedropdown dropdown celldropdown">';

 result:= result +
  '<button recno="${recNo}" id="'+ ElementID +'" class="' + StringReplace(vCSSList.CommaText, ',', ' ', [rfReplaceAll]) + ifThen(Buttons.Count > 0, ' dropdown-toggle') + IfThen(not Visible, ' invisible') + '"' +
  ' onclick="' + AnsiUpperCase(FPrismGridColumn.PrismGrid.NamePrefix) + '_CellButtonClick('+ IntToStr(FPrismGridColumn.ColumnIndex) +',this)' + '"';
 if FButtons.Count > 0 then
 result:= result +
  ' data-bs-toggle="dropdown" aria-expanded="false"';
 if not Enabled then
 result:= result +
  ' disabled';
 result:= result +
  ' style="">';

 if FButtonIcon <> '' then
  result:= result + '<i class="' + FButtonIcon + '" aria-hidden="true"></i>';

 result:= result + Caption + '</button>';

 if FButtons.Count > 0 then
 result:= result + '<ul class="d2bridgedropdownmenu dropdown-menu" id="' + ElementID + 'dropdown" aria-labelledby="' + ElementID + '">';

 //Itens Menu Drop Down
 for I := 0 to Pred(Buttons.Count) do
  if Buttons[I].CSSButtonIcon <> '' then
   result:= result + '<li>' +
     '<a recno="${recNo}" id="' + Buttons[I].ElementID + '" class="d2bridgedropdownmenuitem dropdown-item"' +
     ' onclick="' + AnsiUpperCase(FPrismGridColumn.PrismGrid.NamePrefix) + '_CellButtonClick('+ IntToStr(FPrismGridColumn.ColumnIndex) +',this)' + '">' +
     '<i class="' + Buttons[I].CSSButtonIcon + ' me-2" aria-hidden="true"></i>' +
     Buttons[I].Caption + '</a></li>'
  else
   result:= result + '<li>'+
     '<a recno="${recNo}" id="' + Buttons[I].ElementID + '" class="d2bridgedropdownmenuitem dropdown-item"'+
     ' onclick="' + AnsiUpperCase(FPrismGridColumn.PrismGrid.NamePrefix) + '_CellButtonClick('+ IntToStr(FPrismGridColumn.ColumnIndex) +',this)' + '">' +
     Buttons[I].Caption + '</a></li>';

 if FButtons.Count > 0 then
 begin
  result:= result + '</ul>';
  result:= result + '</div>';
 end;


// <div class="dropdown celldropdown">
//
//   <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
//     Dropdown button
//   </button>
//
//   <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
//
//     <li><a class="dropdown-item" href="#">Action</a></li>
//     <li><a class="dropdown-item" href="#">Another action</a></li>
//     <li><a class="dropdown-item" href="#">Something else here</a></li>
//
//   </ul>
//
// </div>

 vCSSList.Free;
end;

procedure TPrismGridColumnButton.SetButtonHeigth(const Value: string);
begin
 FButtonHeigth:= Value;
end;

procedure TPrismGridColumnButton.SetButtonIcon(const Value: string);
var
 vCLASSIco, vIElement, vFontClass, vNewCSSClass: string;
begin
 vCLASSIco:= Value;
 CSSButtonFontToIelement(vCLASSIco, vNewCSSClass, vFontClass, vIElement);
 FButtonIcon:= vFontClass;
end;

procedure TPrismGridColumnButton.SetButtonModel(const Value: IButtonModel);
begin
 FButtonType:= Value.CSSButtonType;
 FButtonIcon:= Value.CSSButtonIcon;
 FButtonWidth:= Value.CSSButtonWidth;
 FButtonHeigth:= Value.CSSButtonHeigth;
 FCaption:= Value.Caption;
 FIdentify:= Value.Identity;
 FButtonModel:= Value;
end;

procedure TPrismGridColumnButton.SetButtonType(const Value: string);
begin
 FButtonType:= Value;
end;

procedure TPrismGridColumnButton.SetButtonWidth(const Value: string);
begin
 FButtonWidth:= Value;
end;

procedure TPrismGridColumnButton.SetCaption(const Value: string);
begin
 FCaption:= Value;
end;

procedure TPrismGridColumnButton.SetCSS(const Value: string);
begin
 FCSS:= Value;
end;

procedure TPrismGridColumnButton.SetEnabled(const Value: boolean);
begin
 FEnabled:= Value;
end;

procedure TPrismGridColumnButton.SetIdentify(const Value: string);
begin
 FIdentify:= Value;
end;

procedure TPrismGridColumnButton.SetOnClick(const Value: TNotifyEvent);
begin
 FOnClick:= Value;
end;

procedure TPrismGridColumnButton.SetProc(const Value: TProc);
begin
 FProc:= Value;
end;

procedure TPrismGridColumnButton.SetVisible(const Value: boolean);
begin
 FVisible:= Value;
end;

{ TPrismGridColumnButtons }

function TPrismGridColumnButtons.Add: IPrismGridColumnButton;
begin
 Result:= TPrismGridColumnButton.Create(FPrismGridColumn);
 Add(Result);
end;

procedure TPrismGridColumnButtons.Add(AButton: IPrismGridColumnButton);
begin
 FButtons.Add(AButton);

 FPrismGridColumn.DataFieldModel:= TPrismFieldModel.PrismFieldModelButton;
end;

procedure TPrismGridColumnButtons.Clear;
var
 vButtonInt: IPrismGridColumnButton;
 vButton: TPrismGridColumnButton;
begin
 while FButtons.Count > 0 do
 begin
  vButtonInt:= FButtons.Last;
  vButton:= vButtonInt as TPrismGridColumnButton;
  FButtons.Delete(Pred(FButtons.Count));
  vButtonInt:= nil;
  vButton.Free;
 end;
end;

constructor TPrismGridColumnButtons.Create(APrismGridColumn: IPrismGridColumn);
begin
 Inherited Create;

 FPrismGridColumn:= APrismGridColumn;

 FButtons:= TList<IPrismGridColumnButton>.Create;
end;

destructor TPrismGridColumnButtons.Destroy;
begin
 Clear;
 FreeAndNil(FButtons);

 inherited;
end;

function TPrismGridColumnButtons.GetButtons: TList<IPrismGridColumnButton>;
begin
 Result:= FButtons;
end;

function TPrismGridColumnButtons.MakeHTML: string;
var
 I: integer;
begin
 result:= '';

 for I := 0 to Pred(FButtons.Count) do
 begin
  result:= result + (FButtons.Items[I] as TPrismGridColumnButton).MakeHTML;
  if I < Pred(FButtons.Count) then
   result:= result + '<span class="me-2"></span>';
 end;

 if result <> '' then
 result:= '<div class="d2bridgecellcontrols d2bridgecellbuttons d-flex">'+ Result + '</div>';
end;

end.