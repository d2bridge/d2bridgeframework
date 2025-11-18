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
 D2Bridge.Lang.APP.Spanish,
 D2Bridge.Lang.APP.Italian,
 D2Bridge.Lang.APP.German,
 D2Bridge.Lang.APP.French,
 D2Bridge.Lang.APP.Russian,
 D2Bridge.Lang.APP.Arabic,
 D2Bridge.Lang.APP.Japanese,
 D2Bridge.Lang.APP.Chinese,
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
 Spanish:= TD2BridgeLangAPPSpanish.Create(self, TD2BridgeAPPTerm);
 Italian:= TD2BridgeLangAPPItalian.Create(self, TD2BridgeAPPTerm);
 German:= TD2BridgeLangAPPGerman.Create(self, TD2BridgeAPPTerm);
 French:= TD2BridgeLangAPPFrench.Create(self, TD2BridgeAPPTerm);
 Russian:= TD2BridgeLangAPPRussian.Create(self, TD2BridgeAPPTerm);
 Arabic:= TD2BridgeLangAPPArabic.Create(self, TD2BridgeAPPTerm);
 Japanese:= TD2BridgeLangAPPJapanese.Create(self, TD2BridgeAPPTerm);
 Chinese:= TD2BridgeLangAPPChinese.Create(self, TD2BridgeAPPTerm);

end;

destructor TD2BridgeLangAPPCore.Destroy;
begin
 TD2BridgeLangAPPPortuguese(Portuguese).Destroy;

 inherited;
end;



initialization
 D2BridgeLangAPPCore:= TD2BridgeLangAPPCore.Create;
finalization
 D2BridgeLangAPPCore.Destroy;

end.
