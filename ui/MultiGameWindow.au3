#cs 
    @filename:    MultiGameWindow.au3
    @description: 多个游戏窗口选择
#ce

#include-once
#include <GUIConstantsEx.au3>
#include "../Generic.au3"
#include "../Logger.au3"
#include "../util/DataUtils.au3"

Local $mgw_parentWindow, $mgw_thisWindow = Null
Local $mgw_GameWindowList
Local $mgw_funcStartScript = Null, $mgw_wins = Null

; 创建游戏窗口选择窗口
Func MultiGameWindow_CreateWindow($parent, $wins)
    LogTrace("Create MultiGameWindow")
    $mgw_parentWindow = $parent
    $mgw_wins = $wins
    ; 窗口选择子窗口
    Local $winStyle = BitXOR($WS_OVERLAPPEDWINDOW, $WS_THICKFRAME)
    $mgw_thisWindow = GUICreate("选择窗口", $WINDOW_MULTI_WIDTH, $WINDOW_MULTI_HEIGHT, -1, -1, $winStyle, -1, $parent)
    GUISetOnEvent($GUI_EVENT_CLOSE, "_Evt_MultiGameWindow_CloseWindow", $mgw_thisWindow)

    ; 窗口列表
    $mgw_GameWindowList = GUICtrlCreateList("", 5, 5, $WINDOW_MULTI_WIDTH - 10, $WINDOW_MULTI_HEIGHT - 40)
    GUICtrlSetOnEvent($mgw_GameWindowList, "_Evt_MultiGameWindow_MentionWindow")
    For $i = 1 To $wins[0][0]
        GUICtrlSetData($mgw_GameWindowList, $wins[$i][0] & " (" & $i & ")")
    Next

    Local $btn = GUICtrlCreateButton("确认", 100, $WINDOW_MULTI_HEIGHT - 30, $BUTTON_MIN_WIDTH, $BUTTON_COMMON_HEIGHT)
    GUICtrlSetOnEvent($btn, "_Evt_MultiGameWindow_StartScript")
    
    GUISetState(@SW_DISABLE, $mgw_parentWindow)
    GUISetState(@SW_SHOW, $mgw_thisWindow)
EndFunc ;==>MultiGameWindow_CreateWindow

; 设置启动脚本的函数
Func MultiGameWindow_SetStartScriptFunc($func)
    $mgw_funcStartScript = $func
EndFunc ;==>MultiGameWindow_SetStartScriptFunc

; 根据列表名称获取窗口
Func _MultiGameWindow_GetGameWindowByName($name)
    Local $res = StringSplit($name, "(")
    $res = StringSplit($res[2], ")")
    Return $mgw_wins[Number($res[1])][1]
EndFunc ;==>_MultiGameWindow_GetGameWindowByName

; 销毁窗口
Func _Evt_MultiGameWindow_CloseWindow()
    LogTrace("Destory MultiGameWindow, enable MainWindow.")
    GUISetState(@SW_HIDE, $mgw_thisWindow)
    GUISetState(@SW_ENABLE, $mgw_parentWindow)
    GUISetState(@SW_RESTORE, $mgw_parentWindow)
    GUIDelete($mgw_thisWindow)
    $mgw_thisWindow = Null
EndFunc ;==>_Evt_MultiGameWindow_CloseWindow

; 提示窗口
Func _Evt_MultiGameWindow_MentionWindow()
    Local $name = GUICtrlRead(@GUI_CtrlId)
    Local $debugMsg = ["Select window: ", $name]
    LogDebug($debugMsg)
    Local $handle = _MultiGameWindow_GetGameWindowByName($name)
    WinMove($handle, "", 5, 5)
    WinActivate($handle)
EndFunc ;==>_Evt_MultiGameWindow_MentionWindow

; 启动脚本
Func _Evt_MultiGameWindow_StartScript()
    Local $selectedName = GUICtrlRead($mgw_GameWindowList)
    Local $debugMsg = ["Selected window: ", $selectedName]
    LogDebug($debugMsg)
    
    If DataUtils_IsEmptyString($selectedName) Then
        MsgBox(0, "提示", "请在列表中选择窗口")
        Return
    EndIf

    _Evt_MultiGameWindow_CloseWindow()
    Local $handle = _MultiGameWindow_GetGameWindowByName($selectedName)
    Call($mgw_funcStartScript, $handle)
EndFunc ;==>_Evt_MultiGameWindow_StartScript