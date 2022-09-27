#cs 
    游戏工具
#ce

Global Const $GAME_WINDOW_WIDTH = 1200
Global Const $GAME_WINDOW_HEIGHT = 700

; 重置窗口为通用大小
Func GameUtils_ToCommonSize($winHandler)
    WinMove($winHandler, "", 0, 0, $GAME_WINDOW_WIDTH, $GAME_WINDOW_HEIGHT)
EndFunc ;==>GameUtils_ToCommonSize
