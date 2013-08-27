#!/bin/bash

cd html

find -name "*.html" | while read FILE
do
	echo "Converting $FILE ..."
	sed -i "s|<head>|<head>\\n\\t\\t<meta http-equiv=\"Content-type\" content=\"text/html;charset=UTF-8\">|" "$FILE"
done
