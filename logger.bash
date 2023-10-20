#!/bin/bash
################################################################################
# Author: Sean Tronsen
# Provide a standard logging API.
#
################################################################################

################################################################################
# Provided a string argument and log kind, echo the content prepended with
# logging information. Serves as the base formatter for higher level logging
# functions.
# Arguments:
# 	$1: log kind header
# 	$2: string content to be formatted and echoed back to the caller (or defaults
# 	to stdout)
# Outputs:
# 	provided string content with log formatting.
# Returns:
# 	0
################################################################################
function logger() {
	echo "[$1][$(hostname)][$(date -u +'%Y-%m-%dT%H:%M:%S%z') UTC]: $2"
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
	logger "INFO" "$1"
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
	logger "WARNING" "$1"
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
	logger "ERROR" "$1"
	exit $2
}
