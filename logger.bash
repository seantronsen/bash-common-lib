#!/bin/bash

function logger() {
	echo "[$(date -u) UTC] $1"
}

function info() {
	logger "[INFO]: $1"
}

function warning() {
	logger "[WARNING]: $1"
}

function error() {
	logger "[ERROR]: $1"
	exit $2
}
