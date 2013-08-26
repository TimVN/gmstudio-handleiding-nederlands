#!/bin/bash

cd html

CORRECT="style.css"
for DEPTH in {0..5}
do
	CORRECT="../$CORRECT"
	find "000_Using GameMaker" "001_Advanced Use" "002_Reference" -mindepth $DEPTH -maxdepth $DEPTH -type d | while read DIR
	do
		echo "Processing $DIR ..."
		if ls "$DIR/"*.html &> /dev/null
		then
			sed -ri "s|\"(\\.\\./)*style.css\"|\"$CORRECT\"|" "$DIR/"*.html
		fi
	done
done
