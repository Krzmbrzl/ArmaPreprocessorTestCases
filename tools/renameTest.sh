#!/bin/bash

testPath="$1"
newName="$2"

if [ "$testPath" = "" ]; then
	>&2 echo No test provided
	exit 1
fi

if [ "$newName" = "" ]; then
	>&2 echo No new name provided
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


	if [ ! -f "$resultDir"/"$resultName" ]; then
		# try to replace "test" with "result" (lowercase)
		resultName=$(echo "$resultName" | sed s/test/result/)

		if [ ! -f "$resultDir"/"$resultName" ]; then
			>&2 echo Unable to find result file for "$testName"
			exit 1
		fi
	fi
fi

if [ ! "$testName" = "$resultName" ]; then
	echo After renaming \""$testName"\" and \""$resultName"\" will have the same name. Do you want to continue?
	read -p "Continue? [y|N]? "

	if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit 0; fi
fi


echo Renaming \""$testDir"/"$testName"\" to \""$testDir"/"$newName"\"
echo and \""$resultDir"/"$resultName"\" to \""$resultDir"/"$newName"\"
