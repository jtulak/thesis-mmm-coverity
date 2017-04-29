#!/usr/bin/env bash
set -euo pipefail

NAME="coverity"

PROG="$0"

function usage() {
	echo "Usage: $PROG [-i|-h] [PATH]"
	echo "Where -i is interactive (bash) session and PATH is workdir"
	exit 0
}

DIR="$(pwd)"
INTERACTIVE=0

if [ $# -gt 0 ]; then
	if [ "$1" = "-h" ]; then
		usage
	elif [ "$1" = "-i" ]; then
		INTERACTIVE=1
	fi

	if [ $INTERACTIVE -eq 0 ]; then
		DIR=$(realpath "$1")
	elif [ $# -eq 2 ]; then
		DIR=$(realpath "$2")
	elif [ $# -gt 2 ]; then
		usage # more than 2 arguments is wrong
	fi
fi


if [ $INTERACTIVE -eq 1 ]; then
	docker run \
		--rm \
		-ti \
		-v "$DIR":/workdir \
		-h $NAME \
		--entrypoint /bin/bash \
		jtulak/$NAME
else
	docker run \
		--rm \
		-ti \
		-v "$DIR":/workdir \
		-h $NAME \
		jtulak/$NAME
fi
