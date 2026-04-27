# How to set up and use the dev tools for the Angular Portal

> This guide contains instructions for versions 9.2.x and 9.3.x of One Identity Manager.
> The commands and specific versions of tools and dependencies are known to work for these versions of OneIM. Later versions may work as well.
> This guide is NOT a tutorial for git, node or any other development tools. Basic knowledge of git, node and usage of a terminal are assumed.

## Installation of required tools
Download and install the following tools

1. git [https://git-scm.com/](https://git-scm.com/)
2. node.js
    - OneIM 9.2.x: version 16.10.0
    - OneIM 9.3.x: version 22.0.0

## Install the Angular framework
Use the node package manager (part of the previously installed node.js) to install the Angular framework. Use the terminal command to specify the correct Angular version for your version of OneIM.

- OneIM 9.2.x: `npm install -g @angular/cli@14.2.12`
- OneIM 9.3.x: `npm install -g @angular/cli@18.2.14`

# Create a local repository
In the next steps, you will create a local copy of the Angular source code. These are the files that you will directly edit when doing changes.

## Fork the Angular source code to your own repository
The official repository for the Angular source code is located at [https://github.com/OneIdentity/IdentityManager.Imx](https://github.com/OneIdentity/IdentityManager.Imx). Create a fork of this repository on your git platform of choice.

How you create a fork depends on the platform or tools you are using to host the forked repository.

> Creating a fork is not strictly necessary. It is recommended to create a fork if you want to enable multiple people to work on a shared repository. You cannot push customizations to the official repository.

## Clone the Angular source code
Clone the Angular source code to a local repository, either from your fork (if you created one) or from the official repository.
Switch to the correct branch of the repository for your version of OneIM:

- OneIM 9.2.x: branch `v92`
- OneIM 9.3.x: branch `v93`

After cloning, the repository should be contained in a directory `IdentityManager.Imx`. In the following instructions, this directory will be referred to as the `repository directory`, directory paths will be relative to this directory.

> How you clone the source code and switch branches depends on the tools you are using.
> You can use an editor or IDE which has GUI controls or use terminal commands to directly use the git tools.

# Prepare the local repository

## Install dependencies
Inside a terminal, navigate to the folder `.\imxweb` inside your repository directory. Use the node package manager to install all required project dependencies:

- OneIM 9.2.x: `npm install`
- OneIM 9.3.x: `npm install --skip-dialog`

## Initial compilation
After all dependencies have been installed, all modules and applications that make up the Angular portal need to be compiled once. Later, you will only need to compile modules and applications that were changed. The modules and applications are compiled by using the node package manager to run the build scripts that are provided in the repository.

Use the following terminal commands:

- OneIM 9.2.x (execute all commands in the given order):
    
        `npm run build qbm`
        `npm run build qer`
        `npm run build tsb`
        `npm run build att`
        `npm run build rms`
        `npm run build aad`
        `npm run build aob`
        `npm run build uci`
        `npm run build cpl`
        `npm run build dpr`
        `npm run build rmb`
        `npm run build rps`
        `npm run build o3t`
        `npm run build olg`
        `npm run build hds`
        `npm run build pol`
        `npm run build qer-app-portal`
        `npm run build qbm-app-landingpage`
        `npm run build qer-app-operationssupport`
        `npm run build qer-app-pwdportal`
        `npm run build custom-app`

- OneIM 9.3.x: `npm run nx:build-all`


# Running the Angular portal locally
To test changes to the Angular portal without having to deploy them to a OneIM installation, you can start a local ApiServer and use it for testing.
This requires access to a OneIM installation and database that can be used for testing.

## Start a local ApiServer
Open a terminal and navigate to the OneIM installation directory (usually located at `C:\Program Files\One Identity\One Identity Manager`).

Run the following command: `imxclient.exe run-apiserver -B`

A OneIM login screen will be shown. Log in with an administrative system user (`viadmin` or a custom user).

Wait until the startup process is finished. This is indicated by a message in the terminal that says that the local server is reachable at `http://localhost:8182`. You can verify the successful start by opening this URL in a browser.

The last message in the terminal says `Press ENTER to continue`. This will actually shut down the local ApiServer, so only do this if you do not want to do any further testing.

## Start the modified Angular portal from your local repository
> All changed modules and applications need to be compiled before you start the Angular portal on the local ApiServer.

In a terminal, navigate to `.\imxweb` inside your repository folder and execute the command `npm run start qer-app-portal`.

Wait until the start script is finished, indicated by a message that says that the local server is reachable at `http://localhost:4200`.

> Note that two different web applications can now be accessed at `http://localhost`, only separated by the port number appended to the URL. Your modified portal will always be reachable on port 4200, while port 8182 will present an unmodified version of the portal.

Open `http://localhost:4200` in a browser and test your changes.

To shut down the modified Angular portal, end the process in the terminal from which it was started.

If you want to debug specific pieces of code, check the [debugging guide](../Debugging/debugging.md) in this repository.

# Deploying changes
After a change has been made, tested, debugged and everything works, follow these steps to deploy the change to a OneIM environment:

