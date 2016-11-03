@echo off
SET VS_VERSION=vs2015

premake5 --file=src/ShapeFitting_Plugins_premake5.lua %VS_VERSION%
premake5 --file=src/adaptive_premake5.lua %VS_VERSION%

pause