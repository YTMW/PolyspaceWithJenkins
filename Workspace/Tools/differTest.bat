set BUILD_NUMBER=69
set PREV=68
set PRG=Monopoly
set WORKSPACE=C:\Polyspace\Tools\Jenkins\Workspace
set WSP=%WORKSPACE%\%PRG%
set MROOT=C:\Program Files\MATLAB\R2015b
"%MROOT%\polyspace\bin\polyspace-comments-import.exe" -debug -debug -debug -diff-rte "%WSP%\R_BF_%PREV%" "%WSP%\R_BF_%BUILD_NUMBER%"
