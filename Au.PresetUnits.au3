Global $pid, $d2handle
Global $x_Diff[2], $y_Diff[2]
Global $xy_base[2] = [408, 286] ;this defines where lines should start
Global $x_Final[2], $y_Final[2], $xy_Final[2]
Global $Coords, $coords2
Global Const $NewDiabloTitle = "[TITLE:Diablo II; CLASS:Diablo II]" ;identifier for the window
Global Const $D2CLIENT_OFFSET = 0x6FAB0000
Global Const $D2LAUNCH_OFFSET = 0x6FA40000
Global Const $D2MULTI_OFFSET = 0x6F9D0000
Global Const $D2WIN_OFFSET = 0x6F8E0000
Global Const $PEN_Colours[8] = [0xFFED1C24, 0xFFFFF200, 0xFF22B14C, 0xFF00A2E8, 0xFFA349A4, 0xFFB97A57, 0xFFFFAEC9, 0xFFC8BFE7] ;Colours for the lines drawn
Global $hPen[8] ; need one pen for each colour, i don't think there's any level in diablo II that has more than 8 entries.
Global $Warps, $Area_Old,$Area_New, $newcoords, $oldcoords, $Xp_start,$Correct

;#######################################################################################################
;#######################################################################################################
;#######################################################################################################

; THIS FILE IS BY NO MEANS COMPLETE; ADDED FOR REFERENCE. CREDITS: SHAGGI

;#######################################################################################################
;#######################################################################################################
;#######################################################################################################

#include <Array.au3>
#include <WinApi.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WINAPI.au3>
#include <GDIPlus.au3>
#include <StaticConstants.au3>
#include "DiaAPIConstants.au3"
#include "Minimized.au3"
#include "AU.Levels.au3"
#include "AU.Algorithms.au3"
#include "AU.Memory.au3"
#include "AU.Map.au3"
#include "AU.Char.au3"
#include "AU.DiaApi.au3"
#include "AU.Game.au3"

#cs
PresetUnit:
d2client.dll+11BBFC -> 2C -> 1C -> 10 -> 5C
d2client.dll+unitany -> path -> room1 -> room2 -> presetunit

Room1:
d2client.dll+11BBFC -> 2C -> 1C
d2client.dll+unitany -> path -> room1
Room1 coords:
	DWORD dwXStart;			//0x4C
	DWORD dwYStart;			//0x50

#Ce
D2Info()

While 1
	$ilvl = ITEM_GetIlvl($pid)
	If $ilvl = 0 Then
		ToolTip("")
	Else
		$pos = MouseGetPos()
		$Msg = "Ilvl of selected item is: " & $ilvl
		ToolTip($msg,$pos[0],$pos[1],"Autumn Ilvl Reader")
	Endif
	Sleep(50)
Wend




Func D2Info()
	$pid = WinGetProcess($NewDiabloTitle)
	$d2handle = WinGetHandle($NewDiabloTitle)
EndFunc   ;==>D2Info

#cs
While 1
	$PresetType = MAP_GetPresetType($pid)
	If $PresetType <> 0 Then
		$PresetName = PresetName($Presettype)
		$Room1_X_Y = Room1Get_x_y($pid)
		$coords = CHAR_GetCoords($pid)
		$pixels = Conv_CoordToPixel($coords,MAP_GetPresetX($pid)+$Room1_X_Y[0],MAP_GetPresetX($pid)+$Room1_X_Y[1])
		$msg = "Deteced object: " & $Presetname & @CRLF & "Offset.x = " & MAP_GetPresetX($pid) & @CRLF & "Offset.y = " &MAP_GetPresetX($pid) & @CRLF & $Room1_X_Y[0] & "," & $Room1_X_Y[1] _
		& @CRLF & "Your Coords: " & $coords[0] & "," & $Coords[1]
		ToolTip(".",$pixels[0],$pixels[1])
	Else
		ToolTip("")
	Endif
	Sleep(20)
Wend

		If $presetname <> 2 Then
			$presetnext = _ReadD2Memory($pid,MAP_GetPresetStructPtr($pid) + 0x0C)
			$omg = 0
			Do
				$omg += 1
				$presetnext = _ReadD2Memory($pid,$presetnext + 0x0C)
				$type = _ReadD2Memory($pid,$presetnext + 0x04)
				Consolewrite(@CRLF & $omg & "--> " & $type)
				If $type = 0 then $type = 2
			Until $type = 2
		Endif


Func Room1Get_x_y($pid)
	dim $temp[2]
	$temp[0] = _ReadD2Memory($pid,MAP_GetRoom1StructPtr($pid) + 0x4C)
	$temp[1] = _ReadD2Memory($pid,MAP_GetRoom1StructPtr($pid) + 0x50)
	Return $temp
Endfunc
Func PresetName($type)
	Switch $type
		case 2
			Return "Experience Shrine"
		Case 119
			Return "Waypoint"
		Case 83
			Return "Mana Shrine"
		Case 78
			Return "Townportal"
		Case Else
			Return "Unknown"
	EndSwitch
Endfunc

Func MAP_GetRoom1StructPtr($pid)
	$aHandle = openSecureProcess($pid)
	Local $Read = 0
	Local $v_Buffer = DllStructCreate("dword")
	_WinAPI_ReadProcessMemory($aHandle, $D2CLIENT_OFFSET + 0x11BBFC, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer), $Read)
	$ptr1 = DllStructGetData($v_Buffer, 1)
	_WinAPI_ReadProcessMemory($aHandle, $ptr1 + 0x2c, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer), $Read)
	$ptr2 = DllStructGetData($v_Buffer, 1)
	_WinAPI_ReadProcessMemory($aHandle, $ptr2 + 0x1c, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer), $Read)
	_WinAPI_CloseHandle($aHandle)
	Return DllStructGetData($v_Buffer, 1)
Endfunc ;==>MAP_GetRoom1StructPtr

Func D2Info()
	$pid = WinGetProcess($NewDiabloTitle)
	$d2handle = WinGetHandle($NewDiabloTitle)
EndFunc   ;==>D2Info
/*void DrawPresets(Room2 *pRoom2)
 *	This will find all the shrines, special automap icons, and level names and place on map.
 */
Func GetPresets ($room2)
{
	//UnitAny* Player = D2CLIENT_GetPlayerUnit();
	//Grabs all the preset units in room.
	for (PresetUnit *pUnit = pRoom2->pPreset; pUnit; pUnit = pUnit->pPresetNext)
	{
		int mCell = -1;
		if (pUnit->dwType == 1);//Special NPCs.
		{
			if (pUnit->dwTxtFileNo == 256)//Izzy
				mCell = 300;
			if (pUnit->dwTxtFileNo == 745)//Hephasto
				mCell = 745;
		} else if (pUnit->dwType == 2) { //Objects on Map

			;//Special Units that require special checking:)
			if (pUnit->dwTxtFileNo == 371)
				mCell = 301; //Countess Chest
			if (pUnit->dwTxtFileNo == 152)
				mCell = 300; //A2 Orifice
			if (pUnit->dwTxtFileNo == 460)
				mCell = 1468; //Frozen Anya
			if ((pUnit->dwTxtFileNo == 402) && (pRoom2->pLevel->dwLevelNo == 46))
				mCell = 0; //Canyon/Arcane Waypoint
			if ((pUnit->dwTxtFileNo == 267) && (pRoom2->pLevel->dwLevelNo != 75) && (pRoom2->pLevel->dwLevelNo != 103))
				mCell = 0;
			if ((pUnit->dwTxtFileNo == 376) && (pRoom2->pLevel->dwLevelNo == 107))
				mCell = 376;

			if (pUnit->dwTxtFileNo > 574)
				mCell = 0;

			if (mCell == -1)
			{
				//Get the object cell
				ObjectTxt *obj = D2COMMON_GetObjectText(pUnit->dwTxtFileNo);

				if (mCell == -1)
				{
					mCell = obj->nAutoMap;//Set the cell number then.
				}
			}
		}

		//Draw the cell if wanted.
		if ((mCell > 0) && (mCell < 1258))
		{
			AutomapCell *pCell = D2CLIENT_NewAutomapCell();
			pCell->nCellNo = (WORD)mCell;
			int pX = (pUnit->dwPosX + (pRoom2->dwPosX * 5));
			int pY = (pUnit->dwPosY + (pRoom2->dwPosY * 5));
			pCell->xPixel = (WORD)((((pX - pY) * 16) / 10) + 1);
			pCell->yPixel = (WORD)((((pY + pX) * 8) / 10) - 3);

			D2CLIENT_AddAutomapCell(pCell, &((*p_D2CLIENT_AutomapLayer)->pObjects));
		}
	}
}
#ce
#cs
struct UnitAny {
	DWORD dwType;					//0x00
	DWORD dwTxtFileNo;				//0x04
	DWORD _1;						//0x08
	DWORD dwUnitId;					//0x0C
	DWORD dwMode;					//0x10
	union
	{
		PlayerData *pPlayerData;
		ItemData *pItemData;
		MonsterData *pMonsterData;
		ObjectData *pObjectData;
		//TileData *pTileData doesn't appear to exist anymore
	};								//0x14
	DWORD dwAct;					//0x18
	Act *pAct;						//0x1C
	DWORD dwSeed[2];				//0x20
	DWORD _2;						//0x28
	union
	{
		Path *pPath;
		ItemPath *pItemPath;
		ObjectPath *pObjectPath;
	};								//0x2C
	DWORD _3[5];					//0x30
	DWORD dwGfxFrame;				//0x44
	DWORD dwFrameRemain;			//0x48
	WORD wFrameRate;				//0x4C
	WORD _4;						//0x4E
	BYTE *pGfxUnk;					//0x50
	DWORD *pGfxInfo;				//0x54
	DWORD _5;						//0x58
	StatList *pStats;				//0x5C
	Inventory *pInventory;			//0x60
	Light *ptLight;					//0x64
	DWORD _6[9];					//0x68
	WORD wX;						//0x8C
	WORD wY;						//0x8E
	DWORD _7;						//0x90
	DWORD dwOwnerType;				//0x94
	DWORD dwOwnerId;				//0x98
	DWORD _8[2];					//0x9C
	OverheadMsg* pOMsg;				//0xA4
	Info *pInfo;					//0xA8
	DWORD _9[6];					//0xAC
	DWORD dwFlags;					//0xC4
	DWORD dwFlags2;					//0xC8
	DWORD _10[5];					//0xCC
	UnitAny *pChangedNext;			//0xE0
	UnitAny *pListNext;				//0xE4 -> 0xD8
	UnitAny *pRoomNext;				//0xE8
};
#ce