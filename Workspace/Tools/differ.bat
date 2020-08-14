set /a PREV=%BUILD_NUMBER%-1
set PRG=%JOB_NAME%
set WSP=%WORKSPACE%\%PRG%
set MROOT=%MATLABROOT%
@echo on

"%MROOT%\polyspace\bin\polyspace-comments-import.exe" -diff-rte "%WSP%\R_BF_%PREV%" "%WSP%\R_BF_%BUILD_NUMBER%" > "%WSP%\diff.txt" 2>&1
