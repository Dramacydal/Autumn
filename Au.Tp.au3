; Defines the routines for chickening to town.

#AutoIt3Wrapper_UseX64=n
#include <Processcall.au3>
Global Const $pRoom1 = 0x1C
Global Const $pRoom2First = 0x10
Global Const $MAX_MSG = 0x100
Global Const $ProgramName = "0x0000000000000000000000000000000000000000000000000000000000000"
Global Const $pLevel = 0x58
Global Const $pPath = 0x2C

Global Const $pRRoom1 = 0x30
Global Const $pRoom2 = 0x10
Global Const $pUnitFirst = 0x74
Global Const $pRoomNext = 0xE4
Global Const $pRoom2Next = 0x24
Global Const $PlayerUnit = $D2CLIENT_OFFSET + $p_PlayerUnit
#cs
Global Const $D2CLIENT_OFFSET = 0x6FAB0000



Global Const $Room2_PresetUnit = 0x5C
Global Enum $UNIT_PLAYER = 0, $UNIT_MONSTER, $UNIT_OBJECT, $UNIT_MISSILE, $UNIT_ITEM, $UNIT_TILE

Global Const $GetPlayerUnit = 0xA4D60
Global Const $GetLayer = 0x6CB20
Global Const $GetLevel = 0x2D9B0
Global Const $AddRoomData = 0x3CCA0
Global Const $InitAutomapLayer_I = 0x62710
Global Const $RevealAutoMapRoom = 0x62580
Global Const $InitLevel = 0x2E360
Global Const $LoadAct = 0x3CB30
Global Const $LoadAct_1 = 0x62AA0
Global Const $LoadAct_2 = 0x62760
Global Const $RemoveRoomData = 0x3CBE0
Global Const $p_D2CLIENT_Difficulty = 0x11C390
Global Const $p_D2CLIENT_PlayerUnit = 0x11BBFC
Global Const $p_D2CLIENT_ExpCharFlag = 0x119854
Global Const $p_D2CLIENT_AutomapLayer = 0x11C1C4
Global Const $p_ExitGame = 0x42850
Global Const $pRoutine_GetLevel = 0x00000000 ;CE10EB73 ?
Global Const $pRoutine_Maphack = 0x74001350
Global Const $pRoutine_InitAutoMap = 0x00000000
Global Const $pRoutine_Maphack_begin = 0x00000000
Global Const $iDataSize = 1024
#ce

Global $_D2net, $std_packet, $stdpacket, $stdpacket_dummy, $stdpacket_size_pointer
Func LoadTPSystem() ;Updated
	$_D2net = ProcCall($Diablo_MemHandle,"stdcall",_GetProcAddress(_WinAPi_GetModuleHandle("Kernel32.dll"),"GetModuleHandleA"),"handle","char*","D2Net.dll")
	$std_packet = $_D2net + $f_SendPacket


	$stdpacket_size_pointer = _VIrtualAllocEx($Diablo_memhandle, 0, 4, BitOR($MEM_RESERVE, $MEM_COMMIT), $PAGE_EXECUTE_READWRITE)
	$stdpacket_dummy = "0x0000000000000000000000000000000000000000000000000000000000000"
	$stdPacket = ProcCallBackRegister($Diablo_MemHandle,"stdcall",$std_packet,"int","&int",$stdpacket_size_pointer,"int",1,"byte*",$stdpacket_dummy)
EndFunc






Func TpToTown() ;Updated
	IF NOT IsTown($Area_new) And Game_DetectIngame() Then
		$Time = TimerInit()
		SendPacket("0x3Cdc000000FFFFFFFF",9)
		$Pos = CHAR_GetCoords()
		SendPacket("0x0C" &	SwapShort($Pos[0]) & SwapShort($Pos[1]),5)
		Do
			$Portal = FindUnit(2, 59)
		Until $Portal Or TimerDiff($Time) > 3000
		If $Portal Then SendPacket("0x13" & _SwapEndian(2) & _SwapEndian(pread($Portal + 0x0c)),9)
	EndIf
EndFunc   ;==>TPTOTOWN
;ConsoleWRite(_WinAPI_GetLastErrorMessage() & @CRLF)



Func SendPacket($aPacket,$size) ;Updated
	$Buf = DllStructCreate("byte[" & $Size & "]")
	DllStructSetData($BUf,1, $aPacket)
	dwrite($stdpacket_size_pointer,$Size)
	Local $BytesWritten
	_WinAPI_WriteProcessMemory($Diablo_MemHandle,$StdPacket[1][1],DllStructGetPtr($Buf),DllStructGetSize($Buf),$BytesWritten)
	ProcCallBack($stdpacket)
EndFunc

Func SwapShort($Short) ;Updated
	Return StringTrimRight(_SwapEndian($Short), 4)
EndFunc   ;==>SwapShort


Func pRead($A) ; Speed is key here, reads a pointer from address.
	;local $n = 0
	$r = DllCall($__DLL_Kernel32, "bool", "ReadProcessMemory", "handle", $Diablo_memhandle, "ptr", $A, "int*", 0, "int", 4, "int*", 0)
	Return $r[3]
EndFunc   ;==>pRead
Func dWrite($A,$c) ; Speed is key here, writes a dword to address
	;local $n = 0
	$r = DllCall($__DLL_Kernel32,"bool","WriteProcessMemory","handle",$Diablo_MemHandle,"ptr",$a,"int*",$c,"int",4,"int*",0)
	return $r[0]
EndFunc




Func FindUnit($unittype = -1, $textfileno = -1);Updated
	Local $ptRoomOther = pread($pRoom2First + pread($pLevel + pread($pRoom2 + pread($pRoom1 + pread($pPath + pread($PlayerUnit)))))) ;Room2* ptRoomOther = Unit->pPath->pRoom1->pRoom2->pLevel->pRoom2First
	Local $Unit = 0 ;UnitAny * Unit;
	while $ptRoomOther
		$Unit = pread($pUnitFirst + pread($pRRoom1 + $ptRoomOther)) ;Unit = ptRoomOther->pRoom1->pUnitFirst
		while $Unit
			;Do stuff
			If $UnitType <> -1 Then
				If pread($Unit) = $Unittype then
					If $textfileno <> -1 Then
						If pread($Unit + 0x04) = $textfileno Then return $unit
					Else
						Return $Unit
					EndIf
				EndIf
			EndIf
			$Unit = pread($Unit + 0xE8) ; Unit = Unit->pListNext
		wend
		$ptRoomOther = pread($pRoom2Next + $ptRoomOther) ;ptRoomOther = ptRoomOther->pRoom2Next;
	WEnd
	return 0
EndFunc   ;==>FindUnit
