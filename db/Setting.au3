#cs 
    @filename:    Setting.au3
    @description: 脚本设置数据管理
#ce

#include-once
#include "CommonDB.au3"

; 插入脚本设置
Func InsertScriptSetting($m, $k, $v)
    Local $debugMsg[] = ["AddSetting(", $m, ", ", $k, ", ", $v, ")"]
    LogTrace($debugMsg)
    _SQLite_Exec($scriptDb, "INSERT INTO SCRIPT_SET (MODULE, KEY, VALUE) VALUES ('" & $m & "', '" & $k & "', '" & $v & "')")
EndFunc

; 更新脚本设置
Func UpdateScriptSetting($m, $k, $v)
    Local $debugMsg[] = ["UpdateSetting(", $m, ", ", $k, ", ", $v, ")"]
    LogTrace($debugMsg)
    _SQLite_Exec($scriptDb, "UPDATE SCRIPT_SET SET VALUE = '" & $v & "' WHERE MODULE = '" & $m & "' AND KEY = '" & $k & "';")
EndFunc ;==>UpdateScriptSetting

; 查询脚本设置
Func QueryScriptSettingValue($m, $k, $d = Null)
    Local $row
    _SQLite_QuerySingleRow($scriptDb, "SELECT VALUE FROM SCRIPT_SET WHERE MODULE = '" & $m & "' AND KEY = '" & $k & "';", $row)

    Local $debugMsg[] = ["QuerySetting(", $m, ", ", $k, ") ==> ", $row[0]]
    LogTrace($debugMsg)

    If $row[0] = Null OR $row[0] = "" Then
        Return $d
    EndIf

    Return $row[0]
EndFunc ;==>QueryScriptSettingValue

; 设置是否存在
Func QueryScriptSettingExist($m, $k)
    Local $row
    _SQLite_QuerySingleRow($scriptDb, "SELECT 1 FROM SCRIPT_SET WHERE MODULE = '" & $m & "' AND KEY = '" & $k & "';", $row)
    
    Local $debugMsg[] = ["ExistSetting(", $m, ", ", $k, ") ==> ", $row[0]]
    LogTrace($debugMsg)
    Return $row[0] = 1
EndFunc ;==>QueryScriptSettingExist

; 保存脚本设置(插入/更新)
Func SaveScriptSetting($m, $k, $v)
    If QueryScriptSettingExist($m, $k) Then
        UpdateScriptSetting($m, $k, $v)
    Else
        InsertScriptSetting($m, $k, $v)
    EndIf
EndFunc ;==> SaveScriptSetting