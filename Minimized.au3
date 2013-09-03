;#################################################
;~ AutoIt Version:  3.3.6.1
;~ Author:          Insolence
;~ Credits:         -||-
;~ Modified:		Shaggi
;~ What is this? Custom made minimized udf for diablo II.
;~ Feautures: Ability to click and send keys to a minimized window.
;#################################################
#include-once
	Local $MK_LBUTTON = 0x0001
	Local $MK_RBUTTON = 0x0002
Func _MouseClickMinimized($Handle, $Button = "left", $X = "", $Y = "", $Clicks = 1)

	Local $ButtonDown, $ButtonUp
	Local $i = 0
	Select
		Case $Button = "right"
			$Button = $MK_RBUTTON
			$ButtonDown = $WM_RBUTTONDOWN
			$ButtonUp = $WM_RBUTTONUP
		Case $Button = "left"
			$Button = $MK_LBUTTON
			$ButtonDown = $WM_LBUTTONDOWN
			$ButtonUp = $WM_LBUTTONUP
		Case Else
			Exit
	EndSelect
	If $X = "" Or $Y = "" Then
		Exit
	EndIf
	For $i = 1 To $Clicks
		DllCall("user32.dll", "int", "SendMessage", _
				"hwnd", $Handle, _
				"int", $WM_MOUSEMOVE, _
				"int", 0, _
				"long", _MakeLong($X, $Y))
		DllCall("user32.dll", "int", "SendMessage", _
				"hwnd", $Handle, _
				"int", $ButtonDown, _
				"int", $Button, _
				"long", _MakeLong($X, $Y))
		DllCall("user32.dll", "int", "SendMessage", _
				"hwnd", $Handle, _
				"int", $ButtonUp, _
				"int", $Button, _
				"long", _MakeLong($X, $Y))
	Next
EndFunc   ;==>_MouseClickMinimized

Func _MouseMoveMinimized($Handle, $X = "", $Y = "")
	Local $WM_MOUSEMOVE = 0x0200
	Local $i = 0

	If $X = "" Or $Y = "" Then
		Exit
	EndIf

	DllCall("user32.dll", "int", "SendMessage", _
			"hwnd", $Handle, _
			"int", $WM_MOUSEMOVE, _
			"int", 0, _
			"long", _MakeLong($X, $Y))
EndFunc   ;==>_MouseMoveMinimized

Func _SendMinimized($Handle, $keys)
	ControlSend($Handle, "", "", $keys)
EndFunc   ;==>_SendMinimized

Func _MakeLong($LoWord, $HiWord)
	Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))
EndFunc   ;==>_MakeLong