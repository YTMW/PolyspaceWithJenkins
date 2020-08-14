
PREV=`expr $BUILD_NUMBER - 1`
PRG=$JOB_NAME
WSP=$WORKSPACE/$PRG
MROOT=$MATLABROOT

$MROOT/polyspace/bin/polyspace-comments-import -diff-rte "$WSP/R_BF_${PREV}" "$WSP/R_BF_${BUILD_NUMBER}" > "$WSP/diff.txt" 2>&1
