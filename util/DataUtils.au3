#cs 
    @filename:    DataUtils.au3
    @description: 数据转换工具
#ce

#include-once
#include "../Logger.au3"

; 转换为布尔值
Func DataUtils_ToBool($val)
    If IsBool($val) Then
        Return $val
    ElseIf IsNumber($val) Then
        Return $val <> 0
    ElseIf IsString($val) Then
        Return $val = "1" OR $val = "True" OR $val = "true"
    Else
        Return False
    EndIf
EndFunc ;==>DataUtils_ToBool

; 转换为布尔字符串
Func DataUtils_ToBoolString($val)
    If DataUtils_ToBool($val) Then
        Return "True"
    EndIf
    Return "False"
EndFunc ;==>DataUtils_ToBoolString

; 转换为数字
Func DataUtils_ToNumber($val)
    If IsNumber($val) Then
        Return $val
    ElseIf IsBool($val) Then
        Return $val ? 1 : 0
    ElseIf IsString($val) Then
        Return Number($val)
    Else
        LogError("DataUtils_ToNumber: " & $val)
        Return Null
    EndIf
EndFunc ;==>DataUtils_ToNumber

; 选择框值转换为布尔值
Func DataUtils_CheckboxBool($val)
    Return $val = 1
EndFunc ;==>DataUtils_CheckboxDataUtils_CheckboxBool

; 选择框值转换为状态值
Func DataUtils_CheckboxState($val)
    Return DataUtils_ToBool($val) ? 1 : 4
EndFunc ;==>DataUtils_CheckboxState