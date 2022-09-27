#cs 
    @filename:    MainWindow.au3
    @description: 助手主窗口
#ce

#include-once
#include <GUIConstantsEx.au3>
#include "SettingWindow.au3"
#include "TaskWindow.au3"
#include "../Generic.au3"
#include "../Logger.au3"
#include "../db/CommonDb.au3"
#include "../script/AllScripts.au3"

Local $mw_thisWindow = Null, $mwc_listTasks = Null
Local $mw_settingWindow = Null, $mw_taskWindow = Null
Local $mw_startButton = Null, $mw_stopButton = Null

; 创建主窗口
Func MainWindow_CreateWindow()
    ; 主窗口
    $mw_thisWindow = GUICreate($APP_NAME, $WINDOW_MAIN_WIDTH, $WINDOW_MAIN_HEIGHT)
    GUISetOnEvent($GUI_EVENT_CLOSE, "_MainWindow_CloseWindow")

    ; 主窗口: 任务选择下拉框
    Local $comboTasks = GUICtrlCreateCombo("", 5, 5, 120, 30, $CBS_DROPDOWNLIST)

    ; 主窗口: 任务列表
    $mwc_listTasks = GUICtrlCreateList("", 5, 30, 120, 285)
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
    $mw_startButton = GUICtrlCreateButton("开始", 5, 320, $BUTTON_MIN_WIDTH, $BUTTON_COMMON_HEIGHT)
    GUICtrlSetOnEvent($mw_startButton, "_MainWindow_StartScript")
    
    ; 主窗口: 停止按钮
    $mw_stopButton = GUICtrlCreateButton("停止", 80, 320, $BUTTON_MIN_WIDTH, $BUTTON_COMMON_HEIGHT)
    GUICtrlSetOnEvent($mw_stopButton, "_MainWindow_StopScript")
    GUICtrlSetState($mw_stopButton, $GUI_DISABLE)

    ; 主窗口: 设置
    Local $btnSetting = GUICtrlCreateButton("设置", 155, 320, $BUTTON_MIN_WIDTH, $BUTTON_COMMON_HEIGHT)
    GUICtrlSetOnEvent($btnSetting, "_MainWindow_OpenSettingWindow")
    
    ; 主窗口: 任务
    Local $btnTask = GUICtrlCreateButton("任务", 230, 320, $BUTTON_MIN_WIDTH, $BUTTON_COMMON_HEIGHT)
    GUICtrlSetOnEvent($btnTask, "_MainWindow_OpenTaskWindow")

    Return $mw_thisWindow
EndFunc ;==>MainWindow_CreateWindow

; 关闭主窗口
Func _MainWindow_CloseWindow()
    Local $userRes = MsgBox(1, "提示", "确认退" & $APP_NAME & "吗?")
    If $userRes <> 1 Then
        LogDebug("User Canceled.")
        Return
    EndIf

    LogDebug("Close MainWindow.")
    DestoryDb()
    GUIDelete($mw_thisWindow)
    If $mw_settingWindow <> Null Then
        GUIDelete($mw_settingWindow)
    EndIf
    If $mw_taskWindow <> Null Then
        GUIDelete($mw_taskWindow)
    EndIf
    Exit 0
EndFunc

; 打开设置窗口, 禁用主窗口
Func _MainWindow_OpenSettingWindow()
    If $mw_settingWindow = Null Then
        $mw_settingWindow = SettingWindow_CreateWindow($mw_thisWindow)
    EndIf
    LogDebug("Open SettingWindow, disable MainWindow.")
    GUISetState(@SW_DISABLE, $mw_thisWindow)
    GUISetState(@SW_SHOW, $mw_settingWindow)
EndFunc

; 打开任务窗口, 禁用主窗口
Func _MainWindow_OpenTaskWindow()
    If $mw_taskWindow = Null Then
        $mw_taskWindow = TaskWindow_CreateWindow($mw_thisWindow)
    EndIf
    LogDebug("Open SettingWindow, disable MainWindow.")
    GUISetState(@SW_DISABLE, $mw_thisWindow)
    GUISetState(@SW_SHOW, $mw_taskWindow)
EndFunc

; 执行脚本
Func _MainWindow_StartScript()
    GUICtrlSetState($mw_startButton, $GUI_DISABLE)
    GUICtrlSetState($mw_stopButton, $GUI_ENABLE)
    LogInfo("StartScript")
    Local $res = GUICtrlRead($mwc_listTasks)
    LogInfo("start: " & $res)

    Local $scriptNames = Common_GetAllScriptNames()

    For $name In $scriptNames
        Call(Common_GetScriptFunc($name))
    Next
EndFunc

; 执行脚本
Func _MainWindow_StopScript()
    GUICtrlSetState($mw_stopButton, $GUI_DISABLE)
    GUICtrlSetState($mw_startButton, $GUI_ENABLE)
    LogInfo("StopScript")
EndFunc