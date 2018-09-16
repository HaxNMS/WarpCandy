@echo off

REM full paths
set HAXTOOLS=X:\Media\Games\No Mans Sky\Tools\HaxTools
set MODS_PATH=X:\GameLibrary\No Mans Sky\GAMEDATA\PCBANKS\MODS

REM relative path
set MATERIALS_PATH=GAMEDATA\HAX\WARPCANDY\MATERIALS

set PSARC_PACK="%HAXTOOLS%\PSARC-PACK.BAT"
set STRIPBBCODES="%HAXTOOLS%\stripbbcode\stripbbcode.bat"
set ARCHIVE="%HAXTOOLS%\bin\7z.exe" a -tzip -y -r

REM Compile all materials
for %%I in ("%MATERIALS_PATH%\*.exml") do start %%I

REM pack the GAMEDATA folder
call %PSARC_PACK% -q "GAMEDATA"
if ERRORLEVEL 1 goto ERROR

REM get the name of this mod pkg
for %%I in (.) do set PKG_NAME=%%~nxI

REM get the name of the new pak
for /f "delims=" %%I in ('dir /b /a-d /od "%PKG_NAME%-*.pak"') do set PKG=%%~nI

REM delete any instances of this mod from the MODS folder
for /f "delims=" %%I in ('dir /b /od "%MODS_PATH%\%PKG_NAME%-*.pak"') do del "%MODS_PATH%\%%~nxI"

REM copy the new pak to the MODS folder
copy ".\%PKG%.pak" "%MODS_PATH%\%PKG%.pak"

REM generate a plain-text version of the README.md file
call %STRIPBBCODES% "..\..\resources\README.md"

REM create a release folder and copy the artifacts
mkdir "%PKG%" > nul
copy "%PKG%.pak" "%PKG%\%PKG%.pak"
copy "%PKG_NAME%.jpg" "%PKG%\%PKG%.jpg"
copy "..\..\resources\WarpCandy - Cover.jpg" "%PKG%\WarpCandy.jpg"
copy "..\..\resources\README.txt" "%PKG%\README.txt"

REM zip it
%ARCHIVE% "%PKG%.zip" "%PKG%"

REM delete the release pkg folder
rmdir /s /q "%PKG%"


goto FINISHED


:ERROR
    echo ERROR!
    pause

:FINISHED
    exit /b