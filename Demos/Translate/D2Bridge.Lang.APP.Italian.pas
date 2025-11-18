unit D2Bridge.Lang.APP.Italian;

interface

Uses
 D2Bridge.Lang.Italian;


type
 TD2BridgeLangAPPItalian = class(TD2BridgeLangItalian)
  private

  protected
   Procedure DoConfigFormatSettings; override;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); override;
  public

 end;

implementation

{ TD2BridgeLangAPPItalian }

procedure TD2BridgeLangAPPItalian.DoConfigFormatSettings;
begin
 inherited;

end;

procedure TD2BridgeLangAPPItalian.DoTranslate(const AContext, ATerm: string;
  var ATranslated: string);
begin
 inherited;

 if AContext = '' then
 begin
  if ATerm = 'Phrase1' then
   ATranslated:= 'Molto bello tradurre con D2Bridge Framework';
 end;
end;

end.
