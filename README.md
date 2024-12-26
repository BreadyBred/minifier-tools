# Minifier Tools

**Tired of manually minifying your JS and CSS files?** Minifier Tools is a handy GitHub repository that provides you with three easy ways to minify your files locally and on demand!

## What it Does

Minifier Tools allows you to quickly reduce the size of your JavaScript and CSS files. This can significantly improve website loading times and performance.

## Features

There are three ways to use Minifier Tools:

*   **Post-build Minifier:** Perfect for integration with your build process. Simply add a script to your `package.json` to automatically minify your compiled JavaScript file after running `npm run build`.
*   **Standalone Minifier:** Drag your JS and CSS files to the `to_minify` folder. Run the script and voila! Your minified files will appear in the `minified` folder. No configuration needed!
*   **Portable Minifier:** This interactive script prompts you for the absolute path of a file (using forward slashes `/`) and minifies it on the spot.

**Important Notes:**

*   The post-build minifier currently only works with JavaScript files.
*   None of the tools overwrite existing files. Minified files will have a suffix of `-min.js` or `-min.css`.
*   All scripts automatically check for and install necessary tools (NodeJS, CleanCSS, UglifyJS) if they're missing.

## Getting Started

Head over to the GitHub repository to download Minifier Tools and get started: [Link to your GitHub repository here]

## How to Use It

**Post-build Minifier:**

1.  Update your `package.json` using the following format:
    ```json
    "scripts": {
		  "build": "tsc",
		  "postbuild": "bash ./path/to/script/postbuild_minifier.sh",
	  }
    ```
> `postbuild` will be automatically called after the successfull call of `build`

2.  Replace `FILE_NAME="C://PATH/TO/JS/SCRIPT/script.js"` with the actual path to your compiled JavaScript file.
3.  Everytime you run the `npm run build`, you will find your newly minified file under `$FILE_NAME-min.js`

**Standalone Minifier:**

1.  Drag your JS and CSS files to the `to_minify` folder.
2.  Run the script.
3.  Find your minified scripts in the `minified` folder.

**Portable Minifier:**

1.  Run the script.
2.  Enter the absolute path (using forward slashes `/`, `\` are **NOT** supported) of the file you want to minify when prompted.
3.  Find the minified file under `$FILE_NAME-min.extension`.

## Technologies Used

*   Shell
*   Node.js
*   CleanCSS
*   UglifyJS