unit D2Bridge.Lang.APP.Arabic;

interface

Uses
 D2Bridge.Lang.Arabic;


type
 TD2BridgeLangAPPArabic = class(TD2BridgeLangArabic)
  private

  protected
   Procedure DoConfigFormatSettings; override;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); override;
  public

 end;

implementation

{ TD2BridgeLangAPPArabic }

procedure TD2BridgeLangAPPArabic.DoConfigFormatSettings;
begin
 inherited;

end;

procedure TD2BridgeLangAPPArabic.DoTranslate(const AContext, ATerm: string;
  var ATranslated: string);
begin
 inherited;

 if AContext = '' then
 begin
  if ATerm = 'Phrase1' then
   ATranslated:= 'رائع جدا للترجمة مع إطار D2Bridge';
 end;

end;

end.
