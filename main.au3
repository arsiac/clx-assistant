#cs 
    @filename:    main.au3
    @description: 程序入口
#ce

#include "Generic.au3"
#include "Logger.au3"
#include "db/Setting.au3"
#include "script/AllScripts.au3"
#include "ui/MainWindow.au3"

Main()

Func Main()
    InitializeDb()
    SetLogLevelByName(QueryScriptSettingValue($CGGP_COMMON, $CG_COMMON_LOGLEVEL))
    Logger_SetConsoleEnable(QueryScriptSettingValue($CGGP_COMMON, $CG_COMMON_CONSOLE))

    ; 显示窗口
    GUISetState(@SW_SHOW, MainWindow_CreateWindow())

    LogDebug("Running: " & @ScriptDir)

    ; 防止程序退出
    While True
        Sleep(1000)
    WEnd
EndFunc ;==>Main
