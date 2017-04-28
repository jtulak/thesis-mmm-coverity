#!/usr/bin/env bash
set -euo pipefail

NAME="coverity"

docker run --rm -ti -v "$(pwd)":/workdir -h $NAME jtulak/$NAME /bin/bash
