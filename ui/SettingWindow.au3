#cs 
    @filename:    SettingWindow.au3
    @description: 助手设置管理子窗口
#ce

#include-once
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiComboBoxEx.au3>
#include "../Generic.au3"
#include "../Logger.au3"
#include "../db/Setting.au3"
#include "../db/GameGundeon.au3"
    
Local $sw_parentWindow, $sw_thisWindow
Local $sw_allGundeons, $sw_gundeonCtrlMap[]

; 创建设置窗口
Func SettingWindow_CreateWindow($parent)
    LogTrace("Create SettingWindow")
    $sw_parentWindow = $parent
    ; 设置子窗口
    Local $winStyle = BitXOR($WS_OVERLAPPEDWINDOW, $WS_THICKFRAME)
    $sw_thisWindow = GUICreate("设置", $WINDOW_SET_WIDTH, $WINDOW_SET_HEIGHT, -1, -1, $winStyle, -1, $parent)
    GUISetOnEvent($GUI_EVENT_CLOSE, "_SettingWindow_CloseWindow", $sw_thisWindow)

    ; 设置子窗口: 标签页
    _SettingWindow_CreateTab()
    Return $sw_thisWindow
EndFunc ;==>SettingWindow_CreateWindow

; 关闭设置窗口, 激活主窗口
Func _SettingWindow_CloseWindow()
    LogTrace("Hide SettingWindow, enable MainWindow.")
    GUISetState(@SW_HIDE, $sw_thisWindow)
    GUISetState(@SW_ENABLE, $sw_parentWindow)
    GUISetState(@SW_RESTORE, $sw_parentWindow)
EndFunc ;==>_SettingWindow_CloseWindow

; 创建标签页
Func _SettingWindow_CreateTab()
    Local $tab = GUICtrlCreateTab(0, 0, $WINDOW_SET_WIDTH, $WINDOW_SET_HEIGHT)
    _SettingWindow_CreateTabItem_Common($tab)
    _SettingWindow_CreateTabItem_Reword($tab)
EndFunc ;==>_SettingWindow_CreateTabItems

; 通用标签页
Func _SettingWindow_CreateTabItem_Common($tab)
    GUICtrlCreateTabItem("通用")
    GUICtrlCreateGroup("日志设置", 5, 30, $WINDOW_SET_WIDTH - 10, 60)
    ; 日志级别
    GUICtrlCreateLabel("日志级别", 10, 55, $CTRL_LABEL_WIDTH, $CTRL_COMMON_HEIGHT)
    Local $logLevelCombo = GUICtrlCreateCombo("", 75, 50, $CTRL_COMBO_WIDTH, $CTRL_COMMON_HEIGHT, $CBS_DROPDOWNLIST)
    GUICtrlSetOnEvent($logLevelCombo, "_SettingWindow_TabCommon_LogLevelCombo")
    For $l In Logger_GetLogLevelNames()
        GUICtrlSetData($logLevelCombo, $l)
    Next
    _GUICtrlComboBox_SelectString($logLevelCombo, QueryScriptSettingValue($CGGP_COMMON, $CG_COMMON_LOGLEVEL, GetLogLevelName()))

    ; 控制台输出
    GUICtrlCreateLabel("控制台日志", 165, 55, $CTRL_LABEL_W_WIDTH, $CTRL_COMMON_HEIGHT)
    Local $consoleLogCombo = GUICtrlCreateCombo("", 240, 50, $CTRL_COMBO_WIDTH, $CTRL_COMMON_HEIGHT, $CBS_DROPDOWNLIST)
    GUICtrlSetOnEvent($consoleLogCombo, "_SettingWindow_TabCommon_ConsoleCombo")
    GUICtrlSetData($consoleLogCombo, "True|False")
    _GUICtrlComboBox_SelectString($consoleLogCombo, DataUtils_ToBoolString(QueryScriptSettingValue($CGGP_COMMON, $CG_COMMON_CONSOLE)))
EndFunc ;==>_SettingWindow_CreateTabItem_Common

; 悬赏标签页
Func _SettingWindow_CreateTabItem_Reword($tab)
    $sw_allGundeons = QueryAllGameGundeon()
    ;~ GUISwitch($sw_thisWindow, $tab)
    GUICtrlCreateTabItem("悬赏")
    GUICtrlCreateGroup("悬赏副本", 5, 30, $WINDOW_SET_WIDTH - 10, 80)
    Local $colCount, $rowCount, $row = 1
    For $i = 0 To UBound($sw_allGundeons) - 1
        $colCount = Mod($i, 5)
        $rowCount = Floor($i / 5)
        Local $x, $y
        $x = 10 + $colCount * $CTRL_CHECKBOX_WIDTH
        $y = 45 + $rowCount * $CTRL_CHECKBOX_HEIGHT
        Local $ctrl = GUICtrlCreateCheckbox($sw_allGundeons[$i][0], $x, $y, $CTRL_CHECKBOX_WIDTH, $CTRL_COMMON_HEIGHT)
        GUICtrlSetOnEvent($ctrl, "_SettingWindow_TabReword_Gundeon")
        $sw_gundeonCtrlMap[$ctrl] = $sw_allGundeons[$i][1]
        GUICtrlSetState($ctrl, DataUtils_CheckboxState(QueryScriptSettingValue($CGGP_REWORD, $sw_allGundeons[$i][1])))
    Next
EndFunc ;==>_SettingWindow_CreateTabItem_Reword

; 事件处理: 日志级别
Func _SettingWindow_TabCommon_LogLevelCombo()
    Local $selected = GUICtrlRead(@GUI_CTRLID)
    SaveScriptSetting($CGGP_COMMON, $CG_COMMON_LOGLEVEL, $selected)
    SetLogLevelByName($selected)
EndFunc ;==>_SettingWindow_CreateTabItem_Reword

; 事件处理: 控制台日志输出
Func _SettingWindow_TabCommon_ConsoleCombo()
    Local $selected = GUICtrlRead(@GUI_CTRLID)
    SaveScriptSetting($CGGP_COMMON, $CG_COMMON_CONSOLE, $selected)
    Logger_SetConsoleEnable($selected)
EndFunc ;==>_SettingWindow_TabCommon_ConsoleCombo

; 事件处理: 副本选择
Func _SettingWindow_TabReword_Gundeon()
    Local $checkRes = DataUtils_CheckboxBool(GUICtrlRead(@GUI_CTRLID))
    SaveScriptSetting($CGGP_REWORD, $sw_gundeonCtrlMap[@GUI_CTRLID], $checkRes)
EndFunc