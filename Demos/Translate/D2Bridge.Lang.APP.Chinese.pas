unit D2Bridge.Lang.APP.Chinese;

interface

Uses
 D2Bridge.Lang.Chinese;


type
 TD2BridgeLangAPPChinese = class(TD2BridgeLangChinese)
  private

  protected
   Procedure DoConfigFormatSettings; override;
   procedure DoTranslate(const AContext: string; const ATerm: string; var ATranslated: string); override;
  public

 end;

implementation

{ TD2BridgeLangAPPChinese }

procedure TD2BridgeLangAPPChinese.DoConfigFormatSettings;
begin
 inherited;

end;

procedure TD2BridgeLangAPPChinese.DoTranslate(const AContext, ATerm: string;
  var ATranslated: string);
begin
 inherited;

 if AContext = '' then
 begin
  if ATerm = 'Phrase1' then
   ATranslated:= '用D2Bridge Framework翻译非常酷';
 end;
end;

end.
