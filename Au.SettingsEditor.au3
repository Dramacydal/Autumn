;Nn these includes really

;#include <ButtonConstants.au3>
;#include <EditConstants.au3>
;#include <GUIConstantsEx.au3>
;#include <StaticConstants.au3>
;5#include <TabConstants.au3>
;#include <WindowsConstants.au3>

;Variables and consts
Global Const $ES_PASSWORD = 32
Global Const $ES_AUTOHSCROLL = 128

Global Const $GUI_DOCKWIDTH = 0x0100
Global Const $GUI_DOCKHEIGHT = 0x0200

Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_CHECKED = 1
Global Const $GUI_UNCHECKED = 4

Global Const $WS_GROUP = 0x00020000
Global Const $WS_EX_STATICEDGE = 0x00020000
$Settingspath = @Scriptdir & "\Settings.ini"


;#######################################
;########################################################
$Diablopath = IniRead($Settingspath, "CONFIG", "Diablo Path", "NotFound")
$Account = IniRead($Settingspath, "CONFIG", "Account", "NotFound")
$Pass = IniRead($Settingspath, "CONFIG", "Password", "NotFound")
$Charlocation = IniRead($Settingspath, "CONFIG", "Charspot", "NotFound")
$ChatMsg = IniRead($Settingspath, "CONFIG", "Enable TrayTip", False)
$AllowMemoryRead = IniRead($Settingspath, "CONFIG", "ReadMemory", "No")
$EnableLogging = IniRead($Settingspath, "CONFIG", "EnableLogging", "Yes")
$Minimized = IniRead($Settingspath, "CONFIG", "Minimized", "No")
$Debug_ENABLED = IniRead($Settingspath, "CONFIG", "DebugEnabled", "No")

;Gamesettings
$MinGameTime = IniRead($Settingspath, "GAMESETTINGS", "MinGameTime", "NotFound")
$MiniWaitTime = IniRead($Settingspath, "GAMESETTINGS", "MiniWaitTime", "5000")
$GameName = IniRead($Settingspath, "GAMESETTINGS", "Gamename", "NotFound")
$Run = IniRead($Settingspath, "GAMESETTINGS", "Ingamescript", "NotFound")
$GamePass = IniRead($Settingspath, "GAMESETTINGS", "Gamepass", "NotFound")
$Difficulty = IniRead($Settingspath, "GAMESETTINGS", "Difficulty", "NotFound")
;########################################################
;########################################################
$Form1_1 = GUICreate("Autumn Setting Editor", 331, 271, 250, 141)
$MenuItem2 = GUICtrlCreateMenu("&Options")
$MenuItem4 = GUICtrlCreateMenuItem("Save to Settings.ini", $MenuItem2)
$MenuItem3 = GUICtrlCreateMenuItem("Exit", $MenuItem2)
$Inisetup = GUICtrlCreateTab(0, 0, 329, 249)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$TabSheet1 = GUICtrlCreateTabItem("Config")
$Button1 = GUICtrlCreateButton("Diablo II Path", 16, 40, 113, 25, $WS_GROUP)
$Label1 = GUICtrlCreateLabel($DiabloPath, 144, 56, 170, 16, -1, $WS_EX_STATICEDGE)
GUICtrlCreateLabel("Current Diablo II path:", 144, 34, 107, 17)
$Your = GUICtrlCreateInput($Account, 144, 80, 113, 21)
$Input2 = GUICtrlCreateInput($Pass, 144, 112, 113, 21, BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
$Label2 = GUICtrlCreateLabel("Account:", 16, 82, 47, 17)
$Label3 = GUICtrlCreateLabel("Password:", 16, 114, 53, 17)
$Label4 = GUICtrlCreateLabel("Character spot:", 16, 144, 76, 17)


$Radio3 = GUICtrlCreateRadio("", 144, 168, 20, 17)
$Radio9 = GUICtrlCreateRadio("", 144, 144, 20, 17)
$Radio1 = GUICtrlCreateRadio("", 144, 192, 20, 17)
$Radio2 = GUICtrlCreateRadio("", 144, 216, 20, 17)
$Radio4 = GUICtrlCreateRadio("", 168, 144, 20, 17)
$Radio5 = GUICtrlCreateRadio("", 168, 168, 20, 17)
$Radio6 = GUICtrlCreateRadio("", 168, 192, 20, 17)
$Radio7 = GUICtrlCreateRadio("", 168, 216, 20, 17)


$TabSheet2 = GUICtrlCreateTabItem("Layout")
$Input1 = GUICtrlCreateInput($Gamename, 96, 40, 97, 21)
$Label5 = GUICtrlCreateLabel("Transparancy", 24, 42, 64, 17)
$Label6 = GUICtrlCreateLabel("Game pass:", 24, 74, 60, 17)
$Input3 = GUICtrlCreateInput($GamePass, 96, 72, 97, 21)
$Label7 = GUICtrlCreateLabel("Difficulty:", 24, 104, 47, 17)
$Radio8 = GUICtrlCreateRadio("Normal", 96, 104, 113, 17)
$Radio10 = GUICtrlCreateRadio("Nightmare", 96, 128, 113, 17)
$Radio11 = GUICtrlCreateRadio("Hell", 96, 152, 113, 17)
$Label8 = GUICtrlCreateLabel("Minimum time before next game (in seconds):", 24, 184, 250, 17)
$Input4 = GUICtrlCreateInput($MinGameTime, 96, 208, 81, 21)
$TabSheet3 = GUICtrlCreateTabItem("Autumn settings")
$Checkbox1 = GUICtrlCreateCheckbox("Run Minimized", 8, 32, 97, 17)
$Checkbox2 = GUICtrlCreateCheckbox("Read Diablo II memory", 8, 56, 137, 17)
$Checkbox3 = GUICtrlCreateCheckbox("Enable debuglog", 8, 80, 97, 17)
$Checkbox4 = GUICtrlCreateCheckbox("Enable logging of ingame messages", 8, 104, 193, 17)
$Label9 = GUICtrlCreateLabel("This delay makes the bot wait longer between OOG actions.", 8, 168, 287, 17)
$Label10 = GUICtrlCreateLabel("Recommended to be between 3-5000 miliseconds.", 8, 184, 243, 17)
$Input17 = GUICtrlCreateInput($MiniWaitTime, 8, 208, 113, 21)
$Checkbox5 = GUICtrlCreateCheckbox("Notify about ingame messages", 8, 128, 217, 17)
GUICtrlCreateTabItem("")


;Refresh settings
Select
	Case $CharLocation = 1
		GUICtrlSetState($radio9, $GUI_CHECKED)
	Case $CharLocation = 2
		GUICtrlSetState($radio4, $GUI_CHECKED)
	Case $CharLocation = 3
		GUICtrlSetState($radio3, $GUI_CHECKED)
	Case $CharLocation = 4
		GUICtrlSetState($radio5, $GUI_CHECKED)
	Case $CharLocation = 5
		GUICtrlSetState($radio1, $GUI_CHECKED)
	Case $CharLocation = 6
		GUICtrlSetState($radio6, $GUI_CHECKED)
	Case $CharLocation = 7
		GUICtrlSetState($radio2, $GUI_CHECKED)
	Case $CharLocation = 8
		GUICtrlSetState($radio7, $GUI_CHECKED)
EndSelect

Select
	Case $Difficulty = 1
		GUICtrlSetState($radio8, $GUI_CHECKED)
	Case $Difficulty = 2
		GUICtrlSetState($radio10, $GUI_CHECKED)
	Case $Difficulty = 3
		GUICtrlSetState($radio11, $GUI_CHECKED)
EndSelect

If $Minimized = "No" Then
	GUICtrlSetState($Checkbox1, 4)
Elseif $Minimized = "Yes" Then
	GUICtrlSetState($Checkbox1, 1)
Endif

If $AllowMemoryRead = "No" Then
	GUICtrlSetState($Checkbox2, 4)
Elseif $AllowMemoryRead = "Yes" Then
	GUICtrlSetState($Checkbox2, 1)
Endif

If $Debug_ENABLED = "No" Then
	GUICtrlSetState($Checkbox3, 4)
Elseif $Debug_ENABLED = "Yes" Then
	GUICtrlSetState($Checkbox3, 1)
Endif

If $Enablelogging = "No" Then
	GUICtrlSetState($Checkbox4, 4)
Elseif $Enablelogging = "Yes" Then
	GUICtrlSetState($Checkbox4, 1)
Endif

If $ChatMsg = False Then
	GUICtrlSetState($Checkbox5, 4)
Elseif $ChatMsg = True Then
	GUICtrlSetState($Checkbox5, 1)
Endif

;Show Gui
GUISetState(@SW_SHOW)

;Main Loop
While 1
	$nMsg = GUIGetMsg()
	Select
		Case $nMsg = $GUI_EVENT_CLOSE
			$Answer3 = Msgbox(484, "Autumn", "Do you want to save your settings before exiting?")
			If $Answer3 = 6 Then
				EditIni()
			Endif
			Exit
		Case $nMsg = $Menuitem3
			$Answer3 = Msgbox(484, "Autumn", "Do you want to save your settings before exiting?")
			If $Answer3 = 6 Then
				EditIni()
			EndIf
			Exit
		Case $nMsg = $MenuItem4
			EditIni()
			Traytip("Autumn","Edited settings in Settings.ini",5)
		Case $nMsg = $Button1
			$DiabloPath = FileOpenDialog("Select game.exe", @ProgramFilesDir, "Executables (*.exe)")
			If stringlen($DiabloPath) > 25 Then
				$NewD2Path = StringLeft($DiabloPath,25) & "..."
			Else
				$NewD2Path = $DiabloPath & " -w -skiptobnet"
			Endif
			GUICtrlSetData(9, $NewD2Path)
	Endselect
WEnd

Func EditIni()
;DiabloPath
	IniWrite($Settingspath, "CONFIG","Diablo Path",$DiabloPath & " -w")
;Account
	$Account = GuiCtrlRead($Your)
	IniWrite($Settingspath, "CONFIG","Account",$Account)
;Password
	$Pass = GuiCtrlRead($Input2)
	IniWrite($Settingspath, "CONFIG","Password",$Pass)
;Charspot
	Select
		Case GUICtrlRead($radio9) = $GUI_CHECKED
			$CharLocation = 1
		Case GUICtrlRead($radio4) = $GUI_CHECKED
			$CharLocation = 2
		Case GUICtrlRead($radio3) = $GUI_CHECKED
			$CharLocation = 3
		Case GUICtrlRead($radio5) = $GUI_CHECKED
			$CharLocation = 4
		Case GUICtrlRead($radio1) = $GUI_CHECKED
			$CharLocation = 5
		Case GUICtrlRead($radio6) = $GUI_CHECKED
			$CharLocation = 6
		Case GUICtrlRead($radio2) = $GUI_CHECKED
			$CharLocation = 7
		Case GUICtrlRead($radio7) = $GUI_CHECKED
			$CharLocation = 8
	Endselect
	IniWrite($Settingspath, "CONFIG", "Charspot", $Charlocation)
;Filter spammessages
	If GuiCtrlRead($Checkbox5) = $GUI_CHECKED Then
		$ChatMsg = True
	ElseIf GuiCtrlRead($Checkbox5) = $GUI_UNCHECKED Then
		$ChatMsg = False
	Endif
	IniWrite($Settingspath, "CONFIG", "MsgSettings",$ChatMsg)
;Allow the bot to read memory
	If GuiCtrlRead($Checkbox2) = $GUI_CHECKED Then
		$AllowMemoryRead = "Yes"
	ElseIf GuiCtrlRead($Checkbox2) = $GUI_UNCHECKED Then
		$AllowMemoryRead = "No"
	Endif
	IniWrite($Settingspath, "CONFIG", "ReadMemory", $AllowMemoryRead)
;Enableloggin of messages
	If GuiCtrlRead($Checkbox4) = $GUI_CHECKED Then
		$EnableLogging = "Yes"
	ElseIf GuiCtrlRead($Checkbox4) = $GUI_UNCHECKED Then
		$EnableLogging = "No"
	Endif
	IniWrite($Settingspath, "CONFIG", "EnableLogging", $EnableLogging)
;Run minimized
	If GuiCtrlRead($Checkbox1) = $GUI_CHECKED Then
		$Minimized = "Yes"
	ElseIf GuiCtrlRead($Checkbox1) = $GUI_UNCHECKED Then
		$Minimized = "No"
	Endif
	IniWrite($Settingspath, "CONFIG", "Minimized", $Minimized)
;Open debuglog on start
	If GuiCtrlRead($Checkbox3) = $GUI_CHECKED Then
		$Debug_ENABLED = "Yes"
	ElseIf GuiCtrlRead($Checkbox3) = $GUI_UNCHECKED Then
		$Debug_ENABLED = "No"
	Endif
	IniWrite($Settingspath, "CONFIG", "DebugEnabled", $Debug_ENABLED)
;Difficulty
	Select
		Case GUICtrlRead($radio8) = $GUI_CHECKED
			$Difficulty = 1
		Case GUICtrlRead($radio10) = $GUI_CHECKED
			$Difficulty = 2
		Case GUICtrlRead($radio11) = $GUI_CHECKED
			$Difficulty = 3
	EndSelect
	IniWrite($Settingspath, "GAMESETTINGS", "Difficulty", $Difficulty)
;Time before next game
	$MinGameTime = GuiCtrlRead($Input4)
	IniWrite($Settingspath, "GAMESETTINGS", "MinGameTime",$MinGameTime)
;Time to wait between locations:
	$MiniWaitTime = GuiCtrlRead($Input17)
	IniWrite($Settingspath, "CONFIG", "MiniWaitTime",$MiniWaitTime)
;Gamename
	$GameName = GuiCtrlRead($Input1)
	IniWrite($Settingspath, "GAMESETTINGS", "GameName",$GameName)
;GamePass
	$GamePass = GuiCtrlRead($Input3)
	IniWrite($Settingspath, "GAMESETTINGS", "GamePass",$GamePass)
Endfunc