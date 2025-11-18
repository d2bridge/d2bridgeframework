unit D2Bridge.Lang.APP.Japanese;

interface

Uses
 D2Bridge.Lang.Japanese;


type
 TD2BridgeLangAPPJapanese = class(TD2BridgeLangJapanese)
  private

  protected
   Procedure DoConfigFormatSettings; override;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); override;
  public

 end;

implementation

{ TD2BridgeLangAPPJapanese }

procedure TD2BridgeLangAPPJapanese.DoConfigFormatSettings;
begin
 inherited;

end;

procedure TD2BridgeLangAPPJapanese.DoTranslate(const AContext, ATerm: string;
  var ATranslated: string);
begin
 inherited;

 if AContext = '' then
 begin
  if ATerm = 'Phrase1' then
   ATranslated:= '"D2Bridge Frameworkで翻訳するのはとても素晴らしいです';
 end;
end;

end.
