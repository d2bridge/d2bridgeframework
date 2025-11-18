unit D2Bridge.Lang.APP.French;

interface

Uses
 D2Bridge.Lang.French;


type
 TD2BridgeLangAPPFrench = class(TD2BridgeLangFrench)
  private

  protected
   Procedure DoConfigFormatSettings; override;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); override;
  public

 end;

implementation

{ TD2BridgeLangAPPFrench }

procedure TD2BridgeLangAPPFrench.DoConfigFormatSettings;
begin
 inherited;

end;

procedure TD2BridgeLangAPPFrench.DoTranslate(const AContext, ATerm: string;
  var ATranslated: string);
begin
 inherited;

 if AContext = '' then
 begin
  if ATerm = 'Phrase1' then
   ATranslated:= 'Très cool de traduire avec D2Bridge Framework';
 end;
end;

end.
