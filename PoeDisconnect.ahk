#NoEnv
#SingleInstance, Ignore

SendMode, Input
SetWorkingDir, %A_ScriptDir%

; Run as admin
if (not A_IsAdmin) {
    try {
        if (A_IsCompiled) {
            Run, *RunAs "%A_ScriptFullPath%" /restart
        }
        else {
            Run, *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
        }
    }
    ExitApp
}

; Download cports if neccesary
if (not FileExist("cports\cports.exe")) {
    FileCreateDir, cports

    UrlDownloadToFile, https://www.nirsoft.net/utils/cports-x64.zip, cports\cports-x64.zip

    AppObj := ComObjCreate("Shell.Application")
    FolderObj := AppObj.Namespace(A_WorkingDir . "\cports\cports-x64.zip")
    FolderItemsObj := FolderObj.Items()
    AppObj.Namespace(A_WorkingDir . "\cports\").CopyHere(FolderItemsObj, 4|16)

    FileDelete, cports\cports-x64.zip
}

; Global vars
global Binary, Client, Logout

; Read settings
IniRead, Client, settings\settings.ini, Settings, Client, Steam
IniRead, Logout, settings\settings.ini, Settings, Logout, F2

; Create Hotkey
CreateHotkey()

; Tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Settings, SettingsHandler
Menu, Tray, Add,
Menu, Tray, Add, Exit, ExitHandler
Return

; Settings menu
SettingsHandler:
    Gui, +AlwaysOnTop +Owner -SysMenu
    Gui, Font,, Arial

    Gui, Add, GroupBox, xm w90 Section, Client
    Gui, Add, Radio, vClientInput xs+10 ys+20, Standalone
    Gui, Add, Radio, xs+10 ys+40, Steam

    GuiControl,, % Client, 1

    Gui, Add, GroupBox, xm w90 Section, Logout Hotkey
    Gui, Add, Hotkey, vLogoutInput xs+10 ys+20 w70, % Logout

    Gui, Add, Button, Default xm w90, Save
    Gui, Show
Return

; Save settings
ButtonSave:
    Gui, Submit
    Gui, Destroy

    Clients := {1: "Standalone", 2: "Steam"}

    if (Logout <> LogoutInput) {
        DeleteHotkey()
    }

    Client := Clients[ClientInput]
    Logout := LogoutInput

    CreateHotkey()

    if (not FileExist("settings\settings.ini")) {
        FileCreateDir, settings
    } 
    else {
        FileSetAttrib, -R, settings\settings.ini
    }

    IniWrite, % Client, settings\settings.ini, Settings, Client
    IniWrite, % Logout, settings\settings.ini, Settings, Logout

    FileSetAttrib, +R, settings\settings.ini
Return

; Exit
ExitHandler:
ExitApp

; Create hotkey
CreateHotkey() {
    Binaries := {"Standalone": "PathofExile.exe", "Steam": "PathofExileSteam.exe"}
    Binary := Binaries[Client]

    Hotkey, IfWinActive, ahk_class POEWindowClass
        Hotkey, % Logout, Command, On
}

; Delete hotkey
DeleteHotkey() {
    Hotkey, % Logout, Off
}

; Hotkey command
Command() {
    Critical 
    RunWait, cports\cports.exe /close * * * * %Binary%
}