@echo off

premake5 --file=src/SUMB_ShapeFitting_premake5.lua vs2015
premake5 --file=src/adaptive_premake5.lua vs2013

pause