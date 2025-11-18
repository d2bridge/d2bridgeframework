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

unit D2Bridge.VCLObj.TcxButtonEdit;


interface

{$IFDEF DEVEXPRESS_AVAILABLE}

uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass,
  ExtCtrls, Controls, Graphics, Forms;

type
 TVCLObjTcxButtonEdit = class(TD2BridgeItemVCLObjCore)
  public
   function VCLClass: TClass; override;
   function CSSClass: String; override;
   Procedure VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle); override;
   procedure ProcessPropertyClass(NewObj: TObject); override;
   procedure ProcessEventClass; override;
   function FrameworkItemClass: ID2BridgeFrameworkItem; override;
 end;


implementation

uses
 Prism.Util, Prism.Types, D2Bridge.Util, D2Bridge.Item.VCLObj.Style, D2Bridge.Prism.ButtonedEdit,
 cxButtonEdit, cxDBEdit;

{ VCLObjTcxButtonEdit }


function TVCLObjTcxButtonEdit.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTcxButtonEdit.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit;
end;

procedure TVCLObjTcxButtonEdit.ProcessEventClass;
begin
 if Assigned(TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnDblClick) then
  FrameworkItemClass.OnDblClick:=
    procedure(EventParams: TStrings)
    begin
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnDblClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.OnButtonClick) then
  PrismButtonedEdit(FrameworkItemClass).OnRightButtonClick:=
    procedure(EventParams: TStrings)
    begin
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.OnButtonClick(FD2BridgeItemVCLObj.Item, 0);
    end;

 if Assigned(TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.OnChange) then
 FrameworkItemClass.OnChange:=
    procedure(EventParams: TStrings)
    begin
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.OnChange(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
      KeyChar:  Char;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
      KeyChar:  Char;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTcxButtonEdit.ProcessPropertyClass(NewObj: TObject);
begin
 if TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.PasswordChar <> #0 then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.DataType:= PrismFieldTypePassword;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.CharCase:= TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.CharCase;

 if TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.Buttons.Count > 0 then
  FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.ButtonRightText:= TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.Buttons.Items[0].Caption;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 PrismButtonedEdit(FrameworkItemClass).GetRightButtonEnabled:=
    function: Variant
    begin
     if TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.Buttons.Count > 0 then
      Result:= TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.Buttons.Items[0].Enabled
     else
      Result:= false;
    end;

 PrismButtonedEdit(FrameworkItemClass).GetRightButtonVisible:=
    function: Variant
    begin
     if TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.Buttons.Count > 0 then
      Result:= TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.Buttons.Items[0].Visible
     else
      Result:= false;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetVisible:=
    procedure(AValue: Variant)
    begin
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetReadOnly:=
    function: Variant
    begin
     Result:= TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.ReadOnly;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetReadOnly:=
    procedure(AValue: Variant)
    begin
     TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.ReadOnly:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetPlaceholder:=
    function: Variant
    begin
     if TcxButtonEdit(FD2BridgeItemVCLObj.Item).TextHint <> '' then
      Result:= TcxButtonEdit(FD2BridgeItemVCLObj.Item).TextHint
     else

     if TcxButtonEdit(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TcxButtonEdit(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.OnGetText:=
    function: Variant
    begin
     if (FD2BridgeItemVCLObj.Item is TcxDBButtonEdit) and
        (Assigned(TcxDBButtonEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataSource) and (TcxDBButtonEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataField <> '')) and
        (TcxDBButtonEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataSource.DataSet.Active) then
     begin
      try
       Result:=
        TcxDBButtonEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataSource.DataSet
         .FieldByName(TcxDBButtonEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataField).AsString;
      except
      end;
     end else
      Result:= TcxButtonEdit(FD2BridgeItemVCLObj.Item).Text;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.OnSetText:=
    procedure(AValue: Variant)
    begin
     if (FD2BridgeItemVCLObj.Item is TcxDBButtonEdit) and
        (Assigned(TcxDBButtonEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataSource) and (TcxDBButtonEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataField <> '')) and
        (TcxDBButtonEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataSource.DataSet.Active) then
     begin
      try
       if (TcxDBButtonEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataLink.Editing) or
          (TcxDBButtonEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataLink.Edit) then
       begin
        TcxDBButtonEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataSource.DataSet
         .FieldByName(TcxDBButtonEdit(FD2BridgeItemVCLObj.Item).DataBinding.DataField)
         .Value:= AValue;
       end;
      except
      end;
     end else
      TcxButtonEdit(FD2BridgeItemVCLObj.Item).Text:= AValue;
    end;
end;

function TVCLObjTcxButtonEdit.VCLClass: TClass;
begin
 Result:= TcxButtonEdit;
end;

procedure TVCLObjTcxButtonEdit.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TcxButtonEdit(FD2BridgeItemVCLObj.Item).Style.Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TcxButtonEdit(FD2BridgeItemVCLObj.Item).Style.Font.Size;

 if TcxButtonEdit(FD2BridgeItemVCLObj.Item).Style.Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TcxButtonEdit(FD2BridgeItemVCLObj.Item).Style.Font.Color;

 if TcxButtonEdit(FD2BridgeItemVCLObj.Item).Style.Color <> DefaultColor then
  VCLObjStyle.Color := TcxButtonEdit(FD2BridgeItemVCLObj.Item).Style.Color;

 if TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.Alignment.Horz <> DefaultAlignment then
  VCLObjStyle.Alignment:= TcxButtonEdit(FD2BridgeItemVCLObj.Item).Properties.Alignment.Horz;

 VCLObjStyle.FontStyles := TcxButtonEdit(FD2BridgeItemVCLObj.Item).Style.Font.Style;
end;


{$ELSE}
implementation
{$ENDIF}

end.
