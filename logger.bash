#!/bin/bash
################################################################################
# Author: Sean Tronsen
# Provide a standard logging API.
#
################################################################################

################################################################################
# Provided a string argument, echo the content prepending with logging
# information. Serves as the base formatter for higher level logging functions.
# Arguments:
# 	$1: string content to be formatted and echoed back to the caller (or defaults
# 	to stdout)
# Outputs:
# 	provided string content with log formatting.
# Returns:
# 	0
################################################################################
function logger() {
	echo "[$(hostname)] [$(date -u) UTC] $1"
}

################################################################################
# Echo back the provided string content as an 'info' log.
# Arguments:
# 	$1: string text content
# Outputs:
# 	text content in 'info' log format
# Returns:
# 	0
################################################################################
function info() {
	logger "[INFO]: $1"
}

################################################################################
# Echo back the provided string content as an 'warning' log.
# Arguments:
# 	$1: string text content
# Outputs:
# 	text content in 'warning' log format
# Returns:
# 	0
################################################################################
function warning() {
	logger "[WARNING]: $1"
}

################################################################################
# Echo back the provided string content as an 'error' log.
# Arguments:
# 	$1: string text content
# Outputs:
# 	text content in 'error' log format
# Returns:
# 	0
################################################################################
function error() {
	logger "[ERROR]: $1"
	exit $2
}
