#!/bin/bash

cd html

relpath() {
	# relpath <target> <current>
	python -c "import os.path; import sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))" "$1" "$2"
}
urlencode() {
	php -r "echo str_replace(\"%2F\", \"/\", rawurlencode(trim(file_get_contents('php://stdin'))));"
}
urldecode() {
	php -r "echo urldecode(trim(file_get_contents('php://stdin')));"
}

find -name "*.html" | while read FILE
do
	grep -oE "(href|src)=\"[^\"]*\.(html|png|gif|css)\"" "$FILE" | cut -d = -f 2 | tr -d \" | sort -u | while read LINK
	do
		if [[ "$LINK" != http://* ]] && [[ "$LINK" != https://* ]]
		then
			TARGET="$( dirname "$FILE" )/$( echo "$LINK" | urldecode )"
			if [ ! -f "$TARGET" ]
			then
				TARGET="./$( relpath "$TARGET" . )"
				TARGET2="$( find -iwholename "$TARGET" )"
				if [ -f "$TARGET2" ]
				then
					sed -i "s|href=\"$LINK\"|href=\"$( relpath "$TARGET2" "$( dirname "$FILE" )" | urlencode )\"|" "$FILE"
					sed -i "s|src=\"$LINK\"|src=\"$( relpath "$TARGET2" "$( dirname "$FILE" )" | urlencode )\"|" "$FILE"
					echo -e "---- Fixed case mismatch\n"
				else
					TARGET3="$( find -iname "$( basename "$TARGET" )" )"
					if [ -f "$TARGET3" ]
					then
						sed -i "s|href=\"$LINK\"|href=\"$( relpath "$TARGET3" "$( dirname "$FILE" )" | urlencode )\"|" "$FILE"
						sed -i "s|src=\"$LINK\"|src=\"$( relpath "$TARGET3" "$( dirname "$FILE" )" | urlencode )\"|" "$FILE"
						echo -e "---- Fixed wrong path\n"
					else
						TARGET4="$( find -iwholename "*/$( basename "$( dirname "$TARGET" )" )/$( basename "$TARGET" )" )"
						if [ -f "$TARGET4" ]
						then
							sed -i "s|href=\"$LINK\"|href=\"$( relpath "$TARGET4" "$( dirname "$FILE" )" | urlencode )\"|" "$FILE"
							sed -i "s|src=\"$LINK\"|src=\"$( relpath "$TARGET4" "$( dirname "$FILE" )" | urlencode )\"|" "$FILE"
							echo -e "---- Fixed wrong path (2)\n"
						else
							echo -e "In file $FILE\n\t$LINK\n\t$TARGET\n"
						fi
					fi
				fi
			fi
		fi
	done
done
