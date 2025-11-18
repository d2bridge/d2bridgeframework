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

unit D2Bridge.Item.HTML.Editor;

interface

uses
  Classes, SysUtils, Generics.Collections,
  Prism.Interfaces,
  D2Bridge.Item, D2Bridge.BaseClass, D2Bridge.Item.VCLObj, D2Bridge.Interfaces
  {$IFDEF FMX}

  {$ELSE}

  {$ENDIF}
  ;

type
  TD2BridgeItemHTMLEditor = class(TD2BridgeItem, ID2BridgeItemHTMLEditor)
   //events
   procedure BeginReader; virtual;
   procedure EndReader; virtual;
  private

  strict protected
   function GetTextVCLComponent: TComponent;
   procedure SetTextVCLComponent(AComponent: TComponent);
   function GetHeight: Integer;
   procedure SetHeight(const Value: Integer);
   function GetShowButtonBold: boolean;
   function GetShowButtonCode: Boolean;
   function GetShowButtonFullScrean: Boolean;
   function GetShowButtonHeading: boolean;
   function GetShowButtonHelp: Boolean;
   function GetShowButtonItalic: boolean;
   function GetShowButtonLink: Boolean;
   function GetShowButtonList: Boolean;
   function GetShowButtonNumList: Boolean;
   function GetShowButtonRule: Boolean;
   function GetShowButtonStrikethrough: boolean;
   function GetShowButtonTable: Boolean;
   function GetShowButtonImage: Boolean;
   function GetShowToolbar: Boolean;
   procedure SetShowButtonBold(const Value: boolean);
   procedure SetShowButtonCode(const Value: Boolean);
   procedure SetShowButtonFullScrean(const Value: Boolean);
   procedure SetShowButtonHeading(const Value: boolean);
   procedure SetShowButtonHelp(const Value: Boolean);
   procedure SetShowButtonImage(const Value: Boolean);
   procedure SetShowButtonItalic(const Value: boolean);
   procedure SetShowButtonLink(const Value: Boolean);
   procedure SetShowButtonList(const Value: Boolean);
   procedure SetShowButtonNumList(const Value: Boolean);
   procedure SetShowButtonRule(const Value: Boolean);
   procedure SetShowButtonStrikethrough(const Value: boolean);
   procedure SetShowButtonTable(const Value: Boolean);
   procedure SetShowToolbar(const Value: Boolean);
  protected
   FD2BridgeItem: TD2BridgeItem;
   function PrismEditor: IPrismEditor;
  public
   constructor Create(AOwner: TD2BridgeClass); override;
   destructor Destroy; override;

   procedure PreProcess; override;
   procedure Render; override;
   procedure RenderHTML; override;

   property ShowToolbar: Boolean read GetShowToolbar write SetShowToolbar;
   property ShowButtonBold: boolean read GetShowButtonBold write SetShowButtonBold;
   property ShowButtonCode: Boolean read GetShowButtonCode write SetShowButtonCode;
   property ShowButtonFullScrean: Boolean read GetShowButtonFullScrean write SetShowButtonFullScrean;
   property ShowButtonHeading: boolean read GetShowButtonHeading write SetShowButtonHeading;
   property ShowButtonHelp: Boolean read GetShowButtonHelp write SetShowButtonHelp;
   property ShowButtonImage: Boolean read GetShowButtonImage write SetShowButtonImage;
   property ShowButtonItalic: boolean read GetShowButtonItalic write SetShowButtonItalic;
   property ShowButtonLink: Boolean read GetShowButtonLink write SetShowButtonLink;
   property ShowButtonList: Boolean read GetShowButtonList write SetShowButtonList;
   property ShowButtonNumList: Boolean read GetShowButtonNumList write SetShowButtonNumList;
   property ShowButtonRule: Boolean read GetShowButtonRule write SetShowButtonRule;
   property ShowButtonStrikethrough: boolean read GetShowButtonStrikethrough write SetShowButtonStrikethrough;
   property ShowButtonTable: Boolean read GetShowButtonTable write SetShowButtonTable;

   property Height: Integer read GetHeight write SetHeight;
   property TextVCLComponent: TComponent read GetTextVCLComponent write SetTextVCLComponent;
  end;

implementation

Uses
 Prism.Editor, Prism.Forms, Prism.Forms.Controls,
 D2Bridge.Util;

{ TD2BridgeItemHTMLEditor }

procedure TD2BridgeItemHTMLEditor.BeginReader;
begin
 (BaseClass.Form as TPrismForm).AddControl(FPrismControl);
end;

constructor TD2BridgeItemHTMLEditor.Create(AOwner: TD2BridgeClass);
begin
 FD2BridgeItem:= Inherited Create(AOwner);

 FD2BridgeItem.OnBeginReader:= BeginReader;
 FD2BridgeItem.OnEndReader:= EndReader;
end;

destructor TD2BridgeItemHTMLEditor.Destroy;
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

 inherited;
end;

procedure TD2BridgeItemHTMLEditor.EndReader;
begin

end;

function TD2BridgeItemHTMLEditor.GetHeight: Integer;
begin
 result:= PrismEditor.Height;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonBold: boolean;
begin
 result:= PrismEditor.ShowButtonBold;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonCode: Boolean;
begin
result:= PrismEditor.ShowButtonCode;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonFullScrean: Boolean;
begin
 result:= PrismEditor.ShowButtonFullScrean;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonHeading: boolean;
begin
 result:= PrismEditor.ShowButtonHeading;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonHelp: Boolean;
begin
 result:= PrismEditor.ShowButtonHelp;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonImage: Boolean;
begin
 result:= PrismEditor.ShowButtonImage;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonItalic: boolean;
begin
 result:= PrismEditor.ShowButtonItalic;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonLink: Boolean;
begin
 result:= PrismEditor.ShowButtonLink;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonList: Boolean;
begin
 result:= PrismEditor.ShowButtonList;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonNumList: Boolean;
begin
 result:= PrismEditor.ShowButtonNumList;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonRule: Boolean;
begin
 result:= PrismEditor.ShowButtonRule;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonStrikethrough: boolean;
begin
 result:= PrismEditor.ShowButtonStrikethrough;
end;

function TD2BridgeItemHTMLEditor.GetShowButtonTable: Boolean;
begin
 result:= PrismEditor.ShowButtonTable;
end;

function TD2BridgeItemHTMLEditor.GetShowToolbar: Boolean;
begin
 result:= PrismEditor.ShowToolbar;
end;

function TD2BridgeItemHTMLEditor.GetTextVCLComponent: TComponent;
begin
 result:= PrismEditor.TextVCLComponent;
end;

procedure TD2BridgeItemHTMLEditor.PreProcess;
begin
  inherited;

end;

function TD2BridgeItemHTMLEditor.PrismEditor: IPrismEditor;
begin
 result:= GetPrismControl as IPrismEditor;
end;

procedure TD2BridgeItemHTMLEditor.Render;
begin
 BaseClass.HTML.Render.Body.Add('{%'+TrataHTMLTag(ItemPrefixID+' class="d2bridgeeditor '+Trim(CSSClasses)+'" style="'+GetHTMLStyle+'" '+ GetHTMLExtras) + '%}');
end;

procedure TD2BridgeItemHTMLEditor.RenderHTML;
begin
  inherited;

end;

procedure TD2BridgeItemHTMLEditor.SetHeight(const Value: Integer);
begin
 PrismEditor.Height:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonBold(
  const Value: boolean);
begin
 PrismEditor.ShowButtonBold:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonCode(
  const Value: Boolean);
begin
 PrismEditor.ShowButtonCode:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonFullScrean(
  const Value: Boolean);
begin
 PrismEditor.ShowButtonFullScrean:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonHeading(
  const Value: boolean);
begin
 PrismEditor.ShowButtonHeading:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonHelp(
  const Value: Boolean);
begin
 PrismEditor.ShowButtonHelp:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonImage(
  const Value: Boolean);
begin
 PrismEditor.ShowButtonImage:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonItalic(
  const Value: boolean);
begin
 PrismEditor.ShowButtonItalic:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonLink(
  const Value: Boolean);
begin
 PrismEditor.ShowButtonLink:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonList(
  const Value: Boolean);
begin
 PrismEditor.ShowButtonList:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonNumList(
  const Value: Boolean);
begin
 PrismEditor.ShowButtonNumList:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonRule(
  const Value: Boolean);
begin
 PrismEditor.ShowButtonRule:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonStrikethrough(
  const Value: boolean);
begin
 PrismEditor.ShowButtonStrikethrough:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowButtonTable(
  const Value: Boolean);
begin
 PrismEditor.ShowButtonTable:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetShowToolbar(
  const Value: Boolean);
begin
 PrismEditor.ShowToolbar:= Value;
end;

procedure TD2BridgeItemHTMLEditor.SetTextVCLComponent(
  AComponent: TComponent);
begin
 PrismEditor.TextVCLComponent:= AComponent;
end;

end.
