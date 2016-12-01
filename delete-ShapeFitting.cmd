@echo off

REM paths config
set SU_PLUGIN_DIR_16=%AppData%\SketchUp\SketchUp 2016\SketchUp\Plugins
set SU_PLUGIN_DIR_17=%AppData%\SketchUp\SketchUp 2017\SketchUp\Plugins

REM SU 2016
rmdir	/s /q "%SU_PLUGIN_DIR_16%\mb_shape_fitting"
del		/s /q "%SU_PLUGIN_DIR_16%\mb_shape_fitting_plugin.rb"

REM SU 2017
rmdir	/s /q "%SU_PLUGIN_DIR_17%\mb_shape_fitting"
del		/s /q "%SU_PLUGIN_DIR_17%\mb_shape_fitting_plugin.rb"
