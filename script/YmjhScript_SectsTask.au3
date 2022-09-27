#cs 
    @filename:    YmjhScript_SectsTask.au3
    @description: 门派任务
#ce

#include-once
#include "ScriptManager.au3"

Common_ScriptRegister("门派任务", "SectsTask_Start", "SectsTask_Stop")

; 开始执行脚本
Func SectsTask_Start()
    LogInfo("Start Script: SectsTask")
EndFunc ;==>SectsTask_Start

; 停止脚本
Func SectsTask_Stop()
    LogInfo("Stop Script: SectsTask")
EndFunc ;==>SectsTask_Stop