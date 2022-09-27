#cs 
    通用脚本
#ce
#include-once
;~ #RequireAdmin
#include <Array.au3>
#include "../Logger.au3"
#include "../util/PageUtils.au3"
#include "../Generic.au3"

; 脚本信息
Local Const $sm_arrayRaise = 10
Local $sm_arraySize = 10
Local $sm_arrayIndex = 0
Local $sm_scriptNameArray[$sm_arraySize] = []
Local $sm_scriptFuncArray[$sm_arraySize] = []

; 注册脚本
Func Common_ScriptRegister($name, $func)
    Local $size = UBound($sm_scriptNameArray)
    If $sm_arrayIndex = $sm_arraySize - 1 Then
        Redim $sm_scriptNameArray[$sm_arraySize + $sm_arrayRaise]
        Redim $sm_scriptFuncArray[$sm_arraySize + $sm_arrayRaise]
    EndIf

    $sm_scriptNameArray[$sm_arrayIndex] = $name
    $sm_scriptFuncArray[$sm_arrayIndex] = $func
    $sm_arrayIndex = $sm_arrayIndex + 1
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