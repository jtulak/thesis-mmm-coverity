#!/usr/bin/env bash
set -euo pipefail

NAME="coverity"

PROG="$0"

function usage() {
	echo "Usage: $PROG [-i] [-h] [-n] [-c] [PATH]"
	echo "  PATH is workdir, if skipped, pwd is used"
	echo "  -i   Is interactive (bash) session"
	echo "  -n   Do not copy xfsprogs to a temporary directory"
	echo "  -c   Run make clean before compiling"
	exit 0
}

DIR="$(pwd)"
INTERACTIVE=0
NOCOPY=0
CLEAN=0

OPTS=""
while getopts ":nic" opt; do
	case $opt in
		n)
			NOCOPY=1
			OPTS+=" -n"
			;;
		i)
			INTERACTIVE=1
			OPTS+=" -i"
			;;
		c)
			CLEAN=1
			OPTS+=" -c"
			;;
		\?)
			usage ;;
	esac
done

shift $((OPTIND-1))

if [ $# -gt 0 ]; then
	DIR=$(realpath "$1")
	echo "setting up dir"
fi


docker run \
	--rm \
	-ti \
	-v "$DIR":/workdir \
	-h $NAME \
	jtulak/$NAME $OPTS
