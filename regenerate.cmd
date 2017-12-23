@echo off
SET VS_VERSION=vs2017

premake5 --file=src/SUMB_ShapeFitting_premake5.lua %VS_VERSION%
REM premake5 --fi/le=src/adaptive_premake5.lua %VS_VERSION%

pause