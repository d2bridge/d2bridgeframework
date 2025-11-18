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

unit D2Bridge.Prism.Text;

interface

uses
  Classes,
  D2Bridge.Interfaces, D2Bridge.Prism, D2Bridge.Prism.Item,
  Prism.Types;



type
 PrismLabel = class(TD2BridgePrismItem, ID2BridgeFrameworkItemLabel)
  private
   FProcGetText: TOnGetValue;
   FDataType: TPrismFieldType;
   procedure SetOnGetText(AProc: TOnGetValue);
   function GetOnGetText: TOnGetValue;
   procedure SetDataType(Value: TPrismFieldType);
   function GetDataType: TPrismFieldType;
  public
   procedure Clear; override;
   function FrameworkClass: TClass; override;
   procedure ProcessPropertyClass(VCLObj, NewObj: TObject); override;
   procedure ProcessEventClass(VCLObj, NewObj: TObject); override;
   procedure ProcessPropertyByName(VCLObj, NewObj: TObject; PropertyName: string; PropertyValue: Variant); override;

   property OnGetText: TOnGetValue read GetOnGetText write SetOnGetText;
   property DataType: TPrismFieldType read GetDataType write SetDataType;
  end;



implementation

uses
  Prism.Text;


{ PrismLabel }


procedure PrismLabel.Clear;
begin
 inherited;

 FDataType:= PrismFieldTypeAuto;
 FProcGetText:= nil;
end;

function PrismLabel.FrameworkClass: TClass;
begin
 inherited;

 Result:= TPrismLabel;
end;

function PrismLabel.GetDataType: TPrismFieldType;
begin
 Result:= FDataType;
end;

function PrismLabel.GetOnGetText: TOnGetValue;
begin
 Result:= FProcGetText;
end;

procedure PrismLabel.ProcessEventClass(VCLObj, NewObj: TObject);
begin
 inherited;

end;

procedure PrismLabel.ProcessPropertyByName(VCLObj, NewObj: TObject;
  PropertyName: string; PropertyValue: Variant);
begin
 inherited;

end;

procedure PrismLabel.ProcessPropertyClass(VCLObj, NewObj: TObject);
begin
 inherited;

 TPrismLabel(NewObj).DataType:= DataType;

 if Assigned(FProcGetText) then
 TPrismLabel(NewObj).ProcGetText:= FProcGetText;
end;

procedure PrismLabel.SetDataType(Value: TPrismFieldType);
begin
 FDataType:= Value;
end;

procedure PrismLabel.SetOnGetText(AProc: TOnGetValue);
begin
 FProcGetText:= AProc;
end;

end.
