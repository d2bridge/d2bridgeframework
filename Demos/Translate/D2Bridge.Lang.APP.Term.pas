unit D2Bridge.Lang.APP.Term;

interface

Uses
 System.Classes,
 D2Bridge.Lang.Term.BaseClass;


type
 TContext1 = class; //TContext1 is Class of TD2BridgeTermItem declared bellow


 //TERMS
 TD2BridgeAPPTerm = class(TD2BridgeTermBaseClass)
  public
   Context1: TContext1; //Context Example (Buttons, Combobox, Form1, Form2, etc)

   //Terms to translate
   function HelloWorld: string; //Hello World

   constructor Create(AID2BridgeLang: ID2BridgeLang); override;
 end;


 //Context1
 TContext1 = class(TD2BridgeTermItem)
  public
   function Test: string; //Test
 end;


implementation

{ TD2BridgeAPPTerm }

constructor TD2BridgeAPPTerm.Create(AID2BridgeLang: ID2BridgeLang);
begin
 inherited;

 //Instance Context1
 Context1:= TContext1.Create(self, 'Context1');
end;


function TD2BridgeAPPTerm.HelloWorld: string;
begin
 result:= Language.Translate(Context, 'HelloWorld');
end;

{ TContext1 }

function TContext1.Test: string;
begin
 result:= Language.Translate(Context, 'Test');
end;

end.
