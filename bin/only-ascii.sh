#!/bin/bash

if [[ -n $PRE_COMMIT_FROM_REF && -n $PRE_COMMIT_TO_REF ]]; then
	non_ascii="$(
		git diff "$PRE_COMMIT_FROM_REF..$PRE_COMMIT_TO_REF" -- "$@" |
			grep '^+[^+]' |
			tr -d '\011\012\015\040-\176'
	)"
else
	non_ascii="$(
		grep -IZl '.' -- "$@" | xargs -0 cat | tr -d '\011\012\015\040-\176'
	)"
fi

if [[ -z $non_ascii ]]; then
	exit 0
fi

echo "ERROR: Changed file(s) contain non-ASCII character(s). \
Please remove them before committing:
$non_ascii"
exit 1
