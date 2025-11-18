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

unit D2Bridge.Lang.Core;

interface

uses
  Classes, SysUtils, D2Bridge.JSON,
  D2Bridge.Lang.Interfaces, D2Bridge.Lang.Core.JSON, D2Bridge.Lang.Core.BaseClass, D2Bridge.Types,
  D2Bridge.Lang.Util;

type
 TD2BridgeLangCore = class(TD2BridgeLangCoreBaseClass, ID2BridgeLangCore)
  private

  public
   constructor Create;
   destructor Destroy; override;
 end;

var
 D2BridgeLangCore: TD2BridgeLangCore;


implementation

uses
  D2Bridge.Lang.Term;

{ TD2BridgeLang }


constructor TD2BridgeLangCore.Create;
begin
 inherited Create(TD2BridgeTerm);

 D2BridgeLangCore:= self;
 PathExportJSON:= PathExportJSON + 'd2bridge' + PathDelim;
 ResourcePrefix:= 'D2Bridge_Lang_';
 ExportJSON:= false;

 //Enable Languages
 Languages:= AllLanguages;
end;


destructor TD2BridgeLangCore.Destroy;
begin

 inherited;
end;


end.