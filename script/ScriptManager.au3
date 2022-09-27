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
Local $sm_scriptFuncArray[0] = []

; 注册脚本
Func Common_ScriptRegister($name, $func)
    LogTest("Script reg: " & $name & ", " & $func)
    Local $size = UBound($sm_scriptNameArray)
    Redim $sm_scriptNameArray[$size + 1]
    Redim $sm_scriptFuncArray[$size + 1]

    $sm_scriptNameArray[$size] = $name
    $sm_scriptFuncArray[$size] = $func
    Local $debugMsg[] = ["Script register: ", $name, ", ", $func]
    LogTest($debugMsg)
EndFunc ;==>Common_ScriptRegister

; 获取所有脚本名称
Func Common_GetAllScriptNames()
    Return $sm_scriptNameArray
EndFunc ;==>Common_GetAllScriptNames

; 根据脚本名称获取执行方法
Func Common_GetScriptFunc($name)
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
        Return $sm_scriptFuncArray[$foundIndex]
    EndIf
EndFunc ;===>Common_GetScriptFunc