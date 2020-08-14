MBUILD=$1
MROOT=$MATLABROOT

$MROOT/polyspace/bin/polyspace-configure -allow-build-error -prog $JOB_NAME -output-options-file "$WORKSPACE/$JOB_NAME/$JOB_NAME.opts" bash $MBUILD
