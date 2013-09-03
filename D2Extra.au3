;######################################################
;~>													<~;
;~>		AutoIt Version: 3.3.6.1						<~;
;~>		Author:        Shaggi						<~;
;~>													<~;
;~>		~~ D2Extra v. 1.1 ~~						<~;
;~>													<~;
;~>		Script Function:							<~;
;~>		Opens a new Diablo II window,				<~;
;~>		from the settings in the ini, safe.			<~;
;~>		If renamed to D2Multi.exe, it will			<~;
;~>		read settings from D2Multi.ini.				<~;
;~>													<~;
;~>		Credits:									<~;
;~>		Rain and Murder567 for idea.				<~;
;~>													<~;
;~>		Commandline:								<~;
;~>		Accepts -title "your title"					<~;
;~>													<~;
;######################################################
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Diablo%20II%202.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <Misc.au3>
#include <WinAPI.au3>
; #FUNCTION# ;===============================================================================
; Name...........: _DiaAPI_CreateDia
; Description ...: Creates Diablo window and registers it.
; Syntax.........: _DiaAPI_CreateDia($sPath[, $sTitle = "Diablo II"[, $iLeft = ""[, $iTop = ""[, $iWidth = ""[, $iHeight = ""[, $bWindowed = True]]]]]])
; Parameters ....: $sPath - Path to executable file
;                  $sTitle - Window title
;                  $Params - [optional] Adds parameters to the path
;                  $iLeft - [optional] Left side of Diablo Window
;                  $iTop - [optional] Top of Diablo window
;                  $iWidth - [optional] The width of the window.
;                  $iHeight - [optional] The height of the window.
; Return values .: Success - Handle of Diablo II window
;                  Failure - False
; Author ........: Polite
; Modified.......: Shaggi
; Remarks .......: This function can create unlimited Diablo 2 windows with out using D2Loader or any other hacks
; Related .......:  _DiaAPI_DestroyDia
; Link ..........:
; Example .......: No
;============================================================================================
Func _DiaAPI_CreateDia($sPath, $sTitle = "Diablo II", $Params = "",$WorkingDir = @ScriptDir,$iLeft = "", $iTop = "", $iWidth = "", $iHeight = "")
	For $i = 1 To $DiabloList[0]
		If IsHwnd($DiabloList[$i]) Then
			If NOT _ChangeParent($DiabloList[$i], $hDias) Then MsgBox(16,"Autumn " & $Version & " :: D2Extra","Error code while changing parent: " & _WinAPI_GetLastError() & @CRLF & _WinAPI_GetLastErrorMessage())
		EndIf
	Next
	If $sPath <> "" Then
		;$sPath &= " " & $Params
		Local $nStruct = CreateProcess($sPath,$Params,$WorkingDir)
		If NOT IsDllStruct($nStruct) Then
			MsgBox(16,"Autumn " & $Version & " :: D2Extra","Failed to run path")
			Return False
		EndIf
		$hWnd = WinWait($NewDiabloTitle,"",20)
		If NOT $hWnd Then
			MsgBox(16,"Autumn " & $Version & " :: D2Extra","TimeOut")
			Return False
		EndIf
		_ArrayAdd($DiabloList, $hWnd)
		$DiabloList[0] += 1
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
	For $i = 1 To $DiabloList[0]
		If IsHwnd($DiabloList[$i]) Then
			If NOT _ChangeParent($DiabloList[$i], 0) Then MsgBox(16,"Autumn " & $Version & " :: D2Extra","Error code while changing parent: " & _WinAPI_GetLastError() & @CRLF & _WinAPI_GetLastErrorMessage())
		EndIf
	Next
	Return $nStruct
EndFunc   ;==>_DiaAPI_CreateDia
; #FUNCTION# ;===============================================================================
; Name...........: _ChangeParent
; Description ...: Changes the parent window of the specified child window
; Syntax.........: _ChangeParent($hWndChild,$hWndParentNew)
; Parameters ....: $hWndChild - Window handle of child window
;                  $$hWndParentNew - Handle to the new parent window. If 0, the desktop window becomes the new parent window.
; Return values .: None.
; Author ........: Probably Murder567
; Modified.......: Shaggi
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
;============================================================================================
Func _ChangeParent($hWndChild, $hWndParentNew)
	$Call = DllCall('user32.dll', 'hWnd', 'SetParent', 'hWnd', $hWndChild, 'hWnd', $hWndParentNew)
	Return $call[0]
EndFunc   ;==>_ChangeParent