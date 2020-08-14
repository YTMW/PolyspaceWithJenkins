set BUILD_NUMBER=58
set PREV=57
set PRG=Monopoly
set WORKSPACE=C:\Polyspace\Tools\Jenkins\Workspace
set WSP=%WORKSPACE%\%PRG%
set MROOT=C:\Program Files\MATLAB\R2015b
"%MROOT%\sys\perl\win32\bin\perl.exe" "%WORKSPACE%\Tools\lib\PolyspaceDiff.pl" -bf -annotations "%WSP%\diff.txt" -diff "%WSP%\R_BF_%PREV%" "%WSP%\R_BF_%BUILD_NUMBER%" -rdir "%WSP%"
