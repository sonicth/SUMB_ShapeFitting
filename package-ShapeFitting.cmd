@echo off

set ARCHIVER=%ProgramFiles%\7-Zip\7z.exe
set DST=build\products
set VERSION=0.2.1
set FILENAME=mb_shape_fitting_v%VERSION%.rbz

set CURR_DIR=%~dp0
set ARCHIVE=%CURR_DIR%\%DST%\%FILENAME%
set UILIB_DIR=%CURR_DIR%\ThirdParty\SKUI\src

REM delete existing archive
del /f /q %ARCHIVE%

REM add to archive
"%ARCHIVER%" a -tzip "%ARCHIVE%" "%CURR_DIR%\src\Scripts\mb_shape_fitting"
"%ARCHIVER%" a -tzip "%ARCHIVE%" "%CURR_DIR%\src\Scripts\mb_shape_fitting_plugin.rb"

REM add libraries
set BINDIR=mb_shape_fitting

REM copy binaries
mkdir %BINDIR%\win_x64
xcopy /y /d %DST%\release\SUMB_ShapeFitting_rb20.so %BINDIR%\win_x64
xcopy /y /d %DST%\release\SUMB_ShapeFitting_rb22.so %BINDIR%\win_x64
xcopy /y /d %DST%\release\ShapeFittingDyLib.dll %BINDIR%\win_x64

REM	..ui library
xcopy /y /d /f /s	"%UILIB_DIR%"	"%BINDIR%\"

"%ARCHIVER%" a -tzip "%ARCHIVE%" %BINDIR%

REM clean directories
del /q /s %BINDIR%
rmdir /q /s %BINDIR%

pause