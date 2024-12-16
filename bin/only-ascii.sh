#!/bin/bash

ref_args=()
if [[ -n $PRE_COMMIT_FROM_REF && -n $PRE_COMMIT_TO_REF ]]; then
	ref_args=("$PRE_COMMIT_FROM_REF...$PRE_COMMIT_TO_REF")
else
	ref_args=(HEAD)
fi

non_ascii="$(
	git diff "${ref_args[@]}" -- "$@" |
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
