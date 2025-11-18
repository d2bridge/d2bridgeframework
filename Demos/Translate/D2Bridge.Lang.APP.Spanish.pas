unit D2Bridge.Lang.APP.Spanish;

interface

Uses
 D2Bridge.Lang.Spanish;


type
 TD2BridgeLangAPPSpanish = class(TD2BridgeLangSpanish)
  private

  protected
   Procedure DoConfigFormatSettings; override;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); override;
  public

 end;

implementation

{ TD2BridgeLangAPPSpanish }

procedure TD2BridgeLangAPPSpanish.DoConfigFormatSettings;
begin
 inherited;

end;

procedure TD2BridgeLangAPPSpanish.DoTranslate(const AContext, ATerm: string;
  var ATranslated: string);
begin
 inherited;

 if AContext = '' then
 begin
  if ATerm = 'Phrase1' then
   ATranslated:= 'Muy bueno traducir con D2Bridge Framework';
 end;
end;

end.
