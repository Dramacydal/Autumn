Global $pRef_Stat = 7
Global $nStatic = False

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetStatValue
; Description ...: Reads the current value of the stat requested
; Syntax.........: _DiaAPI_GetStatValue($iStat[,$iVector = 0[,$iStatlist = 0[,$ptr = -1]]])
; Parameters ....: $iStat - The Stat To Be Read (for full list see ItemStatCost.txt, around 300 possible entries)
;                  |strength	0
;                  |energy		1
;                  |dexterity	2
;                  |vitality	3
;                  |statpts		4
;                  |newskills	5
;                  |hitpoints	6
;                  |maxhp		7
;                  |mana		8
;                  |maxmana		9
;                  |stamina		10
;                  |maxstamina	11 // bugged, but who cares
;                  |level		12
;                  |experience	13
;                  |gold		14
;                  |goldbank	15
;                  $iVector - Ranging from 0 to 2, determines which vector of the statlist to read from
;                  |base		0
;                  |accrued		1 (corrosponding to "total")
;                  |modified	2
;                  $iStatlist - (Optional) Ranging from 0 to amount of statlists in diablo, determines which statlist to read from
;                  $ptr - (Optional) A pointer to the UnitAny structure of the unit. Default is the playerunit.
; Return values .: On Success - Returns the value of the specified stat.
;                  On Failure - Returns 0 if failure, -1 if stat doesn't exist
; Author ........: Murder567, Shaggi - function has been rewritten from scratch. Now loops coorectly through the statlists, and always returns correct stat.
; Modified.......: Polite, Shaggi
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetStatValue($iStat,$iVector = 0,$iStatlist = 0,$ptr = -1)
	Local $ret, $statcount, $ptr_stats, $statindex, $Startcount = 0

	If $ptr = -1 Then
		$ptr = _ReadD2Memory($Diablo_MemHandle, 0x5c + _
			_ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_PlayerUnit,"dword",False,$__DLL_Kernel32),"dword",False,$__DLL_Kernel32)
		EndIf
	For $i = 1 to $iStatlist
		$ptr = _ReadD2Memory($Diablo_MemHandle,$ptr + 0x3c,"dword",False,$__DLL_Kernel32)
	Next
	Switch $iVector
		Case 0
			$ptr_Stats = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x24,"dword",False,$__DLL_Kernel32)
			$statcount = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x28,"word",False,$__DLL_Kernel32)
		Case 1
			$ptr_Stats = _ReadD2Memory($Diablo_MemHandle,$ptr + 0x48,"dword",False,$__DLL_Kernel32)
			$statcount = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x4c,"word",False,$__DLL_Kernel32)
		Case 2
			$ptr_Stats = _ReadD2Memory($Diablo_MemHandle,$ptr + 0x50,"dword",False,$__DLL_Kernel32)
	EndSwitch
	If $iStat == $pRef_Stat Then
		;If $nStatic Then $StartCount = $nStatic
	ElseIf $istat > 3 Then
		$startcount = 5
	Else
		$Startcount = 0
	EndIf
	Local $szStruct = "word wSubIndex;word wStatIndex;dword dwStatValue;", $FinalStruct
	For $i = 0 to $iStat
		$FinalStruct &= $szStruct
	Next
	Local $Statstruct = DllStructCreate($FinalStruct)
	Local $iSize = DllStructGetSize($Statstruct)
	Local $iPtr = DllStructGetPtr($StatStruct)

	readProcessMemory($Diablo_MemHandle,$ptr_stats, $iPtr,$iSize,$__DLL_Kernel32)
	For $i = $startcount to $statcount
		$statindex = DllStructGetData($StatStruct,2 + (3 * $i))
		If $statindex == $istat Then
			If $iStat == $pRef_Stat Then
				$nStatic = $i
			EndIf
			$ret = DllStructGetData($StatStruct,3 + (3 * $i))
			Switch $istat
				Case 6 to 11
					return $ret/256
				Case Else
					return $ret
			EndSwitch
		EndIf
	Next
	Return -1
EndFunc