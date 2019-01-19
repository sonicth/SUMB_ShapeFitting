@echo off

if not "%1" == "" (
	SET ACTION=%1
	echo setting action/generator to: %ACTION%
) else (
	SET ACTION=vs2017
)

premake5 --file=src/SUMB_ShapeFitting_premake5.lua %ACTION%
premake5 --file=src/adaptive_premake5.lua %ACTION%

pause

:end