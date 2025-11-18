del D2Bridge.Lang.res
del Prism\prism.res
if not defined DELPHIBIN set DELPHIBIN=C:\Program Files (x86)\Embarcadero\Studio\21.0\bin
"%DELPHIBIN%\BRCC32.exe" D2Bridge.Lang.rc
"%DELPHIBIN%\BRCC32.exe" Prism\prism.rc