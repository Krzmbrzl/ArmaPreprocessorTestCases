#!/bin/bash

baseDir=$(dirname "$0")/../

cd "$baseDir"

for currentResult in $(ls -p unsortedResults | grep -v /); do
	if [[ "$currentResult" = *Test* ]] || [[ "$currentResult" = *test* ]]; then
		>&2 echo The file unsortedResults/"$currentResult" seems to be a test rather than a result
		continue
	fi

	currentTest=$(echo "$currentResult" | sed s/Result/Test/)

	searchResults=$(find tests -type f -name "$currentTest")

	if [ "$searchResults" = "" ]; then
		>&2 echo Unable to find test for "$currentResult" 
		continue
	fi

	if [ $(echo "$searchResults" | wc -l) -gt 1 ]; then
		>&2 echo Found multiple matching tests for "$currentResult":
		>&2 echo "$searchResults"
		continue
	fi

	# assemble the destination dir
	resultPath=$(dirname "$searchResults" | sed s/^tests/results/)/"$currentResult"

	if [ -f "$resultPath" ]; then
		>&2 echo \""$resultPath"\" does already exist
		continue
	fi

	mv unsortedResults/"$currentResult" "$resultPath"
done
