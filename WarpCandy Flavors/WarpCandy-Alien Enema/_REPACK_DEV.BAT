@echo off

set PSARC_PACK="X:\Media\Games\No Mans Sky\Tools\HaxTools\PSARC-PACK_DEV.BAT"
set MODS_PATH=X:\GameLibrary\No Mans Sky\GAMEDATA\PCBANKS\MODS
set MATERIALS_PATH=GAMEDATA\HAX\WARPCANDY\MATERIALS

REM Compile all materials
for %%I in ("%MATERIALS_PATH%\*.exml") do start %%I

REM pack the GAMEDATA folder
call %PSARC_PACK% -q "GAMEDATA"
if ERRORLEVEL 1 (
    echo ERROR!
    pause
    exit /b
)

REM get the name of this mod pkg
for %%I in (.) do set PKG_NAME=%%~nxI

REM get the name of the new pak
for /f %%I in ('dir /b /od %PKG_NAME%-*.pak') do set PKG=%%~nxI

REM delete any instances of this mod from the MODS folder
for /f %%I in ('dir /b /od "%MODS_PATH%\%PKG_NAME%-*.pak"') do del "%MODS_PATH%\%%~nxI"

REM copy the new pak to the MODS folder
copy ".\%PKG%" "%MODS_PATH%\%PKG%"

exit /b