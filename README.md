# Minifier Tools

**Tired of manually minifying your files?** Minifier Tools is a handy GitHub repository that provides you with three easy ways to minify your files locally and on demand!

## Overview

Minifier Tools is designed to simplify the process of reducing the size of your files, whether you're working on a personal project or managing a complex build process. By minimizing file sizes, you can:

*	Significantly improve website loading times.
*	Enhance overall performance by reducing bandwidth usage.
*	Streamline your workflow with automated or manual options for file minification.

This tool supports multiple file types and is flexible enough to fit into any development setup. Whether you're automating your build pipeline or handling ad-hoc file minification, Minifier Tools has you covered!

## Features

There are two ways to use Minifier Tools:

*	**Post-build Minifier:** Perfect for integration with your build process. Simply add a script to your `package.json` to automatically minify your compiled JavaScript file after running `npm run build`. This script **WILL** overwrite your old JavaScript file.
*	**Standalone Minifier:** Drag your files to the `to_minify` folder. Run the script and voilà! Your minified files will appear in the `minified` folder. No manual configuration needed!

Additional Features:

*	Automatic Dependency Installation: Checks for and installs missing tools like CleanCSS, or UglifyJS.
*	Safe File Handling: The standalone version ensures no overwriting by appending a -min.extension suffix to minified files.

## Supported File Types

*	JavaScript
*	CSS
*	JSON
*	HTML
*	SVG

**Important Notes:**

*	The post-build minifier currently only works with JavaScript files.
*	Standalone version will not overwrite existing files. Minified files will have a suffix of `-min.extension`.
*	All scripts automatically check for and install necessary tools (CleanCSS, UglifyJS, etc...) if they're missing.

## Getting Started

Head over to the GitHub repository to download Minifier Tools and get started by launching `minifier_tools.exe`

### Prerequisites

**1. Node.js and NPM:**

Minifier Tools requires a functional Node.js environment and NPM (Node Package Manager) for installing and using the necessary tools. Ensure that Node.js and NPM are installed and properly configured on your system before proceeding.
- Download and install Node.js from the [official website](https://nodejs.org/).
- Verify installation:
	```bash
	node --version
	npm --version
	```

> [!IMPORTANT]
> Make sure Node.js is added to your PATH environment variable during installation.

**2. Bash Interpreter (e.g., Git Bash):**

A Bash interpreter is necessary for running shell scripts.
- Download Git Bash from the [official website](https://git-scm.com/downloads).

> [!IMPORTANT]
> Ensure Git Bash is added to your PATH during installation.

**3. Python (optional):**

If you plan to use the EXE version, Python is required.
- Download Python from the [official website](https://www.python.org/downloads/).
- Verify installation:
```bash
python --version
```

> [!IMPORTANT]
> Make sure to check the "Add Python 3.x to PATH" option during installation.

### Installation

1. Clone the repository:
```bash
git clone https://github.com/BreadyBred/minifier-tools.git
cd minifier-tools
```
2. That's it! You're ready to go, start `minifier_tools.exe` to start using the Standalone version or start setting up the postbuild tool with the quick guid in [Usage](#usage).

### Usage

**Post-build Minifier:**

1.	Update your `package.json` using the following format:
```json
"scripts": {
		"build": "tsc",
		"postbuild": "bash ./path/to/script/postbuild_minifier.sh",
}
```
> `postbuild` will be automatically called after the successfull call of `build`

2.	Replace `FILE_NAME="C://PATH/TO/JS/SCRIPT/script.js"` with the actual path to your compiled JavaScript file.
3.	Everytime you run the `npm run build`, you will find your newly minified file under `$FILE_NAME-min.js`

**Standalone Minifier:**

1.	Drag your files to the `to_minify` folder.
2.	Run the script.
3.	Find your minified scripts in the `minified` folder.

## Technologies Used

*	Shell
*	Python