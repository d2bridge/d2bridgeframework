unit D2Bridge.Lang.APP.Russian;

interface

Uses
 D2Bridge.Lang.Russian;


type
 TD2BridgeLangAPPRussian = class(TD2BridgeLangRussian)
  private

  protected
   Procedure DoConfigFormatSettings; override;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); override;
  public

 end;

implementation

{ TD2BridgeLangAPPRussian }

procedure TD2BridgeLangAPPRussian.DoConfigFormatSettings;
begin
 inherited;

end;

procedure TD2BridgeLangAPPRussian.DoTranslate(const AContext, ATerm: string;
  var ATranslated: string);
begin
 inherited;

 if AContext = '' then
 begin
  if ATerm = 'Phrase1' then
   ATranslated:= 'Очень круто переводить с помощью D2Bridge Framework';
 end;
end;

end.
