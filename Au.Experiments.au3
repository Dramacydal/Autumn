#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#AutoIt3Wrapper_usex64=n
; Script Start - Add your code below here
#include <ProcessCall.au3>
#include <WinApi.au3>
#include <Misc.au3>
#include "Au.Vars.au3"
#include "Au.Memory.au3"
#include "Au.Algorithms.au3"
#include "Au.Char.au3"
#include "Au.DiaApi.au3"
#include "Minimized.au3"
#include "DiaAPIConstants.au3"
;#include "Au.Sm.au3"
#include <Array.au3>
Opt("TrayIconDebug",1)
Global Const $pRoom2First = 0x10
Global Const $ProgramName = "Bot"
Global Const $pLevel = 0x58
Global COnst $pPath = 0x2C
Global Const $pRoom1 = 0x1C
Global Const $pRRoom1 = 0x30
Global Const $pRoom2= 0x10
Global Const $pUnitFirst = 0x74
Global Const $pRoomNext = 0xE4
Global Const $pRoom2Next = 0x24
Global Const $Room2_PresetUnit = 0x5C
Global Enum  $UNIT_PLAYER = 0,$UNIT_MONSTER,$UNIT_OBJECT,$UNIT_MISSILE,$UNIT_ITEM,$UNIT_TILE
Global Const $PlayerUnit = 0x6FBCBBFC
	Global Const $GetPlayerUnit 					= 0xA4D60
	Global Const $GetLayer 							= 0x6CB20
	Global Const $GetLevel 							= 0x2D9B0
	Global Const $AddRoomData 						= 0x3CCA0
	Global Const $InitAutomapLayer_I 				= 0x62710
	Global Const $RevealAutoMapRoom 				= 0x62580
	Global Const $InitLevel 						= 0x2E360
	Global Const $LoadAct 							= 0x3CB30
		Global Const $LoadAct_1 					= 0x62AA0
		Global Const $LoadAct_2 					= 0x62760
	Global Const $RemoveRoomData 					= 0x3CBE0
	Global Const $p_D2CLIENT_Difficulty 			= 0x11C390
	Global Const $p_D2CLIENT_PlayerUnit 			= 0x11BBFC
	Global Const $p_D2CLIENT_ExpCharFlag 			= 0x119854
	Global Const $p_D2CLIENT_AutomapLayer 			= 0x11C1C4
	Global Const $p_ExitGame 						= 0x42850
		Global Const $pRoutine_GetLevel				= 0x00000000		;CE10EB73 ?
		Global Const $pRoutine_Maphack 				= 0x74001350
		Global Const $pRoutine_InitAutoMap 			= 0x00000000
		Global Const $pRoutine_Maphack_begin 		= 0x00000000
		Global Const $iDataSize 					= 1024

Global $pathx_start[10] = [7798,7801,7800,7797,7801,7804,7790,7818,7799,7795]
Global $pathy_start[10] = [5900,5818,5756,5671,5602,5490,5431,5391,5335,5296] ; to star

Global $pathx_leftc[3] = [7766,7737,7723] ;left clear
Global $pathy_leftc[3] = [5283,5298,5297]

Global $pathx_lefts[3] = [7691,7658,7653]
Global $pathy_lefts[3] = [5315,5305,5280] ; left star

Global $pathx_upc[5] = [7678,7723,7749,7785,7788]
Global $pathy_upc[5] = [5315,5309,5295,5267,5239] ;upper clear

Global $pathx_ups[5] = [7794,7778,7809,7809,7779]
Global $pathy_ups[5] = [5249,5219,5192,5158,5159] ; upper clear

Global $pathx_rightc[4] = [7769,7773,7805,7837]
Global $pathy_rightc[4] = [5162,5219,5265,5296] ; right clear

Global $pathx_rights[3] = [7860,7878,7900]
Global $pathy_rights[3] = [5295,5295,5293] ; right star

Global $pathx_tostar[3] = [7855,7815,7790]
Global $pathy_tostar[3] = [5290,5282,5293]
Global $mod_health = false, $mod_mana = false


Global $HotKeys[12] = ["f","q","w","{f6}","{f5}","d","r","a","1","2","3","4"]
Global Enum $Tele, $Hammer, $WSwitch, $Bc, $Bo, $Conc, $Redem, $Hs, $Hp1, $Hp2, $Mp1, $Mp2
$pID = WinGetProcess($NewDiabloTitle)
$Diablo_hWnd = WinGetHandle($NewDiabloTitle)
$__DLL_Kernel32 = DllOpen("Kernel32.dll")
$Diablo_MemHandle = openSecureProcess($pID,0x001F0FFF) ;open handle to Diablo memory

Global $StdPrint = ProcCallBackRegister($Diablo_MemHandle,"stdcall",$D2client + 0x7D610,"void","wchar*",$Programname,"int",2)


Func Print($szMsg)
	If NOT $szMsg Then Return False
	$Size = StringLen($szMsg)+2
	$ByteStruct = DllStructCreate("wchar[" & $Size & "]")
	DllStructSetData($ByteStruct,1,$szMsg)
	DllStructSetData($ByteStruct,$Size-1,0)
	Local $BytesWritten
	_WinApi_WriteProcessMemory($Diablo_MemHandle,$StdPrint[1][1],DllStructGetPtr($ByteStruct),DllStructGetSize($ByteStruct),$BytesWritten)
	ProcCallBack($stdPrint)
EndFunc

AdLibRegister("Chicken",300)
Global $Mana, $Health, $Shift, $health_timer = TimerInit(), $mana_timer = TimerInit()
HotKeySet("{esc}","_hExit")
HotKeySet("{pause}","Pause")
Global $Pause = False
Func Pause()
	$Pause = NOT $Pause
	If $Pause Then
		Print("Pausing script...")
	Else
		Print("Resuming script...")
	EndIf
	While $Pause
		Sleep(10)
	WEnd
EndFunc
Func _hExit()
	Exit
EndFUnc
OnAutoItExitRegister("_nExit")
WinActivate($Diablo_Hwnd)

;OpenDesiesSeal()
;Dia()
;IterateItems()
	Print("Starting up Diabot")
	precast()
	Print("Moving to star")
	PathTo(7795,5296)
	NT_OpenSealsInt()
	Precast()
	PathTo(7798, 5298)
	Print("Waiting for Diablo to spawn...")
	WaitAndKill("Diablo")
#cs
$Array = GetObjects()
EnumArraY($Array)
For $i = 0 to $Array[0]
		$Coords = GetItemCoords($Array[$i])
		If ($Coords[0] > 500) AND ($Coords[1] > 500) Then
			ConsoleWrite($Coords[0] & ", " & $Coords[1] & " -> " & pread( $Array[$i] + 0x04 )& @CRLF)
			;PathTo($Coords[0],$Coords[1],0,0,"right")
		EndIf
	Sleep(10)
Next
#ce
While 1
	Sleep(100)
	$Coords = CHAR_GetCoords()
	ToolTip($Coords[0] & ", " & $Coords[1],0,0)
Wend
Func Precast()
	Print("ÿc1Precasting")
	WSwitch()
	sleep(500)
	qsend($Hotkeys[$Bc])
	sleep(200)
	_mouseclick($Diablo_hWnd,"right",500,500)
	sleep(500)
	qsend($Hotkeys[$Bo])
	sleep(200)
	_mouseclick($Diablo_hWnd,"right",500,500)
	sleep(500)
	WSwitch()
	sleep(500)
	qsend($Hotkeys[$Hs])
	sleep(100)
	_mouseclick($Diablo_hWnd,"right",500,500)
	sleep(100)
	qsend($Hotkeys[$Tele])
	sleep(200)
EndFunc
Func WSwitch($b = -1)
	$Old = pread($D2client_offset+0x11BC94)
	qsend($Hotkeys[$Wswitch])
	$Start = TimerInit()
	While $Old = pread($D2client_offset+0x11BC94)
		Sleep(10)
		If TimerDiff($start) > 3000 Then Return False
	WEnd
	Return NOT $Old
EndFunc
Func CreateRemoteThread($hProcess, $lpThreadAttributes, $dwStackSize, $lpStartAddress, $lpParameter, $dwCreationFlags, $lpThreadId)
	Local $call = DllCall($__DLL_Kernel32, "ptr", "CreateRemoteThread", _
			"ptr", $hProcess, _
			"ptr", $lpThreadAttributes, _
			"uint", $dwStackSize, _
			"ptr", $lpStartAddress, _
			"ptr", $lpParameter, _
			"dword", $dwCreationFlags, _
			"ptr", $lpThreadId)
	Return $call[0]
EndFunc   ;==>CreateRemoteThread
Func ExitGame()
	Local $Thread = CreateRemoteThread($Diablo_MemHandle,0,0,$D2client + $p_ExitGame,0,0,0)
	_WinAPI_WaitForSingleObject($Thread,20000)
	_WinAPI_CloseHandle($Thread)
	Sleep(2000)
	Exit(1)
EndFunc
Func Chicken()
	$mana = _DiaApi_GetStatValue(8)
	$Health = _DiaApi_GetStatValue(6)
		;ConsoleWrite("Health is " & $Health & @CRLF)
		If $Health < 400 OR $Health = -1 Then
			ExitGame()
		elseif $Health < 1600 Then
			IF TimerDiff($health_timer) > 3000 Then
				If $Shift Then
					send("{shiftup}")
					$mod_health = NOT $mod_health
					If $mod_health THen
						qsend($Hotkeys[$Hp1])
					Else
						qsend($Hotkeys[$Hp1])
					EndIf
					send("{shiftdown}")
				Else
					$mod_health = NOT $mod_health
					If $mod_health THen
						qsend($Hotkeys[$Hp1])
					Else
						qsend($Hotkeys[$Hp2])
					EndIf
				EndIf
				$health_timer = TimerInit()
			EndIf
		EndIf
	IF TimerDiff($mana_timer) > 3000 Then

		;ConsoleWrite("Mana is " & $Mana & @CRLF)
		If $mana < 150 Then
			If $Shift Then
				send("{shiftup}")
				$mod_mana = NOT $mod_mana
				If $mod_mana  THen
					qsend($Hotkeys[$mp1])
				Else
					qsend($Hotkeys[$mp2])
				EndIf
				send("{shiftdown}")
			Else
				$mod_mana = NOT $mod_mana
				If $mod_mana  THen
					qsend($Hotkeys[$mp1])
				Else
					qsend($Hotkeys[$mp2])
				EndIf
			EndIf
			$mana_timer = TimerInit()
		EndIf
	EndIf
EndFunc


; HERE STARTS THE FUN
;
;
;
#cs
While 1
	$Unit = FindUnit($PlayerUnit,$UNIT_ITEM)
	While NOT $Unit
		$Unit = FindUnit($PlayerUnit,$UNIT_ITEM)
		Sleep(200)
	WEnd
	Sleep(2000)
	$Coords = GetItemCoords($Unit)

	iF $Coords[1] Then
		ToolTip($Coords[0] & ", " & $Coords[1])
		PathTo($Coords[0],$Coords[1])
	EndIf
WEnd
#ce
;ConsoleWrite("0x" & Hex(83425792))
Func WaitAndKill($ID)
	$Time = TimerInit()
	Do
		$Unit = FindUniqueMonster($Id)
		Sleep(500)
	Until $Unit OR TimerDiff($Time) > 20000
	If NOT $Unit Then Return False
	Return KillUnit($Unit)
EndFunc

Func KillUnit($Unit)
	$Data = pread($Unit + 0x10) ; Unit->dwMode
	;ConsoleWrite("Data = " & $Data & @CRLF)
	While $Data and ($data <> 12)  ; Checking that mon isnt dead
		$Coords = GetMonCoords($Unit)
		Attack($Coords[0],$Coords[1])
		$Data = pread($Unit + 0x10) ; Unit->dwMode
	WEnd
EndFunc
Func GetObjects()
	Local $Array[1] = [0]
	Local $ptRoomOther = pread($pRoom2First + pread($pLevel + pread($pRoom2 + pread($pRoom1 + pread($pPath + pread($PlayerUnit)))))) ;Room2* ptRoomOther = Unit->pPath->pRoom1->pRoom2->pLevel->pRoom2First
	Local $Unit = 0 ;UnitAny * Unit;
	while $ptRoomOther
		$Unit = pread($pUnitFirst + pread($pRRoom1 + $ptRoomOther)) ;Unit = ptRoomOther->pRoom1->pUnitFirst
		while $Unit
			;Do stuff
			If pread($Unit) = $UNIT_OBJECT then
				_ArrayAdd($Array,$Unit)
				$Array[0] += 1
			EndIf
			$Unit = pread($Unit + 0xE8) ; Unit = Unit->pListNext
		wend
		$ptRoomOther = pread($pRoom2Next + $ptRoomOther) ;ptRoomOther = ptRoomOther->pRoom2Next;
	WEnd
	Return $Array
EndFunc


Func BuildMonsterList()
	Local $Array[1] = [0]
	Local $ptRoomOther = pread($pRoom2First + pread($pLevel + pread($pRoom2 + pread($pRoom1 + pread($pPath + pread($PlayerUnit)))))) ;Room2* ptRoomOther = Unit->pPath->pRoom1->pRoom2->pLevel->pRoom2First
	Local $Unit = 0 ;UnitAny * Unit;
	while $ptRoomOther
		$Unit = pread($pUnitFirst + pread($pRRoom1 + $ptRoomOther)) ;Unit = ptRoomOther->pRoom1->pUnitFirst
		while $Unit
			;Do stuff
			If pread($Unit) = $UNIT_MONSTER then
				_ArrayAdd($Array,$Unit)
				$Array[0] += 1
			EndIf
			$Unit = pread($Unit + 0xE8) ; Unit = Unit->pListNext
		wend
		$ptRoomOther = pread($pRoom2Next + $ptRoomOther) ;ptRoomOther = ptRoomOther->pRoom2Next;
	WEnd
	Return $Array
EndFunc
Func ClearArea($Range = 60,$Array = 0,$bIgnore = True)
	If IsArray($Array) Then
		$Monlist = $Array
	Else
		$MonList = BuildMonsterList()
	EndIf
	;EnumArray($Monlist)
	Local $Time = TimerInit()
	Local $Data, $Deadlist[1] = [0], $Id
	Local $StartCoords = CHAR_GetCoords()
	For $i = 0 to $Monlist[0]
		$Data = pread($monlist[$i] + 0x10) ; Unit->dwMode
		;ConsoleWrite("Data = " & $Data & @CRLF)
		If $Data and ($data <> 12) Then ; Checking that mon isnt dead
			IF $bIgnore AND (pread($monlist[$i] + 0x4) = 306) Then ContinueLoop ; Ignore those damn storm casters
			$Coords = GetMonCoords($monlist[$i])
			If NOT Difference($StartCoords[0],$StartCoords[1],$coords[0],$coords[1],$range) Then
				Attack($Coords[0],$Coords[1],8)
				$Data = pread($monlist[$i] + 0x10) ; Unit->dwMode
				If $Data and ($data <> 12) Then ; Checking that mon isnt dead
					_ArrayAdd($Deadlist,$monlist[$i])
					$deadlist[0] += 1
				EndIf
			EndIf
		EndIf
		Sleep(10)
	Next
	If($DeadList[0]) Then Return ClearArea($Range,$Deadlist)
	PathTo($StartCoords[0],$Startcoords[1])
	If TimerDiff($Time) > 5000 Then
		qsend($Hotkeys[$Redem])
		Sleep(2000)
	ENdIf
	qsend($Hotkeys[$Tele])
EndFunc


Exit

Func EnumArray($Variable)
	Local $COunt
	ConsoleWrite("Enumeration of Array ::" & @CRLF)
	$Dimensions = uBound($Variable,0)
	For $element in $Variable
		$Count += 1
		ConsoleWrite(@Tab & $element & @CRLF)
	Next
	Return True
EndFunc
	;_ArrayDisplay($Coords)
Func qsend($keys)
	Return ControlSend($Diablo_hWnd,"","",$Keys)
EndFunc
Func Attack($x,$y,$Range = 4)
	qsend($Hotkeys[$Tele])
	Sleep(40)
	PathTo($x,$y,0,0,"right",false,$Range)
	;sleep(1000)
	qsend($HotKeys[$Hammer])
	qsend($Hotkeys[$Conc])
	send("{shiftdown}")
	$Shift = True
	sleep(300)
	DllCall("user32.dll", "int", "SendMessage", _
			"hwnd", $Diablo_hWnd, _
			"int", $WM_LBUTTONDOWN, _
			"int", $MK_LBUTTON, _
			"long", _MakeLong(500, 500))
	Sleep(2000)
	DllCall("user32.dll", "int", "SendMessage", _
			"hwnd", $Diablo_hWnd, _
			"int", $WM_LBUTTONUP, _
			"int", $MK_LBUTTON, _
			"long", _MakeLong(500, 500))
	qsend($Hotkeys[$Tele])
	send("{shiftup}")
	$Shift = False
EndFunc

#CS        TESTING
Sleep(300)
$Start = TimerInit()
For $i = 0 to 20
ConsoleWrite( _ReadD2Memory($Diablo_MemHandle, 0x6FBAADA8, "byte",False,$__DLL_Kernel32) & @CRLF)
Next

ConsoleWrite(TimerDiff($Start)/20 - 0.0088 & @CRLF)

$Start = TimerInit()
For $i = 0 to 20
	ConsoleWrite(pread(0x6FBAADA8) & @CRLF)
Next
ConsoleWrite(TimerDiff($Start)/20 - 0.0088 & @CRLF)

$Start = TimerInit()
$Buffer = DllStructCreate("dword")
$Blank = ""
For $i = 0 to 20
ConsoleWrite(_WinAPI_ReadProcessMemory($Diablo_MemHandle, 0x6FBAADA8, DllStructGetPtr($Buffer),DllStructGetSize($Buffer),$Blank) & @CRLF)
Next

ConsoleWrite(TimerDiff($Start)/20 - 0.0088 & @CRLF)
#ce
#cs
;struct UnitAny {
	"DWORD dwType;" & _					//0x00
	"DWORD dwTxtFileNo;"				//0x04
	"DWORD _1;"						//0x08
	"DWORD dwUnitId;"					//0x0C
	"DWORD dwMode;"					//0x10
	"ptr pUnitData"
	"DWORD dwAct;"					//0x18
	"ptr pAct;"						//0x1C
	"DWORD dwSeed[2];"				//0x20
	"DWORD _2;"						//0x28
	"ptr pUnitPath"							//0x2C
	"DWORD _3[5];"					//0x30
	"DWORD dwGfxFrame;"				//0x44
	"DWORD dwFrameRemain;"			//0x48
	"WORD wFrameRate;"				//0x4C
	"WORD _4;"						//0x4E
	"ptr pGfxUnk;"					//0x50
	"ptr pGfxInfo;"				//0x54
	"DWORD _5;"						//0x58
	"ptr pStats;"				//0x5C
	"ptr pInventory;"			//0x60
	"ptr ptLight;"					//0x64
	"DWORD _6[9];"					//0x68
	"WORD wX;"						//0x8C
	"WORD wY;"						//0x8E
	"DWORD _7;"						//0x90
	"DWORD dwOwnerType;"				//0x94
	"DWORD dwOwnerId;"				//0x98
	"DWORD _8[2];"					//0x9C
	"ptr pOMsg;"				//0xA4
	"ptr pInfo;"					//0xA8
	"DWORD _9[6];"					//0xAC
	"DWORD dwFlags;"					//0xC4
	"DWORD dwFlags2;"					//0xC8
	"DWORD _10[5];"					//0xCC
	"ptr pChangedNext;"			//0xE0
	"ptr pRoomNext;"				//0xE4
	"ptr pListNext;"				//0xE8 -> 0xD8



                for(Room2* ptRoomOther = Unit->pPath->pRoom1->pRoom2->pLevel->pRoom2First;
					ptRoomOther;
					ptRoomOther = ptRoomOther->pRoom2Next)
                {
                        if(!ptRoomOther->pRoom1)
                                continue;
                        for(Unit = ptRoomOther->pRoom1->pUnitFirst; Unit; Unit = Unit->pRoomNext)
                        {
							if(Unit->dwType == UNIT_OBJECT && Unit->dwTxtFileNo == 59)
							{
								unit2 = Unit;
								break;
							}
						}
				}
#ce
Func dWrite($A,$c) ; Speed is key here, writes a dword to address
	;local $n = 0
	$r = DllCall($__DLL_Kernel32,"bool","WriteProcessMemory","handle",$Diablo_MemHandle,"ptr",$a,"int*",$c,"int",4,"int*",0)
	return $r[0]
EndFunc
Func pRead($A) ; Speed is key here, reads a pointer from address.
	;local $n = 0
	$r = DllCall($__DLL_Kernel32,"bool","ReadProcessMemory","handle",$Diablo_MemHandle,"ptr",$a,"int*",0,"int",4,"int*",0)
	return $r[3]
EndFunc
Func IterateItems()
	;Getting variables set up
	Local $Unit = pread($PlayerUnit)
	Local $Inventory = pread($Unit + 0x60)
	Local $Item = pread($Inventory + 0x0C)
	Local $Itemdata = pread($Item + 0x14)
	;Now we cant make a for loop because autoit doesn't support pointer syntax, so we make a while-loop
	While $Item ;This makes the loop stop when there's no more items
		;Item is now a UnitAny struct, from there you can get all stats / positions / types etc.
		;Do stuff here
		ConsoleWrite("There's an item at address 0x" & Hex($Item) & @CRLF)
		$Itemdata = pread($Item + 0x14)
		;Now we move on to next item:
		$Item = pread($Itemdata + 0x64)
	WEnd
EndFunc
Func FindUnit($povUNIT,$unittype = -1,$textfileno = -1)
	Local $ptRoomOther = pread($pRoom2First + pread($pLevel + pread($pRoom2 + pread($pRoom1 + pread($pPath + pread($povUnit)))))) ;Room2* ptRoomOther = Unit->pPath->pRoom1->pRoom2->pLevel->pRoom2First
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
EndFunc

Func GetPresetCoords($_unit)
	Local $Return[2]
	$Return[0] = pread($_unit[1]+0x34) * 5 + pread($_unit[0]+0x08)
	$return[1] = pread($_unit[1]+ 0x38) * 5 + pread($_unit[0]+ 0x18)
	Return $Return
ENdFunc
Func FindPreset($textfileno = -1)
	Local $ptRoomOther = pread($pRoom2First + pread($pLevel + pread($pRoom2 + pread($pRoom1 + pread($pPath + pread($PlayerUnit)))))) ;Room2* ptRoomOther = Unit->pPath->pRoom1->pRoom2->pLevel->pRoom2First
	Local $pUnit = 0 ;PresetUnit * Unit;
	Local $Return[2]
	while $ptRoomOther
		;ConsoleWrite($ptRoomOther & @CRLF)
		$Unit = pread($Room2_PresetUnit + $ptRoomOther) ;Unit = ptRoomOther->pPreset;
		while $Unit
			;Do stuff
			;ConsoleWrite("-> " & pread($unit + 0x04) & @CRLF)
			If $textfileno <> -1 Then
				If pread($unit + 0x04) = $textfileno Then
					$return[0] = $unit
					$return[1] = $ptRoomOther
					Return $Return
				EndIf
			Else
				$return[0] = $unit
				$return[1] = $ptRoomOther
				Return $Return
			ENdIf
			$Unit = pread($Unit + 0x0c) ; Unit = Unit->pPresetNext
		wend
		$ptRoomOther = pread($pRoom2Next + $ptRoomOther) ;ptRoomOther = ptRoomOther->pRoom2Next;
	WEnd
	return SetError(1,@Error,False)
EndFunc


Func GetNextUnit($povUNIT,$UNITTYPE = -1)
	Local $Unit = pread($povUNIT + 0xE8)
	while $Unit
		ToolTip("Scanning Unit 0x" & Hex($Unit),0,0)
		;Do stuff
		If $UnitType <> -1 Then
			If pread($Unit) = $Unittype then return $unit
		EndIf
		$Unit = pread($Unit + 0xE8) ; Unit = Unit->pListNext
	wend
	return False;
EndFunc

Func GetMonCoords($Unit)
	Dim $Temp[2]
	Local $Read = 0
	Local $v_Buffer2 = DllStructCreate("short;short;short")
	readProcessMemory($Diablo_MemHandle, pread($Unit + 0x2c) + 0x2, DllStructGetPtr($v_Buffer2), DllStructGetSize($v_Buffer2),$__DLL_Kernel32)
	$Temp[0] = DllStructGetData($v_Buffer2, 1)
	;readProcessMemory($Diablo_MemHandle, $ptr2 + 0x6, DllStructGetPtr($v_Buffer2), DllStructGetSize($v_Buffer2),$__DLL_Kernel32)
	$Temp[1] = DllStructGetData($v_Buffer2, 3)
	Return $Temp
EndFunc   ;==>CHAR_GetCoords


Func GetItemCoords($Unit)
	;DWORD dwPosX;					//0x0C
	;DWORD dwPosY;					//0x10
	Dim $Temp[2]
	If NOT $Unit Then Return $Temp
	Local $Read = 0
	Local $v_Buffer2 = DllStructCreate("dword;dword")
	$ptr2 = pread($unit + 0x2c)
	readProcessMemory($Diablo_MemHandle, $ptr2 + 0x0C, DllStructGetPtr($v_Buffer2), DllStructGetSize($v_Buffer2),$__DLL_Kernel32)
	$Temp[0] = DllStructGetData($v_Buffer2, 1)
	$Temp[1] = DllStructGetData($v_Buffer2, 2)
	Return $Temp
EndFunc   ;==>GetUnitCoords



Func _MouseClick($hWnd,$button,$x,$y,$hold = false)
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
	if NOT $hold then _SendMessage($hWnd,$ButtonUp,$Button,_WinApi_MakeLong($x,$y))
	Return True
EndFunc

Func clickMap($hWnd,$x,$y,$button = "left",$Hold = false)
	Local $ME_Coords = CHAR_GetCoords()
	Local $clickCoords = Conv_CoordToPixel($ME_Coords,$x,$y)
	Return _MouseClick($hWnd,$button,$clickCoords[0],$clickCoords[1],$Hold)
EndFunc

Func PathTo($x,$y,$key_x = 0,$key_y = 0,$Button = "right", $bClear = False,$Range = 4)
	Local $Retries, $OldCoords = CHAR_GetCoords()
	If (IsArray($key_x) AND IsArray($key_y)) Then
		For $i = 0 to ubound($key_x) -1
			Do
				clickMap($Diablo_Hwnd,$key_x[$i],$key_y[$i],$Button)
				Sleep(100)
				$_Start_Coords = CHAR_GetCoords()
				If NOT Difference($_Start_Coords[0],$_Start_Coords[1],$OldCoords[0],$OldCoords[1],10) Then
					$Retries += 1
					clickMap($Diablo_Hwnd,$x+Random(-5 * ($Retries/2),5* ($Retries/2),1),$y+Random(-5* ($Retries/2),5* ($Retries/2),1),$Button)
					;Sleep(1000 * (1+$Retries/10))
					If $Retries > 10 then return
					$OldCoords = $_Start_Coords
				EndIf
			Until NOT Difference($_Start_Coords[0],$_Start_Coords[1],$key_x[$i],$key_y[$i],6)
			If $bClear THen ClearArea()
		Next
	Endif
	Do
		clickMap($Diablo_Hwnd,$x,$y,$Button)
		Sleep(100)
		$_Start_Coords = CHAR_GetCoords()
		If NOT Difference($_Start_Coords[0],$_Start_Coords[1],$OldCoords[0],$OldCoords[1],10) Then
			$Retries += 1
			clickMap($Diablo_Hwnd,$x+Random(-5 * ($Retries/2),5* ($Retries/2),1),$y+Random(-5* ($Retries/2),5* ($Retries/2),1),$Button)
			;Sleep(1000 * (1+$Retries/10))
			If $Retries > 10 then return
			$OldCoords = $_Start_Coords
		EndIf
	Until  NOT Difference($_Start_Coords[0],$_Start_Coords[1],$x,$y,$Range)
EndFunc

Func _nExit()
	ProcCallBackFree($stdprint)
	_WinApi_CloseHandle($Diablo_MemHandle)
EndFunc
Global Const $ROOM2_dwPosy = 0x38

func NT_OpenSealsInt()
	Local $_unit;
	Local $_result;
	PathTo(7708, 5303)
	ClearRange(7763,5318,7703,5266)
	$_unit = FindPreset(396);

	if @Error then return false;
	Print("ÿc5Opening Vizier seals.")
	if (pread($_unit[1]+ 0x38) * 5 + pread($_unit[0]+ 0x18)) = 5275 Then
		ConsoleWrite("Vizier type is 1" & @CRLF)
		$_result = NT_OpenVizierSealInt(1);
	else
		ConsoleWrite("Vizier type is 2" & @CRLF)
		$_result = NT_OpenVizierSealInt(2);
	EndIf
	WaitAndKill(38)
	;WaitAndKill(38+734)
	ClearArea(60,0,False)
	PathTo(7790,5292)
	PathTo(7791,5223)
	ClearRange(7818,5263,7766,5223)

	$_unit = FindPreset(394);
	If @Error Then
		PathTo(7791+20,5223+20)
		$_unit = FindPreset(394);
	EndIf
	Print("ÿc5Opening De Seis seal.")
	if (pread($_unit[1]+0x34) * 5 + pread($_unit[0]+0x08)) = 7773 Then
		ConsoleWrite("DeSeis type is 1" & @CRLF)
		$_result = NT_OpenDeSeisSealInt(1);
	else
		ConsoleWrite("DeSeis type is 2" & @CRLF)
		$_result = NT_OpenDeSeisSealInt(2);
	EndIf
	PathTo(7798, 5193)
	WaitAndKill(37)
	;WaitAndKill(37+734)
	ClearArea()
	;if NOT $_result then return false;
	ClearRange(7881,5321,7822,5267)

	PreCast()

	$_unit = FindPreset(392);

	if @Error Then return false;
	Print("ÿc5Opening Venom seals.")
	if (pread($_unit[1]+0x34) * 5 + pread($_unit[0]+0x08) = 7893) Then
		$_result = NT_OpenVenomSealInt(1);
	else
		$_result = NT_OpenVenomSealInt(2);
	EndIf
	WaitAndKill(36)
	ClearArea()
	Return True
EndFunc

FUnc ClearRange($Maxx, $Maxy, $Minx, $miny,$Array = 0)

	Local $Middlespot[2] = [$minx + ($maxx-$minx), $maxy - ($maxy-$miny)]
	PathTo($Middlespot[0]-20,$Middlespot[1]+20)
	If IsArray($Array) Then
		$Monlist = $Array
	Else
		$MonList = BuildMonsterList()
	EndIf
	;EnumArray($Monlist)
	Local $Time = TimerInit()
	Local $Data, $Deadlist[1] = [0]
	Local $StartCoords = CHAR_GetCoords()
	For $i = 0 to $Monlist[0]
		$Data = pread($monlist[$i] + 0x10) ; Unit->dwMode
		;ConsoleWrite("Data = " & $Data & @CRLF)
		If $Data and ($data <> 12) Then ; Checking that mon isnt dead
			$Coords = GetMonCoords($monlist[$i])
			;ConsoleWrite("x is " & $coords[0] & ", minx = " & $minx & ", maxx = " & $maxx & @CRLF)
			Switch $Coords[0]
				Case $minx to $maxx
					;ConsoleWrite("y is " & $coords[1] & ", miny = " & $miny & ", maxy = " & $maxy & @CRLF)
					Switch $coords[1]
						case $miny to $maxy
							;ConsoleWrite("ATTACKING" & @CRLF)
							Attack($Coords[0],$Coords[1])
							$Data = pread($monlist[$i] + 0x10) ; Unit->dwMode
							If $Data and ($data <> 12) Then ; Checking that mon isnt dead
								_ArrayAdd($Deadlist,$monlist[$i])
								$deadlist[0] += 1
							EndIf
					EndSwitch
			EndSwitch
		EndIf
		Sleep(10)
	Next
	If($DeadList[0]) Then Return ClearRange($Maxx, $Maxy, $Minx, $miny,$Deadlist)
	PathTo($StartCoords[0],$Startcoords[1])
	If TimerDiff($Time) > 5000 Then
		qsend($Hotkeys[$Redem])
		Sleep(2000)
	ENdIf
	qsend($Hotkeys[$Tele])
EndFunc


func NT_OpenVizierSealInt($type)
	local $i, $n;
	local  $_attackposx[2] = [7767,7630]
	local  $_attackposy[2] = [5322,5265]

	PathTo(7708, 5303)

	ClearArea(20)
	if ($type = 1) Then
		NT_OpenSealInt(395, 7654, 5310);
		NT_OpenSealInt(396, 7655, 5275);

		PathTo(7665, 5277);
	else
		NT_OpenSealInt(395, 7655, 5275);
		NT_OpenSealInt(396, 7655, 5315);
		PathTo(7775,5190)
	EndIf


	#cs
	for (var j = 0; j < 100; j++) {
		if (NTC_FindMonster(getLocaleString(2851))) {
			break;
		}
		NTC_Delay(100)
	}
	for (n = 0; n < 8; n++) {
		if (NTA_KillBoss(getLocaleString(2851))) //Grand Vizier of Chaos
		{
			NTA_ClearPosition();
			NTSI_PickItems();
			return true;//  NTM_MoveTo(7750, 5280);
		}
	}
	#ce
	return false;
EndFunc
Func FindUniqueMonster($UniqueID)
	Local $ptRoomOther = pread($pRoom2First + pread($pLevel + pread($pRoom2 + pread($pRoom1 + pread($pPath + pread($playerunit)))))) ;Room2* ptRoomOther = Unit->pPath->pRoom1->pRoom2->pLevel->pRoom2First
	Local $Unit = 0 ;UnitAny * Unit;
	Local $Struct = DllStructCreate("wchar[40]"), $Name, $iRead, $Data
	while $ptRoomOther
		$Unit = pread($pUnitFirst + pread($pRRoom1 + $ptRoomOther)) ;Unit = ptRoomOther->pRoom1->pUnitFirst
		while $Unit
			If pread($Unit) = $UNIT_MONSTER then
					$Data = pread($Unit +0x14)
				IF IsString($UniqueID) Then
					$Data = pread($Unit +0x10)
					#cs
					_WinApi_ReadProcessMemory($Diablo_MemHandle,$Data + 0x2C,DllStructGetPtr($Struct),28*2,$iRead)
					$Name = DllStructGetData($Struct,1)
					$ID = pread($Data+0x26)
					ConsoleWrite($ID & " + " &$name & @CRLF)
					#ce
					If $Data AND ($Data <> 12) Then Return $Unit
				Else
					$ID = pread($Data+0x26)
					;COnsoleWrite($Id& @CRLF)
					If $ID = $UniqueID Then Return $UNIT
				ENdIf
			EndIf
			$Unit = pread($Unit + 0xE8) ; Unit = Unit->pListNext
		wend
		$ptRoomOther = pread($pRoom2Next + $ptRoomOther) ;ptRoomOther = ptRoomOther->pRoom2Next;
	WEnd
	return 0
EndFunc
func NT_OpenDeSeisSealInt($type)
	local $i, $n;
	local  $_attackposx[2] = [7766,7822]
	local  $_attackposy[2] = [5280,5100]
	PathTo(7795,5200,0,0,"right",true)
	ClearArea(20)
	if ($type = 1) Then
		NT_OpenSealInt(394, 7773, 5155);
	else
		NT_OpenSealInt(394, 7815, 5155);
	EndIf
	;PathTo(7770, 5169);
	;PathTo(7789, 5230);
	return PathTo(7800, 5255);
EndFunc

func NT_OpenVenomSealInt($type)

   	if ($type == 1) Then
		NT_OpenSealInt(393, 7915, 5275);
		NT_openSealInt(392, 7893, 5313);
	else
		NT_OpenSealInt(393, 7915, 5275);
		NT_OpenSealInt(392, 7915, 5315);
	EndIf
	return false;
EndFunc

Func WaitForMovements()
	Local $Player = pread($PlayerUnit)
	Local $Mode = pread($Player + 0x10)
	While True
		Switch $Mode
			Case 1
				Return
			Case 5
				Return
		EndSwitch
		Sleep(100)
		$Mode = pread($Player + 0x10)
		ConsoleWrite($Mode & @CRLF)
	WEnd
EndFunc
Func Fpoint(byref $arr)
	return "x = " & $arr[0] & ", y = " & $arr[1]
EndFunc
Func NT_OpenSealInt($classid, $x, $y)
	Local $_seal;

	PathTO($x, $y);

	$_seal = FindUnit($PlayerUnit,$UNIT_OBJECT, $classid);
	if NOT $_seal Then return false;
	$_seal2 = FindPreset($classid)
	$coords2 = GetPresetCoords($_seal2)
	if pread($_seal + 0x10) then return true;

	$Coords = GetItemCoords($_Seal)
	ClearArea(20)
	PathTo($x,$y)
	Sleep(500)
	Local $retries
	While NOT pread($_seal + 0x10)
		ConsoleWrite("current sealcoords is " & fpoint($coords) & @CRLF & "current seal2 coords is " &fpoint($Coords2) & @CRLF & "passed coords is x = " & $x & ", y = " & $y)
		clickMap($Diablo_Hwnd,$x,$y,"left")
		WaitForMovements()
		Sleep(300)
		$Retries += 1
		If $retries > 5 Then
			$_seal = FindUnit($PlayerUnit,$UNIT_OBJECT, $classid);
			if NOT $_seal Then return false;
			$Coords = GetItemCoords($_Seal)
			PathTo($x,$y)
			WaitForMovements()
			Sleep(300)
		EndIf
		;_SendMessage($Diablo_Hwnd,0x0200,0,_WinApi_MakeLong($clickCoords[0],$clickCoords[1]))
		#cs
		if NOT Mod($i,2) then
			;ClickMap($Diablo_Hwnd,$x,$y,"left")
			Sleep(1000)
		Elseif NOT Mod($i,4) then
		Sleep(500)
			ClickMap($Diablo_Hwnd,$x,$y,"right")
		Sleep(500)
		EndIf
		sleep(500);
		#ce
	WEnd

	return false;
EndFunc
