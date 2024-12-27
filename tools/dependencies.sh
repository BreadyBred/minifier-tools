#!/bin/bash

# Node.JS status check, install if not installed
check_nodejs() {
	info_message "Checking Node.js status..."
	if ! command -v node &> /dev/null; then
		warning_message "Node.js is either not installed or not configured correctly."
		handle_error "Please install Node.js from https://nodejs.org/ or configure it properly before using Minifier Tools again."
	else
		useless_action_message "Node.js is installed and ready!"
	fi
	carriage_return_message
}

# Generic tool status check, install if not installed
check_tool() {
	local tool_name=$1
	local bettered_name=$2
	local install_command=$3

	info_message "Checking $bettered_name status..."
	if ! command -v $tool_name &> /dev/null; then
		warning_message "$bettered_name is not installed. Installing..."
		eval $install_command
		if [ $? -ne 0 ]; then
			handle_error "$bettered_name installation failed. Please install it manually."
		fi
		info_message "$bettered_name installed successfully."
	else
		useless_action_message "$bettered_name is already installed!"
	fi
	carriage_return_message
}