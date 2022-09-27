#include "Generic.au3"
#include "Logger.au3"
#include "db/Setting.au3"
#include "script/AllScripts.au3"
#include "ui/MainWindow.au3"
#include "ui/SettingWindow.au3"

InitializeDb()
SetLogLevelByName(QueryScriptSettingValue($CGGP_COMMON, $CG_COMMON_LOGLEVEL))
Logger_SetConsoleEnable(QueryScriptSettingValue($CGGP_COMMON, $CG_COMMON_CONSOLE))

Local $mainWindow = MainWindow_CreateWindow()
Local $settingWindow = SettingWindow_CreateWindow($mainWindow)
MainWindow_SetSettingWindow($settingWindow)

; 显示窗口
GUISetState(@SW_SHOW, $mainWindow)

LogDebug("Running: " & @ScriptDir)

; 防止程序退出
While True
    Sleep(1000)
WEnd
