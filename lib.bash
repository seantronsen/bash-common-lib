#!/bin/bash

echo "sourced bash-common-lib version: $(git rev-parse HEAD)"

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

function dependency_check() {
	for arg in "$@"; do
		if [[ -z "$(which $arg)" ]]; then
			error "dependency not found: '$arg'"
		else
			echo "dependency found: '$arg'"
		fi
	done
}
