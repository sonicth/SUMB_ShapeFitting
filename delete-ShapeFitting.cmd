@echo off

REM paths config
set SU_PLUGIN_DIR=%AppData%\SketchUp\SketchUp 2016\SketchUp\Plugins
set SU_PLUGIN_SF_DIR=%SU_PLUGIN_DIR%\mb_shape_fitting

rmdir	/s /q "%SU_PLUGIN_SF_DIR%"
del		/s /q "%SU_PLUGIN_DIR%\mb_shape_fitting_plugin.rb"
