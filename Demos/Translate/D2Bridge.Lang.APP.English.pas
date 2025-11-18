unit D2Bridge.Lang.APP.English;

interface

Uses
 D2Bridge.Lang.English;


type
 TD2BridgeLangAPPEnglish = class(TD2BridgeLangEnglish)
  private

  protected
   Procedure DoConfigFormatSettings; override;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); override;
  public

 end;

implementation

{ TD2BridgeLangAPPEnglish }

procedure TD2BridgeLangAPPEnglish.DoConfigFormatSettings;
begin
 inherited;

end;

procedure TD2BridgeLangAPPEnglish.DoTranslate(const AContext, ATerm: string;
  var ATranslated: string);
begin
 inherited;

 if AContext = '' then
 begin
  if ATerm = 'Phrase1' then
   ATranslated:= 'Very cool to translate with D2Bridge Framework';
 end;

end;

end.
