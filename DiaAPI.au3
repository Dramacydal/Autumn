#include <Array.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <DiaAPIConstants.au3>

;OK I tidied comments a bit, but still need some work (maybe).

#cs
	User Defined Function coding standards

	Function Names
	All function names must start with an underscore (“_”). *
	Each word in the function name should be capitalized.
	The first word of the function name should start with a word describing a general category such as “Date”, “String”, “Array”, “Network”, etc.. If the word is too long like “Window”, then an obvious abbreviation may be used (e.g. “Win” for “Window” or “Net” for “Network”).
	All function names must closely resemble the established naming convention for "internal" AutoIt functions.

	Variable Names
	The first set of characters after the dollar sign (“$”) should be used to specify the type of data that will be held in it. The following list signifies the different prefixes and their data type significance.
	$a<letter> - Array (the following letter describes the data type taken from the rest of the data types below)
	$b - Binary data
	$h - File or window handle
	$i - Integer
	$f - Boolean
	$n - Floating point number
	$s - String
	$v - Variant (unknown/variable type of data)
	The rest of the name uses capitalized words to describe the function of the variable. Names like “$iC” are unacceptable. "$aiWeekDayNames" or "$iCounter" are much preferable.
	All variables must be declared at the beginning of the UDF with a “Local” scope and before they are used for the first time.
	The “Dim” or “Global” keywords are ambiguous inside of a UDF and as such should be avoided, all variables should be transferred via the Function Parameters using Byref when the updated value needs to be returned.

	Parameters
	The parameter names must use the same naming conventions as variables.
	All parameters must be checked for validity and return appropriate error codes.
	If parameters are used to pass data back to the calling script (ByRef), then the documentation should explicitly describe said behavior.

	Function Documentation
	All UDFs must have a documentation header in the script in the following form:
#ce

; #FUNCTION# ;===============================================================================
;
; Name...........: _DateDiff
; Description ...: Returns the difference between 2 dates, expressed in the type requested
; Syntax.........: _DateDiff($sType, $sStartDate, $sEndDate)
; Parameters ....: $sType - One of the following:
;                  |D = Difference in days between the given dates
;                  |M = Difference in months between the given dates
;                  |Y = Difference in years between the given dates
;                  |w = Difference in Weeks between the given dates
;                  |h = Difference in hours between the given dates
;                  |n = Difference in minutes between the given dates
;                  |s = Difference in seconds between the given dates
;                   $sStartDate  - Input Start date in the format "YYYY/MM/DD[ HH:MM:SS]"
;                   $sEndDate    - Input End date in the format "YYYY/MM/DD[ HH:MM:SS]"
; Return values .: Success - Difference between the 2 dates.
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Invalid $sType
;                  |2 - Invalid $sStartDate
;                  |3 - Invalid $sEndDate
; Author ........: Jos van der Zande
; Modified.......:
; Remarks .......:
; Related .......:  _DateAdd
; Link ..........:
; Example .......: Yes
;
;
;====================================================================================================

#cs
	How we gonna handle versions?
	I used to handle versions like this
	Version .......: 1.1.0.0
	Total times this file  made from zero
	Total times new funcs added
	Total times funcs modified
	Total typo fixes/func/var rename (such that doesn't affect functionality
#ce
; #INDEX# ======================================================================
; Title .........: _DiaAPI
; Version .......: 1.2.0.0
; AutoIt Version : 3.2 or better
; Language ......: English
; Description ...: Diablo II memory reading
; Author ........: Murder567 & Polite (TheRain13)
; ==============================================================================

; #CURRENT# ====================================================================
; Version .......: 1.0.0.0
; _DiaAPI_OpenProcessByWindow
; _DiaAPI_GetAreaLevel
; _DiaAPI_GetLevelXY
; _DiaAPI_GetLevelCoords
; _DiaAPI_GetSkillLevel
; _DiaAPI_GetSkillID
; _DiaAPI_ReadRosterUnit(Under development still...)
; _DiaAPI_GetStatValue
; _DiaAPI_SetSkillByID(Still in test phase...only tested on SP so far.)
; _DiaAPI_GetRoom2XY
; _DiaAPI_GetRoom2Coords
; _DiaAPI_GetRoom1XY
; _DiaAPI_GetRoom1Coords
; Version .......: 1.1.0.0
; _DiaAPI_CreateDia
; _DiaAPI_DestroyDia
; _ProcessGetWindow
; _ProcessGetId
; _ProcessGetName
; _ChangeParent
; _DiaAPI_GetGameName
; _ConsoleWriteLine (shouldn't be in here)
; __DiaAPI_SetFull
; _ArrayFind
; _MouseLock
; _DisplayTutorial
; Version .......: 1.2.0.0
; _DiaAPI_GetPlayerName
; _DiaAPI_GetGamePassword
; _DiaAPI_GetRealmName
; _DiaAPI_GetAccountName
; _DiaAPI_GetGameIP
 ;_DiaAPI_GetGamePing
; ==============================================================================
;~ $Open = _DiaAPI_OpenProcessByWindow(WinGetHandle("test"))
;~ WinActivate("test")
;~ Sleep(1000)
;~ MsgBox(1, "", _DiaAPI_GetSkillByID(_DiaAPI_GetSkillID($Open, 2)))
;~ MsgBox(1, "", _DiaAPI_GetStatValue($Open, 14, True))
;~ MsgBox(1, "", _DiaAPI_GetPlayerName($Open))
;~ MsgBox(1, "", _DiaAPI_GetGamePassword($Open))
;~ MsgBox(1, "", _DiaAPI_GetRealmName($Open))
;~ MsgBox(1, "", _DiaAPI_GetAccountName($Open))
;~ MsgBox(1, "", _DiaAPI_GetGameIP($Open))
;~ MsgBox(1, "", _DiaAPI_GetGamePing($Open))
Dim $DiabloList[1]
$HDias = GUICreate("lol")
$spath = "G:\Games\Diablo 2\Diablo II\Game.exe"

_DiaAPI_CreateDia($sPath)
_DiaAPI_CreateDia($sPath)
_DiaAPI_CreateDia($sPath)

;VAriables
#region Variables
Dim $DiabloList[1]
Global $ini = @ScriptDir & "\_MouseLock.ini"
Global $DisplaTutorial = IniRead($ini, "_MouseLocker", "Tutorial", "False")
Global $KeyList = "Left mouse button|Right mouse button|Middle mouse button (three-button mouse)|Windows 2000/XP: X1 mouse button|Windows 2000/XP: X2 mouse button|BACKSPACE |TAB |CLEAR |ENTER |SHIFT |CTRL |ALT |PAUSE |CAPS LOCK |ESC |SPACEBAR|PAGE UP |PAGE DOWN |END |HOME |LEFT ARROW |UP ARROW |RIGHT ARROW |DOWN ARROW |SELECT |PRINT |EXECUTE |PRINT SCREEN |INS |DEL |0 |1 |2 |3 |4 |5 |6 |7 |8 |9 |A |B |C |D |E |F |G |H |I |J |K |L |M |N |O |P |Q |R |S |T |U |V |W |X |Y |Z |Left Windows |Right Windows |Numeric pad 0 |Numeric pad 1 |Numeric pad 2 |Numeric pad 3 |Numeric pad 4 |Numeric pad 5 |Numeric pad 6 |Numeric pad 7 |Numeric pad 8 |Numeric pad 9 |Multiply |Add |Separator |Subtract |Decimal |Divide |F1 |F2 |F3 |F4 |F5 |F6 |F7 |F8 |F9 |F10 |F11 |F12 |F13 |F14|F15|F16|F17 |F18|F19|F20|F21|F22|F23|F24|NUM LOCK |SCROLL LOCK |Left SHIFT |Right SHIFT |Left CONTROL |Right CONTROL |Left MENU |Right MENU |;|=|,|-|.|/|`|["
Global $KeylistSplitted = StringSplit($KeyList, "|")
Global $KeyListSplitedMatchList = StringSplit("01|02|04|05|06|08|09|0C|0D|10|11|12|13|14|1B|20|21|22|23|24|25|26|27|28|29|2A|2B|2C|2D|2E|30|31|32|33|34|35|36|37|38|39|41|42|43|44|45|46|47|48|49|4A|4B|4C|4D|4E|4F|50|51|52|53|54|55|56|57|58|59|5A|5B|5C|60|61|62|63|64|65|66|67|68|69|6A|6B|6C|6D|6E|6F|70|71|72|73|74|75|76|77|78|79|7A|7B|7C|7D|7E|7F|80|81|82|83|84|85|86|87|90|91|A0|A1|A2|A3|A4|A5|BA|BB|BC|BD|BE|BF|C0|DB|DC|DD|", "|")
Global $HDias = GUICreate("Diablo II secret area")
$Key1Code = IniRead($ini, "_MouseLocker", "KEY1", "A2")
$Key2Code = IniRead($ini, "_MouseLocker", "KEY2", "11")
$DisplaTutorial = IniRead($ini, "_MouseLocker", "Tutorial", "False")

$Key1String = $KeylistSplitted[ArrayFind($KeyListSplitedMatchList, $Key1Code)]
$Key2String = $KeylistSplitted[ArrayFind($KeyListSplitedMatchList, $Key2Code)]
#endregion

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetAreaLevel
; Description ...: Reads The Area Level Id From Diablo 2 Memory
; Syntax.........: _DiaAPI_GetAreaLevel($hProc)
; Parameters ....: $hProc - The handle to the opened Diablo 2 process as returned
;                           by _DiaAPI_OpenProcessByWindow
; Return values .: On Success - Returns the integer value of the area level
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetAreaLevel($hProc)
	Local $Buffer = DllStructCreate('ptr')
	Local $AreaLevel = DllStructCreate('int')
	Local $iRead1 = 4
	Local $iRead2 = 2
	_WinAPI_ReadProcessMemory($hProc, $D2Client + $pUnitAnyStruct, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer1 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pActStructUA)
	_WinAPI_ReadProcessMemory($hProc, $Pointer1, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pRoom1StructA)
	_WinAPI_ReadProcessMemory($hProc, $Pointer2, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer3 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pRoom2StructR1)
	_WinAPI_ReadProcessMemory($hProc, $Pointer3, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer4 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pLevelStructR2)
	_WinAPI_ReadProcessMemory($hProc, $Pointer4, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer5 = '0x' & Hex(DllStructGetData($Buffer, 1) + $dwLevelNoL)
	_WinAPI_ReadProcessMemory($hProc, $Pointer5, DllStructGetPtr($AreaLevel), DllStructGetSize($AreaLevel), $iRead2)
	Return DllStructGetData($AreaLevel, 1)
EndFunc   ;==>_DiaAPI_GetAreaLevel

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetLevelXY
; Description ...: Reads the X and Y coords of your character from the level struct
;                  in the memory of Diablo 2
; Syntax.........: _DiaAPI_GetLevelXY($hProc, $iAxis)
; Parameters ....: $hProc - The handle to the opened Diablo 2 process as returned
;                           by _DiaAPI_OpenProcessByWindow
;                  $iAxis - Designates whether to read the X or Y coordinate
;                  |1 - X Coord
;                  |2 - Y Coord
; Return values .: On Success - Returns the X or Y position of your char in the level
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetLevelXY($hProc, $iAxis) ; $iAxis = 1 X Pos, $iAxis = 2 Y Pos
	Local $Buffer = DllStructCreate('ptr')
	Local $LevelX = DllStructCreate('dword')
	Local $iRead1 = 4
	Local $iRead2 = 2
	_WinAPI_ReadProcessMemory($hProc, $D2Client + $pUnitAnyStruct, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer1 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pActStructUA)
	_WinAPI_ReadProcessMemory($hProc, $Pointer1, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pRoom1StructA)
	_WinAPI_ReadProcessMemory($hProc, $Pointer2, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer3 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pRoom2StructR1)
	_WinAPI_ReadProcessMemory($hProc, $Pointer3, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer4 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pLevelStructR2)
	_WinAPI_ReadProcessMemory($hProc, $Pointer4, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	If $iAxis = 1 Then
		$Pointer5 = '0x' & Hex(DllStructGetData($Buffer, 1) + $dwPosXL)
	ElseIf $iAxis = 2 Then
		$Pointer5 = '0x' & Hex(DllStructGetData($Buffer, 1) + $dwPosYL)
	EndIf
	_WinAPI_ReadProcessMemory($hProc, $Pointer5, DllStructGetPtr($LevelX), DllStructGetSize($LevelX), $iRead1)
	Return DllStructGetData($LevelX, 1)
EndFunc   ;==>_DiaAPI_GetLevelXY

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetRoom2XY
; Description ...: Reads the X and Y coords of your character from the Room2 struct
;                  in the memory of Diablo 2
; Syntax.........: _DiaAPI_GetRoom2XY($hProc, $iAxis)
; Parameters ....: $hProc - The handle to the opened Diablo 2 process as returned
;                           by _DiaAPI_OpenProcessByWindow
;                  $iAxis - Designates whether to read the X or Y coordinate
;                  |1 - X Coord
;                  |2 - Y Coord
; Return values .: On Success - Returns the X or Y position of your char in the Room2
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetRoom2XY($hProc, $iAxis) ; $iAxis = 1 X Pos, $iAxis = 2 Y Pos
	Local $Buffer = DllStructCreate('ptr')
	Local $Room2X = DllStructCreate('dword')
	Local $iRead1 = 4
	Local $iRead2 = 2
	_WinAPI_ReadProcessMemory($hProc, $D2Client + $pUnitAnyStruct, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer1 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pActStructUA)
	_WinAPI_ReadProcessMemory($hProc, $Pointer1, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pRoom1StructA)
	_WinAPI_ReadProcessMemory($hProc, $Pointer2, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer3 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pRoom2StructR1)
	_WinAPI_ReadProcessMemory($hProc, $Pointer3, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	If $iAxis = 1 Then
		$Pointer4 = '0x' & Hex(DllStructGetData($Buffer, 1) + $dwPosXR2)
	ElseIf $iAxis = 2 Then
		$Pointer4 = '0x' & Hex(DllStructGetData($Buffer, 1) + $dwPosYR2)
	EndIf
	_WinAPI_ReadProcessMemory($hProc, $Pointer4, DllStructGetPtr($Room2X), DllStructGetSize($Room2X), $iRead1)
	Return DllStructGetData($Room2X, 1)
EndFunc   ;==>_DiaAPI_GetRoom2XY

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetRoom1XY
; Description ...: Reads the X and Y coords of your character from the Room1 struct
;                  in the memory of Diablo 2
; Syntax.........: _DiaAPI_GetRoom1XY($hProc, $iAxis)
; Parameters ....: $hProc - The handle to the opened Diablo 2 process as returned
;                           by _DiaAPI_OpenProcessByWindow
;                  $iAxis - Designates whether to read the X or Y coordinate
;                  |1 - X Coord
;                  |2 - Y Coord
; Return values .: On Success - Returns the X or Y position of your char in the Room1
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetRoom1XY($hProc, $iAxis) ; $iAxis = 1 X Pos, $iAxis = 2 Y Pos
	Local $Buffer = DllStructCreate('ptr')
	Local $Room1X = DllStructCreate('dword')
	Local $iRead1 = 4
	Local $iRead2 = 2
	_WinAPI_ReadProcessMemory($hProc, $D2Client + $pUnitAnyStruct, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer1 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pActStructUA)
	_WinAPI_ReadProcessMemory($hProc, $Pointer1, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pRoom1StructA)
	_WinAPI_ReadProcessMemory($hProc, $Pointer2, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	If $iAxis = 1 Then
		$Pointer3 = '0x' & Hex(DllStructGetData($Buffer, 1) + $dwPosXR1)
	ElseIf $iAxis = 2 Then
		$Pointer3 = '0x' & Hex(DllStructGetData($Buffer, 1) + $dwPosYR1)
	EndIf
	_WinAPI_ReadProcessMemory($hProc, $Pointer3, DllStructGetPtr($Room1X), DllStructGetSize($Room1X), $iRead1)
	Return DllStructGetData($Room1X, 1)
EndFunc   ;==>_DiaAPI_GetRoom1XY

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetLevelCoords
; Description ...: Reads the X and Y Coords from the level struct in Diablo 2 memory
; Syntax.........: _DiaAPI_GetLevelCoords($hProc)
; Parameters ....: $hProc - The handle to the opened Diablo 2 process as returned
;                           by _DiaAPI_OpenProcessByWindow
; Return values .: On Success - Returns the string of coords X,Y
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......:
; Remarks .......: Returns them in a string like: X,Y
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetLevelCoords($hProc)
	Local $Coords = _DiaAPI_GetLevelXY($hProc, 1) & ',' & _DiaAPI_GetLevelXY($hProc, 2)
	Return $Coords
EndFunc   ;==>_DiaAPI_GetLevelCoords

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetRoom2Coords
; Description ...: Reads the X and Y Coords from the Room2 struct in Diablo 2 memory
; Syntax.........: _DiaAPI_GetRoom2Coords($hProc)
; Parameters ....: $hProc - The handle to the opened Diablo 2 process as returned
;                           by _DiaAPI_OpenProcessByWindow
; Return values .: On Success - Returns the string of coords X,Y
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......:
; Remarks .......: Returns them in a string like: X,Y
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetRoom2Coords($hProc)
	Local $Coords = _DiaAPI_GetRoom2XY($hProc, 1) & ',' & _DiaAPI_GetRoom2XY($hProc, 2)
	Return $Coords
EndFunc   ;==>_DiaAPI_GetRoom2Coords

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetRoom1Coords
; Description ...: Reads the X and Y Coords from the Room1 struct in Diablo 2 memory
; Syntax.........: _DiaAPI_GetRoom1Coords($hProc)
; Parameters ....: $hProc - The handle to the opened Diablo 2 process as returned
;                           by _DiaAPI_OpenProcessByWindow
; Return values .: On Success - Returns the string of coords X,Y
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......:
; Remarks .......: Returns them in a string like: X,Y
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetRoom1Coords($hProc)
	Local $Coords = _DiaAPI_GetRoom1XY($hProc, 1) & ',' & _DiaAPI_GetRoom1XY($hProc, 2)
	Return $Coords
EndFunc   ;==>_DiaAPI_GetRoom1Coords

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetSkillLevel
; Description ...: Reads the base skill level of the skill on your left or right hand
; Syntax.........: _DiaAPI_GetSkillLevel($hProc, $iHand)
; Parameters ....: $hProc - The handle to the opened Diablo 2 process as returned
;                           by _DiaAPI_OpenProcessByWindow
;                  $iHand - The hand the skill should be read from
;                  |1 Left Hand
;                  |2 Right Hand
; Return values .: On Success - Returns the base skill level of skill on right
;                  or left hand. Base skill level does not include any
;                  bonuses from items. The max is 20.
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetSkillLevel($hProc, $iHand) ; $iHand = 1 (left), $iHand = 2 (right)
	Local $Buffer = DllStructCreate('ptr')
	Local $SkillLevel = DllStructCreate('dword')
	Local $iRead1 = 4
	Local $iRead2 = 2
	_WinAPI_ReadProcessMemory($hProc, $D2Client + $pUnitAnyStruct, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer1 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pInfoStructUA)
	_WinAPI_ReadProcessMemory($hProc, $Pointer1, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	If $iHand = 1 Then
		$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pLeftSkillI)
	ElseIf $iHand = 2 Then
		$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pRightSkillI)
	EndIf
	_WinAPI_ReadProcessMemory($hProc, $Pointer2, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer3 = '0x' & Hex(DllStructGetData($Buffer, 1) + $dwSkillLevelS)
	_WinAPI_ReadProcessMemory($hProc, $Pointer3, DllStructGetPtr($SkillLevel), DllStructGetSize($SkillLevel), $iRead1)
	Return DllStructGetData($SkillLevel, 1) ;Baselevel not including any bonuses from items 20 = max
EndFunc   ;==>_DiaAPI_GetSkillLevel

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetSkillID
; Description ...: Reads the skill ID from left or right hand
; Syntax.........: _DiaAPI_GetSkillID($hProc, $iHand)
; Parameters ....: $hProc - The handle to the opened Diablo 2 process as returned
;                           by _DiaAPI_OpenProcessByWindow
;                  $iHand - The hand the skill should be read from
;                  |1 Left Hand
;                  |2 Right Hand
; Return values .: On Success - Returns the integer value of the skill ID from
;                               the left or the right hand.
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetSkillID($hProc, $iHand)
	Local $Buffer = DllStructCreate('ptr')
	Local $SkillID = DllStructCreate('int')
	Local $iRead1 = 4
	Local $iRead2 = 2
	_WinAPI_ReadProcessMemory($hProc, $D2Client + $pUnitAnyStruct, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer1 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pInfoStructUA)
	_WinAPI_ReadProcessMemory($hProc, $Pointer1, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	If $iHand = 1 Then
		$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pLeftSkillI)
	ElseIf $iHand = 2 Then
		$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pRightSkillI)
	EndIf
	_WinAPI_ReadProcessMemory($hProc, $Pointer2, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer3 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pSkillInfoStructS)
	_WinAPI_ReadProcessMemory($hProc, $Pointer3, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer4 = '0x' & Hex(DllStructGetData($Buffer, 1) + $wSkillIDSI)
	_WinAPI_ReadProcessMemory($hProc, $Pointer4, DllStructGetPtr($SkillID), DllStructGetSize($SkillID), $iRead2)
	Return DllStructGetData($SkillID, 1) ; Attack = 0, Kick = 1, Throw = 2...So On. Enum found in SkillType.h (D2Data.dll source w/ ao)
EndFunc   ;==>_DiaAPI_GetSkillID

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_OpenProcessByWindow
; Description ...: Reads the skill ID from left or right hand
; Syntax.........: _DiaAPI_OpenProcessByWindow($hWnd)
; Parameters ....: $hWnd - The handle or title of the Diablo 2 window to be read.
;                          returned by WindGetHandle("Diablo II").
;                          Or just the window name and it will automatically
;                          get the handle and pid.
;                          Or returned by _DiaAPI_CreateDia
; Return values .: On Success - Returns an array containing the Dll handle and an
;                               open handle to the specified process.
;                  On Failure - Returns False
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_OpenProcessByWindow($hWnd)
	$call = DllCall("formulas_v4.dll", "handle:cdecl", "openSecureProcess", "int", WinGetProcess($hWnd), "dword", 0x001F0FFF)
	If Not @error Then
		Return $call[0]
	Else
		Return False
	EndIf
EndFunc   ;==>_DiaAPI_OpenProcessByWindow

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetStatValue
; Description ...: Reads the current value of the stat requested
; Syntax.........: _DiaAPI_GetStatValue($hProc, $iStat[, $bItems])
; Parameters ....: $hProc - The handle to the opened Diablo 2 process as returned
;                           by _DiaAPI_OpenProcessByWindow
;                  $iStat - The Stat To Be Read
;                  |6    = current life
;                  |14   = max life
;                  |22   = current mana
;                  |38   = current stamina
;                  |53   = current level
;                  |61   = current experience
;                  |-27  = (naked) strength
;                  |-19  = (naked) energy
;                  |-11  = (naked) dexterity
;                  |-3   = (naked) vitality
; Return values .: On Success - Returns the base value of the specified stat.
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......: Polite
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetStat_Value($hProc, $iStat, $bItems = False)
	Local $Buffer = DllStructCreate('ptr')
	Local $StatValue = DllStructCreate('dword')
	Local $StatOffset = 31
	Local $iRead1 = 4
	Local $iRead2 = 2
	_WinAPI_ReadProcessMemory($hProc, $D2Client + $pUnitAnyStruct, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer1 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pStatListStructUA)
	_WinAPI_ReadProcessMemory($hProc, $Pointer1, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	If $bItems Then
		$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + 72)
	Else
		$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pStatStructSL)
	EndIf
	_WinAPI_ReadProcessMemory($hProc, $Pointer2, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer3 = '0x' & Hex(DllStructGetData($Buffer, 1) + $StatOffset + $iStat)
	_WinAPI_ReadProcessMemory($hProc, $Pointer3, DllStructGetPtr($StatValue), DllStructGetSize($StatValue), $iRead1)
	Return DllStructGetData($StatValue, 1)
EndFunc   ;==>_DiaAPI_GetStatValue

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_ReadRosterUnit
; Description ...: Reads the roster unit struct for player information.
; Syntax.........: _DiaAPI_ReadRosterUnit($hProc)
; Parameters ....: $hProc - The handle to the opened Diablo 2 process as returned
;                           by _DiaAPI_OpenProcessByWindow
; Return values .: On Success - Returns the specified info of a player.
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
;Todo: Make It Read And Store All Data In Array
Func _DiaAPI_ReadRosterUnit($hProc) ; works to read party members iffy on single player with urself lol
	Local $Buffer = DllStructCreate('ptr')
	Local $AreaLevel = DllStructCreate('dword')
	Local $iRead1 = 4
	Local $iRead2 = 2
	_WinAPI_ReadProcessMemory($hProc, $D2Client + $pRosterUnitStruct, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer1 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pNextRU)
	_WinAPI_ReadProcessMemory($hProc, $Pointer1, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + $dwPartyFlagsRU) ;specify what to read here
	_WinAPI_ReadProcessMemory($hProc, $Pointer2, DllStructGetPtr($AreaLevel), DllStructGetSize($AreaLevel), $iRead1)
	;$Pointer3 = '0x' & Hex(DllStructGetData($Buffer, 1)+$pRoom2StructR1)
	;_WinAPI_ReadProcessMemory($hProc, $Pointer3, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	;$Pointer4 = '0x' & Hex(DllStructGetData($Buffer, 1)+$pLevelStructR2)
	;_WinAPI_ReadProcessMemory($hProc, $Pointer4, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	;$Pointer5 = '0x' & Hex(DllStructGetData($Buffer, 1)+$dwLevelNoL)
	;_WinAPI_ReadProcessMemory($hProc, $Pointer5, DllStructGetPtr($AreaLevel), DllStructGetSize($AreaLevel), $iRead2)
	Return DllStructGetData($AreaLevel, 1)
EndFunc   ;==>_DiaAPI_ReadRosterUnit

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_SetSkillByID
; Description ...: Sets the skill on right or left hand by its ID.
; Syntax.........: _DiaAPI_SetSkillByID($hProc, $iHand, $iSkillID)
; Parameters ....: $hProc - The handle to the opened Diablo 2 process as returned
;                           by _DiaAPI_OpenProcessByWindow
;                  $iHand - The hand the skill should be set to
;                           |1 - Left Hand
;                           |2 - Right Hand
;                  $iSkillID - The ID of the skill to be set. Found in SkillType.h
;                              from D2Data.dll source. Comes w/ ao source.
; Return values .: On Success - Returns the integer value of the skill ID from
;                               the left or the right hand.
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......:
; Remarks .......: Still iffy...glitches the level from previous skill on that hand.
;                  Probably bannable on Bnet but havent tested only used SP.
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_SetSkillByID($hProc, $iHand, $iSkillID)
	Local $Buffer = DllStructCreate('ptr')
	Local $SkillID = DllStructCreate('int')
	DllStructSetData($SkillID, 1, $iSkillID)
	Local $iRead1 = 4
	Local $iRead2 = 2
	_WinAPI_ReadProcessMemory($hProc, $D2Client + $pUnitAnyStruct, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer1 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pInfoStructUA)
	_WinAPI_ReadProcessMemory($hProc, $Pointer1, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	If $iHand = 1 Then
		$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pLeftSkillI)
	ElseIf $iHand = 2 Then
		$Pointer2 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pRightSkillI)
	EndIf
	_WinAPI_ReadProcessMemory($hProc, $Pointer2, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer3 = '0x' & Hex(DllStructGetData($Buffer, 1) + $pSkillInfoStructS)
	_WinAPI_ReadProcessMemory($hProc, $Pointer3, DllStructGetPtr($Buffer), DllStructGetSize($Buffer), $iRead1)
	$Pointer4 = '0x' & Hex(DllStructGetData($Buffer, 1) + $wSkillIDSI)
	_WinAPI_WriteProcessMemory($hProc, $Pointer4, DllStructGetPtr($SkillID), DllStructGetSize($SkillID), $iRead2)
	;Return DllStructGetData($SkillID, 1) ; Attack = 0, Kick = 1, Throw = 2...So On. Enum found in SkillType.h (D2Data.dll source w/ ao)
EndFunc   ;==>_DiaAPI_SetSkillByID

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetSkillByID
; Description ...: Returns the string name for the skill.
; Syntax.........: _DiaAPI_GetSkillByID($iSkillID)
; Parameters ....: $iSkillID - The ID of the skill. Returned from _DiaAPI_GetSkillID
; Return values .: On Success - Returns the string name of the skill ID.
;                  On Failure - Returns 0
; Author ........: Murder567
; Modified.......: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetSkillByID($iSkillID)
	Return $skilldata[$iSkillID + 1]
EndFunc   ;==>_DiaAPI_GetSkillByID

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_CreateDia
; Description ...: Creates Diablo window and registers it.
; Syntax.........: _DiaAPI_CreateDia($sPath[, $sTitle = "Diablo II"[, $iLeft = ""[, $iTop = ""[, $iWidth = ""[, $iHeight = ""[, $bWindowed = True]]]]]])
; Parameters ....: $sPath - Path to executable file
;                  $sTitle - Window title
;                  $iLeft - [optional] Left side of Diablo Window
;                  $iTop - [optional] Top of Diablo window
;                  $iWidth - [optional] The width of the window.
;                  $iHeight - [optional] The height of the window.
;                  $bWindowed - [optional] If true Doablo will be created in windowed mode
; Return values .: Success - Handle of Diablo II window
;                  Failure - False
; Author ........: Polite
; Modified.......:
; Remarks .......: This function can create unlimited Diablo 2 windows with out using D2Loader or any other hacks
; Related .......:  _DiaAPI_DestroyDia
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_CreateDia($sPath, $sTitle = "Diablo II", $iLeft = "", $iTop = "", $iWidth = "", $iHeight = "", $bWindowed = True)
	For $i = 0 To UBound($DiabloList) - 1
		If $i > 0 Then
			If $DiabloList[$i] <> "" And $DiabloList[$i] > 0 Then
				_ChangeParent($DiabloList[$i], $HDias)
				ConsoleWrite("New Parent: "&$HDias&@CRLF)
			EndIf
		EndIf
	Next
	If $sPath <> "" Then
		If $bWindowed Then
			$sPath &= " -w"
		EndIf
		$iPid = Run($sPath)
;~ 		;Wtf seems like secret window to foolish window handle based bots
		WinWait("Diablo II")
		WinWait("Diablo II")
		$hWnd = _ProcessGetWindow($iPid)
		_ArrayAdd($DiabloList, $hWnd)
		WinSetTitle($hWnd, "", $sTitle)
		$xywh = WinGetPos($hWnd)
		If Not @error Then
			If $iLeft = "" Then $iLeft = $xywh[0]
			If $iTop = "" Then $iTop = $xywh[1]
			If $iWidth = "" Then $iWidth = $xywh[2]
			If $iHeight = "" Then $iHeight = $xywh[3]
		EndIf
		WinMove($hWnd, "", $iLeft, $iTop, $iWidth, $iHeight)
	Else
		Return False
	EndIf
	For $i = 0 To UBound($DiabloList) - 1
		If $i > 0 Then
			If $DiabloList[$i] <> "" And $DiabloList[$i] > 0 Then
				_ChangeParent($DiabloList[$i], 0)
			EndIf
		EndIf
	Next
	Return $hWnd
EndFunc   ;==>_DiaAPI_CreateDia

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_DestroyDia
; Description ...: Kills Diablo window and unregisters it
; Syntax.........: _DiaAPI_DestroyDia($hWnd)
; Parameters ....: $hWnd - Handle of window
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......: _DiaAPI_CreateDia
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_DestroyDia($hWnd)
	For $i = 0 To UBound($DiabloList) - 1
		If $i > 0 Then
			If $DiabloList[$i] <> "" And $DiabloList[$i] > 0 Then
				If $DiabloList[$i] = $hWnd Then
					WinKill($DiabloList[$i])
					_ArrayDelete($DiabloList, $i)
					Return True
				EndIf
			EndIf
		EndIf
	Next
	Return False
EndFunc   ;==>_DiaAPI_DestroyDia

; #FUNCTION# ;===============================================================================
; Name...........: _ProcessGetWindow
; Description ...: Gets process's main window
; Syntax.........: _ProcessGetWindow($PId)
; Parameters ....: $PId - Process PId
; Return values .: Window title
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _ProcessGetWindow($PId)
	If IsNumber($PId) = 0 Or ProcessExists(_ProcessGetName($PId)) = 0 Then
		SetError(1)
	Else
		Local $WinList = WinList("Diablo II")
		Local $i = 1
		Local $WindowHandle = ""
		While $i <= $WinList[0][0] And $WindowHandle = ""
			If WinGetProcess($WinList[$i][0], "") = $PId Then
				$WindowHandle = $WinList[$i][1]
			Else
				$i += 1
			EndIf
		WEnd
		Return $WindowHandle
	EndIf
EndFunc   ;==>_ProcessGetWindow

; #FUNCTION# ;===============================================================================
; Name...........: _ProcessGetId
; Description ...: Writes data to console
; Syntax.........: _ProcessGetId($Process)
; Parameters ....: $Process - Process name
; Return values .: Process ID.
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _ProcessGetId($Process)
	If IsString($Process) = 0 Then
		SetError(2)
	ElseIf ProcessExists($Process) = 0 Then
		SetError(1)
	Else
		Local $PList = ProcessList($Process)
		Local $i
		Local $PId[$PList[0][0] + 1]
		$PId[0] = $PList[0][0]
		For $i = 1 To $PList[0][0]
			$PId[$i] = $PList[$i][1]
		Next
		Return $PId
	EndIf
EndFunc   ;==>_ProcessGetId

; #FUNCTION# ;===============================================================================
; Name...........: _ProcessGetName
; Description ...: Gets process name by it's PID
; Syntax.........: _ProcessGetName($PId)
; Parameters ....: $PId - Process ID
; Return values .: Process name
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _ProcessGetName($PId)
	If IsNumber($PId) = 0 Then
		SetError(2)
	ElseIf $PId > 9999 Then
		SetError(1)
	Else
		Local $PList = ProcessList()
		Local $i = 1
		Local $ProcessName = ""

		While $i <= $PList[0][0] And $ProcessName = ""
			If $PList[$i][1] = $PId Then
				$ProcessName = $PList[$i][0]
			Else
				$i = $i + 1
			EndIf
		WEnd
		Return $ProcessName
	EndIf
EndFunc   ;==>_ProcessGetName

; #FUNCTION# ;===============================================================================
; Name...........: _ChangeParent
; Description ...: Changes the parent window of the specified child window
; Syntax.........: _ChangeParent($hWndChild,$hWndParentNew)
; Parameters ....: $hWndChild - Window handle of child window
;                  $$hWndParentNew - Handle to the new parent window. If 0, the desktop window becomes the new parent window.
; Return values .: None.
; Author ........: Probably Murder567
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _ChangeParent($hWndChild, $hWndParentNew)
	DllCall('user32.dll', 'hWnd', 'SetParent', 'hWnd', $hWndChild, 'hWnd', $hWndParentNew)
EndFunc   ;==>_ChangeParent

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetGameName
; Description ...: Gets game name
; Syntax.........: _ConsoleWriteLine($sData)
; Parameters ....: $hProc - The handle to the opened Diablo 2 window as returned
;                           by _DiaAPI_OpenProcessByWindow
; Return values .: Game name
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetGameName($hProc)
	Local $pBuffer = DllStructCreate("ptr")
	Local $GameName = DllStructCreate("char[15]")
	$iRead = 4
	$gRead = 16
	_WinAPI_ReadProcessMemory($hProc, "0x" & Hex($D2Client + $GameStructInfo), DllStructGetPtr($pBuffer), DllStructGetSize($pBuffer), $iRead)
	_WinAPI_ReadProcessMemory($hProc, DllStructGetData($pBuffer, 1) + 0x1b, DllStructGetPtr($GameName), DllStructGetSize($GameName), $gRead)
	Return DllStructGetData($GameName, 1)
EndFunc   ;==>_DiaAPI_GetGameName

; #FUNCTION# ;===============================================================================
; Name...........: _ConsoleWriteLine
; Description ...: Writes data to console
; Syntax.........: _ConsoleWriteLine($sData)
; Parameters ....: $sData - Data to write in console
; Return values .: None
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _ConsoleWriteLine($sData)
	ConsoleWrite($sData & @CRLF)
EndFunc   ;==>_ConsoleWriteLine

; #FUNCTION# ;===============================================================================
; Name...........:__DiaAPI_SetFull
; Description ...: Streches Diablo window to fullscreen
; Syntax.........:__DiaAPI_SetFull($hWnd)
; Parameters ....: $hWnd - The handle to the opened Diablo 2 window as returned
;                          by _DiaAPI_CreateDia
; Return values .: None
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func __DiaAPI_SetFull($hWnd)
	$xywh = WinGetPos($hWnd)
	$Client = WinGetClientSize($hWnd)
	$ClientWidth = $Client[0]
	$ClientHeight = $Client[1]
	$WindowBorderWidth = ($xywh[2] - $ClientWidth) / 2
	$WindowTilebarHeight = ($xywh[3] - $WindowBorderWidth) - $ClientHeight
	WinMove($hWnd, "", -$WindowBorderWidth, -$WindowTilebarHeight, @DesktopWidth + $WindowBorderWidth + $WindowBorderWidth, @DesktopHeight + $WindowTilebarHeight + $WindowBorderWidth)
EndFunc   ;==>_Dia_SetFull

; #FUNCTION# ;===============================================================================
; Name...........: ArrayFind
; Description ...: Searches for value from array
; Syntax.........: ArrayFind($Array, $Val)
; Parameters ....: $Array - Array to search from
;                  $Val - Value to search for
; Return values .: None
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func ArrayFind($Array, $Val)
	For $i = 1 To $Array[0]
		If $Array[$i] = $Val Then Return $i
	Next
EndFunc   ;==>ArrayFind

; #FUNCTION# ;===============================================================================
; Name...........: _MouseLock
; Description ...: Locks mouse in given window
; Syntax.........: _MouseLock($Title)
; Parameters ....: $sTitle - Window title
; Return values .: None
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _MouseLock($Title)
	$xywh = WinGetPos($Title)
	_ConsoleWriteLine("Mouse Locked in window: " & $Title)
	$Lock = True
	$dll = DllOpen("user32.dll")
	If $DisplaTutorial = "true" Then
		SplashTextOn("Selected: " & $Title, "To allow your mouse leave from selected window, press " & $Key1String & " + " & $Key2String, 450, 70, 0, 0)
	EndIf
	$Client = WinGetClientSize($Title)
	$ClientWidth = $Client[0]
	$ClientHeight = $Client[1]
	$WindowBorderWidth = ($xywh[2] - $ClientWidth) / 2
	$WindowTilebarHeight = ($xywh[3] - $WindowBorderWidth) - $ClientHeight
	Sleep(250);In order not to let _IsPressed capture keystoke used to lock mouse
	;If you remove this sleep, mouse will unlocked instantly
	While $Lock = True
		If Not WinExists($Title) Then Return False
		$xy = MouseGetPos()
		If $xy[0] < $xywh[0] + $WindowBorderWidth Then MouseMove($xywh[0] + $WindowBorderWidth, $xy[1], 0);left
		If $xy[0] > $xywh[0] + $xywh[2] - $WindowBorderWidth - 1 Then MouseMove($xywh[0] + $xywh[2] - $WindowBorderWidth - 1, $xy[1], 0);right
		If $xy[1] < $xywh[1] + $WindowTilebarHeight Then MouseMove($xy[0], $xywh[1] + $WindowTilebarHeight, 0);top
		If $xy[1] > $xywh[1] + $xywh[3] - $WindowBorderWidth - 1 Then MouseMove($xy[0], $xywh[1] + $xywh[3] - $WindowBorderWidth - 1, 0);bottom
		If Not WinActive($Title) Then WinActivate($Title)
		If _IsPressed($Key1Code, $dll) And _IsPressed($Key2Code, $dll) Then
			_ConsoleWriteLine("Deactivated (" & $Key1Code & ";" & $Key2Code & ")")
			If $DisplaTutorial = "true" Then
				SplashOff()
			EndIf
			_DisplayTutorial("Unselected", "You can now freely move your mouse again", 450, 70)
			$Lock = False
			Return True
		EndIf
		Sleep(10)
	WEnd
	DllClose($dll)
EndFunc   ;==>_MouseLock

; #FUNCTION# ;===============================================================================
; Name...........: _DisplayTutorial
; Description ...: Displays tutorial
; Syntax.........: _DisplayTutorial($sTitle, $sText, $iW, $iH)
; Parameters ....: $sTitle - Window title
;                  $sText - Text to Display
;                  $iW - Window width
;                  $iH - Window height
; Return values .: None
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DisplayTutorial($sTitle, $sText, $iW, $iH)
	If $DisplaTutorial = "True" Then
		$hGui = GUICreate($sTitle, $iW, $iH + 35)
		GUICtrlCreateLabel($sText, 10, 10, $iW - 20, $iH)
		$NoTutorial = GUICtrlCreateButton("Do not show tutorials anymore", 10, $iH + 5, 170)
		$Continue = GUICtrlCreateButton("Continue >>", 180, $iH + 5, 75)
		GUISetState()

		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case -3
					Exit
				Case $Continue
					GUIDelete()
					Return
				Case $NoTutorial
					GUIDelete()
					IniWrite($ini, "_MouseLocker", "Tutorial", "False")
					$DisplaTutorial = "False"
					Return
			EndSwitch
		WEnd
	EndIf
	Return
EndFunc   ;==>_DisplayTutorial

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetPlayerName
; Description ...: Gets player name
; Syntax.........: _DiaAPI_GetPlayerName($hProc)
; Parameters ....: $hProc - The handle to the opened Diablo 2 window as returned
;                           by _DiaAPI_OpenProcessByWindow
; Return values .: Character name
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetPlayerName($hProc)
	Local $pBuffer = DllStructCreate("ptr")
	Local $GameName = DllStructCreate("char[15]")
	$iRead = 4
	$gRead = 16
	_WinAPI_ReadProcessMemory($hProc, "0x" & Hex($D2Client + $GameStructInfo), DllStructGetPtr($pBuffer), DllStructGetSize($pBuffer), $iRead)
	_WinAPI_ReadProcessMemory($hProc, DllStructGetData($pBuffer, 1) + 0xB9, DllStructGetPtr($GameName), DllStructGetSize($GameName), $gRead)
	Return DllStructGetData($GameName, 1)
EndFunc   ;==>_DiaAPI_GetPlayerName

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetGamePassword
; Description ...: Gets game password
; Syntax.........: _DiaAPI_GetGamePassword($hProc)
; Parameters ....: $hProc - The handle to the opened Diablo 2 window as returned
;                           by _DiaAPI_OpenProcessByWindow
; Return values .: Game password
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetGamePassword($hProc)
	Local $pBuffer = DllStructCreate("ptr")
	Local $GameName = DllStructCreate("char[15]")
	$iRead = 4
	$gRead = 16
	_WinAPI_ReadProcessMemory($hProc, "0x" & Hex($D2Client + $GameStructInfo), DllStructGetPtr($pBuffer), DllStructGetSize($pBuffer), $iRead)
	_WinAPI_ReadProcessMemory($hProc, DllStructGetData($pBuffer, 1) + 0x241, DllStructGetPtr($GameName), DllStructGetSize($GameName), $gRead)
	Return DllStructGetData($GameName, 1)
EndFunc   ;==>_DiaAPI_GetPlayerName

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetRealmName
; Description ...: Gets realm name
; Syntax.........: _DiaAPI_GetRealmName($hProc)
; Parameters ....: $hProc - The handle to the opened Diablo 2 window as returned
;                           by _DiaAPI_OpenProcessByWindow
; Return values .: Realm name
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetRealmName($hProc)
	Local $pBuffer = DllStructCreate("ptr")
	Local $GameName = DllStructCreate("char[15]")
	$iRead = 4
	$gRead = 16
	_WinAPI_ReadProcessMemory($hProc, "0x" & Hex($D2Client + $GameStructInfo), DllStructGetPtr($pBuffer), DllStructGetSize($pBuffer), $iRead)
	_WinAPI_ReadProcessMemory($hProc, DllStructGetData($pBuffer, 1) + 0xD1, DllStructGetPtr($GameName), DllStructGetSize($GameName), $gRead)
	Return DllStructGetData($GameName, 1)
EndFunc   ;==>_DiaAPI_GetPlayerName

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetAccountName
; Description ...: Gets account name
; Syntax.........: _DiaAPI_GetAccountName($hProc)
; Parameters ....: $hProc - The handle to the opened Diablo 2 window as returned
;                           by _DiaAPI_OpenProcessByWindow
; Return values .: Account name
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetAccountName($hProc)
	Local $pBuffer = DllStructCreate("ptr")
	Local $GameName = DllStructCreate("char[15]")
	$iRead = 4
	$gRead = 16
	_WinAPI_ReadProcessMemory($hProc, "0x" & Hex($D2Client + $GameStructInfo), DllStructGetPtr($pBuffer), DllStructGetSize($pBuffer), $iRead)
	_WinAPI_ReadProcessMemory($hProc, DllStructGetData($pBuffer, 1) + 0x89, DllStructGetPtr($GameName), DllStructGetSize($GameName), $gRead)
	Return DllStructGetData($GameName, 1)
EndFunc   ;==>_DiaAPI_GetPlayerName

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetGameIP
; Description ...: Gets game IP address
; Syntax.........: _DiaAPI_GetGameIP($hProc)
; Parameters ....: $hProc - The handle to the opened Diablo 2 window as returned
;                           by _DiaAPI_OpenProcessByWindow
; Return values .: Game IP address
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetGameIP($hProc)
	Local $pBuffer = DllStructCreate("ptr")
	Local $GameName = DllStructCreate("char[15]")
	$iRead = 4
	$gRead = 16
	_WinAPI_ReadProcessMemory($hProc, "0x" & Hex($D2Client + $GameStructInfo), DllStructGetPtr($pBuffer), DllStructGetSize($pBuffer), $iRead)
	_WinAPI_ReadProcessMemory($hProc, DllStructGetData($pBuffer, 1) + 0x33, DllStructGetPtr($GameName), DllStructGetSize($GameName), $gRead)
	Return DllStructGetData($GameName, 1)
EndFunc   ;==>_DiaAPI_GetPlayerName

; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_GetGamePing
; Description ...: Gets game ping
; Syntax.........: _DiaAPI_GetGamePing($hProc)
; Parameters ....: $hProc - The handle to the opened Diablo 2 window as returned
;                           by _DiaAPI_OpenProcessByWindow
; Return values .: Game ping
; Author ........: Polite
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_GetGamePing($hProc)
	Local $iPing = DllStructCreate("int")
	$iRead = 4
	_WinAPI_ReadProcessMemory($hProc, "0x" & Hex($D2Client + 0x119804), DllStructGetPtr($iPing), DllStructGetSize($iPing), $iRead)
	Return DllStructGetData($iPing, 1)
EndFunc   ;==>_DiaAPI_GetPlayerName