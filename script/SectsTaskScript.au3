#cs 
    @filename:    SectsTaskScript.au3
    @description: 门派任务脚本
#ce

#include-once
#include "ScriptManager.au3"

Common_ScriptRegister("门派任务", "SectsTask_Start")

; 开始执行脚本
Func SectsTask_Start()
    LogInfo("Start Script: SectsTask")
EndFunc ;==>SectsTask_Start