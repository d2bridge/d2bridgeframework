unit D2Bridge.Lang.APP.German;

interface

Uses
 D2Bridge.Lang.German;


type
 TD2BridgeLangAPPGerman = class(TD2BridgeLangGerman)
  private

  protected
   Procedure DoConfigFormatSettings; override;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); override;
  public

 end;

implementation

{ TD2BridgeLangAPPGerman }

procedure TD2BridgeLangAPPGerman.DoConfigFormatSettings;
begin
 inherited;

end;

procedure TD2BridgeLangAPPGerman.DoTranslate(const AContext, ATerm: string;
  var ATranslated: string);
begin
 inherited;

 if AContext = '' then
 begin
  if ATerm = 'Phrase1' then
   ATranslated:= 'Sehr cool, mit D2Bridge Framework zu übersetzen';
 end;
end;

end.
