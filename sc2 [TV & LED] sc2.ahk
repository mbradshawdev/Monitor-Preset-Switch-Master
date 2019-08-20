/* MONITOR PRESET SWITCH MASTER
    Script to take Increasingly drastic measures to get AMD's Catalyst Control Center presets to work :/

NOTES:
     Ahk script filename MUST match preset name. eg: profilename="sc1 [Monitors] sc1" so script must be named "sc1 [Monitors] sc1.ahk"
     Sometimes it is required to first kill the process "MOM.exe" and it's kind of like a The Binding Of Isaac reference :')

;SETTINGS
*/ #NoEnv
    SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
    #SingleInstance Force


;MAIN PROGRAM
SplitPath, A_ScriptName,,,, x           ;Get preset name from script filename

GoSub, GetScreenInfo                ;Get info on display situation (Adapted from "2 3 4 up" script)

ToolTip 1                                     ;1 simple launch of the shortcut 
run, "C:\Program Files (x86)\AMD\ATI.ACE\Core-Static\CLI.exe" Start Load profilename="%x%"
Sleep 1000
GoSub, GetScreenInfo
GoSub, DidItWork

ToolTip 2                                   ;2 try again
Sleep 500
run, "C:\Program Files (x86)\AMD\ATI.ACE\Core-Static\CLI.exe" Start Load profilename="%x%"
Sleep 2000
GoSub, GetScreenInfo
GoSub, DidItWork

ToolTip 3                               ;3 Close AMD Catalyst services and try aagain
Sleep 500
run, TASKKILL /F /IM "MOM.exe"
run, TASKKILL /F /IM "CCC.exe"
Sleep 2000
run, "C:\Program Files (x86)\AMD\ATI.ACE\Core-Static\CLI.exe" Start Load profilename="%x%"
Sleep 2000
GoSub, GetScreenInfo
GoSub, DidItWork

ToolTip 4                           ;4 Close AMD Catalyst services multiple times and longer waits
Sleep 1000
run, TASKKILL /F /IM "MOM.exe"
run, TASKKILL /F /IM "CCC.exe"
run, TASKKILL /F /IM "MOM.exe"
run, TASKKILL /F /IM "CCC.exe"
run, TASKKILL /F /IM "MOM.exe"
run, TASKKILL /F /IM "CCC.exe"
Sleep 4000
run, "C:\Program Files (x86)\AMD\ATI.ACE\Core-Static\CLI.exe" Start Load profilename="%x%"
Sleep 4000
GoSub, GetScreenInfo
GoSub, DidItWork

;5 reload script with warning (endless loop)
ToolTip 5
Sleep 1000
 MsgBox, 1,, % "UnsuccessfuI. Restarting... Press [NO] to cancel`nCheck preset name '" x "' is correct.", 5
  IfMsgBox Cancel
     ExitApp
 reload


;SUB-ROUTINES

GetScreenInfo:
    monPLeftOld := monPLeft                ;Current situation saved to compare with next situation
    monPTopOld := monPTop                 ;Doesn't do anything on first run 0 = 0
    monPRightOld := monPRight
    monPBottomOld := monPBottom
    
    monSLeftOld := monSLeft
    monSTopOld := monSTop
    monSRightOld := monSRight
    monSBottomOld := monSBottom      
    
    SysGet, monP, MonitorWorkArea,           ;Primary
    Loop 4                                                    ;Secondary
    {
        SysGet, monS, MonitorWorkArea, %A_Index%        ;For possible screens 1-4 get the info and see first if the screen exists AND then that it's different from primary (aka it's secondary)
        if (monSLeft or MonSTop or monSRight or monSBottom) and (!(monSLeft = monPLeft) or !(monSTop = monPTop) or !(monSRight = monPRight) or !(monSBottom = monPBottom))
            break
       }
Return


DidItWork:
    if ((monPRightOld != monPRight) or (monPBottomOld != monPBottom) or (monSBottomOld != monSBottom) or (monSRightOld != monSRight))
    {
        ;success = 1
        ;GoSub, debugMsgBox
        ToolTip It worked! Quitting
        Sleep 1000
        ExitApp
        Return
    }
Return


debugMsgBox:
MsgBox, 
(
A_ScriptName:`t %A_ScriptName%
x:`t`t %x%

monPLeft:`t %monPLeft%
monPTop:`t %monPTop%
monPRight:`t %monPRight%
monPBottom:`t %monPBottom%

monPRightOld:`t %monPRightOld%
monPBottomOld:`t %monPBottomOld%

monSLeft:`t %monSLeft%
monSTop:`t %monSTop%
monSRight:`t %monSRight%
monSBottom:`t %monSBottom%

monSRightOld:`t %monSRightOld%
monSBottomOld:`t %monSBottomOld%
)
Sleep 500
Return