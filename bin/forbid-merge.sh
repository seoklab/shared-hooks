#!/bin/bash

set -euo pipefail

z40=0000000000000000000000000000000000000000

if [[ ${PRE_COMMIT_FROM_REF-$z40} != "$z40" &&
	${PRE_COMMIT_TO_REF-$z40} != "$z40" ]]; then
	commits=("$PRE_COMMIT_FROM_REF..$PRE_COMMIT_TO_REF")
fi

while IFS=' ' read -r _ local_sha _ remote_sha; do
	if [[ $remote_sha = "$z40" ]] || [[ $local_sha = "$z40" ]]; then
		continue
	fi
	commits+=("$remote_sha..$local_sha")
done

for range in "${commits[@]}"; do
	if [[ $(git rev-list --count --merges "$range") -gt 0 ]]; then
		echo "ERROR: Merge commits are not allowed in pushed changes. \
Please rebase your changes to remove merge commits."
		exit 1
	fi
done
