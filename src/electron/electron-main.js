"use strict";
const electron = require("electron");
const {ipcMain} = require("electron");
const app = electron.app;
const BrowserWindow = electron.BrowserWindow;
const client = require('electron-connect').client;

let mainWindow;

// Create the browser window.
function appMain () {
    mainWindow = new BrowserWindow({
        width: 1024,
        height: 768,
        show:false,
        frame:true,
        autoHideMenuBar:true,
        minWidth : 320,
        minHeight : 400,
        fullscreenable: false,
        useContentSize: true,
        "node-integration": true,
    });
    mainWindow.loadURL(`file://${__dirname}/index.html`);
    client.create(mainWindow); //TODO: Remove in release
    // Setup Events.
    mainWindow.on("closed", function () {
        mainWindow = null;
    });
    mainWindow.once("ready-to-show", () => {
        mainWindow.show();
    });

    // Setup IPC
    ipcMain.on("close-main-window", function () {
        app.quit();
    });
    ipcMain.on("min-main-window", function () {
        if(mainWindow.isMinimized() === false) {
            mainWindow.minimize();
        } else {
            mainWindow.restore();
        }
    });
    ipcMain.on("max-main-window", function () {
        if(mainWindow.isMaximized() === false) {
            mainWindow.maximize();
        } else {
            mainWindow.unmaximize();
        }
    });
}

app.on("ready", appMain);

app.on("window-all-closed", function () {
    if (process.platform !== "darwin") {
        app.quit();
    }
});

app.on("activate", function () {
    if (mainWindow === null) {
        appMain();
    }
});
