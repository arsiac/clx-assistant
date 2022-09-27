#cs 
    @filename:    ScriptManager.au3
    @description: 脚本管理
#ce

#include-once
;~ #RequireAdmin
#include <Array.au3>
#include "../Logger.au3"
#include "../util/PageUtils.au3"
#include "../Generic.au3"

; 脚本信息
Local Const $sm_arrayRaise = 10
Local $sm_scriptNameArray[0] = []
Local $sm_scriptStartFuncArray[0] = []
Local $sm_scriptStopFuncArray[0] = []

; 注册脚本
Func Common_ScriptRegister($name, $startFunc, $stopFunc)
    Local $size = UBound($sm_scriptNameArray)
    Redim $sm_scriptNameArray[$size + 1]
    Redim $sm_scriptStartFuncArray[$size + 1]
    Redim $sm_scriptStopFuncArray[$size + 1]

    $sm_scriptNameArray[$size] = $name
    $sm_scriptStartFuncArray[$size] = $startFunc
    $sm_scriptStopFuncArray[$size] = $stopFunc
EndFunc ;==>Common_ScriptRegister

; 获取所有脚本名称
Func Common_GetAllScriptNames()
    Return $sm_scriptNameArray
EndFunc ;==>Common_GetAllScriptNames

; 根据脚本名称获取执行方法
Func Common_GetStartScriptFunc($name)
    Local $foundIndex = -1
    For $i = 0 To UBound($sm_scriptNameArray) - 1
        If $sm_scriptNameArray[$i] = $name Then
            $foundIndex = $i
            ExitLoop
        EndIf
    Next

    If $foundIndex = -1 Then
        Return Null
    Else
        Return $sm_scriptStartFuncArray[$foundIndex]
    EndIf
EndFunc ;===>Common_GetStartScriptFunc

; 根据脚本名称获取执行方法
Func Common_GetStopScriptFunc($name)
    Local $foundIndex = -1
    For $i = 0 To UBound($sm_scriptNameArray) - 1
        If $sm_scriptNameArray[$i] = $name Then
            $foundIndex = $i
            ExitLoop
        EndIf
    Next

    If $foundIndex = -1 Then
        Return Null
    Else
        Return $sm_scriptStopFuncArray[$foundIndex]
    EndIf
EndFunc ;===>Common_GetScriptFunc