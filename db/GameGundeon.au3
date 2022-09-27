#cs 
    @filename:    GameGundeon.au3
    @description: 游戏副本数据管理
#ce

#include-once
#include "CommonDB.au3"

; 查询所有副本
Func QueryAllGameGundeon()
    Local $result[0][3], $query, $row, $size = 0, $index = 0

    _SQLite_Query($scriptDb, "SELECT GUNDEON_NAME, CONFIG_KEY, SORT FROM GAME_GUNDEON ORDER BY SORT, GUNDEON_NAME", $query)
    While _SQLite_FetchData($query, $row) = $SQLITE_OK
        If $index = $size Then
            $size = $size + 1
            Redim $result[$size][3]
        EndIf
        $result[$index][0] = $row[0]
        $result[$index][1] = $row[1]
        $result[$index][2] = $row[2]
        $index = $index + 1
    WEnd
    Return $result
EndFunc ;==>QueryAllGameGundeon
