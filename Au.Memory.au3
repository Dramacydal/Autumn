;#################################################
;~ AutoIt Version:  3.3.6.1
;~ Author:          Shaggi
;~ Credits:         Rain / polite / buthcer, Fuhrmanator, asp
;~ What is this? Custom made memory udf for diablo II.
;~ Feautures: Supports every windows system based on NT and both x86 and x64. Includes all functions needed. Patches rights for game.exe.
;~ Optimized for speed and ease.
;#################################################

#include-once
#include <WinApi.au3>

If NOT IsDeclared("SE_KERNEL_OBJECT") Then Global Const $SE_KERNEL_OBJECT 						= 6
If NOT IsDeclared("DACL_SECURITY_INFORMATION") Then  	Global Const $DACL_SECURITY_INFORMATION 			= 0x00000004
If NOT IsDeclared("ERROR_SUCCESS") Then Global Const $ERROR_SUCCESS 						= 0
If NOT IsDeclared("WRITE_DAC") Then  Global Const $WRITE_DAC 							= 0x00040000
If NOT IsDeclared("UNPROTECTED_DACL_SECURITY_INFORMATION") Then Global Const $UNPROTECTED_DACL_SECURITY_INFORMATION = 0x20000000
If NOT IsDeclared("READ_CONTROL") Then  Global Const $READ_CONTROL 							= 0x00020000
Global $nCount = 0
Global $nStartTime = TimerInit()
;##################################################
;~ This is a full, custom wrapper for Diablo II, that reads the memory, using a process id
;~ Parameters:
;~ $Pid --> processid of app
;~ $Address --> address to be read
;~ $Format --> Defines how the memory that is read should be returned,- dword by default
;~ $Read --> amount of data read
;~ $DebugEnabled --> writes some stuff to console to help debugging.
;~ Note: If you want to use this a lot, better use _ReadD2Memory() func
;##################################################

Func _ReadD2MemoryW($pid, $Address, $format = "dword",$Debugenabled = False)
	Local $aHandle = openSecureProcess($pid,0x001F0FFF)
	Local $v_Buffer = DllStructCreate($format)
	Local $Result = readProcessMemory($aHandle, $Address, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer))
	Local $Temp = DllStructGetData($v_Buffer, 1)
	closeProcess($aHandle)
	If $Debugenabled = True Then
		ConsoleWrite(@CRLF & $pid & " <--- pID of process." & @CRLF)
		ConsoleWrite($aHandle & " <--- Handle to process." & @CRLF)
		ConsoleWrite(DllStructGetData($v_Buffer, 1) & " <--- DllStruct of format." & @CRLF)
		ConsoleWrite($Result & " <--- Result of ReadprocessMemory (1 = success, 0 = failure)." & @CRLF)
		ConsoleWrite($Temp & " <--- Memory Read." & @CRLF)
	EndIf
	Return $Temp
EndFunc   ;==>_ReadD2Memory

;##################################################
;~ This is a custom wrapper for Diablo II, that reads the memory, using a handle
;~ Parameters:
;~ $Pid --> processid of app
;~ $Address --> address to be read
;~ $Format --> Defines how the memory that is read should be returned,- dword by default
;~ $Read --> amount of data read
;~ $DebugEnabled --> writes some stuff to console to help debugging.
;~ $hDll --> Open handle to the dll "kernel32"
;##################################################
Func _ReadD2Memory($aHandle, $Address, $format = "dword",$Debugenabled = False,$hDll = "kernel32.dll")
	Local $v_Buffer = DllStructCreate($format)
	Local $Result = readProcessMemory($aHandle, $Address, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$hDll)
	Local $Temp = DllStructGetData($v_Buffer, 1)
	If $Debugenabled Then
		ConsoleWrite(@CRLF & $pid & " <--- pID of process." & @CRLF)
		ConsoleWrite($aHandle & " <--- Handle to process." & @CRLF)
		ConsoleWrite($format & " <--- DllStruct of format." & @CRLF)
		ConsoleWrite($Result & " <--- Result of ReadprocessMemory (1 = success, 0 = failure)." & @CRLF)
		ConsoleWrite($Temp & " <--- Memory Read." & @CRLF)
	EndIf
	Return $Temp
EndFunc   ;==>_ReadD2Memory

Func readProcessMemory($hProcess, $pBaseAddress, $pBuffer, $iSize,$hDll = "kernel32.dll")
	Local $aResult = DllCall($__Dll_Kernel32, "bool", "ReadProcessMemory", "handle", $hProcess,"ptr", $pBaseAddress, "ptr", $pBuffer, "ulong_ptr", $iSize, "ulong_ptr*", 0)
	Return $aResult[0]
EndFunc   ;==>readProcessMemory

Func _OpenProcess($iAccess, $fInherit, $iProcessID,$hDll = "kernel32.dll")
	Local $aResult = DllCall($hDll, "handle", "_OpenProcess", "dword", $iAccess, "bool", $fInherit, "dword", $iProcessID)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then Return $aResult[0]
EndFunc	;==>_OpenProcess

Func closeProcess($aHandle,$hDll = "kernel32.dll")
	Local $aResult = DllCall($hDll, "bool", "CloseHandle", "handle", $aHandle)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>closeProcess

Func setPrivilege($Privilege, $Enable)
	Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
	If @error Then Return SetError(@error, @extended, 0)
	_Security__SetPrivilege($hToken, $Privilege, $Enable)
EndFunc

;##################################
;/**	openSecureProcess()
;* Opens a process. Overwrite the DACL of target process
;* as a fallback if the process has dropped rights. Doesn't
;* require the user to be logged in with system or admin
;* rights.
;*
;* Edited by Shaggi:
;* Tries with debug privilege first, then overwrites dacl,
;* and resets it back to original state.
;*
;* @author asp
;* @param wndclass Name of windowclass.
;* @param rights The process access rights you want.
;* @return 0 on failure. Otherwise handle to process.
;*/
;~ Credits to Rain for converting it to AutoIt.
;##################################
Func openSecureProcess($Pid, $Rights)
	If NOT ProcessExists($pid) Then Return False
	; Try to open the process with the requested rights.
	$process = _WinAPI_OpenProcess($Rights, False, $Pid, True);
	If $process Then
		Return $process
	EndIf
	;Okay, didnt work, even with debug privilege.
	;Going to mirror our SID to target process,
	;open a handle, and reset SID
	Local $process
	Local $dacl = DllStructCreate("ptr")
	Local $secdesc = DllStructCreate("ptr")
	Local $dacl_target = DllStructCreate("ptr")
	Local $secdesc_target = DllStructCreate("ptr")
	; Get the DACL of this process since we know we have
	; all rights in it. This really can't fail.
	If(getSecurityInfo(_WinAPI_GetCurrentProcess(), _
			$SE_KERNEL_OBJECT, _
			$DACL_SECURITY_INFORMATION, _
			0, _
			0, _
			DllStructGetPtr($dacl, 1), _
			0, _
			DllStructGetPtr($secdesc, 1)) <> $ERROR_SUCCESS) Then
		Return False
	EndIf
	; Open it with WRITE_DAC || READ_CONTROL access,
	; so that we can read and write to the DACL.
	$process = _WinAPI_OpenProcess(BitOR($WRITE_DAC, $READ_CONTROL), 0, $Pid)
	If NOT $process Then
		_WinAPI_LocalFree($secdesc)
		Return False
	EndIf
	; Get the DACL of target process and store it,
	; so we can reset it later
	If(getSecurityInfo($process, _
			$SE_KERNEL_OBJECT, _
			$DACL_SECURITY_INFORMATION, _
			0, _
			0, _
			DllStructGetPtr($dacl_target, 1), _
			0, _
			DllStructGetPtr($secdesc_target, 1)) <> $ERROR_SUCCESS) Then
		Return False
	EndIf
	;Overwrite the Dacl with our own
	If(setSecurityInfo($process, _
			$SE_KERNEL_OBJECT, _
			BitOR($DACL_SECURITY_INFORMATION, $UNPROTECTED_DACL_SECURITY_INFORMATION), _
			0, _
			0, _
			DllStructGetData($dacl, 1), _
			0) <> $ERROR_SUCCESS) Then
		_WinAPI_LocalFree($secdesc)
		Return False
	EndIf
	; The DACL is overwritten with our own DACL. We
	; should be able to open it with the requested
	; privileges now.
	_WinAPI_LocalFree($secdesc)
	_WinAPI_CloseHandle($process)
	$hProc = _WinAPI_OpenProcess($Rights, False, $Pid, True)
	If NOT $hProc Then
		Return False
	EndIf
	;Assuming we got the process. Proceeding to revert the patch, and return the enabled process handle
	If(setSecurityInfo($hProc, _
			$SE_KERNEL_OBJECT, _
			BitOR($DACL_SECURITY_INFORMATION, $UNPROTECTED_DACL_SECURITY_INFORMATION), _
			0, _
			0, _
			DllStructGetData($dacl_target, 1), _
			0) <> $ERROR_SUCCESS) Then
		_WinAPI_LocalFree($secdesc_target)
		Return False
	EndIf
	_WinAPI_LocalFree($secdesc_target)
	Return $hProc
EndFunc   ;==>openSecureProcess

Func getSecurityInfo($handle, $ObjectType, $SecurityInfo, $ppsidOwner, $ppsidGroup, $ppDacl, $ppSacl, $ppSecurityDescriptor)
	Local $call = DllCall("Advapi32.dll", "long", "GetSecurityInfo", _
			"ptr", $handle, _
			"int", $ObjectType, _
			"dword", $SecurityInfo, _
			"ptr", $ppsidOwner, _
			"ptr", $ppsidGroup, _
			"ptr", $ppDacl, _
			"ptr", $ppSacl, _
			"ptr", $ppSecurityDescriptor)
	Return $call[0]
EndFunc   ;==>GetSecurityInfo

Func setSecurityInfo($handle, $ObjectType, $SecurityInfo, $psidOwner, $psidGroup, $pDacl, $pSacl)
	$call = DllCall("Advapi32.dll", "long", "SetSecurityInfo", _
			"ptr", $handle, _
			"int", $ObjectType, _
			"dword", $SecurityInfo, _
			"ptr", $psidOwner, _
			"ptr", $psidGroup, _
			"ptr", $pDacl, _
			"ptr", $pSacl)
	Return $call[0]
EndFunc   ;==>SetSecurityInfo

;~ #########################################
;~ Credits to Fuhrmanator. Modified it a bit to work current ui. This reads wide strings.
;~ #########################################

Func _MemoryReadWideString($iv_Address,$sv_Type = 'wchar[10]')
	Return _ReadD2Memory($Diablo_MemHandle,$iv_Address,$sv_Type,False,$__Dll_Kernel32)
EndFunc   ;==>_MemoryReadWideString