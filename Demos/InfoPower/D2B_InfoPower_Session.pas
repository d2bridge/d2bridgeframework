unit D2B_InfoPower_Session;

interface

uses
  System.SysUtils, System.Classes,
  Prism.SessionBase;

type
  TD2B_InfoPowerSession = class(TPrismSessionBase)
  private

  public
   constructor Create(APrismSession: TPrismSession); override;  //OnNewSession
  end;


implementation

Uses
  D2Bridge.Instance,
  D2B_InfoPowerWebApp;

{$R *.dfm}

constructor TD2B_InfoPowerSession.Create(APrismSession: TPrismSession); //OnNewSession
begin
 inherited;

 //Your code

end;

end.

