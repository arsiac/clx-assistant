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

; 新增任务明细
Func InsertUserTaskItem2($task, $name)
    Local $debugMsg[] = ["AddTaskItem(", $task, ", ", $name, ")"]
    LogTrace($debugMsg)
    Local $pid = SelectUserTaskIdByName($task)
    _SQLite_Exec($scriptDb, "INSERT INTO USER_TASK_ITEM (PID, SCRIPT_NAME) VALUES (" & $pid & ", '" & $name & "');")
EndFunc ;==>InsertUserTaskItem

; 根据ID删除任务
Func DeleteUserTaskById($id)
    Local $debugMsg[] = ["DeleteTask(", $id, ")"]
    LogTrace($debugMsg)
    _SQLite_Exec($scriptDb, "DELETE FROM USER_TASK WHERE ID = " & $id & ";")
EndFunc ;==>DeleteUserTaskById

; 删除任务明细
Func DeleteUserTaskItem($task, $item)
    Local $pid = SelectUserTaskIdByName($task)
    Local $sql = "DELETE FROM USER_TASK_ITEM WHERE PID = " & $pid & " AND SCRIPT_NAME = '" & $item & "';"
    _SQLite_Exec($scriptDb, $sql)
    Local $debugMsg[] = ["DeleteTaskItem(", $task,"(", $pid, ")", ", ", $item, ")"]
    LogTrace($debugMsg)
EndFunc ;==>DeleteUserTaskItem

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

; 任务明细是否存在
Func SelectUserTaskItemExistByName($task, $item)
    Local $row
    _SQLite_QuerySingleRow($scriptDb, "SELECT 1 FROM USER_TASK t LEFT JOIN USER_TASK_ITEM i ON t.ID = i.PID WHERE t.NAME = '" & $task & "' AND i.SCRIPT_NAME = '" & $item & "';", $row)
    Local $debugMsg[] = ["ExistTaskItem(", $task, ", ", $item, ") ==> ", $row[0]]
    LogTrace($debugMsg)
    Return $row[0] == 1
EndFunc ;==>SelectUserTaskItemExistByName

; 查询所有用户任务
Func SelectAllUserTasks()
    Local $result[0], $index = 0, $query, $row
    _SQLite_Query($scriptDb, "SELECT NAME FROM USER_TASK ORDER BY ID;", $query)
    
    While _SQLite_FetchData($query, $row) = $SQLITE_OK
        Redim $result[$index + 1]
        $result[$index] = $row[0]
        $index += 1
    WEnd

    LogTrace("SelectAllTasks")
    Return $result
EndFunc ;==>SelectAllUserTasks

; 查询任务ID
Func SelectUserTaskIdByName($name)
    Local $row
    _SQLite_QuerySingleRow($scriptDb, "SELECT ID FROM USER_TASK WHERE NAME = '" & $name & "';", $row)
    Local $debugMsg[] = ["SelectTaskId(", $name, ") ==> ", $row[0]]
    LogTrace($debugMsg)
    Return $row[0]
EndFunc ;==>SelectUserTaskIdByname

; 查询任务明细
Func SelectUserTaskItemByName($task)
    Local $result[0], $index = 0, $query, $row
    Local $sql = "SELECT i.SCRIPT_NAME FROM USER_TASK t LEFT JOIN USER_TASK_ITEM i ON t.ID = i.PID WHERE t.NAME = '" & $task & "' ORDER BY i.ID"
    _SQLite_Query($scriptDb, $sql, $query)
    
    While _SQLite_FetchData($query, $row) = $SQLITE_OK
        Redim $result[$index + 1]
        $result[$index] = $row[0]
        $index += 1
    WEnd

    Local $debugMsg[] = ["SelectTaskItem(", $task, ")"]
    LogTrace($debugMsg)
    Return $result
EndFunc ;==>SelectUserTaskItemByName
