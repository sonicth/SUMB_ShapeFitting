echo off

REM paths config
set SU_PLUGIN_DIR=%AppData%\SketchUp\SketchUp 2016\SketchUp\Plugins
set SU_BIN_DIR=%ProgramFiles%\SketchUp\SketchUp 2016

REM -------------------
REM -------------------
REM -------------------
set SRC_DIR=%~dp0
set PRODUCTS_DIR=%SRC_DIR%\..\build\products
set SU_PLUGIN_SF_DIR=%SU_PLUGIN_DIR%\mb_shape_fitting
set LOCAL_PLUGIN_DIR=%SRC_DIR%\Scripts\mb_shape_fitting

cd "%SRC_DIR%"

REM create dirs or ignore warnings
mkdir "%MV_GEN_DIR%\win_x64\"
mkdir "%MV_GEN_DIR%\rules\"

REM copy files
xcopy /y /f		"%PRODUCTS_DIR%\SUMB_ShapeFitting.so"					"%SU_PLUGIN_SF_DIR%\win_x64\"
xcopy /y /d /f	"%LOCAL_PLUGIN_DIR%\..\mb_shape_fitting_plugin.rb"	"%SU_PLUGIN_DIR%\"
xcopy /y /d /f	"%LOCAL_PLUGIN_DIR%\mb_shape_fitting.rb"				"%SU_PLUGIN_SF_DIR%\"

pause