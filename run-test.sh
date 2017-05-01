#!/usr/bin/env bash
set -euo pipefail

INTERACTIVE=0
NOCOPY=0
CLEAN=0
WORKDIR="/workdir"
XFSPROGS="/xfsprogs"

function usage() {
	echo "Usage: $0 [-h] [-i] [-n] [-c]"
	echo "  -i   Interactive - ends in a bash instead of running tests."
	echo "  -n   Do not copy xfsprogs to a temporary directory, stay in workdir"
	echo "  -c   Run make clean before compiling"
	exit 1
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
		echo
	fi
	echo "csbuild -c make..."
	csbuild -c make
else
	exec /bin/bash
fi
