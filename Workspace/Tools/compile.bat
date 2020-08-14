set PATH=C:\MinGW\bin\;%PATH%
set MBUILD=%1
set MROOT=%MATLABROOT%
@echo off

"%MROOT%\polyspace\bin\polyspace-configure.exe" -allow-overwrite -allow-build-error -prog %JOB_NAME% -output-options-file "%WORKSPACE%\%JOB_NAME%\%JOB_NAME%.opts" call "%MBUILD%"