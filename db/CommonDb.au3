#include-once
#include <SQLite.au3>
#include <MsgBoxConstants.au3>
#include "../Logger.au3"

; 数据库文件名
Local $dbName = "script.db"

; 数据库连接句柄
Local $scriptDb = Null

; 是否初始化
Local $db_initialized = False

; 初始化脚本数据库
Func InitializeDb()
    If Not $db_initialized Then
        LogDebug("Start SQLite")
        _SQLite_Startup()
        If @error Then
            MsgBox($MB_SYSTEMMODAL, "SQLite Start", "SQLite3.dll Can't be Loaded!")
            Exit -1
        EndIf
        OpenScriptDb()
        $db_initialized = True
    Else
        OpenScriptDb()
    EndIf
EndFunc ;==> InitializeDb

; 关闭脚本数据库
Func DestoryDb()
    If $db_initialized Then
        CloseScriptDb()
        LogDebug("Shutdown SQLite")
        _SQLite_Shutdown()
        $db_initialized = False
    EndIf
EndFunc ;==>DestoryDb

; 打开script.db数据库
Func OpenScriptDb()
    If $scriptDb = Null Then
        Local $msg = ["Open ", $dbName]
        LogDebug($msg)
        $scriptDb = _SQLite_Open($dbName)
        If @error Then
            MsgBox($MB_SYSTEMMODAL, "SQLite Open", "Open " & $dbName & " failed: " & @error)
            Exit -1
        EndIf
    EndIf
EndFunc ;==>OpenScriptDb

; 关闭script.db数据库
Func CloseScriptDb()
    If $scriptDb <> Null Then
        Local $msg[] = ["Close " , $dbName]
        LogDebug($msg)
        _SQLite_Close($scriptDb)
        $scriptDb = Null
    EndIf
EndFunc ;==>CloseScriptDb