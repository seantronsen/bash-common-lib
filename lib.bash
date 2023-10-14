#!/bin/bash

USER_BIN="$HOME/bin"
SHELL_CONFIG="$HOME/.bashrc"

LIB_DIR="$(dirname ${BASH_SOURCE[0]})"

for x in $LIB_DIR/*.bash; do
	if [ ! "$(basename "$x")" == "lib.bash" ]; then
		source "$x"
	fi
done

if ls -a $(realpath $(dirname $BASH_SOURCE)) | grep -oqE "^\.git$"; then
	info "bash-common-lib version: $(git rev-parse HEAD)"
fi

function binary_dependency_check() {
	for arg in "$@"; do
		if [[ -z "$(which $arg)" ]]; then
			error "dependency not found: '$arg'"
		else
			info "dependency found: '$arg'"
		fi
	done
}

function python_dependency_check() {
	binary_dependency_check python3 pip
	for arg in "$@"; do
		if pip list | grep -oqE "^$arg "; then
			info "python dependency found: $arg"
		else
			error "python dependency not found: $arg"
		fi
	done
}

function add-user-bin() {
	if [ ! -d "$USER_BIN" ]; then
		mkdir -vp "$USER_BIN"
	else
		info "directory exists: '$USER_BIN'"
	fi

	if ! grep -qE 'export PATH=\"\$HOME/bin.*' "$SHELL_CONFIG"; then
		info "adding local '$HOME/bin' directory to path by appending to .bashrc"
		info "source $SHELL_CONFIG to activate changes"
		echo 'export PATH="$HOME/bin:$PATH"' >>"$SHELL_CONFIG"
	else
		info "PATH already configured to include user local bin directory: '$USER_BIN'"
	fi
}
