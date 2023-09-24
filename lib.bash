#!/bin/bash

echo "sourced bash-common-lib"
if ls -a $(realpath $(dirname $BASH_SOURCE)) | grep -oE "^\.git$"; then
	echo "version: $(git rev-parse HEAD)"
fi

function logger() {
	echo "[$(date --utc) UTC] $1"
}

function info() {
	logger "[INFO]: $1"
}

function error() {
	logger "[ERROR]: $1"
	exit $2
}

function binary_dependency_check() {
	for arg in "$@"; do
		if [[ -z "$(which $arg)" ]]; then
			error "dependency not found: '$arg'"
		else
			echo "dependency found: '$arg'"
		fi
	done
}

function python_dependency_check() {
	binary_dependency_check python3 pip
	for arg in "$@"; do
		if pip list | grep -oE "^$arg "; then
			echo "python dependency found: $arg"
		else
			echo "python dependency not found: $arg"
		fi
	done
}
