@echo off
SET VS_VERSION=vs2015

premake5 --file=src/SUMB_ShapeFitting_premake5.lua %VS_VERSION%
premake5 --file=src/adaptive_premake5.lua %VS_VERSION%

pause