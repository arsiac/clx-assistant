#cs 
    @filename:    YmjhScript_Reword.au3
    @description: 悬赏任务
#ce

#include-once
#include "ScriptManager.au3"

Common_ScriptRegister("悬赏任务", "Reword_Start", "Reword_Stop")

; 开始执行脚本
Func Reword_Start()
    LogInfo("Start Script: Reword")
EndFunc ;==>Reword_Start

; 停止脚本
Func Reword_Stop()
    LogInfo("Stop Script: Reword")
EndFunc ;==>Reword_Stop