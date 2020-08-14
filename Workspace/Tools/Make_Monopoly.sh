cd /usr/local/Polyspace/tools/jenkins/monopoly
rm -f *.o
make all 
status=$?

if [ $status -ne 0 ]
then
   echo "Failure: error status is $status"
   cd /usr/local/Polyspace/tools/jenkins
   exit $status
fi
cd /usr/local/Polyspace/tools/jenkins
