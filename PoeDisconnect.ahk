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
            Run *RunAs "%A_ScriptFullPath%" /restart
        }
        else
        {
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
        }
    }
    ExitApp
}

Hotkey, IfWinActive, ahk_class POEWindowClass
    F2::
    Critical
    RunWait, cports.exe /close * * * * PathOfExile_x64Steam.exe
Return