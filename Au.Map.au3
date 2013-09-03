;##################################################
;~ Function MAP_DetectInTown_Quick
;~ Returns true if in town, else false - this is somewhat quicker than the other
;##################################################
Func MAP_DetectInTown_Quick() ;Updated
	Local $Area = _ReadD2Memory($Diablo_MemHandle, MAP_GetLevelStructPtr() + 0x1D0, "byte",False,$__DLL_Kernel32)
	Local $Temp2
	Select
		Case $Area = 1
			$Temp2 = True
		Case $Area = 40
			$Temp2 = True
		Case $Area = 75
			$Temp2 = True
		Case $Area = 103
			$Temp2 = True
		Case $Area = 109
			$Temp2 = True
		Case Else
			$Temp2 = False
	EndSelect
	Return $Temp2
EndFunc   ;==>MAP_DetectInTown_Quick

;##################################################
;~ Function MAP_GetWarpPoints()
;~ Retrieves coordinates of all warppoints in the given area.
;~ Returns an 2d array.
;~ First dimension has three subscripts,
;~ [2] = amounts of warppoints,
;~ [0] = x-coordinates categori,
;~ [1] = y-coordinates categori.
;~ Second dimension has up tp 8 subscripts.
;~ [0][0] = x-coordinates to first warppoint
;~ [1][0] = x-coordinates to second warppoint
;##################################################
Func MAP_GetWarpPoints() ;Updated
	Print("Retrieved new warps for area " &  MAP_GetLevelName($Area_new) & ".")
	Local $Objects = MAP_GetEntries()
	If $Objects = 0 Then
		If GAME_DetectIngame() Then
			$Objects = MAP_GetEntries()
		Else
			Return False
		EndIf
	EndIf
	If $Objects = 0 Then Return False
	Local $Warps[3][$Objects]
	$Warps[2][0] = $Objects
	Local $LevelStruct = MAP_GetLevelStructPtr()
	For $i = 0 To $Objects - 1 Step 1
		$Warps[0][$i] = _ReadD2Memory($Diablo_MemHandle, $LevelStruct + 0x1E0 + ($i * 4),"dword",False,$__DLL_Kernel32)
	Next
	For $i = 0 To $Objects - 1 Step 1
		$Warps[1][$i] = _ReadD2Memory($Diablo_MemHandle, $LevelStruct + 0x204 + ($i * 4),"dword",False,$__DLL_Kernel32)
	Next
	Return $Warps
EndFunc   ;==>MAP_GetWarpPoints

;##################################################
;~ Function MAP_GetEntries()
;~ Gets the amount of warppoints in the given area
;##################################################
Func MAP_GetEntries() ;Updated
	Return _ReadD2Memory($Diablo_MemHandle, MAP_GetLevelStructPtr() + 0x228,"dword",False,$__DLL_Kernel32)
EndFunc   ;==>MAP_GetEntries

Func MAP_GetActByArea($nArea) ;Updated
	Switch $nArea
		Case 1 To 39
			Return 1
		Case 40 To 74
			Return 2
		Case 75 To 102
			Return 3
		Case 103 To 108
			Return 4
		Case 109 To 137
			Return 5
	EndSwitch
	Return 0
EndFunc
;##################################################
;~ Function MAP_GetStaffTomb()
;~ Returns the areaid of the Tomb which has the entrance to duriel.
;##################################################
Func MAP_GetStaffTomb() ;Updated
	Return _ReadD2Memory($Diablo_MemHandle, _ReadD2Memory($Diablo_MemHandle,MAP_GetLevelStructPtr() + 0x1B4,"dword",False,$__DLL_Kernel32) + 0x94,"dword",False,$__DLL_Kernel32)
EndFunc   ;==>MAP_GetEntries

;##################################################
;~ Function MAP_GetLevelStructPtr()
;~ Gets the pointer for the current levelstruct
;##################################################
Func MAP_GetLevelStructPtr() ;Updated
	Local $Read = 0
	Local $v_Buffer = DllStructCreate("dword")
	Local $ptr1,$ptr2,$ptr3,$ptr4,$ptr5
	readProcessMemory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_PlayerUnit, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr1 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr1 + 0x2c, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr2 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr2 + 0x1c, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr3 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr3 + 0x10, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr4 = DllStructGetData($v_Buffer, 1)
	$ptr5 = readProcessMemory($Diablo_MemHandle, $ptr4 + 0x58, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	Return DllStructGetData($v_Buffer, 1)
Endfunc ;==>MAP_GetLevelStructPtr

;##################################################
;~ Function MAP_GetArea
;~ Returns an array, where
;~ [0] = areaid
;~ [1] = name of the area (could be used for printing?)
;##################################################
Func MAP_GetArea() ;Updated
	Return _ReadD2Memory($Diablo_MemHandle, MAP_GetLevelStructPtr() + 0x1D0, "byte",False,$__DLL_Kernel32)
EndFunc   ;==>MAP_GetArea

Func MAP_GetQuickArea() ;Updated
	Return _ReadD2Memory($Diablo_MemHandle,$D2CLIENT_OFFSET + $p_LevelId, "byte",False,$__DLL_Kernel32)
EndFunc
Func MAP_GetLevelName($iArea) ;Updated
	Local $Temp = $iArea, $Temp2
	Select
		Case $Temp = 0
			$Temp2 = "NONE"
		Case $Temp = 1
			$Temp2 = "ROGUE_ENCAMPMENT"
		Case $Temp = 2
			$Temp2 = "BLOOD_MOOR"
		Case $Temp = 3
			$Temp2 = "COLD_PLAINS"
		Case $Temp = 4
			$Temp2 = "STONY_FIELD"
		Case $Temp = 5
			$Temp2 = "DARK_WOOD"
		Case $Temp = 6
			$Temp2 = "BLACK_MARSH"
		Case $Temp = 7
			$Temp2 = "TAMOE_HIGHLAND"
		Case $Temp = 8
			$Temp2 = "DEN_OF_EVIL"
		Case $Temp = 9
			$Temp2 = "CAVE_LEVEL_1"
		Case $Temp = 10
			$Temp2 = "UNDERGROUND_PASSAGE_LEVEL_1"
		Case $Temp = 11
			$Temp2 = "HOLE_LEVEL_1"
		Case $Temp = 12
			$Temp2 = "PIT_LEVEL_1"
		Case $Temp = 13
			$Temp2 = "CAVE_LEVEL_2"
		Case $Temp = 14
			$Temp2 = "UNDERGROUND_PASSAGE_LEVEL_2"
		Case $Temp = 15
			$Temp2 = "HOLE_LEVEL_2"
		Case $Temp = 16
			$Temp2 = "PIT_LEVEL_2"
		Case $Temp = 17
			$Temp2 = "BURIAL_GROUNDS"
		Case $Temp = 18
			$Temp2 = "CRYPT"
		Case $Temp = 19
			$Temp2 = "MAUSOLEUM"
		Case $Temp = 20
			$Temp2 = "FORGOTTEN_TOWER"
		Case $Temp = 21
			$Temp2 = "TOWER_CELLAR_LEVEL_1"
		Case $Temp = 22
			$Temp2 = "TOWER_CELLAR_LEVEL_2"
		Case $Temp = 23
			$Temp2 = "TOWER_CELLAR_LEVEL_3"
		Case $Temp = 24
			$Temp2 = "TOWER_CELLAR_LEVEL_4"
		Case $Temp = 25
			$Temp2 = "TOWER_CELLAR_LEVEL_5"
		Case $Temp = 26
			$Temp2 = "MONASTERY_GATE"
		Case $Temp = 27
			$Temp2 = "OUTER_CLOISTER"
		Case $Temp = 28
			$Temp2 = "BARRACKS"
		Case $Temp = 29
			$Temp2 = "JAIL_LEVEL_1"
		Case $Temp = 30
			$Temp2 = "JAIL_LEVEL_2"
		Case $Temp = 31
			$Temp2 = "JAIL_LEVEL_3"
		Case $Temp = 32
			$Temp2 = "INNER_CLOISTER"
		Case $Temp = 33
			$Temp2 = "CATHEDRAL"
		Case $Temp = 34
			$Temp2 = "CATACOMBS_LEVEL_1"
		Case $Temp = 35
			$Temp2 = "CATACOMBS_LEVEL_2"
		Case $Temp = 36
			$Temp2 = "CATACOMBS_LEVEL_3"
		Case $Temp = 37
			$Temp2 = "CATACOMBS_LEVEL_4"
		Case $Temp = 38
			$Temp2 = "TRISTRAM"
		Case $Temp = 39
			$Temp2 = "MOO_MOO_FARM"
		Case $Temp = 40
			$Temp2 = "LUT_GHOLEIN"
		Case $Temp = 41
			$Temp2 = "ROCKY_WASTE"
		Case $Temp = 42
			$Temp2 = "DRY_HILLS"
		Case $Temp = 43
			$Temp2 = "FAR_OASIS"
		Case $Temp = 44
			$Temp2 = "LOST_CITY"
		Case $Temp = 45
			$Temp2 = "VALLEY_OF_SNAKES"
		Case $Temp = 46
			$Temp2 = "CANYON_OF_THE_MAGI"
		Case $Temp = 47
			$Temp2 = "SEWERS_LEVEL_1"
		Case $Temp = 48
			$Temp2 = "SEWERS_LEVEL_2"
		Case $Temp = 49
			$Temp2 = "SEWERS_LEVEL_3"
		Case $Temp = 50
			$Temp2 = "HAREM_LEVEL_1"
		Case $Temp = 51
			$Temp2 = "HAREM_LEVEL_2"
		Case $Temp = 52
			$Temp2 = "PALACE_CELLAR_LEVEL_1"
		Case $Temp = 53
			$Temp2 = "PALACE_CELLAR_LEVEL_2"
		Case $Temp = 54
			$Temp2 = "PALACE_CELLAR_LEVEL_3"
		Case $Temp = 55
			$Temp2 = "STONY_TOMB_LEVEL_1"
		Case $Temp = 56
			$Temp2 = "HALLS_OF_THE_DEAD_LEVEL_1"
		Case $Temp = 57
			$Temp2 = "HALLS_OF_THE_DEAD_LEVEL_2"
		Case $Temp = 58
			$Temp2 = "CLAW_VIPER_TEMPLE_LEVEL_1"
		Case $Temp = 59
			$Temp2 = "STONY_TOMB_LEVEL_2"
		Case $Temp = 60
			$Temp2 = "HALLS_OF_THE_DEAD_LEVEL_3"
		Case $Temp = 61
			$Temp2 = "CLAW_VIPER_TEMPLE_LEVEL_2"
		Case $Temp = 62
			$Temp2 = "MAGGOT_LAIR_LEVEL_1"
		Case $Temp = 63
			$Temp2 = "MAGGOT_LAIR_LEVEL_2"
		Case $Temp = 64
			$Temp2 = "MAGGOT_LAIR_LEVEL_3"
		Case $Temp = 65
			$Temp2 = "ANCIENT_TUNNELS"
		Case $Temp = 66
			$Temp2 = "TAL_RASHAS_TOMB1"
		Case $Temp = 67
			$Temp2 = "TAL_RASHAS_TOMB2"
		Case $Temp = 68
			$Temp2 = "TAL_RASHAS_TOMB3"
		Case $Temp = 69
			$Temp2 = "TAL_RASHAS_TOMB4"
		Case $Temp = 70
			$Temp2 = "TAL_RASHAS_TOMB5"
		Case $Temp = 71
			$Temp2 = "TAL_RASHAS_TOMB6"
		Case $Temp = 72
			$Temp2 = "TAL_RASHAS_TOMB7"
		Case $Temp = 73
			$Temp2 = "DURIELS_LAIR"
		Case $Temp = 74
			$Temp2 = "ARCANE_SANCTUARY"
		Case $Temp = 75
			$Temp2 = "KURAST_DOCKTOWN"
		Case $Temp = 76
			$Temp2 = "SPIDER_FOREST"
		Case $Temp = 77
			$Temp2 = "GREAT_MARSH"
		Case $Temp = 78
			$Temp2 = "FLAYER_JUNGLE"
		Case $Temp = 79
			$Temp2 = "LOWER_KURAST"
		Case $Temp = 80
			$Temp2 = "KURAST_BAZAAR"
		Case $Temp = 81
			$Temp2 = "UPPER_KURAST"
		Case $Temp = 82
			$Temp2 = "KURAST_CAUSEWAY"
		Case $Temp = 83
			$Temp2 = "TRAVINCAL"
		Case $Temp = 84
			$Temp2 = "SPIDER_CAVE"
		Case $Temp = 85
			$Temp2 = "SPIDER_CAVERN"
		Case $Temp = 86
			$Temp2 = "SWAMPY_PIT_LEVEL_1"
		Case $Temp = 87
			$Temp2 = "SWAMPY_PIT_LEVEL_2"
		Case $Temp = 88
			$Temp2 = "FLAYER_DUNGEON_LEVEL_1"
		Case $Temp = 89
			$Temp2 = "FLAYER_DUNGEON_LEVEL_2"
		Case $Temp = 90
			$Temp2 = "SWAMPY_PIT_LEVEL_3"
		Case $Temp = 91
			$Temp2 = "FLAYER_DUNGEON_LEVEL_3"
		Case $Temp = 92
			$Temp2 = "SEWERS_LEVEL_1"
		Case $Temp = 93
			$Temp2 = "SEWERS_LEVEL_2"
		Case $Temp = 94
			$Temp2 = "RUINED_TEMPLE"
		Case $Temp = 95
			$Temp2 = "DISUSED_FANE"
		Case $Temp = 96
			$Temp2 = "FORGOTTEN_RELIQUARY"
		Case $Temp = 97
			$Temp2 = "FORGOTTEN_TEMPLE"
		Case $Temp = 98
			$Temp2 = "RUINED_FANE"
		Case $Temp = 99
			$Temp2 = "DISUSED_RELIQUARY"
		Case $Temp = 100
			$Temp2 = "DURANCE_OF_HATE_LEVEL_1"
		Case $Temp = 101
			$Temp2 = "DURANCE_OF_HATE_LEVEL_2"
		Case $Temp = 102
			$Temp2 = "DURANCE_OF_HATE_LEVEL_3"
		Case $Temp = 103
			$Temp2 = "THE_PANDEMONIUM_FORTRESS"
		Case $Temp = 104
			$Temp2 = "OUTER_STEPPES"
		Case $Temp = 105
			$Temp2 = "PLAINS_OF_DESPAIR"
		Case $Temp = 106
			$Temp2 = "CITY_OF_THE_DAMNED"
		Case $Temp = 107
			$Temp2 = "RIVER_OF_FLAME"
		Case $Temp = 108
			$Temp2 = "CHAOS_SANCTUM"
		Case $Temp = 109
			$Temp2 = "HARROGATH"
		Case $Temp = 110
			$Temp2 = "BLOODY_FOOTHILLS"
		Case $Temp = 111
			$Temp2 = "FRIGID_HIGHLANDS"
		Case $Temp = 112
			$Temp2 = "ARREAT_PLATEAU"
		Case $Temp = 113
			$Temp2 = "CRYSTALLINE_PASSAGE"
		Case $Temp = 114
			$Temp2 = "FROZEN_RIVER"
		Case $Temp = 115
			$Temp2 = "GLACIAL_TRAIL"
		Case $Temp = 116
			$Temp2 = "ECHO_CHAMBER"
		Case $Temp = 117
			$Temp2 = "FROZEN_TUNDRA"
		Case $Temp = 118
			$Temp2 = "ANCIENTS_WAY"
		Case $Temp = 119
			$Temp2 = "GLACIAL_CAVES_LEVEL_2"
		Case $Temp = 120
			$Temp2 = "ROCKY_SUMMIT"
		Case $Temp = 121
			$Temp2 = "NIHLATHAKS_TEMPLE"
		Case $Temp = 122
			$Temp2 = "HALLS_OF_ANGUISH"
		Case $Temp = 123
			$Temp2 = "HALLS_OF_PAIN"
		Case $Temp = 124
			$Temp2 = "HALLS_OF_VAUGHT"
		Case $Temp = 125
			$Temp2 = "HELL1"
		Case $Temp = 126
			$Temp2 = "HELL2"
		Case $Temp = 127
			$Temp2 = "HELL3"
		Case $Temp = 128
			$Temp2 = "THE_WORLDSTONE_KEEP_LEVEL_1"
		Case $Temp = 129
			$Temp2 = "THE_WORLDSTONE_KEEP_LEVEL_2"
		Case $Temp = 130
			$Temp2 = "THE_WORLDSTONE_KEEP_LEVEL_3"
		Case $Temp = 131
			$Temp2 = "THRONE_OF_DESTRUCTION"
		Case $Temp = 132
			$Temp2 = "THE_WORLDSTONE_CHAMBER"
	EndSelect
	Return $Temp2
EndFunc
;##################################################
;~ Function MAP_GetAutomapToggled
;~ Returns 1 if toggled, 0 otherwise (and 0 if oog)
;##################################################
Func MAP_GetAutomapToggled() ;Updated
	Local $Temp
	$Temp = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_AutoMap, "dword",False,$__DLL_Kernel32)
	Return $Temp
EndFunc   ;==>MAP_GetAutomapToggled

Func MAP_GetPresetType() ;Updated
	Return _ReadD2Memory($Diablo_MemHandle,MAP_GetPresetStructPtr() + 0x04,"dword",False,$__DLL_Kernel32)
Endfunc

Func MAP_GetPresetX() ;Updated
	Return _ReadD2Memory($Diablo_MemHandle,MAP_GetPresetStructPtr() + 0x8,"dword",False,$__DLL_Kernel32)
Endfunc
Func MAP_GetPresetY() ;Updated
	Return _ReadD2Memory($Diablo_MemHandle,MAP_GetPresetStructPtr() + 0x18,"dword",False,$__DLL_Kernel32)
Endfunc

Func MAP_GetPresetStructPtr() ;Updated
	Local $Read = 0
	Local $v_Buffer = DllStructCreate("dword")
	readProcessMemory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_PlayerUnit, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr1 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr1 + 0x2c, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr2 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr2 + 0x1c, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr3 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr3 + 0x10, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr4 = DllStructGetData($v_Buffer, 1)
	$ptr5 = readProcessMemory($Diablo_MemHandle, $ptr4 + 0x5C, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	Return DllStructGetData($v_Buffer, 1)
Endfunc ;==>MAP_GetPresetStructPtr

Func MAP_GetRoom1StructPtr() ;Updated
	Local $v_Buffer = DllStructCreate("dword")
	readProcessMemory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_PlayerUnit, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr1 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr1 + 0x2c, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	$ptr2 = DllStructGetData($v_Buffer, 1)
	readProcessMemory($Diablo_MemHandle, $ptr2 + 0x1c, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
	Return DllStructGetData($v_Buffer, 1)
Endfunc ;==>MAP_GetRoom1StructPtr