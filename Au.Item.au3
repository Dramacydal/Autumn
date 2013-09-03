Func ITEM_GetIlvl() ;Updated
	;VARPTR(D2CLIENT, SelectedInvItem, UnitAny*, 0x11BC38)
	;SelectedInvItem -> unitany -> Itemdata -> Ilvl
	;D2CLIENT_Offset + 0x11BC38 -> () -> 0x14 -> 2c
	Local $v_Buffer = DllStructCreate("dword")
	readProcessMemory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_SelItem, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr1 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr1 + 0x14, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr2 = DllStructGetData($v_Buffer,1)
	readProcessMemory($Diablo_MemHandle, $ptr2 + 0x2C, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	Return DllStructGetData($v_Buffer,1)
Endfunc

Func ITEM_GetQuality() ;updated
	Local $v_Buffer = DllStructCreate("dword")
	readProcessMemory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_SelItem, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr1 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr1 + 0x14, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr2 = DllStructGetData($v_Buffer,1)
	readProcessMemory($Diablo_MemHandle, $ptr2, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	Return DllStructGetData($v_Buffer,1)
Endfunc

Func _GetPtr_SelItem() ;Updated
	Local $v_Buffer = DllStructCreate("dword")
	readProcessMemory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_SelItem, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr1 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr1 + 0x14, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	Return DllStructGetData($v_Buffer,1)
EndFunc

Func DelCCode(Const ByRef $szString)
	If StringInStr($szString,"ÿc") > 0 Then
		local $sz_Split
		$sz_Split = StringSplit($szString,"ÿc",1)
		Local $nMsg
		For $i = 1 to $sz_Split[0]
			$nMsg &= StringTrimLeft($sz_split[$i],1)
		Next
		Return $nMsg
	Else
		Return $szString
	EndIf
EndFUnc

Func getText($bItems = False)
	If $bItems Then
		If ITEM_GetIlvl() = 0 Then Return -1 ;; we are not looking at a item, return
		Local $szMsg,$aMsg,$rMsg
		$szMsg = _MemoryReadWideString($D2WIN_Offset + $p_ItemText,"wchar[700]")
		While StringLen($szMsg) < 5
			$szMsg = _MemoryReadWideString($D2WIN_Offset + $p_ItemText,"wchar[700]")
			Sleep(10)
		WEnd
	Else
		Local $szMsg,$aMsg,$rMsg
		$szMsg = _MemoryReadWideString($D2WIN_Offset + $p_ItemText,"wchar[700]")
		For $i = 0 to 5
			$szMsg = _MemoryReadWideString($D2WIN_Offset + $p_ItemText,"wchar[700]")
			Sleep(10)
			If StringLen($szMsg) < 4 Then ExitLoop
		Next
	EndIf
	#cs
	Stupid d2 reverses the message.
	We have to split text into an array by each line break,
	reverse it, and concencate a new text var.
	#ce
	$aMsg = StringSplit($szMsg,@CRLF,2)
	If NOT IsArray($aMsg) Then Return $szMsg
	_ArrayReverse($aMsg)
	For $i = 0 To UBound($aMsg)-1
		$rMsg &= $aMsg[$i] & @CR
	Next
	Return $rMsg
EndFunc