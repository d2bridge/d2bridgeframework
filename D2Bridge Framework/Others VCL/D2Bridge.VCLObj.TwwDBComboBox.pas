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

unit D2Bridge.VCLObj.TwwDBComboBox;

interface

{$IFDEF INFOPOWER_AVAILABLE}
uses
  Classes,
  DBCtrls, Graphics,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass;


type
 TVCLObjTwwDBComboBox = class(TD2BridgeItemVCLObjCore)
  public
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
  Prism.Util, D2Bridge.Util, D2Bridge.Forms, vcl.wwdotdot, vcl.wwdbcomb, Forms, D2Bridge.Item.VCLObj.Style;

{ TVCLObjTwwDBComboBox }


function TVCLObjTwwDBComboBox.CSSClass: String;
begin
 result:= 'form-select';
end;

function TVCLObjTwwDBComboBox.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox;
end;

procedure TVCLObjTwwDBComboBox.ProcessEventClass;
begin
 if Assigned(TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnDblClick) then
 FrameworkItemClass.OnDblClick:=
    procedure(EventParams: TStrings)
    begin
     TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;

 if Assigned(TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnCloseUp) then
 FrameworkItemClass.OnSelect:=
    procedure(EventParams: TStrings)
    begin
     TwwDBComboBox(FD2BridgeItemVCLObj.Item).OnCloseUp(TwwDBComboBox(FD2BridgeItemVCLObj.Item),
                                                      True);
    end;
end;

procedure TVCLObjTwwDBComboBox.ProcessPropertyClass(NewObj: TObject);
begin
 if Assigned(TwwDBComboBox(FD2BridgeItemVCLObj.Item).DataSource) then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.Dataware.DataSource:= TwwDBComboBox(FD2BridgeItemVCLObj.Item).DataSource;

 if TwwDBComboBox(FD2BridgeItemVCLObj.Item).DataField <> '' then
 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.Dataware.DataField:= TwwDBComboBox(FD2BridgeItemVCLObj.Item).DataField;

 //Need to fix error in Nested
 TwwDBCombobox(FD2BridgeItemVCLObj.Item).DataSource:= nil;
 TwwDBCombobox(FD2BridgeItemVCLObj.Item).DataField:= '';

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.ProcGetItems :=
    function: TStrings
    begin
     Result:= TwwDBComboBox(FD2BridgeItemVCLObj.Item).Items;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TwwDBComboBox(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.SetVisible:=
    procedure(AValue: Variant)
    begin
     TwwDBComboBox(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.GetReadOnly:=
    function: Variant
    begin
     Result:= TwwDBComboBox(FD2BridgeItemVCLObj.Item).ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TwwDBComboBox(FD2BridgeItemVCLObj.Item).ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.Combobox.GetPlaceholder:=
    function: Variant
    begin
     if TwwDBComboBox(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TwwDBComboBox(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;


// FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.DBCombobox.ProcGetItems.Assign(TwwDBComboBox(FD2BridgeItemVCLObj.Item).Items);
end;

function TVCLObjTwwDBComboBox.PropertyCopyList: TStringList;
begin
 Result:= inherited;

 if Result.IndexOf('Text') >= 0 then
   Result.Delete(Result.IndexOf('Text'));
end;

function TVCLObjTwwDBComboBox.VCLClass: TClass;
begin
 Result:= TwwDBComboBox;
end;

procedure TVCLObjTwwDBComboBox.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TwwDBComboBox(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TwwDBComboBox(FD2BridgeItemVCLObj.Item).Font.Size;

 if TwwDBComboBox(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TwwDBComboBox(FD2BridgeItemVCLObj.Item).Font.Color;

 if TwwDBComboBox(FD2BridgeItemVCLObj.Item).Color <> clWindow then
  VCLObjStyle.Color := TwwDBComboBox(FD2BridgeItemVCLObj.Item).Color;

// if TwwDBComboBox(FD2BridgeItemVCLObj.Item).Alignment.Horz <> DefaultAlignment then
//  VCLObjStyle.Alignment:= TwwDBComboBox(FD2BridgeItemVCLObj.Item).Properties.Alignment.Horz;

 VCLObjStyle.FontStyles := TwwDBComboBox(FD2BridgeItemVCLObj.Item).Font.Style;
end;

{$ELSE}
implementation
{$ENDIF}

end.
