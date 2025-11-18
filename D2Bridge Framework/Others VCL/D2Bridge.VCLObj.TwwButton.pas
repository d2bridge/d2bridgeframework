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

{$I D2Bridge.inc}

unit D2Bridge.VCLObj.TwwButton;

interface

{$IFDEF INFOPOWER_AVAILABLE}

uses
  System.Classes,
  D2Bridge.Interfaces, D2Bridge.Item, D2Bridge.Item.VCLObj, D2Bridge.BaseClass,
  Vcl.ExtCtrls, Vcl.Controls, Vcl.Graphics, Vcl.Forms;

type
 TVCLObjTwwButton = class(TD2BridgeItemVCLObjCore)
  private
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
 wwButton;

{ TVCLObjTwwButton }

function TVCLObjTwwButton.CSSClass: String;
begin
 result:= 'form-control';
end;

function TVCLObjTwwButton.FrameworkItemClass: ID2BridgeFrameworkItem;
begin
 Result:= FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit;
end;

procedure TVCLObjTwwButton.ProcessEventClass;
begin
 if Assigned(TwwButton(FD2BridgeItemVCLObj.Item).OnClick) then
 FrameworkItemClass.OnClick:=
    procedure(EventParams: TStrings)
    begin
     TwwButton(FD2BridgeItemVCLObj.Item).OnClick(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwButton(FD2BridgeItemVCLObj.Item).OnEnter) then
 FrameworkItemClass.OnEnter:=
    procedure(EventParams: TStrings)
    begin
     TwwButton(FD2BridgeItemVCLObj.Item).OnEnter(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwButton(FD2BridgeItemVCLObj.Item).OnExit) then
 FrameworkItemClass.OnExit:=
    procedure(EventParams: TStrings)
    begin
     TwwButton(FD2BridgeItemVCLObj.Item).OnExit(FD2BridgeItemVCLObj.Item);
    end;

 if Assigned(TwwButton(FD2BridgeItemVCLObj.Item).OnKeyDown) then
 FrameworkItemClass.OnKeyDown:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
      KeyChar:  Char;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwButton(FD2BridgeItemVCLObj.Item).OnKeyDown(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwButton(FD2BridgeItemVCLObj.Item).OnKeyUp) then
 FrameworkItemClass.OnKeyUp:=
    procedure(EventParams: TStrings)
    var
      KeyPress: word;
      KeyChar:  Char;
    begin
     KeyPress := ConvertHTMLKeyToVK(EventParams.values['key']);
     TwwButton(FD2BridgeItemVCLObj.Item).OnKeyUp(FD2BridgeItemVCLObj.Item, KeyPress, []);
    end;

 if Assigned(TwwButton(FD2BridgeItemVCLObj.Item).OnKeyPress) then
 FrameworkItemClass.OnKeyPress:=
    procedure(EventParams: TStrings)
    var
      KeyPress: Char;
    begin
     KeyPress := Chr(ConvertHTMLKeyToVK(EventParams.values['key']));
     TwwButton(FD2BridgeItemVCLObj.Item).OnKeyPress(FD2BridgeItemVCLObj.Item, KeyPress);
    end;
end;

procedure TVCLObjTwwButton.ProcessPropertyClass(NewObj: TObject);
begin

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetEnabled:=
    function: Variant
    begin
     Result:= GetEnabledRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TwwButton(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetEnabled:=
    procedure(AValue: Variant)
    begin
     TwwButton(FD2BridgeItemVCLObj.Item).Enabled:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetVisible:=
    function: Variant
    begin
     Result:= GetVisibleRecursive(FD2BridgeItemVCLObj.Item);
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.SetVisible:=
    procedure(AValue: Variant)
    begin
     TwwButton(FD2BridgeItemVCLObj.Item).Visible:= AValue;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.GetPlaceholder:=
    function: Variant
    begin
     if TwwButton(FD2BridgeItemVCLObj.Item).Hint <> '' then
      Result:= TwwButton(FD2BridgeItemVCLObj.Item).Hint
     else

     if TwwButton(FD2BridgeItemVCLObj.Item).ShowHint then
      Result:= TwwButton(FD2BridgeItemVCLObj.Item).Hint
     else
      Result:= '';
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.OnGetText:=
    function: Variant
    begin
     if (FD2BridgeItemVCLObj.Item is TwwButton) and
        (Assigned(TwwButton(FD2BridgeItemVCLObj.Item).DataSource) and (TwwButton(FD2BridgeItemVCLObj.Item).DataField <> '')) and
        (TwwButton(FD2BridgeItemVCLObj.Item).DataSource.DataSet.Active) then
     begin
      try
       Result:=
        TwwButton(FD2BridgeItemVCLObj.Item).DataSource.DataSet
         .FieldByName(TwwButton(FD2BridgeItemVCLObj.Item).DataField).AsString;
      except
      end;
     end else
      Result:= TwwButton(FD2BridgeItemVCLObj.Item).Caption;
    end;

 FD2BridgeItemVCLObj.BaseClass.FrameworkExportType.ButtonedEdit.OnSetText:=
    procedure(AValue: Variant)
    begin
     if (FD2BridgeItemVCLObj.Item is TwwButton) and
        (Assigned(TwwButton(FD2BridgeItemVCLObj.Item).DataSource) and (TwwButton(FD2BridgeItemVCLObj.Item).DataField <> '')) and
        (TwwButton(FD2BridgeItemVCLObj.Item).DataSource.DataSet.Active) then
     begin
      try
       if (TwwButton(FD2BridgeItemVCLObj.Item).DataLink.Editing) or
          (TwwButton(FD2BridgeItemVCLObj.Item).DataLink.Edit) then
       begin
        TwwButton(FD2BridgeItemVCLObj.Item).DataSource.DataSet
         .FieldByName(TwwButton(FD2BridgeItemVCLObj.Item).DataField)
         .Value:= AValue;
       end;
      except
      end;
     end else
      TwwButton(FD2BridgeItemVCLObj.Item).Caption:= AValue;
    end;
end;

function TVCLObjTwwButton.VCLClass: TClass;
begin
 Result:= TwwButton;
end;

procedure TVCLObjTwwButton.VCLStyle(const VCLObjStyle: ID2BridgeItemVCLObjStyle);
begin
 if TwwButton(FD2BridgeItemVCLObj.Item).Font.Size <> DefaultFontSize then
  VCLObjStyle.FontSize := TwwButton(FD2BridgeItemVCLObj.Item).Font.Size;

 if TwwButton(FD2BridgeItemVCLObj.Item).Font.Color <> DefaultFontColor then
  VCLObjStyle.FontColor := TwwButton(FD2BridgeItemVCLObj.Item).Font.Color;

 if TwwButton(FD2BridgeItemVCLObj.Item).Color <> DefaultColor then
  VCLObjStyle.Color := TwwButton(FD2BridgeItemVCLObj.Item).Color;

 if TwwButton(FD2BridgeItemVCLObj.Item).TextOptions.Alignment <> DefaultAlignment then
  VCLObjStyle.Alignment:= TwwButton(FD2BridgeItemVCLObj.Item).TextOptions.Alignment;

 VCLObjStyle.FontStyles := TwwButton(FD2BridgeItemVCLObj.Item).Font.Style;
end;


{$ELSE}
implementation
{$ENDIF}

end.
