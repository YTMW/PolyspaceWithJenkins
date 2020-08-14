PRG=$JOB_NAME
WSP=$WORKSPACE/$PRG
MROOT=$MATLABROOT
$MROOT/polyspace/bin/polyspace-bug-finder-nodesktop -options-file "$WSP/$PRG.opts" -options-file "$WORKSPACE/Tools/target_${JOB_NAME}.opts" -prog $JOB_NAME -date $BUILD_ID -results-dir "$WSP/R_BF_${BUILD_NUMBER}"
