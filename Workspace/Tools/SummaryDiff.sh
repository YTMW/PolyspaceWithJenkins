PREV=`expr $BUILD_NUMBER - 1`
PRG=$JOB_NAME
WSP=$WORKSPACE/$PRG
MROOT=$MATLABROOT
perl $WORKSPACE/Tools/lib/PolyspaceDiff.pl -annotations $WSP/diff.txt -bf -diff $WSP/R_BF_$PREV "$WSP/R_BF_${BUILD_NUMBER}" -rdir $WSP
