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
Local $tw_funcRefeashParent = Null

; 创建任务窗口
Func TaskWindow_CreateWindow($parent)
    LogTrace("Create TaskWindow")
    $tw_parentWindow = $parent
    ; 设置子窗口
    Local $winStyle = BitXOR($WS_OVERLAPPEDWINDOW, $WS_THICKFRAME)
    $tw_thisWindow = GUICreate("任务管理", $WINDOW_TASK_WIDTH, $WINDOW_TASK_HEIGHT, -1, -1, $winStyle, -1, $parent)
    GUISetOnEvent($GUI_EVENT_CLOSE, "_Evt_TaskWindow_CloseWindow", $tw_thisWindow)

    ; 可选任务
    Local $labelTasks = GUICtrlCreateLabel("可选任务", 35, 10, $CTRL_LABEL_WIDTH, $CTRL_COMMON_HEIGHT - 5)
    $tw_scriptList = GUICtrlCreateList("", 5, 30, $CTRL_LISTBOX_W_WIDTH, 240)
    GUICtrlSetLimit($tw_scriptList, 200)
    For $sName In Common_GetAllScriptNames()
        GUICtrlSetData($tw_scriptList, $sName)
    Next

    Local $newButton = GUICtrlCreateButton("新增", $CTRL_LISTBOX_W_WIDTH + 20, 50, 40, $CTRL_COMMON_HEIGHT)
    GUICtrlSetOnEvent($newButton, "_Evt_TaskWindow_ButtonNew")
    Local $addButton = GUICtrlCreateButton("添加", $CTRL_LISTBOX_W_WIDTH + 20, 90, 40, $CTRL_COMMON_HEIGHT)
    GUICtrlSetOnEvent($addButton, "_Evt_TaskWindow_ButtonAdd")
    Local $delButton = GUICtrlCreateButton("删除", $CTRL_LISTBOX_W_WIDTH + 20, 130, 40, $CTRL_COMMON_HEIGHT)
    GUICtrlSetOnEvent($delButton, "_Evt_TaskWindow_ButtonDelete")

    ; 用户任务下拉列表
    $tw_taskCombo = GUICtrlCreateCombo("", $CTRL_LISTBOX_W_WIDTH + 75, 5, $CTRL_COMBO_W_WIDTH, $CTRL_COMMON_HEIGHT, $CBS_DROPDOWNLIST)
    GUICtrlSetOnEvent($tw_taskCombo, "_Evt_TaskWindow_TaskCombo_RefreshList")
    _TaskWindow_LoadUserTasks()

    ; 任务明细
    $tw_taskItemList = GUICtrlCreateList("", $CTRL_LISTBOX_W_WIDTH + 75, 30, $CTRL_LISTBOX_W_WIDTH, 240)

    ; 手动触发一次刷新
    _TaskWindow_LoadUserTaskItems(GUICtrlRead($tw_taskCombo))
    Return $tw_thisWindow
EndFunc ;==>SettingWindow_CreateWindow\

; 设置父级窗口刷新方法
Func TaskWindow_SetParentRefeashFunc($func)
    $tw_funcRefeashParent = $func;
EndFunc ;==>TaskWindow_SetParentRefeashFunc

; 加载所有任务
Func _TaskWindow_LoadUserTasks()
    Local $tasks = SelectAllUserTasks()
    For $i = 0 To UBound($tasks) - 1
        If $i = 0 Then
            GUICtrlSetData($tw_taskCombo, $tasks[$i], $tasks[$i])
        Else
            GUICtrlSetData($tw_taskCombo, $tasks[$i])
        EndIf
    Next
EndFunc ;==>_TaskWindow_LoadUserTasks

; 加载任务明细
Func _TaskWindow_LoadUserTaskItems($taskName)
    If ($taskName = Null OR $taskName = "") Then
        Return
    EndIf
    Local $items = SelectUserTaskItemByName($taskName)
    GUICtrlSetData($tw_taskItemList, "")
    For $i = 0 To UBound($items) - 1
        _GUICtrlListBox_InsertString($tw_taskItemList, $items[$i])
    Next
EndFunc ;==>_TaskWindow_LoadUserTaskItems

; 新增用户任务
Func _TaskWindow_NewUserTask()
    Local $taskName = InputBox("新增", "请输入新任务名称:", "", "", 250, 150)
    If ($taskName <> Null AND $taskName <> "") Then
        If SelectUserTaskExistByName($taskName) Then
            MsgBox(BitOR($MB_ICONERROR, $MB_DEFBUTTON1), "新增", "任务名称已存在: " & $taskName)
            Return
        EndIf
        GUICtrlSetData($tw_taskCombo, $taskName)
        _GUICtrlComboBox_SelectString($tw_taskCombo, $taskName)

        local $taskDesc = @UserName & ": " & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
        InsertUserTask($taskName, $taskDesc)
    EndIf
    Return $taskName
EndFunc ;==>_TaskWindow_NewUserTask


#cs ------------------------------------------------------
    事件函数
#ce ------------------------------------------------------

; 关闭任务窗口, 激活主窗口
Func _Evt_TaskWindow_CloseWindow()
    LogTrace("Hide TaskWindow, enable MainWindow.")
    GUISetState(@SW_HIDE, $tw_thisWindow)
    GUISetState(@SW_ENABLE, $tw_parentWindow)
    GUISetState(@SW_RESTORE, $tw_parentWindow)
    If Not DataUtils_IsEmptyString($tw_funcRefeashParent) Then
        Call($tw_funcRefeashParent)
    EndIf
EndFunc ;==>_Evt_TaskWindow_CloseWindow

; 下拉框事件
Func _Evt_TaskWindow_TaskCombo_RefreshList()
    Local $selected = GUICtrlRead($tw_taskCombo)
    If ($selected <> Null AND $selected <> "") Then
        _TaskWindow_LoadUserTaskItems($selected)
    EndIf
EndFunc ;==>_Evt_TaskWindow_TaskCombo_RefreshList

; 新增按钮事件
Func _Evt_TaskWindow_ButtonNew()
    _TaskWindow_NewUserTask()
EndFunc ;==>_Evt_TaskWindow_ButtonNew

; 添加按钮事件
Func _Evt_TaskWindow_ButtonAdd()
    Local $selectedScript = GUICtrlRead($tw_scriptList)
    If ($selectedScript = Null OR $selectedScript = "") Then
        MsgBox(0, "提示", "请在左边列表选择脚本", 2)
        Return
    EndIf
    
    ; 用户选择的任务名称
    Local $taskName = GUICtrlRead($tw_taskCombo)
    If ($taskName = Null OR $taskName = "") Then
        $taskName = _TaskWindow_NewUserTask()
        If ($taskName = Null OR $taskName = "") Then
            LogDebug("User Canceled.")
            Return
        EndIf
    EndIf

    If SelectUserTaskItemExistByName($taskName, $selectedScript) Then
        MsgBox(0, "提示", "任务'" & $taskName & "'已存在脚本'" & $selectedScript & "'", 2)
        Return
    EndIf

    GUICtrlSetData($tw_taskItemList, $selectedScript)
    InsertUserTaskItem2($taskName, $selectedScript)
EndFunc ;==>_Evt_TaskWindow_ButtonAdd

; 保存按钮事件
Func _Evt_TaskWindow_ButtonDelete()
    ; 用户选择的任务名称
    Local $taskName = GUICtrlRead($tw_taskCombo)
    Local $taskItem = GUICtrlRead($tw_taskItemList)

    If ($taskItem = Null OR $taskItem = "") Then
        MsgBox(0, "提示", "请选择右侧列表中的脚本", 2)
        Return
    EndIf

    DeleteUserTaskItem($taskName, $taskItem)
    _TaskWindow_LoadUserTaskItems(GUICtrlRead($tw_taskCombo))
EndFunc ;==>_Evt_TaskWindow_ButtonSave
