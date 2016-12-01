@echo off

REM paths config
set SU_PLUGIN_DIR_16=%AppData%\SketchUp\SketchUp 2016\SketchUp\Plugins
set SU_PLUGIN_DIR_17=%AppData%\SketchUp\SketchUp 2017\SketchUp\Plugins

REM -------------------
REM paths for different versions of sketchup
set SU_PLUGIN_SF_DIR_16=%SU_PLUGIN_DIR_16%\mb_shape_fitting
set SU_PLUGIN_SF_DIR_17=%SU_PLUGIN_DIR_17%\mb_shape_fitting
REM paths for all versions
set CURR_DIR=%~dp0
set PRODUCTS_DIR=%CURR_DIR%\build\products
set LOCAL_PLUGIN_DIR=%CURR_DIR%\src\Scripts\mb_shape_fitting
set UILIB_DIR=%CURR_DIR%\ThirdParty\SKUI\src

REM may not be called in script directory, e.g. from another script or Cmd
cd "%CURR_DIR%"

REM create dirs or ignore warnings
mkdir "%MV_GEN_DIR%\win_x64\"
mkdir "%MV_GEN_DIR%\rules\"

REM copy files for 2016
xcopy /y /f		"%PRODUCTS_DIR%\SUMB_ShapeFitting_rb20.so"					"%SU_PLUGIN_SF_DIR_16%\win_x64\"
xcopy /y /f		"%PRODUCTS_DIR%\SUMB_ShapeFitting_rb22.so"					"%SU_PLUGIN_SF_DIR_16%\win_x64\"
xcopy /y /f		"%PRODUCTS_DIR%\ShapeFittingDyLib.dll"						"%SU_PLUGIN_SF_DIR_16%\win_x64\"
xcopy /y /d /f	"%LOCAL_PLUGIN_DIR%\..\mb_shape_fitting_plugin.rb"	"%SU_PLUGIN_DIR_16%\"
xcopy /y /d /f	"%LOCAL_PLUGIN_DIR%\mb_shape_fitting.rb"				"%SU_PLUGIN_SF_DIR_16%\"
xcopy /y /d /f /s	"%UILIB_DIR%"															"%SU_PLUGIN_SF_DIR_16%\"

REM copy files for 2017
xcopy /y /f		"%PRODUCTS_DIR%\SUMB_ShapeFitting_rb20.so"					"%SU_PLUGIN_SF_DIR_17%\win_x64\"
xcopy /y /f		"%PRODUCTS_DIR%\SUMB_ShapeFitting_rb22.so"					"%SU_PLUGIN_SF_DIR_17%\win_x64\"
xcopy /y /f		"%PRODUCTS_DIR%\ShapeFittingDyLib.dll"						"%SU_PLUGIN_SF_DIR_17%\win_x64\"
xcopy /y /d /f	"%LOCAL_PLUGIN_DIR%\..\mb_shape_fitting_plugin.rb"	"%SU_PLUGIN_DIR_17%\"
xcopy /y /d /f	"%LOCAL_PLUGIN_DIR%\mb_shape_fitting.rb"				"%SU_PLUGIN_SF_DIR_17%\"
xcopy /y /d /f /s	"%UILIB_DIR%"															"%SU_PLUGIN_SF_DIR_17%\"

REM pause