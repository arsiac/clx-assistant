#include-once
#include <ComboConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <FontConstants.au3>
#include "util/DataUtils.au3"

AutoItSetOption("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)
DllCall("User32.dll", "bool", "SetProcessDPIAware")

; Game
Global Const $GAME_NAME = "一梦江湖"

; Window
Global Const $WINDOW_MAIN_WIDTH = 600
Global Const $WINDOW_MAIN_HEIGHT = 355
Global Const $WINDOW_SET_WIDTH = 500
Global Const $WINDOW_SET_HEIGHT = 300

; Control
Global Const $CTRL_LABEL_WIDTH = 60
Global Const $CTRL_LABEL_W_WIDTH = 80
Global Const $CTRL_COMBO_WIDTH = 80
Global Const $CTRL_CHECKBOX_WIDTH = 90
Global Const $CTRL_CHECKBOX_HEIGHT = 25
Global Const $CTRL_COMMON_HEIGHT = 28

; Button
Global Const $BUTTON_COMMON_WIDTH = 80
Global Const $BUTTON_COMMON_HEIGHT = $CTRL_COMMON_HEIGHT

Global Const $FONT_COMMON_SIZE = 12
Global Const $FONT_LOG_SIZE = 9

; Configuration
Global Const $CGGP_COMMON = "common"
Global Const $CG_COMMON_LOGLEVEL = "logger.level"
Global Const $CG_COMMON_CONSOLE = "logger.console.enable"

Global Const $CGGP_REWORD = "reword"
