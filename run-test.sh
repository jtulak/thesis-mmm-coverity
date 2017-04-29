#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
	echo "Usage: $0 WORKDIR"
	exit 1
fi

cd $1

if [ ! -d "mkfs" ]; then
	echo "Workdir does not seem to contain xfsprogs"
	exit 1
fi

# TODO
echo "nothing implemented..."
