unit UserSessionUnit;

interface

uses
  System.SysUtils, System.Classes,
  Prism.SessionBase;

type
  TPrismUserSession = class(TPrismSessionBase)
  private

  public
   FUserCod: integer;
   FName: String;
   FUserName: String;
   FUserProfile: String;
   FInditify: string;
  end;


implementation


end.

