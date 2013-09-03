#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Leaf.ico
#AutoIt3Wrapper_Outfile=C:\Users\Janus\Desktop\lifelifelife\AutoIt\Autumn\Autumn 1.5.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
FileInstall(".\LEAF_48.png",@ScriptDir & "\LEAF_48.png")
;#################################################
;~ AutoIt Version:  3.3.6.1
;~ Author:          Shaggi
;~ Credits:         Fuhrmanator, Rain/Polite/Butcher, Insolence, Murder567,Gnarlock,D2bs dev team.
;~ What is this? The most lightweight maphack for d2.
;~ Feautures: blablabla see readme.
;#################################################
;##################################################
;~ Includes
;##################################################
#include <Array.au3>
#include <WinApi.au3>
#include <ProcessCall.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <StaticConstants.au3>
#include <Security.au3>
#include <Misc.au3>
#include <Memory.au3>
#Include "Au.Vars.au3" ;Updated
#include "DiaAPIConstants.au3" ;Fucked
#include "Minimized.au3"
#include "AU.Levels.au3" ;Updated
#include "AU.Algorithms.au3" ;Updated
#include "AU.Memory.au3"
#include "AU.Map.au3" ;Updated
#include "AU.Char.au3" ;Updated
#include "AU.DiaApi.au3" ;Updated
#include "AU.Game.au3" ;Updated
#include "AU.Item.au3" ;Updated
#include "D2Extra.au3"
#include "Au.Sm.au3" ;Updated
#include "Au.Tp.au3"

Main()

;##################################################
;~ Main function
;##################################################
Func Main()
	;##################################################
	;~ Checks
	;##################################################
	If @OSVERSION = "WIN_XP" Then
		$Answer = MsgBox(36, "AU.Map Warning", "It seems you're runnig Au.Map under Windows Xp. Please note that Au.Map will probably be buggy. Do you want to continue?")
		If $Answer = 7 Then
			Exit
		Else
		$Xp = True
		Endif
	Endif
	;##################################################
	;~ Load up settings
	;##################################################
	ReadSettings()
	;##################################################
	;~ Parse commandline
	;##################################################
	Local $_CMDLINE = $CMDLINE
	If $_CMDLINE[0] Then
		$_D2Extra = _ArraySearch($_CMDLINE, "-D2Extra") <> -1
		$Title = "Diablo II"
		$Params = ""
		$Path = ""
		$FullPath = ""
		$BreakValue = 0
		For $i = 0 to $_Cmdline[0]
			If FileExists(StringTrimLeft($_Cmdline[$i],1)) OR FileExists($_Cmdline[$i]) Then
				$Path = StringTrimLeft($_Cmdline[$i],1)
				For $z = $i +1 to $_Cmdline[0]
					If $i <= $BreakValue Then ExitLoop
					if $_Cmdline[$z] == "-title" Then
						$Title = $_cmdline[$z+1]
						_ArrayDelete($_Cmdline,$z)
						_ArrayDelete($_Cmdline,$z)
						$_CmdLine[0] = $_CmdLine[0] -2
						$z -= 2
						$BreakValue = $_Cmdline[0] -2
					EndIf
				Next
				For $z = $i +1 to $_Cmdline[0]
					$Params &= $_Cmdline[$z] & " "
				Next
				ExitLoop
			EndIf
		Next
		If $Path Then
			$FullPath = $Path & " " & $Params
			$Splitted_string = StringSplit($FullPath,"\")
			$Path__ = ""
			$Parameters = ""
			For $i = 1 to $Splitted_string[0] -1
				$path__ &= $Splitted_string[$i] & "\"
			Next
			$olol = StringInStr($FullPath,".exe")
			If $olol Then $Parameters = StringTrimLeft($FullPath,$olol + StringLen(".exe"))
			If $_D2Extra Then
				Global $list, $DiabloList
				Global $HDias = GUICreate("Diablo II secret area")
				$List = Winlist($NewDiabloTitle)
				If $list[0][0] > 0 Then
					Global $DiabloList[$list[0][0]+1]
					$DiabloList[0] = $list[0][0]
					For $i = 1 to $list[0][0]
						$DiabloList[$i] = $list[$i][1]
					Next
				Else
					Global $DiabloList[1] = [0]
				EndIf
				CreateProcess()
				;MsgBox(0,"D2Extra",$Path__ & "Game.exe" & @CRLF & $Title & @CRLF & $Parameters)
				$tStruct = _DiaAPI_CreateDia($Path__ & "Game.exe",$Title,$Parameters,StringTrimRight($Path__,1))
				If IsDllStruct($tStruct) Then
					_WinApi_CloseHandle(DllStructGetData($tStruct,"hThread"))
					GUIDelete($hDias)
					Local $_hWnd = $DiabloList[$DiabloList[0]]
					$__DLL_Kernel32 = DllOpen("Kernel32.dll")
					Autumn(DllStructGetData($tStruct,"ProcessID"),DllStructGetData($tStruct,"hProcess"),$_hWnd)
				EndIf
			Else
				;MsgBox(0,"NOT D2Extra",$Path__ & "Game.exe" & @CRLF & $Title & @CRLF & $Parameters)
				$tStruct = CreateProcess($Path__ & "Game.exe",$Parameters,StringTrimRight($Path__,1))
				If IsDllStruct($tStruct) Then
					_WinApi_CloseHandle(DllStructGetData($tStruct,"hThread"))
					$__DLL_Kernel32 = DllOpen("Kernel32.dll")
					Autumn(DllStructGetData($tStruct,"ProcessID"),DllStructGetData($tStruct,"hProcess"),WinGetHandle($NewDiabloTitle))
				EndIf
			EndIf
		EndIf
		End()
	Else
		;##################################################
		;~ Starter
		;##################################################
		$_hGui_Main = GuiCreate("Autumn " & $version,300,220)
		$List_DiabloWindows = GUICtrlCreateList("", 88, 32, 202, 96)
		GUICtrlSetTip($List_DiabloWindows, "Select an open Diablo II window")
		$Label1 = GUICtrlCreateLabel("Specify an open Diablo II window... :", 8, 8, 177, 17)
		$Label2 = GUICtrlCreateLabel("Or open a new Diablo II instance using the following path...", 8, 170, 282, 17)
		$Input1 = GUICtrlCreateInput(_Iif($Settings_Preferred_Path,$Settings_Preferred_Path,RegRead("HKEY_CURRENT_USER\Software\Blizzard Entertainment\Diablo II", "InstallPath") & "\Diablo II.exe -w"), 8, 190, 281, 21)
		GUICtrlSetTip($Input1, "Full path with parameters")
		$Button1 = GUICtrlCreateButton("Install", 8, 32, 73, 25, $WS_GROUP)
		GUICtrlSetTip($Button1, "Hook Autumn to selected process")
		$Button4 = GUICtrlCreateButton("About", 8, 64, 73, 25, $WS_GROUP)
		$Button2 = GUICtrlCreateButton("Exit", 8, 96, 73, 25, $WS_GROUP)
		$Button3 = GUICtrlCreateButton("Run path", 8, 128, 73, 25, $WS_GROUP)
		$Button5 = GUICtrlCreateButton("Update list...", 220, 128, 73, 25, $WS_GROUP)
		$Chk_D2Extra = GuiCtrlCreateCheckBox("Use D2Extra",88,128)
		GUICtrlSetTip($Chk_D2Extra, "Open multiple Diablo II windows with this setting")
		GUICtrlSetTip($Button5, "Search for new Diablo II windows")
		GUISetState(@SW_SHOW)
		_UpdateList()
		While 1
			$nMsg = GUIGetMsg(1)
			Switch $nMsg[0]
				Case $GUI_EVENT_CLOSE
					Switch $nMsg[1]
						Case $_hGui_Main
							$Settings_Preferred_Path = GuiCtrlRead($Input1)
							IniWrite(@SCRIPTDIR & "\Settings.ini","CONFIG","Path",$Settings_Preferred_Path)
							Exit
						Case $_hGUI_About
							_DeleteAbout()
					EndSwitch
				Case $Button2
						$Settings_Preferred_Path = GuiCtrlRead($Input1)
						IniWrite(@SCRIPTDIR & "\Settings.ini","CONFIG","Path",$Settings_Preferred_Path)
					Exit
				Case $List_DiabloWindows
					$_ = StringSplit(GuiCtrlRead($List_DiabloWindows),"HWND",1)
					If NOT @Error Then
						$HWND = HWND(StringStripWs($_[2],8))
						WinActivate($HWND)
						WinActivate($_hGui_Main)
					EndIf
				Case $Button1
					If NOT GuiCtrlRead($List_DiabloWindows) Then ContinueLoop
					$_ = StringSplit(GuiCtrlRead($List_DiabloWindows),"HWND",1)
					$HWND = HWND(StringStripWs($_[2],8))
					$Diablo_hWnd = $HWND
					$pID = WinGetProcess($HWND)
					If $pID == -1 Then ContinueLoop
					$__DLL_Kernel32 = DllOpen("Kernel32.dll")
					Switch $pID
						Case DllStructGetData($tStruct,"ProcessID")
							$Diablo_MemHandle = DllStructGetData($tStruct,"hProcess")
						Case Else
							setPrivilege("SeDebugPrivilige",True) ;set debug privilegde
							$Diablo_MemHandle = openSecureProcess($pID,BitOR(0x0020,0x0010,0x0008,0x0002,0x0200,0x0400,$WRITE_DAC, $READ_CONTROL))
					EndSwitch
					$Settings_Preferred_Path = GuiCtrlRead($Input1)
					GuiDelete($_hGui_Main)
					OnAutoItExitRegister("Terminate")
					$Need_Config = False
					ExitLoop
				Case $Button3
					Switch GuiCtrlRead($Chk_D2Extra)
						Case $GUI_UNCHECKED
							$Splitted_string = StringSplit(GuiCtrlRead($Input1),"\")
							$Path__ = ""
							$Parameters = ""
							For $i = 1 to $Splitted_string[0] -1
								$path__ &= $Splitted_string[$i] & "\"
							Next
							$olol = StringInStr(GuiCtrlRead($Input1),".exe")
							If $olol Then $Parameters = StringTrimLeft(GuiCtrlRead($Input1),$olol + StringLen(".exe"))
							If NOT $Path__ OR NOT FileExists($Path__ & "\Game.exe") then
								MsgBox(16,"Autumn " & $Version,"Please type in an existing path.")
							EndIf

							$tStruct = CreateProcess($Path__ & "Game.exe",$Parameters,StringTrimRight($Path__,1))
							If IsDllStruct($tStruct) Then _WinApi_CloseHandle(DllStructGetData($tStruct,"hThread"))
							Sleep(1000)
							If WinExists("Diablo II Critical Error","Only one copy of Diablo II may run at a time.") Then
								MsgBox(16,"AU.Map WARNING", "No multiple instances allowed.")
							Else
								WinWait($NewDiabloTitle,"",2)
								_UpdateList()
							EndIf
						Case $GUI_CHECKED
							$Splitted_string = StringSplit(GuiCtrlRead($Input1),"\")
							$Path__ = ""
							$Parameters = ""
							For $i = 1 to $Splitted_string[0] -1
								$path__ &= $Splitted_string[$i] & "\"
							Next
							$olol = StringInStr(GuiCtrlRead($Input1),".exe")
							If $olol Then $Parameters = StringTrimLeft(GuiCtrlRead($Input1),$olol + StringLen(".exe"))
							$Title = "Diablo II"

							$Path__ &= "Game.exe"
							If NOT $Path__ OR NOT FileExists($Path__) Then
								MsgBox(16,"Autumn " & $Version & " :: D2Extra","Please type in an existing path" & @CRLF & " -> " & $Path__)
							EndIf
							Global $list, $DiabloList
							Global $HDias = GUICreate("Diablo II secret area")
							$List = Winlist($NewDiabloTitle)
							If $list[0][0] > 0 Then
								Global $DiabloList[$list[0][0]+1]
								$DiabloList[0] = $list[0][0]
								For $i = 1 to $list[0][0]
									$DiabloList[$i] = $list[$i][1]
								Next
							Else
								Global $DiabloList[1] = [0]
							EndIf
							$tStruct = _DiaAPI_CreateDia($Path__,$Title,$Parameters)
							If NOT IsDllStruct($tStruct) Then MsgBox(16,"Autumn " & $Version & " :: D2Extra","Something went wrong...")
							GUIDelete($hDias)
						EndSwitch
					_UpdateList()
					WinActivate($_hGui_Main)
				Case $Button4
					About()
				Case $Button5
					_UpdateList()
			EndSwitch
		WEnd
		AdlibUnregister("_UpdateList")
	EndIf
	If ($pID AND $Diablo_MemHandle) AND $Diablo_hWnd THen Autumn($pID,$Diablo_MemHandle,$Diablo_hWnd)
EndFunc



Func Autumn($ProcessID,$ProcessHandle,$ProcessWindow)
	$Diablo_MemHandle = $ProcessHandle
	$Diablp_hWnd = $ProcessWindow
	WinActivate($Diablo_hWnd)
	$pos = WinGetPos($Diablo_hWnd)
	If @error Then
		MsgBox(16, "AU.Map ERROR", "No Diablo II window found.")
		Exit
	EndIf
	Opt("WinWaitDelay", 5) ; we are gonna do a lot of window resizing etc. so lower this delay
	;##################################################
	;~ TRAYMENU
	;##################################################
	Opt("TrayMenuMode",1)	; Default tray menu items (Script Paused/Exit) will not be shown.
	Opt("TrayOnEventMode",1)
	$ITEM_ilvl	= TrayCreateItem("Enable Item lvl viewer")
	TrayCreateItem("")
	$ITEM_Lock	= TrayCreateItem("Lock Labelboxes")
	If $ChildWindows_IgnoreInput Then TrayItemSetState ($ITEM_Lock,65)
	TrayCreateItem("")
	$ITEM_Boxes_Hide = TrayCreateItem("Hide Labelboxes")
	TrayCreateItem("")
	$ITEM_Mouse_Lock = TrayCreateItem("Lock Mouse")
	TrayCreateItem("")
	$ITEM_About	= TrayCreateItem("About",-1,-1,0)
	TrayCreateItem("")
	$ITEM_Exit	= TrayCreateItem("Exit")
	TrayItemSetOnEvent ($ITEM_Exit, "End" )
	TrayItemSetOnEvent ($ITEM_About, "About")
	TrayItemSetOnEvent ($ITEM_Ilvl, "Ilvl_Viewer" )
	TrayItemSetOnEvent ($ITEM_Lock,"LockChilds")
	TrayItemSetOnEvent ($ITEM_Mouse_Lock,"Lock_Mouse")
	TrayItemSetOnEvent ($ITEM_Boxes_Hide,"Hide_Windows")
	TraySetState()
	TraySetToolTip("Autumn " & $Version & " for Diablo II")
	;##################################################
	;~ GUI
	;##################################################
	If Not IsDeclared("WM_DWMCOMPOSITIONCHANGED") Then Global Const $WM_DWMCOMPOSITIONCHANGED = 0x031E
	If $Xp Then
		$_hGui_Main = GUICreate("Au.Map", $pos[2] - 10, $pos[3] - 54, $pos[0], $pos[1], -1, BitOR($WS_EX_TOPMOST, $WS_EX_LAYERED))
	Else
		$_hGui_Main = GUICreate("Au.Map", $pos[2] - 10, $pos[3] - 54, $pos[0] + 2, $pos[1] + 24, -1, BitOR($WS_EX_TOPMOST, $WS_EX_LAYERED))
	Endif
	GUISetBkColor(0xABCDEF) ; make gui bk color transparant
	_WinAPI_SetLayeredWindowAttributes($_hGui_Main, 0xABCDEF, $Settings_LineTrans) ; set transparancy
	_WinAPI_SetWindowLong($_hGui_Main, -20, BitOR(_WinAPI_GetWindowLong($_hGui_Main, -20), 0x00000020)) ; disable user intput
	GUISetStyle($WS_POPUP, -1, $_hGui_Main) ;make gui borderless
	GUIRegisterMsg($WM_WINDOWPOSCHANGED,"ChildSizing") ;Call sizing functions for child windows
	_GDIPlus_Startup() ; initiate graphical library
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($_hGui_Main)
	$hEndCap = _GDIPlus_ArrowCapCreate (3, 6)
	For $i = 0 To 7
		$hPen[$i] = _GDIPlus_PenCreate($PEN_Colours[$i], 1)
		_GDIPlus_PenSetCustomEndCap ($hPen[$i], $hEndCap)
	Next
	OnAutoItExitRegister("Terminate")
	Opt("GuiOnEventMode",1)
	GUISetOnEvent($GUI_EVENT_CLOSE,"End",$_hGui_Main)
	;##################################################
	;~ LABELS
	;##################################################
	$_Box_Autumn = CreateLabelBox("Autumn",95, 20,$pos[0]+400-(95/2), $pos[1]+24,0xFFFFFFF,0x00000,200,"",False,"AvQest",5,-3)
	GUICtrlSetFont($_Box_Autumn[1], 16, 1200, "", "AvQest")
	If @error Then GUICtrlSetFont($_Box_Autumn[1], 16, 1200, "", "Arial")
	GUICtrlSetColor($_Box_Autumn[1], 0x948064)
	GUISetState(@SW_SHOW, $_Box_Autumn[0])
	;##################################################
	$_Box_GamePass = CreateLabelBox("",339,30,-32000,-32000,0xFFFFFFF,0x00000,200,"",False,"AvQest",5,7)
	GUICtrlSetFont($_Box_GamePass[1], 12, 600, "", "AvQest")
	If @error Then GUICtrlSetFont($_Box_GamePass[1], 12, 800, "", "Arial")
	GuiSetState(@SW_Show,$_Box_GamePass[0])
	GUICtrlSetColor($_Box_GamePass[1], 0x948064)
	;##################################################
	$_Box_IP = CreateLabelBox("",130, 20, $pos[0]+$_hGui_ChildWindows[1][1],$pos[0]+$_hGui_ChildWindows[1][2],0x948064,0x00000,150,"",NOT $ChildWindows_IgnoreInput)
	$_hGui_ChildWindows[1][0] = $_Box_IP[0]
	$_hGui_ChildWindows[1][3] = $_Box_IP[2]
	GUICtrlSetColor($_Box_IP[1], 0x948064)
	;##################################################
	$_Box_Time = CreateLabelBox("",85, 17, $pos[0]+$_hGui_ChildWindows[1][1],$pos[0]+$_hGui_ChildWindows[1][2],0x948064,0x00000,150,"",NOT $ChildWindows_IgnoreInput,"AvQest",2,2)
	$_hGui_ChildWindows[2][0] = $_Box_Time[0]
	$_hGui_ChildWindows[2][3] = $_Box_Time[2]
	;##################################################
	If $Settings_XpCounter Then
		$_Box_Experience = CreateLabelBox("",115, 70, $pos[0]+$_hGui_ChildWindows[2][1],$pos[1]+$_hGui_ChildWindows[2][2],0x948064,0x00000,150,"",NOT $ChildWindows_IgnoreInput)
		$_hGui_ChildWindows[3][0] = $_Box_Experience[0]
		$_hGui_ChildWindows[3][3] = $_Box_Experience[2]
		GUICtrlSetColor($_Box_Experience[1], 0x948064)
	Else
		$_hGui_ChildWindows[0][0] = 2
	EndIf
	;##################################################
	;~ StatBox
	;##################################################
	$ptr_Statlist = _ReadD2Memory($Diablo_MemHandle, 0x5c + _
					_ReadD2Memory($Diablo_MemHandle, $d2client + $p_Playerunit,"dword",False,$__DLL_Kernel32),"dword",False,$__DLL_Kernel32)
	Global $Stats = False
	Global $StatsBox = CreateLabelBox("",90,230, $pos[0]+775,$pos[1]+110,0x948064,0x00000,150,"",True,"AvQest",-500,-500)
	$_hGui_ChildWindows[4][0] = $StatsBox[0]
	$_hGui_ChildWindows[4][3] = $StatsBox[2]
	$_hGui_ChildWindows[4][1] = 775
	$_hGui_ChildWindows[4][2] = 110+24
	$_Button = GuiCtrlCreateButton("<<",3,3)
	GUICtrlSetFont(-1, 10, 300, "", "AvQest")
	$StatsBox_Labels[1][1] = "Stats"
	$StatsBox_Labels[2][1] = " Fcr  " ;& @TAB
	$StatsBox_Labels[3][1] = " Fhr  " ;& @TAB
	$StatsBox_Labels[4][1] = " Ias   " ;& @TAB
	$StatsBox_Labels[5][1] = " Mf   " ;& @TAB
	$StatsBox_Labels[6][1] = " Dr   " ;& @Tab
	$StatsBox_Labels[7][1] = " Fres: " ;& @TAB
	$StatsBox_Labels[8][1] = " Cres: " ;& @TAB
	$StatsBox_Labels[9][1] = " Lres: " ;& @TAB
	$StatsBox_Labels[10][1] = " PRes: " ;& @TAB
	$StatsBox_Labels[2][2] = 105
	$StatsBox_Labels[3][2] = 99
	$StatsBox_Labels[4][2] = 93
	$StatsBox_Labels[5][2] = 80
	$StatsBox_Labels[6][2] = 36
	$StatsBox_Labels[7][2] = 39
	$StatsBox_Labels[8][2] = 43
	$StatsBox_Labels[9][2] = 41
	$StatsBox_Labels[10][2] = 45
	$StatsBox_Labels[1][0] = GuiCtrlCreateLabel($StatsBox_Labels[1][1],5,30,120)
	$StatsBox_Labels[2][0] = GuiCtrlCreateLabel($StatsBox_Labels[2][1] & "0",5,50,120)
	$StatsBox_Labels[3][0] = GuiCtrlCreateLabel($StatsBox_Labels[3][1] & "0",5,70,120)
	$StatsBox_Labels[4][0] = GuiCtrlCreateLabel($StatsBox_Labels[4][1] & "0",5,90,120)
	$StatsBox_Labels[5][0] = GuiCtrlCreateLabel($StatsBox_Labels[5][1] & "0",5,110,120)
	$StatsBox_Labels[6][0] = GuiCtrlCreateLabel($StatsBox_Labels[6][1] & "0",5,130,120)
	$StatsBox_Labels[7][0] = GuiCtrlCreateLabel($StatsBox_Labels[7][1] & "0",5,150,120)
	$StatsBox_Labels[8][0] = GuiCtrlCreateLabel($StatsBox_Labels[8][1] & "0",5,170,120)
	$StatsBox_Labels[9][0] = GuiCtrlCreateLabel($StatsBox_Labels[9][1] & "0",5,190,120)
	$StatsBox_Labels[10][0] = GuiCtrlCreateLabel($StatsBox_Labels[10][1] & "0",5,210,120)
	For $i = 1 to 10
		GUICtrlSetFont($StatsBox_Labels[$i][0], 10, 600, "", "AvQest")
		If @error Then GUICtrlSetFont($StatsBox_Labels[$i][0], 10, 600, "", "Arial")
		GUICtrlSetColor($StatsBox_Labels[$i][0], 0x948064)
	Next
	WinMove($StatsBox[0],"",$pos[0]+775,$pos[1]+100,25, 35)
	GuiCtrlSetOnEvent($_Button,"Stats")

	;##################################################
	$_Box_IlvlTip = CreateLabelBox("",60, 15,-100,-100,0x948064,0x00000,200,"",False,"AvQest",0,0)
	;##################################################
	;~ General Maintenance / initiating some variables.
	;##################################################
	If $Need_Config Then
		$pID = WinGetProcess($NewDiabloTitle)
		$Diablo_hWnd = WinGetHandle($NewDiabloTitle)
		$__DLL_Kernel32 = DllOpen("Kernel32.dll")
		$Diablo_MemHandle = openSecureProcess($pID,0x001F0FFF) ;open handle to Diablo memory
		setPrivilege("SeDebugPrivilige",True) ;set debug privilegde
	EndIf
	$Mousepos_old = MouseGetPos()
	$oldcoords = CHAR_GetCoords()
	$LastChatMsg = GAME_GetLastChatMsg()
	$LastChatMsg1 = $LastChatMsg
	$Area_Old = MAP_GetArea()
	GUISetState(@SW_SHOW, $_hGui_Main)
	WinActivate($Diablo_hWnd)
	$LastGameName = GAME_GetGameName()
	$LastGamePass = GAME_GetGamePass()
	;##################################################
	;~ Registers
	;##################################################
	AdlibRegister("Resize",300)
	;GUIRegisterMsg(0x0006,"ActivateD2") ;activate Diablo when you activate Autumn
	;##################################################
	;~ Main loop.
	;##################################################
	_FileWriteLog(@ScriptDir & "\Events.log","Autumn " & $Version & " started successfully.")
	While 1
		If GAME_DetectIngame() Then
			InGame()
		Else
			OutOfGame()
		EndIf
		Sleep($Settings_LoopDelay) ; general delaying to prevent too much CPU usage lol
	Wend
EndFunc
;##################################################
;~ Function Ingame()
;~ A loop that contains everything done ingame.
;##################################################
Func Ingame()
	print("Starting in game loop")
	$nStatic = False
	$Area_Old= 0
	$ptr_Statlist = _ReadD2Memory($Diablo_MemHandle, 0x5c + _
			_ReadD2Memory($Diablo_MemHandle, $d2client + $p_Playerunit,"dword",False,$__DLL_Kernel32),"dword",False,$__DLL_Kernel32)
	$Xp_Start = _DiaAPI_GetStatValue(13,0,0,$ptr_Statlist)
	$Level = _DiaAPI_GetStatValue(12,0,0,$ptr_Statlist)
	$LastGameName = GAME_GetGameName()
	$LastGamePass = GAME_GetGamePass()
	$OMG = 0
	$OOG = False
	ActivateChilds()
	GuiSetState(@SW_Hide,$_Box_GamePass[1])
	$Headerpos[0] = 118
	$headerpos[1] = 554
	$ingame = True
	$Starttime = TimerInit()
	$oldcoords[0] = 0
	$oldcoords[1] = 0
	AdlibRegister("Delayed_Settings",1000)
	If $Settings_Logsettings Then
		_FileWriteLog(@ScriptDir & "\Messages.log", @CRLF ,-1,False)
		_FileWriteLog(@ScriptDir & "\Messages.log","#####################################",-1,False)
		_FileWriteLog(@ScriptDir & "\Messages.log", @CRLF)
		_FileWriteLog(@ScriptDir & "\Messages.log", "Joined the game: " & $LastGameName & "//" & $LastGamePass ,-1,False)
		_FileWriteLog(@ScriptDir & "\Messages.log", "Realm: " & CHAR_GetRealm(),-1,False)
		_FileWriteLog(@ScriptDir & "\Messages.log", "Server Ip: " & GAME_GetServerIp(),-1,False)
		_FileWriteLog(@ScriptDir & "\Messages.log", "Character: " & CHAR_GetName(),-1,False)
		_FileWriteLog(@ScriptDir & "\Messages.log", "Account: " & CHAR_GetAccount(),-1,False)
		_FileWriteLog(@ScriptDir & "\Messages.log","#####################################",-1,False)
	EndIf
	For $i = 0 to 4
		$Revealed_Acts[$i] = False
	Next
	ForceResize()
	WriteIp()
	Hotkeys(TRUE)
	Do
		If TimerDiff($StartTime) > 5000 Then
			$Area_NEW = Map_GetQuickArea()
		Else
			$Area_new = MAP_GetArea()
		EndIf
		#Region LineDraw
		Switch IsTown($Area_new)
			Case False
				$_NewCoords = CHAR_GetPathedCoords()
				$Changed_Area = ($Area_New <> $Area_Old) OR NOT $_NewCoords[1] > 1000
				If Difference($_newcoords[0],$_newcoords[1],$oldcoords[0],$oldcoords[1],5)  OR $Changed_Area Then
					$newcoords = CHAR_GetCoords()
					If Difference($newcoords[0],$newcoords[1],$oldcoords[0],$oldcoords[1],3)  OR $Changed_Area Then
						;#####################################
						;~ This is where the linedrawing is done. However, lines are only redrawn if you're ingame, and if you're out of town, and if you changed your position with over 4 coords.
						;~ Besides, new warps are only read if you changed area.
						;#####################################
						If $Area_New <> $Area_Old Then
							$Area_Old = $Area_New
							$Warps = MAP_GetWarpPoints()
						Endif
						ReDraw($Warps)
						$oldcoords = $newcoords
					EndIf
				EndIf
				#EndRegion LineDraw
				Sleep($Settings_LoopDelay/3)
				;#####################################
				;~ Chickensection
				;#####################################
				#region Chicken
				If $Settings_ChickenPercent <> -1 Then
					$Currentlife = CHAR_GetCurrentHp()
					If $Currentlife > 0 Then
						$MaxLife = _DiaAPI_GetStatValue(7,1,0,$ptr_Statlist)
						$LifePercent = Round(($Currentlife / $MaxLife), 3) * 100
						;ToolTip("calculating life percent: " & $LifePercent & @CRLF & "Chickenpercent: " & $Settings_ChickenPercent & @CRLF & "MAXLIFE: " & $Maxlife & @CRLF & "Currentlife: " & $Currentlife & @CRLF,0,0)
						If (($Settings_ChickenPercent > $LifePercent) AND ($lifepercent > 0)) Then
							print("Chickening on "&  $lifepercent)
							exitGame() ;exit game
							;Log chicken
							_FileWriteLog(@ScriptDir & "\Events.log", "Game: " & $LastGameName & "-> Chickened on lifepercent " & $LifePercent & "%. Remaining life was " & $Currentlife & ".")
							;Delete lines
							GUISetBkColor(0xABCDEF, $_hGui_Main)
						EndIf
					EndIf
				EndIf
			Case Else
				GUISetBkColor(0xABCDEF, $_hGui_Main)
				Sleep(400) ;delaying and deleting lines because nn quick responses in town
		EndSwitch
		#EndRegion Chicken
		Sleep($Settings_LoopDelay/3)
		;#####################################
		;~ Here you can do specific ingame stuff
		;#####################################
		#region Messages
		If $Settings_Logsettings Then
			$LastChatMsg = GAME_GetLastChatMsg()
			If $LastChatMsg <> $LastChatMsg1 Then
				$LastChatMsg1 = $LastChatMsg
				If $LastChatMsg1 <> "" Then
					_FileWriteLog(@ScriptDir & "\Messages.log",@tab & "• " &  $LastChatMsg1,-1,False)
					If $Settings_Notify Then
						If NOT WinActive($Diablo_hWnd) Then
							If StringInStr($LastChatMsg,"Diablo's minions grow stronger") Then
								$Player = StringSplit($LastChatMsg,"(")
								$Account = StringSplit($player[2],")")
								$Message = "Player " & $Player[1] & " *" & $Account[1] & " joined your game: " & $LastGameName
								Traytip("Autumn",$message,5)
							ElseIf StringInStr($LastChatMsg,"Diablo's minions weaken") Then
								$Player = StringSplit($LastChatMsg,"(")
								$Account = StringSplit($player[2],")")
								$Message = "Player " & $Player[1] & " *" & $Account[1] & " left your game: " & $LastGameName
								Traytip("Autumn",$message,5)
							Else
								$Message = $LastChatMsg
								Traytip("Autumn",$message,5)
							EndIf
						Endif
					Endif
				EndIf
			EndIf
		EndIf
		#Endregion messages
		#Region MapHack
		If $Settings_RevealOnActChange Then
			If TimerDiff($StartTime) > 2000 Then
				If NOT $Revealed_Acts[MAP_GetActByArea($Area_NEW)-1] Then
					BlockInput(1)
					RevealAct()
					For $i = 0 to 3
						BlockInput(0)
					Next
					$Revealed_Acts[MAP_GetActByArea($Area_NEW)-1] = True
				EndIf
			EndIf
		EndIf
		#EndRegion Maphack
		Sleep($Settings_LoopDelay/3)
	Until NOT GAME_DetectIngame()
	;#####################################
	;~ This section gets called upon gameleave. Delete labels and such here
	;#####################################
	If $Settings_XpCounter Then GUICtrlSetData($_Box_Experience[1], "")
	GUICtrlSetData($_Box_IP[1], "")
	AdlibUnRegister("Delayed_Settings")
	DeactivateChilds()
	GUISetBkColor(0xABCDEF, $_hGui_Main)
	If $Settings_Logsettings Then
		_FileWriteLog(@ScriptDir & "\Messages.log","Left game: " & $LastGameName & "//" & $LastGamePass)
		_FileWriteLog(@ScriptDir & "\Messages.log", @CRLF ,-1,False)
	EndIf
EndFunc
;##################################################
;~ Function OutOfGame()
;~ A loop that contains everything done out of game.
;##################################################
Func OutOfGame()
	print("Starting out of game loop")
	$headerpos[0] = 400-(95/2)
	$headerpos[1] = 24
	Sleep(500)
	GUISetBkColor(0xABCDEF, $_hGui_Main)
	$oog = True
	GuiSetState(@SW_show,$_Box_GamePass[1])
	ForceResize()
	Hotkeys(FALSE)
	Do
	;#####################################
	;~ Here you can do specific out-of-game stuff
	;#####################################
		If _ReadD2Memory($Diablo_MemHandle, $D2MULTI_OFFSET + $p_GameListUp,"dword",False,$__DLL_Kernel32) = 3 Then
			$Join = True
		Else
			$Join = False
		Endif
		WriteGameInfo()
		Sleep(300); delaying oog because nn quick responses here.
	Until GAME_DetectIngame()
	$oog = False
Endfunc
;##################################################
;~ Function Resize()
;~ Resizes the gui.
;##################################################
Func Resize()
	$pos = WinGetPos($_hGui_Main)
	$pos1 = WinGetPos($Diablo_hWnd)
	$pos_old = $pos1
	If @error Then
		AdlibUnregister("Resize")
		For $i = 0 to 5
			BlockInput(0)
		Next
		MsgBox(16, "ERROR", "No diablo window found.")
		Exit
	EndIf
	If WinActive($Diablo_hWnd) Then
		If (($pos1[0]+ 2 <> $pos[0]) OR ($pos1[1]+ 24 <> $pos[1])) Then
			$pos = $pos1
			If $Xp == True Then
				WinMove($_hGui_Main, "", $pos1[0], $pos1[1])
				For $i = 1 to $_hGui_ChildWindows[0][0]
					WinMove($_hGui_ChildWindows[$i][0], "", $pos1[0]+$_hGui_ChildWindows[$i][1],$pos1[1]+$_hGui_ChildWindows[$i][2])
				Next
				WinMove($_Box_Autumn[0],"",$pos1[0]+$headerpos[0], $pos1[1]+$headerpos[1])
			Else
				WinMove($_hGui_Main, "", $pos1[0] + 2, $pos1[1] + 24)
				For $i = 1 to $_hGui_ChildWindows[0][0]
					If IsHWnd($_hGui_ChildWindows[$i][0]) Then WinMove($_hGui_ChildWindows[$i][0], "", $pos1[0]+$_hGui_ChildWindows[$i][1],$pos1[1]+$_hGui_ChildWindows[$i][2])
				Next
				WinMove($_Box_Autumn[0],"",$pos1[0]+$headerpos[0], $pos1[1]+$headerpos[1])
				If $Oog Then
					If $Join Then
						WinMove($_Box_GamePass[0],"",$pos1[0]+428,$pos1[1]+180)
					Endif
				Endif
			Endif
		Endif
		IF $Trap_Enabled Then
			If NOT $Trap_Do Then
				print("trapping mouse")
				_MouseTrap($pos1[0]+4, $pos1[1]+25, $pos1[0] + $pos1[2]-4, $pos1[1] + $pos1[3]-4)
				$Trap_DO = True
			EndIf
			If (($pos_old[0] <> $pos1[0]) OR ($pos_old[1] <> $pos1[1])) Then
				print("retrapping mouse")
				$pos_old = $pos1
				_MouseTrap($pos1[0], $pos1[1], $pos1[0] + $pos1[2], $pos1[1] + $pos1[3])
				$Trap_DO = True
			EndIf
		EndIf
	Else
		Local $Search
		Local $_Hwnd = WinGetHandle("[ACTIVE]")
		For $i = 1 to $_hGui_childwindows[0][0]
			If $_Hwnd == $_hGui_childwindows[$i][0] Then $Search = True
		Next

		If ((-32000 <> $pos[0]) OR (-32000 <> $pos[1])) AND NOT $Search Then ; only minimize them if they arent minimized
			WinMove($_hGui_Main, "", -32000, -32000)
			For $i = 1 to $_hGui_ChildWindows[0][0]
				WinMove($_hGui_ChildWindows[$i][0], "", -32000, -32000)
			Next
			WinMove($_Box_Autumn[0],"",-32000,-32000)
			$pos[0] = -32000
			$pos[1] = -32000
			WinMove($_Box_GamePass[0],"",-32000,-32000)
		Endif
		If $trap_enabled Then
			If $Trap_DO Then
				print("untrapping mouse")
				_MouseTrap()
				$Trap_Do = False
			EndIf
		EndIf
	Endif
EndFunc
;##################################################
;~ Function Resize()
;~ Resizes the gui.
;##################################################
Func ForceResize()
	$pos = WinGetPos($_hGui_Main)
	$pos1 = WinGetPos($Diablo_hWnd)
	$pos_old = $pos1
	If @error Then
		AdlibUnregister("Resize")
		For $i = 0 to 5
			BlockInput(0)
		Next
		MsgBox(16, "ERROR", "No diablo window found.")
		Exit
	EndIf
	If WinActive($Diablo_hWnd) Then
		$pos = $pos1
		If $Xp == True Then
			WinMove($_hGui_Main, "", $pos1[0], $pos1[1])
			For $i = 1 to $_hGui_ChildWindows[0][0]
				WinMove($_hGui_ChildWindows[$i][0], "", $pos1[0]+$_hGui_ChildWindows[$i][1],$pos1[1]+$_hGui_ChildWindows[$i][2])
			Next
			WinMove($_Box_Autumn[0],"",$pos1[0]+$headerpos[0], $pos1[1]+$headerpos[1])
		Else
			WinMove($_hGui_Main, "", $pos1[0] + 2, $pos1[1] + 24)
			For $i = 1 to $_hGui_ChildWindows[0][0]
				If IsHWnd($_hGui_ChildWindows[$i][0]) Then WinMove($_hGui_ChildWindows[$i][0], "", $pos1[0]+$_hGui_ChildWindows[$i][1],$pos1[1]+$_hGui_ChildWindows[$i][2])
			Next
			WinMove($_Box_Autumn[0],"",$pos1[0]+$headerpos[0], $pos1[1]+$headerpos[1])
			If $Oog == True Then
				If $Join == True Then
					WinMove($_Box_GamePass[0],"",$pos1[0]+428,$pos1[1]+180)
				Endif
			Endif
		Endif
		IF $Trap_Enabled Then
			If NOT $Trap_Do Then
				print("trapping mouse")
				_MouseTrap($pos1[0]+4, $pos1[1]+25, $pos1[0] + $pos1[2]-4, $pos1[1] + $pos1[3]-4)
				$Trap_DO = True
			EndIf
			If (($pos_old[0] <> $pos1[0]) OR ($pos_old[1] <> $pos1[1])) Then
				print("retrapping mouse")
				$pos_old = $pos1
				_MouseTrap($pos1[0], $pos1[1], $pos1[0] + $pos1[2], $pos1[1] + $pos1[3])
				$Trap_DO = True
			EndIf
		EndIf
	Else
		If ((-32000 <> $pos[0]) OR (-32000 <> $pos[1])) Then ; only minimize them if they arent minimized
			WinMove($_hGui_Main, "", -32000, -32000)
			For $i = 1 to $_hGui_ChildWindows[0][0]
				WinMove($_hGui_ChildWindows[$i][0], "", -32000, -32000)
			Next
			WinMove($_Box_Autumn[0],"",-32000,-32000)
			$pos[0] = -32000
			$pos[1] = -32000
			WinMove($_Box_GamePass[0],"",-32000,-32000)
		Endif
		If $trap_enabled Then
			If $Trap_DO Then
				print("untrapping mouse")
				_MouseTrap()
				$Trap_Do = False
			EndIf
		EndIf
	Endif
EndFunc
;##################################################
;~ Function Redraw()
;~ Redraws lines on the gui.
;##################################################
Func Redraw($Warps)
	GUISetBkColor(0xABCDEF,$_hGui_Main)
	If MAP_GetAutomapToggled() THen
		If $Warps = False Then Return False
		If IsArray($Warps) = 0 Then Return False
		For $i = 0 to ($Warps[2][0] - 1)
			$Coords = Conv_CoordToPixel($newcoords,$Warps[0][$i], $Warps[1][$i],True)
			_GDIPlus_GraphicsDrawLine($hGraphic, $xy_base[0],$xy_base[1], $Coords[0], $Coords[1], $hPen[$i])
		Next
	Endif
EndFunc   ;==>Redraw

;##################################################
;~ Function Terminate()
;~ Cleans up GDI+ resources + some stuff
;##################################################
Func Terminate()
	If $Settings_Hotkeys_TownChicken <> -1 Then ProcCallBackFree($stdpacket)
	Iniwrite(@Scriptdir & "\Settings.ini","CHILDWINDOWS","amount",3)
	Iniwrite(@ScriptDir & "\Settings.ini","CHILDWINDOWS","Lock",$ChildWindows_IgnoreInput)
	IniWrite(@SCRIPTDIR & "\Settings.ini","CONFIG","Path",$Settings_Preferred_Path)
	For $i = 1 to $_hGui_ChildWindows[0][0]
		Iniwrite(@Scriptdir & "\Settings.ini","CHILDWINDOWS","hwnd" & $i & "prefpos.x",$_hGui_ChildWindows[$i][1])
		Iniwrite(@Scriptdir & "\Settings.ini","CHILDWINDOWS","hwnd" & $i &"prefpos.y",$_hGui_ChildWindows[$i][2])
	Next
	For $i = 0 to ubound($hPen) -1
		_GDIPlus_PenDispose($hPen[$i])
	Next
	_GDIPlus_ArrowCapDispose($hEndCap)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	closeProcess($Diablo_MemHandle)
	DllClose($__DLL_Kernel32)
	setPrivilege("SeDebugPrivilege",False)
	_MouseTrap()
	_FileWriteLog(@ScriptDir & "\Events.log","Autumn " & $Version & " stopped successfully.")
	print(@CRLF & "TERMINATED SUCCESSFULLY")
EndFunc   ;==>Terminate

;##################################################
;~ Function End()
;~ Exits. Called by hotkey or GuiRegisterEvent($GUI_EVENT_CLOSE..)
;##################################################
Func End()
	Exit
EndFunc   ;==>End

Func _End()
	If NOT WinActive($Diablo_hWnd) Then Return
	Exit
EndFunc   ;==>End

;##################################################
;~ Function exitGame($Diablo_MemHandle)
;~ Exits a game.
;##################################################
Func exitGame()
	If NOT GAME_DetectIngame() Then Return False
	If $Settings_ExitUseThread Then
		Local $Thread = CreateRemoteThread($Diablo_MemHandle,0,0,$D2client + $p_ExitGame,0,0,0)
		_WinAPI_WaitForSingleObject($Thread,20000)
		_WinAPI_CloseHandle($Thread)
		Sleep(2000)
		Return True
	Else
		BlockInput(1) ; blocking userinput to avoid userinput to screw up
		Do
			While _ReadD2Memory($Diablo_MemHandle,0x6FA91270,"dword",False,$__DLL_Kernel32) > 0 ; if any screens are opened (like questpage, inventory etc) this will have a value greater than 0. So, send esc untill 0
				_SendMinimized($Diablo_hWnd, "{Esc}")
				Sleep(50)
			Wend
			_SendMinimized($Diablo_hWnd, "{Esc}")
			Sleep(100)
			_MouseClickMinimized($Diablo_hWnd, "Left", 392, 265, 1)
			$Currentlife = CHAR_GetCurrentHp()
			If $Currentlife = 0 Then
				ExitLoop
			EndIf
			$MaxLife = _DiaAPI_GetStatValue(7,1)
			$LifePercent = Round(($Currentlife / $MaxLife), 3) * 100
			If $Settings_ChickenPercent > $LifePercent Then
				ExitLoop
			Endif
			Sleep(500)
		Until NOT GAME_DetectIngame()
		For $i = 0 to 5
			BlockInput(0) ; unblocking, and be sure to do it!
			Sleep(100)
		Next
	EndIf
EndFunc   ;==>End
;##################################################
;~ Function WriteGameName()
;~ Writes previous game + pass in the join screen.
;##################################################
Func WriteGameInfo()
	If $Join Then
		$msg = $LastGameName & "   //   " & $LastGamePass
		If $msg <> GUICtrlRead($_Box_GamePass[1]) Then GUICtrlSetData($_Box_GamePass[1], $msg)
		$_Pos = WinGetPos($_Box_GamePass[0])
		$pos1 = WinGetPos($Diablo_hWnd)
		If WinActive($Diablo_hWnd) Then
			If ((-32000 == $_pos[0]) OR (-32000 == $_pos[1])) Then WinMove($_Box_GamePass[0],"",$pos1[0]+428,$pos1[1]+180)
		Else
			If ((-32000 <> $_pos[0]) OR (-32000 <> $_pos[1])) Then WinMove($_Box_GamePass[0],"",-32000,-32000)
		EndIf
	Else
		WinMove($_Box_GamePass[0],"",-32000,-32000)
	EndIf
EndFunc   ;==>WriteGameInfo

;##################################################
;~ Function WriteIp($pID)
;~ Writes current ip in corrosponding box.
;##################################################
Func WriteIp()
	$ServerIp = GAME_GetServerIp()
	If $ServerIp <> GUICtrlRead($_Box_IP[1]) Then GUICtrlSetData($_Box_IP[1], $ServerIp)
EndFunc   ;==>WriteIp
;##################################################
;~ Function WriteIp($pID)
;~ Writes current ip in corrosponding box.
;##################################################
Func WriteTime()
	$CurrentTime = GetFormattedTimeDiff($Starttime)
	If $CurrentTime <> GuiCtrlRead($_Box_Time[1]) Then GuiCtrlSetData($_Box_Time[1],$CurrentTime)
EndFunc   ;==>WriteIp

;##################################################
;~ Function WriteXp()
;~ Writes some experience related info in corrosponding box
;##################################################
Func WriteXp()
	If $Settings_XpCounter Then
		Local $XP_Current,$level_new,$xp_games,$xp_needed,$xp_earned,$msg
		$Xp_current = _DiaAPI_GetStatValue(13,0,0,$ptr_Statlist)
		$Level_New = _DiaAPI_GetStatValue(12,0,0,$ptr_Statlist)
		if $Level_New <> $Level Then ;; GZ LEVEL UP
			If NOT $Level_New then Return
			If $Level_New = -1 then Return
			$Level = $Level_New
			$Xp_Start = $Level_Pop[$level]
		Endif
		If $Level_New >= 99 Then
			$Xp_games = -1
		Else
			$Xp_Needed = $Level_Pop[$level+1]
			$Xp_Earned = $Xp_Current - $Xp_Start
		EndIf
		If $Xp_Earned = 0 Then
			$Xp_Games = -1
		Else
			$Xp_Games = Ceiling(($Xp_Needed - $Xp_Current) / $Xp_Earned)
		Endif
		$msg = "Earned Xp: " & @CRLF &  $Xp_Earned & @CRLF _
		& "Games till lvl: " & @CRLF & $Xp_Games
		If $msg <> GUICtrlRead($_Box_Experience[1]) Then GUICtrlSetData($_Box_Experience[1], $msg)
	EndIf
EndFunc   ;==>WriteIp

;##################################################
;~ Function Delayed_Settings($pID)
;~ This gets called every ~ 1000 ms.
;##################################################
Func Delayed_Settings()
	WriteXp()
	WriteTime()
EndFunc   ;==>Delayed_Settings

;##################################################
;~ Function IsTown()
;~ Returns true if in town, else false
;##################################################
Func IsTown($Area)
	Select
		Case $Area = 1
			Return True
		Case $Area = 40
			Return True
		Case $Area = 75
			Return True
		Case $Area = 103
			Return True
		Case $Area = 109
			Return True
		Case Else
			Return False
	EndSelect
	Return False
EndFunc   ;==>IsTown

;##################################################
;~ Function _FileWriteLog($sLogPath, $sLogMsg, $iFlag = -1)
;~ Only func i used from File.au3, so figured i might aswell put it here?
;##################################################
Func _FileWriteLog($sLogPath, $sLogMsg, $iFlag = -1,$timedate = True)
	If $timedate then
		Local $iOpenMode = $FO_APPEND
		Local $sDateNow = @YEAR & "-" & @MON & "-" & @MDAY
		Local $sTimeNow = @HOUR & ":" & @MIN & ":" & @SEC
		Local $sMsg = $sDateNow & " " & $sTimeNow & " : " & $sLogMsg
	Else
		Local $iOpenMode = $FO_APPEND
		$sMsg = $sLogMsg
	Endif
	If $iFlag <> -1 Then
		$sMsg &= @CRLF & FileRead($sLogPath)
		$iOpenMode = $FO_OVERWRITE
	EndIf
	Local $hOpenFile = FileOpen($sLogPath, $iOpenMode)
	If $hOpenFile = -1 Then Return SetError(1, 0, 0)
	Local $iWriteFile = FileWriteLine($hOpenFile, $sMsg)
	Local $iRet = FileClose($hOpenFile)
	If $iWriteFile = -1 Then Return SetError(2, $iRet, 0)
	Return $iRet
EndFunc   ;==>_FileWriteLog

;##################################################
;~ Function WinActive()
;~ Returns true if the selected hWnd is active.
;##################################################
Func IsActive($handle)
	If BitAnd( WinGetState($handle), 8) Then
		Return True
	Else
		Return False
	EndIf
EndFunc		;==>IsActive
;##################################################
;~ Function CreateLabelBox()
;~ Creates a d2-styled window that you can draw information in.
;~ Returns an array, where
;~ [0] = hWnd to the newly created window
;~ [1] = Handle to the text control
;~ [2] = information about the old style, if userinput = True
;##################################################
Func CreateLabelBox($Text,$x = 100,$y = 100,$xpos = 0,$ypos = 0,$textcolor = 0xFFFFFFF,$boxcolor = 0x00000,$trans = 150,$Title = "",$userinput = True,$_Box_Autumn = "AvQest", $offsetx = 5, $offsety = 5,$style = 0x0)
	Local $Return[3]
	$return[0] = GuiCreate($Title,$x,$y,$xpos,$ypos,$WS_PopUp,BitOR($WS_EX_CLIENTEDGE,$WS_EX_LAYERED,$WS_EX_TOPMOST,$WS_EX_TOOLWINDOW,$Style))
	$return[1] = GUICtrlCreateLabel($Text,$offsetx,$offsety, $x, $y, -1, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetColor ($return[1],$textcolor)
	GUICtrlSetFont($return[1], 10, 800, "", $_Box_Autumn)
	If @Error Then
		GUICtrlSetFont($return[1], 10, 800, "", "Arial")
	Endif
	GuiSetBkColor($boxcolor,$return[0])
	_WinAPI_SetLayeredWindowAttributes($return[0], 0xABCDEF,$trans) ; set transparancy
	$return[2] = _WinAPI_GetWindowLong($return[0], -20)
	If NOT $Userinput Then
		_WinAPI_SetWindowLong($return[0], -20, BitOR(_WinAPI_GetWindowLong($return[0], -20), 0x00000020)) ; disable user intput
	Endif
	Return $return
Endfunc	;==>CreateLabelBox

;##################################################
;~ Function ChildSizing()
;~ This gets called by WM_WINDOWPOSCHANGED. This changes the relative preffered position of the childwindows, when they get resized.
;##################################################
Func ChildSizing($hWnd, $Msg, $wParam, $lParam)
	If $hWnd = $_hGui_Main Then Return
	If $ChildWindows_IgnoreInput Then Return
	Local $pos_Child,$pos_Dia
	Local $Count = False
	For $i = 1 to $_hGui_ChildWindows[0][0]
		If $hWnd = $_hGui_ChildWindows[$i][0] Then
			$Count = $i
			ExitLoop
		EndIf
	Next
	$pos_Dia = WinGetPos($Diablo_hWnd)
	If @error Then
		AdlibUnregister("Resize")
		For $i = 0 to 5
			BlockInput(0)
		Next
		MsgBox(16, "ERROR", "No diablo window found.")
		Exit
	EndIf
	If $Count Then
		$pos_Child = WinGetPos($_hGui_ChildWindows[$Count][0])
		If (($POS_Child[0] < -4000) or($pos_child[1] < -4000)) Then Return
		$_hGui_ChildWindows[$Count][1] = $pos_Child[0] - $pos_Dia[0]
		$_hGui_ChildWindows[$Count][2] = $pos_Child[1] - $pos_Dia[1]
	EndIf
Endfunc ;==>ChildSizing
;##################################################
;~ Function ActivateChilds()
;~ Activates all of the child windows found in the array $_hGui_ChildWindows
;##################################################
Func ActivateChilds()
	For $i = 1 to $_hGui_ChildWindows[0][0]
		GuiSetState(@SW_SHOW,$_hGui_ChildWindows[$i][0])
	Next
	WinActivate($Diablo_hWnd)
Endfunc	;==>ActivateChilds
;##################################################
;~ Function DeactivateChilds()
;~ Deactivates all of the child windows found in the array $_hGui_ChildWindows
;##################################################
Func DeactivateChilds()
	For $i = 1 to $_hGui_ChildWindows[0][0]
		GuiSetState(@SW_HIDE,$_hGui_ChildWindows[$i][0])
	Next
	WinActivate($Diablo_hWnd)
Endfunc	;==>DeactivateChilds
;##################################################
;~ Function Ilvl_Viewer()
;~ This enables the Ilvl read feature.
;##################################################
Func Ilvl_Viewer()
	If TrayItemGetState ($ITEM_Ilvl) = 65 Then
		GuiSetState(@SW_Show,$_Box_IlvlTip[0])
		AdlibRegister("ToolTip_Ilvl",40)
	Else
		AdlibUnRegister("ToolTip_Ilvl")
		GuiSetState(@SW_HIDE,$_Box_IlvlTip[0])
	EndIf
Endfunc	;==>Ilvl_Viewer
;##################################################
;~ Function About()
;~ Displays some info
;##################################################
Func About()
	$_hGUI_About = GUICreate("Autumn - About", 250, 250, 444, 218,-1, BitOR($WS_EX_WINDOWEDGE,$WS_EX_TOPMOST,$WS_EX_TOOLWINDOW,$WS_EX_LAYERED))
	_WinAPI_SetLayeredWindowAttributes($_hGUI_About, 0xABCDEF,230) ; set transparancy
	Local $Msg = _
	"System info:" & @CRLF & "CPU arch: " & @CPUArch & @CRLF & "OS arch: " & @OSArch & @CRLF & "OS: " & @OSVersion & @CRLF
	$About_Font = GUICtrlCreateLabel("Autumn Version " & $Version,5,5,251)
	GuiCtrlSetFont($About_Font,14)
	GuiCtrlCreateLabel('', 5, 30,245, 2, $SS_SUNKEN)
	GuiCtrlCreateLabel("- Created by Shaggi",5,40)
	GuiCtrlCreateLabel($msg,5,55,245,55,$SS_SUNKEN)
	GuiCtrlCreateLabel('', 5, 120,245, 2, $SS_SUNKEN)
	GuiCtrlCreateLabel("Autumn is an open source vectorhack for Diablo II, written in AutoIt. If you like it, feel free to donate ""cancerbits"" @ D2jsp.",5,140,245,40)
	GUISetState(@SW_SHOW,$_hGUI_About)
	If $giGDIPRef == 0 Then
		_GDIPlus_Startup()
		OnAutoItExitRegister("_GDIPlus_ShutDown")
	EndIf
	$_hGUI_About_Graphics = _GDIPlus_GraphicsCreateFromHWND($_hGUI_About)
	$_hGUI_About_Image = _GDIPlus_BitmapCreateFromFile(@ScriptDir & "\LEAF_48.png")
	_GDIPlus_GraphicsDrawImage($_hGUI_About_Graphics, $_hGUI_About_Image, 200, 200)
	GUISetOnEvent($GUI_EVENT_CLOSE,"_DeleteAbout",$_hGUI_About)
Endfunc ;==>About
;##################################################
;~ Function ToolTip_Ilvl()
;~ This, if an item is selected, creates a small tooltip which shows the ilvl.
;##################################################
Func ToolTip_Ilvl()
	$Mousepos_new = MouseGetPos()
	If (($Mousepos_new[0] <> $Mousepos_old[0]) OR  ($Mousepos_new[1] <> $Mousepos_old[1])) Then
		$Mousepos_old = $Mousepos_new
		Local $WinPos = WinGetPos($_Box_IlvlTip[0])
		$ilvl = ITEM_GetIlvl()
		If NOT $ilvl Then
			If ((-32000 <> $WinPos[0]) OR (-32000 <> $WinPos[1])) Then Winmove($_Box_IlvlTip[0],"",-32000,-32000)
		Else
			$Msg = "Ilvl: " & $ilvl
			GuiCtrlSetData($_Box_IlvlTip[1],$msg)
			If (($Mousepos_old[0]+15 <> $WinPos[0]) OR ($Mousepos_old[1]+15 <> $WinPos[1])) Then WInMove($_Box_IlvlTip[0],"",$Mousepos_old[0]+15,$Mousepos_old[1]+15)
		Endif
	Endif
Endfunc	;==>ToolTip_Ilvl

Func ActivateD2($hWnd)
	Switch $hWnd
		Case $_hGui_Main
			WinActivate($Diablo_hWnd)
	EndSwitch
Endfunc

Func _DeleteAbout()
	_GDIPlus_GraphicsDispose($_hGUI_About_Graphics)
	_GDIPlus_BitmapDispose($_hGUI_About_Image)
	GuiDelete($_hGUI_About)
EndFunc

Func CopyItem()
	If NOT WinActive($Diablo_hWnd) Then Return
	Local $sztext, $sz_split
	$sztext = getText(True)
	If StringLen($sztext) < 5 Then Return
	$sz_Split = StringSplit($sztext,@CR)
	local $szItem
	$szItem = DelCCode($sz_Split[1]) & @CRLF
	For $i = 2 to $sz_Split[0]
		If StringInStr($sz_Split[$i],"ÿc") > 0 Then
			$szItem &= DelCCode($sz_Split[$i]) & @CRLF
		Else
			$szItem &= $sz_Split[$i] & @CRLF
		EndIf
	Next
	ClipPut($szItem)
	TrayTip("Autumn","Copied item " & DelCCode($sz_Split[1]) & " to clipboard",10)
	Sleep(2000)
EndFunc

;##################################################
;~ Function Ilvl_Viewer()
;~ This enables the Ilvl read feature.
;##################################################
Func LockChilds()
	If TrayItemGetState ($ITEM_Lock) = 65 Then
		$ChildWindows_IgnoreInput = True
		For $i = 1 to $_hGui_ChildWindows[0][0]
			_WinAPI_SetWindowLong($_hGui_ChildWindows[$i][0], -20, BitOR(_WinAPI_GetWindowLong($_hGui_ChildWindows[$I][0], -20), 0x00000020)) ; disable user intput
		Next
	Else
		$ChildWindows_IgnoreInput = False
		For $i = 1 to $_hGui_ChildWindows[0][0]
			_WinAPI_SetWindowLong($_hGui_ChildWindows[$i][0], -20,$_hGui_ChildWindows[$i][3]) ;Enable user intput
		Next
	EndIf
Endfunc	;==>LockChilds

;##################################################
;~ Function Hide_Windows()
;~ This hides or activates child windows
;##################################################
Func Hide_Windows()
	If TrayItemGetState ($ITEM_Boxes_Hide) = 65 Then
		DeactivateChilds()
	Else
		ActivateChilds()
	EndIf
Endfunc	;==>LockChilds

Func print($msg = @CRLF)
	If $msg = "" then Return
	Consolewrite($msg & @CRLF)
EndFunc

Func Lock_Mouse()
	If TrayItemGetState ($ITEM_Mouse_Lock) == 65 Then
		$pos = WinGetPos($Diablo_hWnd)
		MouseMove($pos[0]+($pos[2]/2),$pos[1]+($pos[3]/2),0)
		$Trap_Enabled = True
		WinActivate($Diablo_hWnd)
	Else
		$Trap_Enabled = False
	EndIf
EndFunc

Func GetFormattedTimeDiff($Starttime)
	Local $seconds = "00", $minutes = "00", $hours = "00", $difference_ms
	$difference_ms = TimerDiff($starttime)
	Select
		Case ($difference_ms / 3600000) >= 1 ;; Hours passed
			$remaining_ms_from_hour = Mod($difference_ms,3600000)
			$remaining_ms_from_hour_from_min = Mod($remaining_ms_from_hour,60000)
			$seconds = String(Floor($remaining_ms_from_hour_from_min / 1000))
			$minutes = String(Floor($remaining_ms_from_hour / 60000))
			$hours = String(Floor($difference_ms / 3600000))
			If StringLen($seconds) == 1 Then $Seconds = "0" & $Seconds
			If StringLen($minutes) == 1 Then $minutes = "0" & $minutes
			If StringLen($hours) == 1 Then $hours = "0" & $hours
		Case ($difference_ms / 60000) >= 1 ;; Minutes passed
			$remaining_ms_from_min = Mod($difference_ms,60000)
			$seconds = String(Floor($remaining_ms_from_min / 1000))
			$minutes = String(Floor($difference_ms / 60000))
			If StringLen($seconds) == 1 Then $Seconds = "0" & $Seconds
			If StringLen($minutes) == 1 Then $minutes = "0" & $minutes
		Case ($difference_ms / 1000) >= 1 ;; Seconds passed
			$seconds = String(Floor($difference_ms / 1000))
			If StringLen($seconds) == 1 Then $Seconds = "0" & $Seconds
	EndSelect
	Return $hours & ":" &  $minutes & ":" & $seconds
EndFunc

Func SetLastError($iError = 0)
	Local $call = DllCall($__DLL_Kernel32,"none","SetLastError","dword",$iError)
	Return $call[0]
EndFunc   ;==>SetLastError
Func CreateProcess($Path,$Params,$Dir = @ScriptDir)
		Local $CommandLine = $Path & " " & $Params
		Local $STARTUPINFO = DllStructCreate($tagSTARTUPINFO)
			DllStructSetData($STARTUPINFO,"Size",DLlStructGetSize($STARTUPINFO))
        Local $PROCESS_INFORMATION  = DLLStructCreate($tagPROCESS_INFORMATION)

	Local $iResult = _WinAPI_CreateProcess($Path, $CommandLine,0, 0, False, 0x04000000, 0, $Dir,DllStructGetPtr($STARTUPINFO),DllStructGetPtr($PROCESS_INFORMATION))
	Return _Iif($iResult,$PROCESS_INFORMATION,_WinApi_GetLastError())
EndFunc

Func _UpdateList()
	GuiCtrlSetData($List_DiabloWindows,"")
	$_List = WinList("[CLASS:Diablo II]")
	For $i = 1 to $_list[0][0]
		GUICtrlSetData($List_DiabloWindows, $i & ". " & $_list[$i][0] & " - HWND " & $_list[$i][1] & "|")
	Next
EndFunc

Func Stats()
	Local $poss = WinGetPos($Diablo_hWnd)
	$Stats = Not $Stats
	Switch $Stats
		Case True
			GuiCtrlSetData($_Button,">>")
			For $i = 2 to 10
				GuiCtrlSetData($StatsBox_Labels[$i][0],$StatsBox_Labels[$i][1] & _DiaAPI_GetStatValue($StatsBox_Labels[$i][2],1,0,$ptr_Statlist))
			Next
			WinMove(@GUI_WINHANDLE,"",$poss[0]+710 + 2,$poss[1]+110+24,90,230)
			$_hGui_ChildWindows[4][1] = 710 + 2
			$_hGui_ChildWindows[4][2] = 110+24
		Case False
			GuiCtrlSetData($_Button,"<<")
			$_hGui_ChildWindows[4][1] = 775
			$_hGui_ChildWindows[4][2] = 110+24
			WinMove(@GUI_WINHANDLE,"",$poss[0]+775,$poss[1]+110+24,25, 32)
	EndSwitch
EndFunc

Func ReadSettings()
	;##################################################
	;~ CHILDWINDOWS - This array contains information about the childwindows.
	;~ THE ARRAY MUST KEEP THE STRUCTURE LIKE THIS:
	;~ [0][0] = amont of boxes.
	;~ [1][0] = handle to first window
	;~ [1][1] = Desired x-position of the first window
	;~ [1][2] = Desired x-position of the first window
	;~ [1][3] = Contains information about the hWnd (return from wingetlong)
	;~ [2][0] = handle to next window etc..
	;##################################################
	Global $_hGui_ChildWindows [5][4]
	$_hGui_ChildWindows[0][0] = 4;iniread(@Scriptdir & "\Settings.ini","CHILDWINDOWS","amount",2)
	$ChildWindows_IgnoreInput = Execute(Iniread(@Scriptdir & "\Settings.ini","CHILDWINDOWS","Lock",True))
	For $i = 1 to $_hGui_ChildWindows[0][0]
		$_hGui_ChildWindows[$i][1] = Iniread(@Scriptdir & "\Settings.ini","CHILDWINDOWS","hwnd" & $i & "prefpos.x",0)
		$_hGui_ChildWindows[$i][2] = Iniread(@Scriptdir & "\Settings.ini","CHILDWINDOWS","hwnd" & $i &"prefpos.y",0)
	Next
	;##################################################
	;~ Settings
	;##################################################
	If NOT FileExists(@ScriptDir & "\Settings.ini")Then
		FileWrite(@ScriptDir & "\Settings.ini",";#######################################" & @CRLF _
		& ";#	~Chickenpercent: Should be obvious... set to -1 if you want to disable the chicken." & @CRLF _
		& ";#	~Logging: The program will read ingame messages and log them in a file." & @CRLF _
		& ";#	~Traytip: The program will pop up traytips if something happens ingame while your Diablo II is minimized" & @CRLF _
		& ";#	~Line transparancy: Amount from 0 to 255; defines transparancy of the lines drawn. Default = 180" & @CRLF _
		& ";#	~Copyitem Hotkey: Allows to set a custom key combination for the copyitem feauture. Default is CTRL+C" & @CRLF _
		& ";#	~ThreadChicken: Allows Autumn to use the internal game function for exiting games. Much quicker and failsafe." & @CRLF _
		& ";#	~Reveal Act Hotkey: Hotkey to reveal the current act. !WARNING Although this doesn't inject a DLL it is still subject to detection!." & @CRLF _
		& ";#	~Townchicken: Hotkey to tp'ing to town. !WARNING - subject to prior warning!." & @CRLF _
		& ";#######################################")
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "Chicken Percent", 40)
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "Enable Xp Counter", True)
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "Enable Logging", False)
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "Enable Traytip", False)
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "Line Transparancy", 180)
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "CopyItem Hotkey", "^c")
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "ThreadChicken", -1)
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "Reveal Act Hotkey", -1)
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "Townchicken Hotkey", -1)
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "Reveal On Act Change", False)
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "Exit Game Hotkey", -1)
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "Close Autumn Hotkey", -1)
		IniWrite(@ScriptDir & "\Settings.ini", "CONFIG", "Use optimization", True)
		FileWrite(@ScriptDir & "\Settings.ini",@CRLF & ";#######################################" & @CRLF _
		& ";#	~Loopdelay : This defines how long the program will sleep between a loop." & @CRLF _
		& ";#	~Decreasing this will make the program update more often, but use more cpu. Default is 20 ms (corrosponds to 20-30 loops /sec.)" & @CRLF _
		& ";#######################################" & @CRLF)
		Iniwrite(@ScriptDir & "\Settings.ini","DELAYS","Loopdelay",20)
		FileWrite(@ScriptDir & "\Settings.ini", @CRLF & ";#######################################" & @CRLF _
		& ";#	~Dont edit anything below, the program will do it itself." & @CRLF _
		& ";#######################################" & @CRLF)
		Iniwrite(@ScriptDir & "\Settings.ini","CHILDWINDOWS","amount",3)
		Iniwrite(@ScriptDir & "\Settings.ini","CHILDWINDOWS","Lock",False)
		MsgBox(64, "AU.Map", "No Settings.ini found - created a new.")
	EndIf
	$Settings_ChickenPercent = Number(IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "Chicken Percent", 40))
	$Settings_XpCounter = Execute(IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "Enable Xp Counter", True))
	$Settings_Logsettings = Execute(IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "Enable Logging", False))
	$Settings_Notify = Execute(IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "Enable Traytip", False))
	$Settings_LoopDelay = Number(IniRead(@ScriptDir & "\Settings.ini", "DELAYS", "Loopdelay", 20))
	$Settings_LineTrans = Number(IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "Line Transparancy", 180))
	$Settings_Preferred_Path = IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "Path", "")
	$Settings_Hotkeys_CopyItem = IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "CopyItem Hotkey", "^c")
	$Settings_Hotkeys_RevealAct = IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "Reveal Act Hotkey", -1)
	$Settings_Hotkeys_TownChicken = IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "Townchicken Hotkey", -1)
	$Settings_RevealOnActChange = Execute(IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "Reveal On Act Change", False))
	$Settings_Hotkeys_ExitGame = IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "Exit Game Hotkey", -1)
	$Settings_Hotkeys_End = IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "Close Autumn Hotkey", -1)
	$Settings_ExitUseThread = Execute(IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "ThreadChicken", False))
	$Settings_Optimize = Execute(IniRead(@ScriptDir & "\Settings.ini", "CONFIG", "Use optimization", True))
EndFunc

Func HotKeys($bEnable)
	Switch $bEnable
		Case True
			IF $Settings_Hotkeys_End <> -1 Then HotKeySet($Settings_Hotkeys_End, "_End")
			IF $Settings_Hotkeys_ExitGame <> -1 Then HotKeySet($Settings_Hotkeys_ExitGame,"exitGame")
			IF $Settings_Hotkeys_CopyItem <> -1 Then HotKeySet($Settings_Hotkeys_CopyItem,"CopyItem")
			IF $Settings_Hotkeys_RevealAct <> -1 Then HotKeySet($Settings_Hotkeys_RevealAct,"RevealAct")
			IF $Settings_Hotkeys_TownChicken <> -1 Then
				If NOT $bTPLOADED Then
					LoadTpSystem()
					$bTPLOADED += 1
				EndIf
				HotKeySet($Settings_Hotkeys_TownChicken ,"TpToTown")
			ENdIf
		Case False
			IF $Settings_Hotkeys_End <> -1 Then HotKeySet($Settings_Hotkeys_End)
			IF $Settings_Hotkeys_ExitGame <> -1 Then HotKeySet($Settings_Hotkeys_ExitGame)
			IF $Settings_Hotkeys_CopyItem <> -1 Then HotKeySet($Settings_Hotkeys_CopyItem)
			IF $Settings_Hotkeys_RevealAct <> -1 Then HotKeySet($Settings_Hotkeys_RevealAct)
			IF $Settings_Hotkeys_TownChicken <> -1 Then
				HotKeySet($Settings_Hotkeys_TownChicken)
			ENdIf
	EndSwitch
EndFunc