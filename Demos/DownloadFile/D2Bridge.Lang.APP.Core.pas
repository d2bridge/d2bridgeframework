unit D2Bridge.Lang.APP.Core;

interface

uses
 D2Bridge.Lang.Interfaces, D2Bridge.Lang.Core.BaseClass, D2Bridge.Lang.Core.JSON;

type
 TD2BridgeLangAPPCore = class(TD2BridgeLangCoreBaseClass, ID2BridgeLangCore)
  private

  public
   constructor Create;

   destructor Destroy; override;
 end;

var
 D2BridgeLangAPPCore: TD2BridgeLangAPPCore;

implementation

Uses
  D2Bridge.Lang.APP.English,
 D2Bridge.Lang.APP.Portuguese,
 D2Bridge.Lang.APP.Term; 

{ TD2BridgeLangAPPCore }

constructor TD2BridgeLangAPPCore.Create;
begin
 inherited Create(TD2BridgeAPPTerm);

 ResourcePrefix:= 'D2Bridge_Lang_APP_';
 
 EmbedJSON:= false;

 CreateJSONDefaultLang;

 //Enable Languages
  English:= TD2BridgeLangAPPEnglish.Create(self, TD2BridgeAPPTerm);
 Portuguese:= TD2BridgeLangAPPPortuguese.Create(self, TD2BridgeAPPTerm);

end;

destructor TD2BridgeLangAPPCore.Destroy;
begin
  TD2BridgeLangAPPEnglish(English).Destroy;
 TD2BridgeLangAPPPortuguese(Portuguese).Destroy;


 inherited;
end;



initialization
 D2BridgeLangAPPCore:= TD2BridgeLangAPPCore.Create;
finalization
 D2BridgeLangAPPCore.Destroy;

end.
