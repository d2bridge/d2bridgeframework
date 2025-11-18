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

{$I D2Bridge.inc}

unit D2Bridge.Prism.Edit;

interface

uses
  Classes,
{$IFDEF HAS_UNIT_SYSTEM_UITYPES}
  System.UITypes,
{$ENDIF}
{$IFDEF FPC}
  StdCtrls,
{$ENDIF}
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.Prism.Item,
  Prism.Types;


type
 TPrismFieldType = Prism.Types.TPrismFieldType;


type
 PrismEdit = class(TD2BridgePrismItem, ID2BridgeFrameworkItemEdit)
  private
   FProcSetText: TOnSetValue;
   FProcGetText: TOnGetValue;
   FDataType: TPrismFieldType;
   FCharCase: TEditCharCase;
   FMaxLength: integer;
{$IFDEF FPC}
  protected
{$ENDIF}
   procedure SetOnGetText(AProc: TOnGetValue);
   function GetOnGetText: TOnGetValue;
   procedure SetOnSetText(AProc: TOnSetValue);
   function GetOnSetText: TOnSetValue;
   procedure SetEditDataType(AEditType: TPrismFieldType);
   function GetEditDataType: TPrismFieldType;
   function GetCharCase: TEditCharCase;
   procedure SetCharCase(ACharCase: TEditCharCase);
   function GetMaxLength: integer;
   procedure SetMaxLength(const Value: integer);
  public
   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   property MaxLength: integer read GetMaxLength write SetMaxLength;

   property DataType: TPrismFieldType read GetEditDataType write SetEditDataType;
   property CharCase: TEditCharCase read GetCharCase write SetCharCase;
   property OnGetText: TOnGetValue read GetOnGetText write SetOnGetText;
   property OnSetText: TOnSetValue read GetOnSetText write SetOnSetText;
  end;



implementation

uses
  Prism.Edit;


{ PrismEdit }


procedure PrismEdit.Clear;
begin
 inherited;

 FMaxLength:= 0;
 FDataType:= PrismFieldTypeAuto;
 FCharCase:= TEditCharCase.ecNormal;
 FProcSetText:= nil;
 FProcGetText:= nil;
end;

function PrismEdit.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismEdit;
end;

function PrismEdit.GetCharCase: TEditCharCase;
begin
 Result:= FCharCase;
end;

function PrismEdit.GetEditDataType: TPrismFieldType;
begin
 Result:= FDataType;
end;

function PrismEdit.GetMaxLength: integer;
begin
 Result:= FMaxLength;
end;

function PrismEdit.GetOnGetText: TOnGetValue;
begin
 Result:= FProcGetText;
end;

function PrismEdit.GetOnSetText: TOnSetValue;
begin
 Result:= FProcSetText;
end;


procedure PrismEdit.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismEdit.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismEdit.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 TPrismEdit(NewObj).DataType:= DataType;

 TPrismEdit(NewObj).CharCase:= CharCase;

 TPrismEdit(NewObj).MaxLength:= FMaxLength;

 if Assigned(FProcSetText) then
 TPrismEdit(NewObj).ProcSetText:= FProcSetText;

 if Assigned(FProcGetText) then
 TPrismEdit(NewObj).ProcGetText:= FProcGetText;
end;


procedure PrismEdit.SetCharCase(ACharCase: TEditCharCase);
begin
 FCharCase:= ACharCase;
end;

procedure PrismEdit.SetEditDataType(AEditType: TPrismFieldType);
begin
 FDataType:= AEditType;
end;

procedure PrismEdit.SetMaxLength(const Value: integer);
begin
 FMaxLength:= Value;
end;

procedure PrismEdit.SetOnGetText(AProc: TOnGetValue);
begin
 FProcGetText:= AProc;
end;

procedure PrismEdit.SetOnSetText(AProc: TOnSetValue);
begin
 FProcSetText := AProc;
end;

end.