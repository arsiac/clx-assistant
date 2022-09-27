#cs 
    @filename:    UserTask.au3
    @description: 用户自定义任务数据管理
#ce

#include-once
#include "CommonDB.au3"

; 新增任务
Func InsertUserTask($name, $desc)
    Local $debugMsg[] = ["AddTask(", $name, ", ", $desc, ")"]
    LogTrace($debugMsg)
    _SQLite_Exec($scriptDb, "INSERT INTO USER_TASK (NAME, DESC) VALUES('" & $name & "', '" & $desc & "');")
EndFunc ;==>InsertTask

; 新增任务明细
Func InsertUserTaskItem($pid, $name)
    Local $debugMsg[] = ["AddTaskItem(", $pid, ", ", $name, ")"]
    LogTrace($debugMsg)
    _SQLite_Exec($scriptDb, "INSERT INTO USER_TASK_ITEM (PID, SCRIPT_NAME) VALUES(" & $pid & ", '" & $name & "');")
EndFunc ;==>InsertUserTaskItem

; 根据ID删除任务
Func DeleteUserTaskById($id)
    Local $debugMsg[] = ["DeleteTask(", $id, ")"]
    LogTrace($debugMsg)
    _SQLite_Exec($scriptDb, "DELETE FROM USER_TASK WHERE ID = " & $id & ";")
EndFunc ;==>DeleteUserTaskById

; 删除任务明细
Func DeleteUserTaskItemByPid($pid)
    _SQLite_Exec($scriptDb, "DELETE FROM USER_TASK_ITEM WHERE PID = " & $pid & ";")
EndFunc ;==>DeleteUserTaskItemByPid

; 删除任务明细
Func DeleteUserTaskItemById($id)
    _SQLite_Exec($scriptDb, "DELETE FROM USER_TASK_ITEM WHERE ID = " & $id & ";")
EndFunc ;==>DeleteUserTaskItemById

; 更新任务
Func UpdateUserTask($id, $name, $desc)
    Local $debugMsg[] = ["UpdateTask(", $name, ", ", $desc,", ", $id, ")"]
    LogTrace($debugMsg)
    _SQLite_Exec($scriptDb, "UPDATE USER_TASK SET NAME='" & $name & "', DESC='" & $desc & "' WHERE ID=" & $id & ";")
EndFunc ;==>UpdateUserTask

; 任务是否存在
Func SelectUserTaskExistByName($name)
    Local $row
    _SQLite_QuerySingleRow($scriptDb, "SELECT 1 FROM USER_TASK WHERE NAME = '" & $name & "';", $row)
    Local $debugMsg[] = ["ExistTask(", $name, ") ==> ", $row[0]]
    LogTrace($debugMsg)
    Return $row[0] == 1
EndFunc ;==>SelectUserTaskExistByName
