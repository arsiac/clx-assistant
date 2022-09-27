#cs 
    @filename:    PageUtils.au3
    @description: 游戏页面工具
#ce

#include-once
#include "../Logger.au3"

; 是否是某个页面
Func PageUtils_IsPage($page)
    Return True
EndFunc ;==>PageUtils_IsPage

; 回到首页
Func PageUtils_GoMainPage($currentPage)
    LogInfo("回到首页")
EndFunc ;==>PageUtils_GoMainPage