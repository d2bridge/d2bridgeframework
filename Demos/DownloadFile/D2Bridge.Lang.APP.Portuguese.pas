unit D2Bridge.Lang.APP.Portuguese;

interface

Uses
 D2Bridge.Lang.Portuguese;


type
 TD2BridgeLangAPPPortuguese = class(TD2BridgeLangPortuguese)
  private

  protected
   Procedure DoConfigFormatSettings; override;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); override;
   procedure DoTranslate(const ATerm: string; var ATranslated: string); override;
  public

 end;

implementation

{ TD2BridgeLangAPPPortuguese }

procedure TD2BridgeLangAPPPortuguese.DoConfigFormatSettings;
begin
 inherited;

end;

procedure TD2BridgeLangAPPPortuguese.DoTranslate(const AContext, ATerm: string;
  var ATranslated: string);
begin
 inherited;

end;

procedure TD2BridgeLangAPPPortuguese.DoTranslate(const ATerm: string; var ATranslated: string);
begin
 inherited;

end;

end.
