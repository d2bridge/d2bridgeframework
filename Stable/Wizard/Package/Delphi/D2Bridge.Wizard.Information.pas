{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  Copyright (c) 2024 Talis Jonatas Gomes - talisjonatas@me.com
  Intellectual property of computer programs protected by international and
  brazilian (9.609/1998) laws.
  Software licensed under "opensource" license.

  Rules:
  Everone is permitted to copy and distribute verbatim copies of this license
  document, but changing it is not allowed.

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not be modified,
  distributed, or sublicensed without express written authorization from
  the author (Talis Jonatas Gomes). This includes creating derivative works
  or distributing the source code through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

unit D2Bridge.Wizard.Information;

interface

implementation


uses
  ToolsAPI, Windows, Graphics, SysUtils, DesignIntf,
  D2Bridge.Wizard.Util;

const
  ICON_SPLASH = 'SPLASHICON';
  ICON_ABOUT = 'ABOUTICON';

var
  AboutBoxServices: IOTAAboutBoxServices;
  AboutBoxIndex: Integer = 0;

resourcestring
{$IFnDEF Win64}
  resPackageName = 'D2Bridge Framework Wizard';
{$ELSE}
  resPackageName = 'D2Bridge Framework Wizard 64bits';
{$ENDIF}
  resLicense = 'Open Source by Talis Jonatas Gomes';
  resAboutCopyright = 'Copyright D2Bridge Framework Delphi WEB by Talis Jonatas Gomes';
  resAboutTitle = 'D2Bridge Framework';
  resAboutDescription =
    'This Delphi Web Framework allows you to develop WEB projects and VCL projects with '+
    'the same base code, this D2Bridge Framework is developed by Talis Jonatas Gomes who '+
    'has been a Delphi developer since 1998. For contact you can use the email talisjonatas@me.com';

procedure RegisterSplashScreen;
var
SplashIcon : TIcon;
begin
 SplashIcon := TIcon.Create;
 SplashIcon.Handle := LoadIcon(HInstance, 'SPLASHICON');

  SplashScreenServices.AddPluginBitmap(resPackageName,
    CreateSplashBitmap(SplashIcon).Handle,
    //LoadBitmap(HInstance,ICON_SPLASH),
    False, resLicense);

 SplashIcon.Free;
end;

procedure RegisterAboutBox;
begin
  if Supports(BorlandIDEServices,IOTAAboutBoxServices, AboutBoxServices) then
    AboutBoxIndex := AboutBoxServices.AddPluginInfo(resAboutTitle, resAboutCopyright + #13#10#13#10 + resAboutDescription, LoadBitmap(HInstance, ICON_ABOUT), False, resLicense);
end;

procedure UnregisterAboutBox;
begin
  if (AboutBoxIndex <> 0) and Assigned(AboutBoxServices) then
  begin
    AboutBoxServices.RemovePluginInfo(AboutBoxIndex);
    AboutBoxIndex := 0;
    AboutBoxServices := nil;
  end;
end;

initialization
  RegisterAboutBox;
  RegisterSplashScreen;

finalization
  UnRegisterAboutBox;

end.


