#include-once
Func _Send($Handle, $keys)
   Return ControlSend($Handle, "", "", $keys)
EndFunc   ;==>_SendMinimized

Func _MouseMove($hWnd,$x,$y)
	Return _SendMessage($hWnd,0x0200,0,_WinApi_MakeLong($x,$y))
EndFunc

Func _MouseClick($hWnd,$button,$x,$y)
	Select
		Case $Button = "right"
			 $Button = 0x0002
			 $ButtonDown = 0x0204
			 $ButtonUp = 0x0205
		Case $Button = "left"
			 $Button = 0x0001
			 $ButtonDown = 0x0201
			 $ButtonUp = 0x0202
		Case Else
			Return
   EndSelect
	_SendMessage($hWnd,0x0200,0,_WinApi_MakeLong($x,$y))
	_SendMessage($hWnd,$ButtonDown,$Button,_WinApi_MakeLong($x,$y))
	_SendMessage($hWnd,$ButtonUp,$Button,_WinApi_MakeLong($x,$y))
	Return True
EndFunc

;; This clicks a specefic ingame-coordinate. Similar to the original, however this will cap at windowsize.
Func clickMap($hWnd,$x,$y,$button = "left")
	Local $ME_Coords = CHAR_GetCoords($MEM_Handle)
	Local $clickCoords = Conv_CoordToPixel($ME_Coords,$x,$y)
	Return _MouseClick($hWnd,$button,$clickCoords[0],$clickCoords[1])
EndFunc