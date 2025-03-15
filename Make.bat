@echo off

:WARNING CHANGE X TO THE DESIRED VERSION WHEN PUBLISHING, VX is solely for testing purposes.
set version=VX

for %%* in (.) do set project_name=%%~n*
set project_dir=%~dp0

title %project_name%
color 0F

cd..
cd system

del /q "%project_name%.*"
ucc.exe Editor.MakeCommandlet -EXPORTCACHE -ini="%project_dir%make.ini"
echo Copying files to ./System/
copy /b /y "%project_name%.u" /b /y "..\%project_name%\System\%project_name%%version%.u"

cd..
cd %project_name%