#!/bin/sh
TESTS_ROOT="$(readlink -f "$(dirname $0)/..")"

export TESTS_ROOT
echo $TESTS_ROOT
cat "${TESTS_ROOT}/tests/nginx.conf.tpl" | envsubst > ${TESTS_ROOT}/tests/nginx/nginx.conf

if ! nginx -t -p ${TESTS_ROOT}/tests/nginx/ -c ${TESTS_ROOT}/tests/nginx/nginx.conf; then
    echo "ERROR: something goes wrong with nginx configuration" >&2
    exit 1
fi

nginx -p ${TESTS_ROOT}/tests/nginx/ -c ${TESTS_ROOT}/tests/nginx/nginx.conf &>/dev/null
