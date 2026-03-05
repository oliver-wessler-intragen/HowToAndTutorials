# How to debug the Angular portal

## About this guide
This guide shows how to debug Angular portal code in VSCode. It assumes that you already have a running Angular portal development environment (VSCode, cloned Angular repository, OIM installation, etc.).
The examples will show how to start debugging the `qer-app-portal` application with Firefox as a browser.

## Setup

### Cloned repository
After setting up VSCode and cloning the Angular portal repository, the folder `IdentityManager.Imx` should be open in VSCode, with the folder `imxweb` inside it:

![VSCode Explorer View of the Angular portal repository](images\opened_folder.png)

### Creating launch configurations
To enable debugging, copy the file `IdentityManager.Imx\imxweb\.vscode\launch.json` to `IdentityManager.Imx\.vscode\launch.json`.
This file contains different launch configurations that can be used for debugging. You can either use one of the included configurations or add your own.

![VSCode Explorer View of the Angular portal repository folder with an arrow that indicates the copied "launch.json" file](images\copy_launch_json.png)

> **Why do you need to copy this file?**
>
> VSCode expects a project's debug configuration at the relative path `.\.vscode\launch.json` inside the project folder. The actual project folder of the Angular Portal is `.\imxweb` inside the repository folder. This is why it already contains a prepared `launch.json` file.
You can open the `imxweb` folder directly in VSCode, and use the existing configuration instead of copying it. The downside is that the `imxweb` folder is not a complete git repository. This means that you would need to switch to the `IdentityManager.Imx` folder whenever you want to use git functionality (committing to your local repository, pushing to the remote repository, etc.).
> 
> By copying the file once, you can use the debugger and git without switching the working directory.

### Adding support for additional browsers
VSCode does not have ootb support for Firefox as a debugging browser. Support for different browsers can be added by installing a VSCode extension.

Firefox debug support can be added with the extension `Debugger for Firefox`, created by Mozilla. It can be downloaded from the [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=firefox-devtools.vscode-firefox-debug) or installed through the VSCode Extension menu.

> <font color=red><b>
> Always be careful when adding extensions to VSCode. Only install extensions from trustworthy sources!
</b></font>

## Starting the debugger
1. Start a local imxclient

2. Build and run the qer-app-portal application in VSCode

3. Switch to the `Run and Debug` view in VSCode. The dropdown at the top offers all start configurations that are defined in the `launch.json` file.

![VSCode "Run and Debug" view showing the available runc configurations](images/debug_view_with_available_configs.PNG)

Select `QER App Portal (Firefox)` and click the green triangle next to the dropdown to start debugging. This will open a new Firefox window and load the Angular Portal start page from the local imxclient. The address bar will be highlighted and showing a robot symbol if the debugger has been connected correctly to the browser.

![Firefox browser with Angular portal login page, the address bar is highlighted to show that the browser is running in debug mode](images/firefox_debug_session.PNG)