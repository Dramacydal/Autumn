Global $pID, $Diablo_hWnd,$__DLL_Kernel32,$Diablo_MemHandle
Global $x_Diff[2], $y_Diff[2]
Global $ITEM_Ilvl, $ITEM_Lock, $ITEM_Mouse_Lock, $Item_Boxes_Hide
Global $xy_base[2] = [408, 286] ;this defines where lines should start
Global $x_Final[2], $y_Final[2], $xy_Final[2]
Global $Coords, $coords2
Global Const $NewDiabloTitle = "[CLASS:Diablo II]" ;identifier for the window
Global Const $D2CLIENT_OFFSET = 0x6FAB0000
Global Const $D2COMMON_OFFSET =  0x6FD50000
Global Const $D2LAUNCH_OFFSET = 0x6FA40000
Global Const $D2MULTI_OFFSET = 0x6F9D0000
Global Const $D2WIN_OFFSET = 0x6F8E0000
Global Const $PEN_Colours[8] = [0xFFED1C24, 0xFFFFF200, 0xFF22B14C, 0xFF00A2E8, 0xFFA349A4, 0xFFB97A57, 0xFFFFAEC9, 0xFFC8BFE7] ;Colours for the lines drawn
Global $hPen[8] ; need one pen for each colour, i don't think there's any level in diablo II that has more than 8 entries.
Global $Warps, $Area_Old,$Area_New, $newcoords[2], $_newcoords[2], $Changed_Area, $oldcoords[2], $Xp_start
Global $LastGameName, $LastGamePass, $Level, $LastChatMsg1
Global $Xp = False
Global $Ingame, $oog = False
Global $Headerpos[2] = [118, 554]
Global $Join = False
Global $Version = "1.5.1"
Global $ilvl_Read = False
Global $Mousepos_new, $Mousepos_old
Global $a_Min = False
Global $_hGUI_About,$_hGUI_About_Graphics,$_hGUI_About_Image,$_hGui_ChildWindows, $_hGui_main
Global $hGraphic, $hEndCap
Global $Need_Config = True
Global $Trap_DO = False
Global $Trap_Enabled = False

Global $Settings_ChickenPercent, $Settings_XpCounter, $Settings_Logsettings, $Settings_Notify, $Settings_LoopDelay, $Settings_LineTrans, $Settings_Optimize
Global $Settings_Preferred_Path, $Settings_Hotkeys_CopyItem, $Settings_Hotkeys_End, $Settings_Hotkeys_ExitGame, $Settings_Hotkeys_RevealAct, $Settings_RevealOnActChange, $Settings_Hotkeys_TownChicken
Global $list, $DiabloList, $hDias
Global $starttime
Global $Settings_ExitUseThread = True
Global $ptr_Statlist
Global $tStruct
Global $Revealed_Acts[5] = [False,False,False,False,False]
Global $ChildWindows_IgnoreInput
Global $StatsBox_Labels[11][3], $Stats, $_Button, $bTPLOADED = 0

Global $List_DiabloWindows

Global $_Box_GamePass
Global $_Box_Experience
Global $_Box_IP
Global $_Box_Autumn
Global $_Box_Time
Global $_Box_IlvlTip

	Global Const $p_CurrentHp = 0x103B2D
	Global Const $p_GameInfo = 0x109738
	Global Const $p_SelItem = 0x11CB28
	Global Const $p_ItemText = 0xC9E68
	Global Const $f_SendPacket = 0x6F20
	Global Const $p_LevelId = 0x11CDE8
	Global Const $p_AutoMap = 0x11C8B8
	Global Const $p_GameListUp = 0x39E10
	Global Const $GetPlayerUnit 					= 0x613C0 ;updated
	Global Const $GetLayer 							= 0x30B00 ;updated
	Global Const $GetLevel 							= 0x6D440 ;updated
	Global Const $AddRoomData 						= 0x24990 ;updated
	Global Const $InitAutomapLayer_I 				= 0x733D0 ;updated
	Global Const $RevealAutoMapRoom 				= 0x73160 ;updated
	Global Const $InitLevel 						= 0x6DDF0 ;updated
	Global Const $LoadAct 							= 0x24810 ;updated
		Global Const $LoadAct_1 					= 0x737F0 ;updated
		Global Const $LoadAct_2 					= 0x2B420 ;updated
	Global Const $RemoveRoomData 					= 0x24930 ;updated
	Global Const $p_D2CLIENT_Difficulty 			= 0x11D1D8 ;updated
	Global Const $p_D2CLIENT_PlayerUnit 			= 0x11D050 ;updated
	Global Const $p_PlayerUnit 						= 0x11D050 ;updated
	Global Const $p_D2CLIENT_ExpCharFlag 			= 0x1087B4 ;updated
	Global Const $p_D2CLIENT_AutomapLayer 			= 0x11CF28 ;updated
	Global Const $p_ExitGame 						= 0x43870 ;updated
		Global Const $pRoutine_GetLevel				= 0x00000000		;CE10EB73 ?
		Global Const $pRoutine_Maphack 				= 0x74001350
		Global Const $pRoutine_InitAutoMap 			= 0x00000000
		Global Const $pRoutine_Maphack_begin 		= 0x00000000
		Global Const $iDataSize 					= 1024
		Global $HackStart
