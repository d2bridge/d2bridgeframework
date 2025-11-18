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