;Functions with relation too your own char.
;##################################################
;~ Function CHAR_GetCharCoords()
;~ Returns an array where
;~ [0] = x-coord
;~ [1] = y-coord
;##################################################
Func CHAR_GetCoords() ;Updated
	Dim $Temp[2]
	Local $Read = 0
	Local $v_Buffer = DllStructCreate("dword")
	Local $v_Buffer2 = DllStructCreate("short;short;short")
	readProcessMemory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_PlayerUnit, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr1 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr1 + 0x2c, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr2 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr2 + 0x2, DllStructGetPtr($v_Buffer2), DllStructGetSize($v_Buffer2),$__DLL_Kernel32)
	$Temp[0] = DllStructGetData($v_Buffer2, 1)
	;readProcessMemory($Diablo_MemHandle, $ptr2 + 0x6, DllStructGetPtr($v_Buffer2), DllStructGetSize($v_Buffer2),$__DLL_Kernel32)
	$Temp[1] = DllStructGetData($v_Buffer2, 3)
	Return $Temp
EndFunc   ;==>CHAR_GetCoords

;##################################################
;~ Function CHAR_GetPathedCoords()
;~ Returns an array where
;~ [0] = x-coord
;~ [1] = y-coord
;##################################################
Func CHAR_GetPathedCoords() ;Lazy
	Return CHAR_GetCoords()
EndFunc   ;==>CHAR_GetPathedCoords

;##################################################
;~ Function CHAR_GetCurrentHp($Pid)
;~ Returns your current hp. Sometimes a bit slow to initialize upon gamejoin?
;##################################################
Func CHAR_GetCurrentHp() ;Updated
	Local $Temp
	$Temp = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_CurrentHp, "ushort",False,$__DLL_Kernel32)
	Return $Temp
EndFunc   ;==>CHAR_GetCurrentHp
;##################################################
;~ Function GAME_GetRealm
;~ Returns your realm
;##################################################
Func CHAR_GetRealm() ;updated
	Local $Temp, $ptr
	$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_GameInfo,"dword",False,$__DLL_Kernel32)
	$Temp = _ReadD2Memory($Diablo_MemHandle, $ptr + 0xD1, "char[18]",False,$__DLL_Kernel32)
	Return $Temp
EndFunc   ;==>CHAR_GetRealm

;##################################################
;~ Function GAME_GetAccount
;~ Returns your account
;##################################################
Func CHAR_GetAccount()  ;updated
	Local $Temp, $ptr
	$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_GameInfo,"dword",False,$__DLL_Kernel32)
	$Temp = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x89, "char[18]",False,$__DLL_Kernel32)
	Return $Temp
EndFunc   ;==>CHAR_GetAccount

;##################################################
;~ Function CHAR_GetName
;~ Returns your Characters name
;##################################################
Func CHAR_GetName() ;updated
	Local $Temp, $ptr
	$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_GameInfo,"dword",False,$__DLL_Kernel32)
	$Temp = _ReadD2Memory($Diablo_MemHandle, $ptr + 0xB9, "char[30]",False,$__DLL_Kernel32)
	Return $Temp
EndFunc   ;==>CHAR_GetName