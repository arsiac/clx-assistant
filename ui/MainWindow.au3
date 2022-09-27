#include-once
#include <GUIConstantsEx.au3>
#include "../Generic.au3"
#include "../Logger.au3"
#include "../db/CommonDb.au3"
#include "../script/AllScripts.au3"

Local $mw_thisWindow = Null, $mw_settingWindow = Null, $mwc_listTasks = Null

; 创建主窗口
Func MainWindow_CreateWindow()
    ; 主窗口
    $mw_thisWindow = GUICreate("助手", $WINDOW_MAIN_WIDTH, $WINDOW_MAIN_HEIGHT)
    GUISetOnEvent($GUI_EVENT_CLOSE, "_MainWindow_CloseWindow")

    ; 主窗口: 任务选择下拉框
    Local $comboTasks = GUICtrlCreateCombo("", 5, 5, 120, 30, $CBS_DROPDOWNLIST)

    ; 主窗口: 任务列表
    $mwc_listTasks = GUICtrlCreateList("", 5, 35, 120, 290)
    GUICtrlSetLimit($mwc_listTasks, 200)

    ; 主窗口: 日志列表
    Local $logSize = 100
    Local $listLog = GUICtrlCreateList("", 130, 5, 465, 310)
    GUICtrlSetFont($listLog, $FONT_LOG_SIZE, $FW_NORMAL)
    GUICtrlSetBkColor($listLog, 0x25292e)
    GUICtrlSetColor($listLog, 0xe2d9dc)
    GUICtrlSetLimit($mwc_listTasks, $logSize)
    Logger_SetLogCtrl($listLog, $logSize)

    ; 主窗口: 开始按钮
    Local $btnStart = GUICtrlCreateButton("开始", 5, 320, $BUTTON_COMMON_WIDTH, $BUTTON_COMMON_HEIGHT)
    GUICtrlSetOnEvent($btnStart, "_MainWindow_StartScript")

    ; 主窗口: 设置
    Local $btnSetting = GUICtrlCreateButton("设置", 100, 320, $BUTTON_COMMON_WIDTH, $BUTTON_COMMON_HEIGHT)
    GUICtrlSetOnEvent($btnSetting, "_MainWindow_OpenSettingWindow")

    Return $mw_thisWindow
EndFunc ;==>MainWindow_CreateWindow

; 设置子窗口
Func MainWindow_SetSettingWindow($handler)
    $mw_settingWindow = $handler
EndFunc ;==>MainWindow_SetSettingWindow

; 关闭主窗口
Func _MainWindow_CloseWindow()
    LogDebug("Close MainWindow")
    DestoryDb()
    GUIDelete($mw_thisWindow)
    GUIDelete($mw_settingWindow)
    Exit 0
EndFunc

; 打开设置窗口, 禁用主窗口
Func _MainWindow_OpenSettingWindow()
    If $mw_settingWindow = Null Then
        LogError("Setting Window not assert.")
    EndIf
    LogDebug("Open SettingWindow, disable MainWindow.")
    GUISetState(@SW_DISABLE, $mw_thisWindow)
    GUISetState(@SW_SHOW, $mw_settingWindow)
EndFunc

; 执行脚本
Func _MainWindow_StartScript()
    LogInfo("StartScript")
    Local $res = GUICtrlRead($mwc_listTasks)
    LogInfo("start: " & $res)

    Local $scriptNames = Common_GetAllScriptNames()

    For $name In $scriptNames
        Call(Common_GetScriptFunc($name))
    Next
EndFunc