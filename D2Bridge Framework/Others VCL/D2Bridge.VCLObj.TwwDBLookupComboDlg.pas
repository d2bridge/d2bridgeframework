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
  Thanks for contribution to this Unit to:
    Alisson Suart
    Email: contato@deuxsoftware.com.br
 +--------------------------------------------------------------------------+
}


{$I ..\D2Bridge.inc}

unit D2Bridge.VCLObj.TwwDBLookupComboDlg;

interface

{$IFDEF INFOPOWER_AVAILABLE}
uses
  Classes, SysUtils, Forms, Graphics, vcl.wwdbdlg, DB,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTwwDBLookupComboDlg = class(TD2BridgeItemVCLObjCore)
  private
   FLookupDataSource: TDataSource; // I need to simulate a DataSource, as the Component only receives a DataSet type connection.
  public
   constructor Create(AOwner: TD2BridgeItemVCLObj); override;
   destructor Destroy; override;

   function VCLClass: TClass; override;
   function CSSClass: String; override;
   Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
   procedure ProcessPropertyClass(NewObj: TObject); override;
   procedure ProcessEventClass; override;
   function PropertyCopyList: TStringList; override;
   function FrameworkItemClass: ID2BridgeFrameworkItem; override;
 end;

implementation

uses
  DBCtrls,
  Prism.Util, D2Bridge.Util, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTwwDBLookupComboDlg }

constructor TVCLObjTwwDBLookupComboDlg.Create(AOwner: TD2BridgeItemVCLObj);
begin
  inherited Create(AOwner);
  FLookupDataSource := TDataSource.Create(nil);
end;

destructor TVCLObjTwwDBLookupComboDlg.Destroy;
begin
  FLookupDataSource.Free;
  inherited Destroy;
end;

function TVCLObjTwwDBLookupComboDlg.CSSClass: String;
begin
 result:= 'form-select';
end;

function TVCLObjTwwDBLookupComboDlg.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox;
end;

procedure TVCLObjTwwDBLookupComboDlg.ProcessEventClass;
begin
 if Assigned(TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;

 if Assigned(TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).OnCloseUp) then
 FrameworkItemClass.OnSelect:=
    procedure(EventParams: TStrings)
    begin
     TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).OnCloseUp(FD2BridgeItemVCLObj.Item,
                                                             TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupTable,
                                                             TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).DataSource.DataSet,
                                                             True);
    end;
end;

procedure TVCLObjTwwDBLookupComboDlg.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.DataSource.DataSource:= TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).DataSource;

 if (TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).DataField <> '') then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.DataSource.DataField:= TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).DataField;

 if Assigned(TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupTable) then
 begin // I need to associate it with the Virtual DataSource, so that the items can be listed correctly.
    FLookupDataSource.DataSet := TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupTable;
    FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListSource:= FLookupDataSource;
 end ;

 if (TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupField <> '') then
 if AnsiPos(';', TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupField) > 0 then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListField:= Copy(TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupField, AnsiPos(';', TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupField) + 1, Length(TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupField) - AnsiPos(';', TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupField))
 else
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListField:= TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupField;

 if (TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupField <> '') then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.KeyField:= TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupField;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.OnGetText:=
    function: Variant
    begin
     Result:= TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.OnSetText:=
    procedure(AValue: Variant)
    begin
     if AValue <> '' then
     TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).LookupValue:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetReadOnly:=
    function: Variant
    begin
     Result:= TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetPlaceholder:=
    function: Variant
    begin
     if TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;

end;

function TVCLObjTwwDBLookupComboDlg.PropertyCopyList: TStringList;
begin
 Result:= inherited;

 if Result.IndexOf('Text') >= 0 then
   Result.Delete(Result.IndexOf('Text'));
end;

function TVCLObjTwwDBLookupComboDlg.VCLClass: TClass;
begin
 Result:= TwwDBLookupComboDlg;
end;

procedure TVCLObjTwwDBLookupComboDlg.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).Font.Size <> Application.DefaultFont.Size then
  VCLObjStyle.FontSize := TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).Font.Size;

 if (TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).Font.Color <> clWindowText) then
  VCLObjStyle.FontColor := TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).Font.Color;

 if (TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).Color <> clWindow) then
  VCLObjStyle.Color := TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).Color;

 VCLObjStyle.FontStyles := TwwDBLookupComboDlg(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.
