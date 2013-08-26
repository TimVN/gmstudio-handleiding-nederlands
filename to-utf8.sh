#!/bin/bash

cd html

find -name "*.html" | while read FILE
do
	echo "Converting $FILE ..."
	iconv -f WINDOWS-1252 -t UTF-8 "$FILE" > "$FILE.iconv-new"
	mv "$FILE.iconv-new" "$FILE"
done
