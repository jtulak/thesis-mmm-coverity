#!/usr/bin/env bash

INTERACTIVE=0
NOCOPY=0
CLEAN=0
WORKDIR="/workdir"
XFSPROGS="/xfsprogs"
OUTPUTDIR="/output"

function usage() {
	echo "Usage: $0 [-h] [-i] [-n] [-c]"
	echo "  -i   Interactive - ends in a bash instead of running tests."
	echo "  -n   Do not copy xfsprogs to a temporary directory, stay in workdir"
	echo "  -c   Run make clean before compiling"
	exit 1
}

function run_coverity_analysis() {
	level=$1
	if [ "$level" != "low" -a "$level" != "medium" -a "$level" != "high" -a "$level" != "custom" ]; then
		echo "Unknown level of analysis: $level"
		exit 1
	fi

	if [ "$level" = "custom" ];then
		echo "cov-analyze --dir=./cov \\"
		echo "            --wait-for-license \\"
		echo "            --aggressiveness-level=high \\"
		echo "            --all"

		/opt/coverity/bin/cov-analyze --dir=./cov \
					--wait-for-license \
					--aggressiveness-level=high \
					--all
	else
		echo "cov-analyze --dir=./cov \\"
		echo "            --wait-for-license \\"
		echo "            --aggressiveness-level=$level"

		/opt/coverity/bin/cov-analyze --dir=./cov \
					--wait-for-license \
					--aggressiveness-level=$level
	fi

	mkdir -p $OUTPUTDIR/cov/$level/html
	echo "Formating HTML output"
	/opt/coverity/bin/cov-format-errors \
		--dir=./cov \
		--html-output=$OUTPUTDIR/cov/$level/html

	echo "Formating text output"
	/opt/coverity/bin/cov-format-errors \
		--dir=./cov \
		--emacs-style &>$OUTPUTDIR/cov/$level/text

	echo "Formating json output"
	/opt/coverity/bin/cov-format-errors \
		--dir=./cov \
		--json-output-v6=$OUTPUTDIR/cov/$level/json
}

echo "invoked with: $@"

while getopts ":nic" opt; do
	case $opt in
		n)
			NOCOPY=1 ;;
		i)
			INTERACTIVE=1 ;;
		c)
			CLEAN=1 ;;
		\?)
			usage ;;
	esac
done


cd "$WORKDIR"

if [ -d "mkfs" ]; then
	if [ $NOCOPY -eq 0 ]; then
		echo "copying xfsprogs to $XFSPROGS"
		cp -r "$WORKDIR" "$XFSPROGS"
		cd "$XFSPROGS"
	fi
else
	echo "Workdir does not seem to contain xfsprogs"
	if [ $INTERACTIVE -eq 0 ]; then
		exit 1
	fi
fi

if [ $INTERACTIVE -eq 0 ]; then
	if [ $CLEAN -eq 1 ]; then
		echo "make clean..."
		make clean &>/dev/null
		rm -rf cov
		echo
	fi
	echo "cov-build --dir=./cov make..."
	/opt/coverity/bin/cov-build --dir=./cov make

	run_coverity_analysis "low"
	run_coverity_analysis "medium"
	run_coverity_analysis "high"
	run_coverity_analysis "custom"

	chmod -R a+w $OUTPUTDIR/cov
else
	exec /bin/bash
fi
