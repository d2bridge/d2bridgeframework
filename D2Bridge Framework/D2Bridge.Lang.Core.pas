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
