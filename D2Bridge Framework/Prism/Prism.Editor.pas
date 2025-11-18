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

unit Prism.Editor;

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
 Prism.Forms.Controls, Prism.Interfaces, Prism.Types, Prism.DataLink.Field;

type
  TPrismEditor = class(TPrismControl, IPrismEditor)
  private
{$IFnDEF FMX}
   FDataLinkField: TPrismDataLinkField;
{$ENDIF}
   FTextVCLComponent: TComponent;
   FHeight: integer;
   FShowButtonBold: boolean;
   FShowButtonCode: Boolean;
   FShowButtonFullScrean: Boolean;
   FShowButtonHeading: boolean;
   FShowButtonHelp: Boolean;
   FShowButtonImage: Boolean;
   FShowButtonItalic: boolean;
   FShowButtonLink: Boolean;
   FShowButtonList: Boolean;
   FShowButtonNumList: Boolean;
   FShowButtonRule: Boolean;
   FShowButtonSplit: Boolean;
   FShowButtonStrikethrough: boolean;
   FShowButtonTable: Boolean;
   FShowToolbar: Boolean;
  strict protected
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
   function GetText: string;
   procedure SetText(const Value: string);
   function GetTextVCLComponent: TComponent;
   procedure SetTextVCLComponent(AComponent: TComponent);
   function GetHeight: Integer;
   procedure SetHeight(const Value: Integer);
  protected
   FStoredText: string;
   procedure Initialize; override;
   procedure ProcessEventParameters(Event: IPrismControlEvent; Parameters: TStrings); override;
   procedure ProcessComponentState(const ComponentStateInfo: TJSONObject); override;
   function GetEnableComponentState: Boolean; override;
   function GetVCLComponent: TComponent; override;
   function GetEnabled: Boolean; override;
   function GetReadOnly: Boolean; override;
  public
   constructor Create(AOwner: TObject); override;
   destructor Destroy; override;

{$IFnDEF FMX}
   function DataWare: TPrismDataLinkField;
{$ENDIF}

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

   property Text: string read GetText write SetText;
   property TextVCLComponent: TComponent read GetTextVCLComponent write SetTextVCLComponent;
   property Height: integer read GetHeight write SetHeight;
 end;

implementation

Uses
 D2Bridge.Forms, D2Bridge.Util;

{ TPrismEditor }

constructor TPrismEditor.Create(AOwner: TObject);
begin
 inherited;

{$IFnDEF FMX}
 FDataLinkField:= TPrismDataLinkField.Create(self);
{$ENDIF}

 FHeight:= 0;
 FShowButtonBold:= true;
 FShowButtonCode:= true;
 FShowButtonFullScrean:= true;
 FShowButtonHeading:= true;
 FShowButtonHelp:= true;
 FShowButtonImage:= true;
 FShowButtonItalic:= true;
 FShowButtonLink:= true;
 FShowButtonList:= true;
 FShowButtonNumList:= true;
 FShowButtonRule:= true;
 FShowButtonStrikethrough:= true;
 FShowButtonTable:= true;
 FShowToolbar:= true;
end;

{$IFnDEF FMX}
function TPrismEditor.DataWare: TPrismDataLinkField;
begin
 result:= FDataLinkField;
end;
{$ENDIF}

destructor TPrismEditor.Destroy;
begin
{$IFnDEF FMX}
 FDataLinkField.Free;
{$ENDIF}

 inherited;
end;

function TPrismEditor.GetEnableComponentState: Boolean;
begin
 Result:= true;
end;

function TPrismEditor.GetEnabled: Boolean;
begin
 if Assigned(FTextVCLComponent) then
 begin
  if (TextVCLComponent is TLabel) //Label's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (TextVCLComponent is TcxLabel)
   or (TextVCLComponent is TcxDBLabel)
{$ENDIF}
{$IFNDEF FMX} or (TextVCLComponent is TDBText){$ENDIF} then
   Result:= TLabel(TextVCLComponent).Enabled
  else
  if (TextVCLComponent is TEdit) //Edit's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (TextVCLComponent is TcxTextEdit)
   or (TextVCLComponent is TcxDBTextEdit)
{$ENDIF}
{$IFNDEF FMX} or (TextVCLComponent is TDBEdit){$ENDIF} then
   Result:= TEdit(TextVCLComponent).Enabled
  else
  if (TextVCLComponent is TMemo) //Memo's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (TextVCLComponent is TcxMemo)
   or (TextVCLComponent is TcxDBMemo)
{$ENDIF}
{$IFNDEF FMX} or (TextVCLComponent is TDBMemo){$ENDIF} then
   Result:= TMemo(TextVCLComponent).Enabled
 end else
{$IFnDEF FMX}
 if Assigned(FDataLinkField.DataSource) and (FDataLinkField.FieldName <> '') then
 begin
  Result:= FDataLinkField.Edit;
 end else
{$ENDIF}
  Result:= Inherited;
end;

function TPrismEditor.GetHeight: Integer;
begin
 result:= FHeight;
end;

function TPrismEditor.GetReadOnly: Boolean;
begin
 if Assigned(FTextVCLComponent) then
 begin
  if (TextVCLComponent is TLabel) //Label's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (TextVCLComponent is TcxLabel)
   or (TextVCLComponent is TcxDBLabel)
{$ENDIF}
{$IFNDEF FMX} or (TextVCLComponent is TDBText){$ENDIF} then
   Result:= True
  else
  if (TextVCLComponent is TEdit) //Edit's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (TextVCLComponent is TcxTextEdit)
   or (TextVCLComponent is TcxDBTextEdit)
{$ENDIF}
{$IFNDEF FMX} or (TextVCLComponent is TDBEdit){$ENDIF} then
   Result:= TEdit(TextVCLComponent).ReadOnly
  else
  if (TextVCLComponent is TMemo) //Memo's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (TextVCLComponent is TcxMemo)
   or (TextVCLComponent is TcxDBMemo)
{$ENDIF}
{$IFNDEF FMX} or (TextVCLComponent is TDBMemo){$ENDIF} then
   Result:= TMemo(TextVCLComponent).ReadOnly
 end else
{$IFnDEF FMX}
 if Assigned(FDataLinkField.DataSource) and (FDataLinkField.FieldName <> '') then
 begin
  Result:= Inherited;

  if not result then
   result:= FDataLinkField.ReadOnly;
 end else
{$ENDIF}
  Result:= Inherited;
end;

function TPrismEditor.GetShowButtonBold: boolean;
begin
 Result:= FShowButtonBold;
end;

function TPrismEditor.GetShowButtonCode: Boolean;
begin
 Result:= FShowButtonCode;
end;

function TPrismEditor.GetShowButtonFullScrean: Boolean;
begin
 Result:= FShowButtonFullScrean;
end;

function TPrismEditor.GetShowButtonHeading: boolean;
begin
 Result:= FShowButtonHeading;
end;

function TPrismEditor.GetShowButtonHelp: Boolean;
begin
 Result:= FShowButtonHelp;
end;

function TPrismEditor.GetShowButtonImage: Boolean;
begin
 Result:= FShowButtonImage;
end;

function TPrismEditor.GetShowButtonItalic: boolean;
begin
 Result:= FShowButtonItalic;
end;

function TPrismEditor.GetShowButtonLink: Boolean;
begin
 Result:= FShowButtonLink;
end;

function TPrismEditor.GetShowButtonList: Boolean;
begin
 Result:= FShowButtonLink;
end;

function TPrismEditor.GetShowButtonNumList: Boolean;
begin
 Result:= FShowButtonNumList;
end;

function TPrismEditor.GetShowButtonRule: Boolean;
begin
 Result:= FShowButtonRule;
end;

function TPrismEditor.GetShowButtonStrikethrough: boolean;
begin
 Result:= FShowButtonStrikethrough;
end;

function TPrismEditor.GetShowButtonTable: Boolean;
begin
 Result:= FShowButtonTable;
end;

function TPrismEditor.GetShowToolbar: Boolean;
begin
 Result:= FShowToolbar;
end;

function TPrismEditor.GetText: string;
begin
 if Assigned(TextVCLComponent) then
 begin
  if (TextVCLComponent is TLabel) //Label's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (TextVCLComponent is TcxLabel)
   or (TextVCLComponent is TcxDBLabel)
{$ENDIF}
{$IFNDEF FMX} or (TextVCLComponent is TDBText){$ENDIF} then
   Result:= TLabel(TextVCLComponent).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}
  else
  if (TextVCLComponent is TEdit) //Edit's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (TextVCLComponent is TcxTextEdit)
   or (TextVCLComponent is TcxDBTextEdit)
{$ENDIF}
{$IFNDEF FMX} or (TextVCLComponent is TDBEdit){$ENDIF} then
   Result:= TEdit(TextVCLComponent).Text
  else
  if (TextVCLComponent is TMemo) //Memo's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (TextVCLComponent is TcxMemo)
   or (TextVCLComponent is TcxDBMemo)
{$ENDIF}
{$IFNDEF FMX} or (TextVCLComponent is TDBMemo){$ENDIF} then
   Result:= TrimRight(TMemo(TextVCLComponent).Text)
 end else
{$IFnDEF FMX}
 if Assigned(FDataLinkField.DataSource) and (FDataLinkField.FieldName <> '') then
 begin
  Result:= FDataLinkField.FieldText;
 end else
{$ENDIF}
  Result:= FStoredText;
end;

function TPrismEditor.GetTextVCLComponent: TComponent;
begin
 result:= FTextVCLComponent;
end;

function TPrismEditor.GetVCLComponent: TComponent;
begin
 if Assigned(FTextVCLComponent) then
  Result:= FTextVCLComponent
 else
  Result:= Inherited;

end;

procedure TPrismEditor.Initialize;
begin
 inherited;

 FStoredText:= Text;
end;

procedure TPrismEditor.ProcessComponentState(const ComponentStateInfo: TJSONObject);
var
 vText,
 vOldText: string;
begin
 inherited;

 if (ComponentStateInfo.GetValue('text') <> nil) then
 begin
  vText:= ComponentStateInfo.GetValue('text').Value;

  vOldText:= FStoredText;
  vOldText:= StringReplace(vOldText, #13#10, #10, [rfReplaceAll]);
  vOldText:= StringReplace(vOldText, #13, #10, [rfReplaceAll]);

  if vText <> vOldText then
  begin
   Text:= vText;
  end;
 end;
end;

procedure TPrismEditor.ProcessEventParameters(
  Event: IPrismControlEvent; Parameters: TStrings);
begin
  inherited;

end;

procedure TPrismEditor.SetHeight(const Value: Integer);
begin
 FHeight:= Value;
end;

procedure TPrismEditor.SetShowButtonBold(const Value: boolean);
begin
 FShowButtonBold:= Value;
end;

procedure TPrismEditor.SetShowButtonCode(const Value: Boolean);
begin
 FShowButtonCode:= Value;
end;

procedure TPrismEditor.SetShowButtonFullScrean(const Value: Boolean);
begin
 FShowButtonFullScrean:= Value;
end;

procedure TPrismEditor.SetShowButtonHeading(const Value: boolean);
begin
 FShowButtonHeading:= Value;
end;

procedure TPrismEditor.SetShowButtonHelp(const Value: Boolean);
begin
 FShowButtonHelp:= Value;
end;

procedure TPrismEditor.SetShowButtonImage(const Value: Boolean);
begin
 FShowButtonImage:= Value;
end;

procedure TPrismEditor.SetShowButtonItalic(const Value: boolean);
begin
 FShowButtonItalic:= Value;
end;

procedure TPrismEditor.SetShowButtonLink(const Value: Boolean);
begin
 FShowButtonLink:= Value;
end;

procedure TPrismEditor.SetShowButtonList(const Value: Boolean);
begin
 FShowButtonList:= Value;
end;

procedure TPrismEditor.SetShowButtonNumList(const Value: Boolean);
begin
 FShowButtonNumList:= Value;
end;

procedure TPrismEditor.SetShowButtonRule(const Value: Boolean);
begin
 FShowButtonRule:= Value;
end;

procedure TPrismEditor.SetShowButtonStrikethrough(const Value: boolean);
begin
 FShowButtonStrikethrough:= Value;
end;

procedure TPrismEditor.SetShowButtonTable(const Value: Boolean);
begin
 FShowButtonTable:= Value;
end;

procedure TPrismEditor.SetShowToolbar(const Value: Boolean);
begin
 FShowToolbar:= Value;
end;

procedure TPrismEditor.SetText(const Value: string);
begin
 if Assigned(TextVCLComponent) then
 begin
  if (TextVCLComponent is TLabel) //Label's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (TextVCLComponent is TcxLabel)
   or (TextVCLComponent is TcxDBLabel)
{$ENDIF}
{$IFNDEF FMX} or (TextVCLComponent is TDBText){$ENDIF} then
   TLabel(TextVCLComponent).{$IFNDEF FMX}Caption{$ELSE}Text{$ENDIF}:= Value
  else
  if (TextVCLComponent is TEdit) //Edit's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (TextVCLComponent is TcxTextEdit)
   or (TextVCLComponent is TcxDBTextEdit)
{$ENDIF}
{$IFNDEF FMX} or (TextVCLComponent is TDBEdit){$ENDIF} then
   TEdit(TextVCLComponent).Text:= Value
  else
  if (TextVCLComponent is TMemo) //Memo's
{$IFDEF DEVEXPRESS_AVAILABLE}
   or (TextVCLComponent is TcxMemo)
   or (TextVCLComponent is TcxDBMemo)
{$ENDIF}
{$IFNDEF FMX} or (TextVCLComponent is TDBMemo){$ENDIF} then
   TMemo(TextVCLComponent).Text:= Value;
{$IFnDEF FMX}
 end else
 if Assigned(FDataLinkField.DataSource) and (FDataLinkField.FieldName <> '') then
 begin
  FDataLinkField.FieldValue:= Value;
{$ENDIF}
 end;

 FStoredText:= Value;
end;

procedure TPrismEditor.SetTextVCLComponent(AComponent: TComponent);
begin
 FTextVCLComponent:= AComponent;
end;


end.

