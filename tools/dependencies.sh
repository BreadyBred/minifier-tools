#!/bin/bash

# Node.JS status check, install if not installed
check_nodejs() {
	info_message "Checking Node.js status..."
	if ! command -v node &> /dev/null; then
		warning_message "Node.js isn't installed. Installing..."
		if [[ "$OSTYPE" == "linux-gnu"* ]]; then
			curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
			sudo apt-get install -y nodejs
		elif [[ "$OSTYPE" == "darwin"* ]]; then
			brew install node
		else
			handle_error "Operating system not supported for automatic Node.js installation.${CARRIAGE_RETURN}Please install Node.js manually from https://nodejs.org/"
		fi

		if ! command -v node &> /dev/null; then
			handle_error "Node.js installation failed. Please install it manually."
		fi

		info_message "Node.js installed successfully."
	else
		useless_action_message "Node.js is already installed!"
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

# XMLLInt status check, install if not installed
check_xmllint() {
    info_message "Checking XMLLInt status..."
    if ! command -v xmllint &> /dev/null; then
        warning_message "XMLLInt is not installed. Installing..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt-get install -y libxml2-utils
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install libxml2
        else
            handle_error "Operating system not supported for automatic XMLLInt installation.${CARRIAGE_RETURN}Please install it manually."
        fi

        if ! command -v xmllint &> /dev/null; then
            handle_error "XMLLInt installation failed. Please install it manually."
        fi

        info_message "XMLLInt installed successfully."
    else
        useless_action_message "XMLLInt is already installed!"
    fi
    carriage_return_message
}