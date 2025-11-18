unit D2Bridge.Lang.APP.{Language};

interface

Uses
 D2Bridge.Lang.{Language};


type
 TD2BridgeLangAPP{Language} = class(TD2BridgeLang{Language})
  private

  protected
   Procedure DoConfigFormatSettings; override;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); override;
   procedure DoTranslate(const ATerm: string; var ATranslated: string); override;
  public

 end;

implementation

{ TD2BridgeLangAPP{Language} }

procedure TD2BridgeLangAPP{Language}.DoConfigFormatSettings;
begin
 inherited;

end;

procedure TD2BridgeLangAPP{Language}.DoTranslate(const AContext, ATerm: string;
  var ATranslated: string);
begin
 inherited;

end;

procedure TD2BridgeLangAPP{Language}.DoTranslate(const ATerm: string; var ATranslated: string);
begin
 inherited;

end;

end.
