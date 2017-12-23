set SU_PATH=C:\Program Files\SketchUp\SketchUp 2017\SketchUp.exe
set CURR_DIR=%~dp0

REM kill existing process and wait for 1 second
taskkill /im sketchup.exe /f
timeout 1

REM update plugin
call update-ShapeFitting.cmd

REM call sketchup
call "%SU_PATH%" -RubyStartup "%CURR_DIR%/src/Scripts/autoload_shape_fitting.rb" "%CURR_DIR%/sample_projects/multipoints.skp"
