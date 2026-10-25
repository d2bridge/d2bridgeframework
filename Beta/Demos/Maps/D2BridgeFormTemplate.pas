unit D2BridgeFormTemplate;

interface

uses
  Classes,
  D2Bridge.Prism.Form;

type
  TD2BridgeFormTemplate = class(TD2BridgePrismForm)
  private
    procedure ProcessHTML(Sender: TObject; var AHTMLText: string);
    procedure ProcessTagHTML(const TagString: string; var ReplaceTag: string);
  public
    constructor Create(AOwner: TComponent; D2BridgePrismFramework: TObject); override;
  end;

implementation

constructor TD2BridgeFormTemplate.Create(AOwner: TComponent;
  D2BridgePrismFramework: TObject);
begin
  inherited;
  OnProcessHTML := ProcessHTML;
  OnTagHTML := ProcessTagHTML;
end;

procedure TD2BridgeFormTemplate.ProcessHTML(Sender: TObject; var AHTMLText: string);
begin
end;

procedure TD2BridgeFormTemplate.ProcessTagHTML(const TagString: string;
  var ReplaceTag: string);
begin
end;

end.
