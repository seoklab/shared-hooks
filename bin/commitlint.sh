#!/bin/bash
#
# commitlint.sh - Shared Hooks
#
# Copyright (c) 2023 SNU Compbio Lab.
#
# SPDX-License-Identifier: MIT
#

if ! CL_BIN="$(type -P commitlint)"; then
	if [[ -n "$HOMEBREW_PREFIX" ]]; then
		CL_BIN="$HOMEBREW_PREFIX/bin/commitlint"
	else
		case "$(uname -s)" in
		Darwin)
			case "$(uname -m)" in
			x86_64)
				CL_BIN="/usr/local/bin/commitlint"
				;;
			arm64)
				CL_BIN="/opt/homebrew/bin/commitlint"
				;;
			*)
				echo "ERROR: Unsupported architecture."
				exit 1
				;;
			esac
			;;
		Linux)
			CL_BIN="/home/linuxbrew/.linuxbrew/bin/commitlint"
			;;
		*)
			echo "ERROR: Unsupported OS"
			exit 1
			;;
		esac
	fi
fi

if [[ ! -x "$CL_BIN" ]]; then
	echo "ERROR: commitlint not found or not executable."
	exit 1
fi

msg="$(sed '/# ------------------------ >8 ------------------------/q' "$1" |
	grep -v '^#')"

if [[ "$msg" =~ ^[[:space:]]*$ ]]; then
	echo 'Aborting commit due to empty commit message.'
	exit 1
fi

exec "$CL_BIN" -V <<<"$msg"
