#NoEnv
#SingleInstance, Force
#MaxHotkeysPerInterval 500

FileEncoding, UTF-8
SendMode, Input
SetTitleMatchMode, 3
SetWorkingDir, %A_ScriptDir%

if (not A_IsAdmin)
{
    try
    {
        if (A_IsCompiled)
        {
            Run, *RunAs "%A_ScriptFullPath%" /restart
        }
        else
        {
            Run, *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
        }
    }
    exitApp
}

if (not FileExist("cports\cports.exe"))
{

    FileCreateDir, cports

    UrlDownloadToFile, https://www.nirsoft.net/utils/cports-x64.zip, cports\cports-x64.zip

    AppObj := ComObjCreate("Shell.Application")
    FolderObj := AppObj.Namespace(A_WorkingDir . "\cports\cports-x64.zip")
    FolderItemsObj := FolderObj.Items()
    AppObj.Namespace(A_WorkingDir . "\cports\").CopyHere(FolderItemsObj, 4|16)

    FileDelete, cports\cports-x64.zip
}

#IfWinActive ahk_class POEWindowClass
    F2::
        critical
        RunWait, cports\cports.exe /close * * * * PathOfExile_x64Steam.exe
    return