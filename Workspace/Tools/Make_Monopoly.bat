set PATH=C:\MinGW\bin\;%PATH%
@echo on
set  JK_ROOTDIR=C:\Polyspace\myProject_JenkinsPipeline\PolyspaceWithJenkins

cd "%JK_ROOTDIR%\Monopoly"
del *.o monopoly.exe
mingw32-make.exe all
if %errorlevel% EQU 1 (
   @echo Failure Reason Given is %errorlevel%
   cd "%JK_ROOTDIR%"
   exit /b %errorlevel%
)
cd "%JK_ROOTDIR%"
