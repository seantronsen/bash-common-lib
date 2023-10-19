#!/bin/bash
################################################################################
# Author: Sean Tronsen
# Provide a set of reusable bash functions to be referenced in scripts utilizing
# this library.
#
################################################################################

################################################################################
# Global variables
#
# Each may be overridden by a properly specified environment variable.
################################################################################
USER_BIN="${USER_BIN:="$HOME/bin"}"
SHELL_CONFIG="${SHELL_CONFIG:="$HOME/.bashrc"}"

################################################################################
# Obtain the directory name of the current script file.
# Globals:
# 	BASH_SOURCE
# Outputs:
# 	a string containing the absolute path to the script file.
################################################################################
function script_dir() {
	echo "$(realpath $(dirname ${BASH_SOURCE[0]}))"
}

LIB_DIR="$(script_dir)"
for x in $LIB_DIR/*.bash; do
	if [ ! "$(basename "$x")" == "lib.bash" ]; then
		source "$x"
	fi
done

if ls -a "$LIB_DIR" | grep -oqE "^\.git$"; then
	(
		cd "$LIB_DIR"
		info "bash-common-lib version: $(git rev-parse HEAD)"
	)
fi

################################################################################
# Ensure that all arguments provided can be located within $PATH
# Arguments:
# 	$@: a list of program names
# Outputs:
# 	for each argument, output status information regarding whether or not the
# 	referenced target could be located via the $PATH variable (using `which`)
# Returns:
# 	0 if all specified arguments exist on $PATH
# 	non-zero if any of the specified arguments cannot be located
################################################################################
function binary_dependency_check() {
	for arg in "$@"; do
		if [[ -z "$(which $arg)" ]]; then
			error "dependency not found: '$arg'"
		else
			info "dependency found: '$arg'"
		fi
	done
}

################################################################################
# Ensure that all arguments are valid python packages which can be found by pip.
# Arguments:
# 	$@: a list of python package names
# Outputs:
# 	for each argument, output status information regarding whether a
# 	corresponding python package exists.
# Returns:
# 	0 if all arguments can be found by pip
# 	non-zero if any argument could not be located
################################################################################
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

################################################################################
# Configure a local binary directory for the calling user and add the location
# the the PATH environment variable within the configuration specified '.*rc"
# file.
# Globals:
# 	USER_BIN: a path where the local binary directory will be created, should
# 	it not exist
# 	SHELL_CONFIG: path to the user shell configuration script (e.g. `.bashrc`)
#
# Outputs:
# 	status information about each subtask that indicates whether it was not
# 	necessary or if the action was performed.
# Returns:
# 	0
################################################################################
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
