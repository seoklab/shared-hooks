#!/bin/bash

non_ascii="$(
	git diff HEAD -- "$@" |
		grep '^+[^+]' |
		tr -d '\011\012\015\040-\176'
)"

if [[ -z $non_ascii ]]; then
	exit 0
fi

echo "ERROR: Non-ASCII characters detected in the diff. \
Please remove them before committing:

$non_ascii"
exit 1
