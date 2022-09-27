#include-once
#include <GuiListBox.au3>
#include "util/DataUtils.au3"

Global Const $LOGLEVEL_TRACE = 0
Global Const $LOGLEVEL_DEBUG = 1
Global Const $LOGLEVEL_INFO = 2
Global Const $LOGLEVEL_WARNING = 3
Global Const $LOGLEVEL_ERROR = 4

Local $logger_LogLevelNameArray[] = ["Trace", "Debug", "Info", "Warn", "Error"]

; 启用控制台输出
Local $logger_consoleEnable = False

; 日志级别
Local $logger_level = $LOGLEVEL_INFO

; 默认日志级别
Local $logger_defaultLevel = $LOGLEVEL_INFO
Local $logger_ctrlView = Null
Local $logger_ctrlMaxSize = 1
Local $logger_msgIndex = 0

; 获取所有日志级别名称
Func Logger_GetLogLevelNames()
    Return $logger_LogLevelNameArray
EndFunc ;==>Logger_GetLogLevelNames

; 获取 $l 对应的日志级别
Func GetLogLevelValue($l)
    Switch ($l)
        Case "Trace"
            Return $LOGLEVEL_TRACE
        Case "Debug"
            Return $LOGLEVEL_DEBUG
        Case "Info"
            Return $LOGLEVEL_INFO
        Case "Warn"
            Return $LOGLEVEL_WARNING
        Case "Error"
            Return $LOGLEVEL_ERROR
    EndSwitch

    Return $logger_defaultLevel
EndFunc ;==>GetLogLevelValue

; 获取日志级别 $l 对应的名称
Func GetLogLevelName($l = Null)
    If $l <> Null Then
        Return $logger_LogLevelNameArray[$l]
    Else
        Return $logger_LogLevelNameArray[$logger_defaultLevel]
    EndIf
EndFunc ;==>GetLogLevelName

; 设置日志级别
Func SetLogLevel($l)
    If $l = Null Then
        $l = $logger_defaultLevel
    EndIf
    
    $logger_level = $l
    LogDebug("Set log level to '" & GetLogLevelName($logger_level) & "'")
EndFunc ;==>SetLogLevel

; 通过名称设置日志级别
Func SetLogLevelByName($name)
    SetLogLevel(GetLogLevelValue($name))
EndFunc ;==>SetLogLevelByName

; 设置日志输出控件
Func Logger_SetLogCtrl($list, $size = 1)
    $logger_ctrlView = $list
    $logger_ctrlMaxSize = $size
EndFunc ;==>Logger_SetLogCtrl

; 设置控制台输出
Func Logger_SetConsoleEnable($enable)
    $logger_consoleEnable = DataUtils_ToBool($enable)
EndFunc ;==>Logger_SetConsoleEnable

Func LogTrace($msg)
    If $LOGLEVEL_TRACE >= $logger_level Then
        _Logger_Output("[Trace] " & _Logger_ResolveMsg($msg))
    EndIf
EndFunc

Func LogDebug($msg)
    If $LOGLEVEL_DEBUG >= $logger_level Then
        _Logger_Output("[Debug] " & _Logger_ResolveMsg($msg))
    EndIf
EndFunc

Func LogInfo($msg)
    If $LOGLEVEL_INFO >= $logger_level Then
        _Logger_Output("[Info ] " & _Logger_ResolveMsg($msg))
    EndIf
EndFunc

Func LogWarn($msg)
    If $LOGLEVEL_WARNING >= $logger_level Then
        _Logger_Output("[Warn ] " & _Logger_ResolveMsg($msg))
    EndIf
EndFunc

Func LogError($msg)
    If $LOGLEVEL_ERROR >= $logger_level Then
        _Logger_Output("[ERROR] " & _Logger_ResolveMsg($msg), True)
    EndIf
EndFunc

; 日志输出
; @param $msg     日志内容
; @param $isError 是否Error级别日志
Func _Logger_Output($msg, $isError = False)
    If $logger_consoleEnable Then
        If $isError Then
            ConsoleWriteError($msg & @LF)
        Else
            ConsoleWrite($msg & @LF)
        EndIf
    EndIf

    If ($logger_ctrlView <> Null) Then
        If $logger_msgIndex >= $logger_ctrlMaxSize Then
            _GUICtrlListBox_DeleteString($logger_ctrlView, 0)
        EndIf
        _GUICtrlListBox_InsertString($logger_ctrlView, $msg)
        
        If $logger_msgIndex > $logger_ctrlMaxSize - 1 Then
            _GUICtrlListBox_SetTopIndex($logger_ctrlView, $logger_ctrlMaxSize - 1)
        Else
            _GUICtrlListBox_SetTopIndex($logger_ctrlView, $logger_msgIndex)
            $logger_msgIndex = $logger_msgIndex + 1
        EndIf
    EndIf
EndFunc ;==?_Logger_Output

; 获取消息
Func _Logger_ResolveMsg($msg)
    If IsString($msg) Then
        Return $msg
    ElseIf IsArray($msg) Then
        Local $res = ""
        For $item In $msg
            $res = $res & $item
        Next
        Return $res
    Else
        Return String($msg)
    EndIf
EndFunc ;==> _Logger_ResolveMsg
