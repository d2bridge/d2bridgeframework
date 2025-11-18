unit <UNITNAME>;

{ Copyright <COPYRIGHTYEAR> D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  Classes, SysUtils, Controls, Graphics, Dialogs, StdCtrls;

type
  T<CLASS_ID> = class(<CLASSINHERITED>)
  private
    { Private declarations }
  published
   class procedure CreateInstance;
   procedure DestroyInstance;
  public
    { Public declarations }
  end;

function <CLASS_ID>:T<CLASS_ID>;

implementation

Uses
  D2Bridge.Instance, <ServerController>;

{$R *.lfm}

class procedure T<CLASS_ID>.CreateInstance;
begin
 D2BridgeInstance.CreateInstance(self);
end;

function <CLASS_ID>:T<CLASS_ID>;
begin
 result:= (D2BridgeInstance.GetInstance(T<CLASS_ID>) as T<CLASS_ID>);
end;

procedure T<CLASS_ID>.DestroyInstance;
begin
 D2BridgeInstance.DestroyInstance(self);
end;

end.
