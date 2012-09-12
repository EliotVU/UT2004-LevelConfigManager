@echo off
color 0F
cd..
cd system
:remove
ucc.exe MakeCommandletUtils.EditPackagesCommandlet 0 LevelConfigManagerV3X
pause
goto remove