@echo off
echo.
echo === Executando conversão de RC para Lazarus com PowerShell ===
powershell -ExecutionPolicy Bypass -File Compile_Resource_Lazarus_LRS.PS1

echo.
echo === Compilando arquivos LRS com lazres ===
if not defined LAZTOOLSBIN set LAZTOOLSBIN=C:\lazarus36win64\tools
"%LAZTOOLSBIN%\lazres.exe" D2Bridge.Lang.lrs @D2Bridge.Lang.rc.laz
"%LAZTOOLSBIN%\lazres.exe" Prism\prism.lrs @Prism\prism.rc.laz

echo.
echo === Finalizado com sucesso ===
