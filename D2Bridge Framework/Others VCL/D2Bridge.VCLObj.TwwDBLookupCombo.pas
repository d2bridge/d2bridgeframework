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

unit D2Bridge.VCLObj.TwwDBLookupCombo;

interface

{$IFDEF INFOPOWER_AVAILABLE}
uses
  Classes, Graphics, DB, vcl.wwdblook,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTwwDBLookupCombo = class(TD2BridgeItemVCLObjCore)
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
  SysUtils, DBCtrls, Prism.Util, D2Bridge.Util,
  Forms, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTwwDBLookupCombo }

constructor TVCLObjTwwDBLookupCombo.Create(AOwner: TD2BridgeItemVCLObj);
begin
 inherited Create(AOwner);

 FLookupDataSource:= TDataSource.Create(Nil);
end;

destructor TVCLObjTwwDBLookupCombo.Destroy;
begin
  FLookupDataSource.Free;
  inherited Destroy;
end;

function TVCLObjTwwDBLookupCombo.CSSClass: String;
begin
 result:= 'form-select';
end;

function TVCLObjTwwDBLookupCombo.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox;
end;

procedure TVCLObjTwwDBLookupCombo.ProcessEventClass;
begin
 if Assigned(TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;

 if Assigned(TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).OnCloseUp) then
 FrameworkItemClass.OnSelect:=
    procedure(EventParams: TStrings)
    begin
     TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).OnCloseUp(FD2BridgeItemVCLObj.Item,
                                                             TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupTable,
                                                             TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).DataSource.DataSet,
                                                             True);
    end;
end;

procedure TVCLObjTwwDBLookupCombo.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.DataSource.DataSource:= TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).DataSource;

 if (TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).DataField <> '') then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.DataSource.DataField:= TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).DataField;

 if Assigned(TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupTable) then
 begin // I need to associate it with the Virtual DataSource, so that the items can be listed correctly.
   FLookupDataSource.DataSet := TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupTable;
   FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListSource:= FLookupDataSource;
 end ;

 if (TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupField <> '') then
 if AnsiPos(';', TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupField) > 0 then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListField:= Copy(TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupField, 0, AnsiPos(';', TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupField) -1)
 else
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.ListField:= TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupField;

 if (TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupField <> '') then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.Dataware.ListSource.KeyField:= TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupField;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.OnGetText:=
    function: Variant
    begin
     Result:= TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.OnSetText:=
    procedure(AValue: Variant)
    begin
     if AValue <> '' then
     TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).LookupValue:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetReadOnly:=
    function: Variant
    begin
     Result:= TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBLookupCombobox.GetPlaceholder:=
    function: Variant
    begin
     if TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;


end;

function TVCLObjTwwDBLookupCombo.PropertyCopyList: TStringList;
begin
 Result:= inherited;

 if Result.IndexOf('Text') >= 0 then
   Result.Delete(Result.IndexOf('Text'));
end;

function TVCLObjTwwDBLookupCombo.VCLClass: TClass;
begin
 Result:= TwwDBLookupCombo;
end;

procedure TVCLObjTwwDBLookupCombo.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).Font.Size;

 if TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).Font.Color;

 if TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).Color <> clWindow then
  VCLObjStyle.Color := TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).Color;

// if TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).Alignment.Horz <> DefaultAlignment then
//  VCLObjStyle.Alignment:= TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).Properties.Alignment.Horz;

 VCLObjStyle.FontStyles := TwwDBLookupCombo(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.
