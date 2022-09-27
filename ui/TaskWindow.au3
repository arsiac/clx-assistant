#cs 
    @filename:    TaskWindow.au3
    @description: 任务管理子窗口
#ce

#include-once
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiComboBoxEx.au3>
#include "../Generic.au3"
#include "../Logger.au3"
#include "../db/UserTask.au3"
#include "../script/AllScripts.au3"

Local $tw_parentWindow, $tw_thisWindow
Local $tw_scriptList, $tw_taskCombo, $tw_taskItemList

; 创建任务窗口
Func TaskWindow_CreateWindow($parent)
    LogTrace("Create TaskWindow")
    $tw_parentWindow = $parent
    ; 设置子窗口
    Local $winStyle = BitOR($WS_CAPTION, $WS_CHILDWINDOW, $WS_POPUP, $WS_THICKFRAME)
    $tw_thisWindow = GUICreate("任务管理", $WINDOW_TASK_WIDTH, $WINDOW_TASK_HEIGHT, -1, -1, $winStyle, -1, $parent)
    GUISetOnEvent($GUI_EVENT_CLOSE, "_TaskWindow_CloseWindow", $tw_thisWindow)

    Local $labelTasks = GUICtrlCreateLabel("可选任务", 40, 10, $CTRL_LABEL_WIDTH, $CTRL_COMMON_HEIGHT)
    GUICtrlSetFont($labelTasks, $FONT_COMMON_SIZE, $FW_NORMAL)
    ; 可选任务
    $tw_scriptList = GUICtrlCreateList("", 5, 30, $CTRL_LISTBOX_W_WIDTH, 240)
    GUICtrlSetLimit($tw_scriptList, 200)
    For $sName In Common_GetAllScriptNames()
        GUICtrlSetData($tw_scriptList, $sName)
    Next

    GUICtrlCreateButton("添加", $CTRL_LISTBOX_W_WIDTH + 20, 50, 40, $CTRL_COMMON_HEIGHT)
    GUICtrlCreateButton("保存", $CTRL_LISTBOX_W_WIDTH + 20, 90, 40, $CTRL_COMMON_HEIGHT)

    ; 用户任务下拉列表
    $tw_taskCombo = GUICtrlCreateCombo("", $CTRL_LISTBOX_W_WIDTH + 75, 5, $CTRL_COMBO_W_WIDTH, $CTRL_COMMON_HEIGHT, $CBS_DROPDOWNLIST)
    ; 任务明细
    $tw_taskItemList = GUICtrlCreateList("", $CTRL_LISTBOX_W_WIDTH + 75, 30, $CTRL_LISTBOX_W_WIDTH, 240)

    Return $tw_thisWindow
EndFunc ;==>SettingWindow_CreateWindow

; 关闭设置窗口, 激活主窗口
Func _TaskWindow_CloseWindow()
    LogTrace("Hide TaskWindow, enable MainWindow.")
    GUISetState(@SW_HIDE, $tw_thisWindow)
    GUISetState(@SW_ENABLE, $tw_parentWindow)
    GUISetState(@SW_RESTORE, $tw_parentWindow)
EndFunc ;==>_TaskWindow_CloseWindow
