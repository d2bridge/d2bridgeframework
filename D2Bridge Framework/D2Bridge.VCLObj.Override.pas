{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.VCLObj.Override;

interface

uses
  Classes;

  function OverrideVCL(VCLClass: TClass): TClass;

implementation

uses
  SysUtils
{$IFDEF FMX}
{$ELSE}
  ,StdCtrls, Buttons, DBGrids, DBCtrls
{$ENDIF}
{$IFDEF DEVEXPRESS_AVAILABLE}
 ,cxButtonEdit
{$ENDIF}
;


{ TD2BridgeOverride }

function OverrideVCL(VCLClass: TClass): TClass;
begin
  Result:= VCLClass;

{$REGION 'Label'}
{$IFNDEF FMX}
  if SameText(VCLClass.ClassName,'TRxLabel') then
    Result:= TLabel;
{$ENDIF}
{$ENDREGION}

{$REGION 'Button'}
{$IFNDEF FMX}
  if SameText(VCLClass.ClassName,'TCxButton') then
    Result:= TButton;

  if SameText(VCLClass.ClassName,'TBitBtn') then
    Result:= TButton;

  if SameText(VCLClass.ClassName,'TSSpeedButton') then
    Result:= TSpeedButton;
{$ENDIF}
{$ENDREGION}

{$REGION 'Edit'}
{$IFNDEF FMX}
  if SameText(VCLClass.ClassName,'TLabeledEdit') then
    Result:= TEdit;
{$ENDIF}
{$ENDREGION}

{$REGION 'DBGrid'}
//  if SameText(VCLClass.ClassName,'TSMDBGrid') then
//    Result:= TDBGrid;
{$ENDREGION}

{$REGION 'DBEdit'}

{$ENDREGION}

{$REGION 'Combobox'}
{$IFNDEF FMX}
  if SameText(VCLClass.ClassName,'TAdvSearchComboBox') then
    Result:= TCombobox;
{$ENDIF}
{$ENDREGION}

{$REGION 'DevExpress'}
{$IFDEF DEVEXPRESS_AVAILABLE}
  if SameText(VCLClass.ClassName,'TcxDBButtonEdit') then
    Result:= TcxButtonEdit;
{$ENDIF}
{$ENDREGION}

end;

end.
