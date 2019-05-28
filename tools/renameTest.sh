#!/bin/bash

testPath="$1"

if [ "$testPath" = "" ]; then
	echo No test provided
	exit 1
fi

if [ ! -f "$testPath" ]; then
	echo The given test \""$testPath"\" does not exist or is not a file
	exit 1
fi

# get the name of the test file
testName=$(basename "$testPath")
# get the absolute directory of the test file
testDir=$(dirname "$testPath")
testDir=$(readlink -f "$testDir")
# get the absolute directory of the base-dir
baseDir=$(dirname "$0")/../
baseDir=$(readlink -f "$baseDir")

# cd to basedir
cd "$baseDir" || exit 1

# assemble path in the result-dir
resultDir=$(echo "$testDir" | sed "s%$baseDir/tests%$baseDir/results%")

# try to find the result name
resultName="$testName"

if [ ! -f "$resultDir"/"$resultName" ]; then
	# maybe replace "Test" with "Result" in the name
	resultName=$(echo "$resultName" | sed s/Test/Result/)

	echo "$resultName"
	echo "$resultDir"/"$resultName"

	if [ ! -f "$resultDir"/"$resultName" ]; then
		# try to replace "test" with "result" (lowercase)
		resultName=$(echo "$resultName" | sed s/test/result/)

		if [ ! -f "$resultDir"/"$resultName" ]; then
			echo Unable to find result file for "$testName"
			exit 1
		fi
	fi
fi

echo Testname: "$testName"
echo Resultname: "$resultName"
		
