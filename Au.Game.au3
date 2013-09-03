;##################################################
;~ Function GAME_GetLastChatMsg($pid)
;~ Retrieves the last game message and deletes colorcodes from it.
;##################################################
Func GAME_GetLastChatMsg() ;Broken
	Return ""
	$Temp = GAME_GetLastMsg()
	;This part deletes color codes from the msg
	$result = StringInStr($Temp, "ÿc")
	Select
		Case $result = 0
			$LastMsg = $Temp

		Case $result > 0
			$msgarray = StringSplit($Temp, "ÿc", 1)
			$Msgarray1 = StringTrimLeft($msgarray[2], 1)
			$Msgarray2 = StringTrimLeft($msgarray[3], 1)
			$LastMsg = $Msgarray1 & $Msgarray2
	EndSelect
	Return $LastMsg
EndFunc   ;==>GAME_GetLastChatMsg

;##################################################
;~ Function GAME_GetLastMsg($Pid) (Internal)
;~ Retrieves the last game message
;##################################################
Func GAME_GetLastMsg()
	Local $ptr
	Local $ptr2
	$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + 0x113AB0, "dword",False,$__DLL_Kernel32)
	$ptr2 = _ReadD2Memory($Diablo_MemHandle, $ptr, "dword",False,$__DLL_Kernel32)
	$Temp = _MemoryReadWideString($ptr2,'wchar[396]')
	Return $Temp
EndFunc   ;==>GAME_GetLastMsg

;##################################################
;~ Function GAME_GetGameName
;~ Gets the last game name
;##################################################
Func GAME_GetGameName() ;Updated
	Local $Temp
	Local $ptr
	$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_GameInfo, "dword",False,$__DLL_Kernel32)
	$Temp = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x1B, "char[15]",False,$__DLL_Kernel32)
	Return $Temp
EndFunc   ;==>GAME_GetGameName

;##################################################
;~ Function GAME_GetGameFps()
;~ Gets the ....
;##################################################
Func GAME_GetGameFps() ;Updated
	Local $Temp
	$Temp = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + 0x11CE10, "dword",False,$__DLL_Kernel32)
	Return $Temp
EndFunc   ;==>GAME_GetGameFps

;##################################################
;~ Function GAME_GetGamePing()
;~ Gets the Game ping
;##################################################
Func GAME_GetGamePing() ; Updated
	Local $Temp
	$Temp = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + 0x108764, "dword",False,$__DLL_Kernel32)
	Return $Temp
EndFunc   ;==>GAME_GetGamePing

;##################################################
;~ Function GAME_DetectIngame
;~ Returns true if ingame
;##################################################
Func GAME_DetectIngame() ;Updated
	If _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_PlayerUnit, "dword",False,$__DLL_Kernel32) > 0 Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>GAME_DetectIngame

;##################################################
;~ Function GAME_GetGamePass($Pid)
;~ Returns the password of the last game you joined
;##################################################
Func GAME_GetGamePass() ;Updated
	Local $Temp, $ptr
	$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_GameInfo,"dword",False,$__DLL_Kernel32)
	$Temp = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x241, "char[18]",False,$__DLL_Kernel32)
	Return $Temp
EndFunc   ;==>GAME_GetGamePass

;##################################################
;~ Function GAME_GetServerIp($pid)
;~ Returns the serverip of the current game.
;##################################################
Func GAME_GetServerIp() ;Updated
	Local $Temp
	Local $ptr
	$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_GameInfo, "dword",False,$__DLL_Kernel32)
	$Temp = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x33, "char[18]",False,$__DLL_Kernel32)
	Return $Temp
EndFunc   ;==>GAME_GetServerIp