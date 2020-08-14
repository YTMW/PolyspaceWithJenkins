set /a PREV=%BUILD_NUMBER%-1
set PRG=%JOB_NAME%
set WSP=%WORKSPACE%\%PRG%
set MROOT=%MATLABROOT%
"%MROOT%\sys\perl\win32\bin\perl.exe" "%WORKSPACE%\Tools\lib\PolyspaceDiff.pl" -annotations "%WSP%\diff.txt" -bf -diff "%WSP%\R_BF_%PREV%" "%WSP%\R_BF_%BUILD_NUMBER%" -rdir "%WSP%"
