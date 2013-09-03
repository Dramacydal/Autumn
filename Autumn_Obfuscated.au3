#NoTrayIcon
#RequireAdmin
FileInstall(".\LEAF_48.png",@ScriptDir & "\LEAF_48.png")
Func _ArrayAdd(ByRef $avArray, $vValue)
If Not IsArray($avArray) Then Return SetError(1, 0, -1)
If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, -1)
Local $iUBound = UBound($avArray)
ReDim $avArray[$iUBound + 1]
$avArray[$iUBound] = $vValue
Return $iUBound
EndFunc
Func _ArrayDelete(ByRef $avArray, $iElement)
If Not IsArray($avArray) Then Return SetError(1, 0, 0)
Local $iUBound = UBound($avArray, 1) - 1
If Not $iUBound Then
$avArray = ""
Return 0
EndIf
If $iElement < 0 Then $iElement = 0
If $iElement > $iUBound Then $iElement = $iUBound
Switch UBound($avArray, 0)
Case 1
For $i = $iElement To $iUBound - 1
$avArray[$i] = $avArray[$i + 1]
Next
ReDim $avArray[$iUBound]
Case 2
Local $iSubMax = UBound($avArray, 2) - 1
For $i = $iElement To $iUBound - 1
For $j = 0 To $iSubMax
$avArray[$i][$j] = $avArray[$i + 1][$j]
Next
Next
ReDim $avArray[$iUBound][$iSubMax + 1]
Case Else
Return SetError(3, 0, 0)
EndSwitch
Return $iUBound
EndFunc
Func _ArrayReverse(ByRef $avArray, $iStart = 0, $iEnd = 0)
If Not IsArray($avArray) Then Return SetError(1, 0, 0)
If UBound($avArray, 0) <> 1 Then Return SetError(3, 0, 0)
Local $vTmp, $iUBound = UBound($avArray) - 1
If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(2, 0, 0)
For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
$vTmp = $avArray[$i]
$avArray[$i] = $avArray[$iEnd]
$avArray[$iEnd] = $vTmp
$iEnd -= 1
Next
Return 1
EndFunc
Func _ArraySearch(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iPartial = 0, $iForward = 1, $iSubItem = -1)
If Not IsArray($avArray) Then Return SetError(1, 0, -1)
If UBound($avArray, 0) > 2 Or UBound($avArray, 0) < 1 Then Return SetError(2, 0, -1)
Local $iUBound = UBound($avArray) - 1
If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
If $iStart < 0 Then $iStart = 0
If $iStart > $iEnd Then Return SetError(4, 0, -1)
Local $iStep = 1
If Not $iForward Then
Local $iTmp = $iStart
$iStart = $iEnd
$iEnd = $iTmp
$iStep = -1
EndIf
Switch UBound($avArray, 0)
Case 1
If Not $iPartial Then
If Not $iCase Then
For $i = $iStart To $iEnd Step $iStep
If $avArray[$i] = $vValue Then Return $i
Next
Else
For $i = $iStart To $iEnd Step $iStep
If $avArray[$i] == $vValue Then Return $i
Next
EndIf
Else
For $i = $iStart To $iEnd Step $iStep
If StringInStr($avArray[$i], $vValue, $iCase) > 0 Then Return $i
Next
EndIf
Case 2
Local $iUBoundSub = UBound($avArray, 2) - 1
If $iSubItem > $iUBoundSub Then $iSubItem = $iUBoundSub
If $iSubItem < 0 Then
$iSubItem = 0
Else
$iUBoundSub = $iSubItem
EndIf
For $j = $iSubItem To $iUBoundSub
If Not $iPartial Then
If Not $iCase Then
For $i = $iStart To $iEnd Step $iStep
If $avArray[$i][$j] = $vValue Then Return $i
Next
Else
For $i = $iStart To $iEnd Step $iStep
If $avArray[$i][$j] == $vValue Then Return $i
Next
EndIf
Else
For $i = $iStart To $iEnd Step $iStep
If StringInStr($avArray[$i][$j], $vValue, $iCase) > 0 Then Return $i
Next
EndIf
Next
Case Else
Return SetError(7, 0, -1)
EndSwitch
Return SetError(6, 0, -1)
EndFunc
Global Const $tagPOINT = "long X;long Y"
Global Const $tagRECT = "long Left;long Top;long Right;long Bottom"
Global Const $tagGDIPSTARTUPINPUT = "uint Version;ptr Callback;bool NoThread;bool NoCodecs"
Global Const $tagTOKEN_PRIVILEGES = "dword Count;int64 LUID;dword Attributes"
Global Const $tagPROCESS_INFORMATION = "handle hProcess;handle hThread;dword ProcessID;dword ThreadID"
Global Const $tagSTARTUPINFO = "dword Size;ptr Reserved1;ptr Desktop;ptr Title;dword X;dword Y;dword XSize;dword YSize;dword XCountChars;" & "dword YCountChars;dword FillAttribute;dword Flags;word ShowWindow;word Reserved2;ptr Reserved3;handle StdInput;" & "handle StdOutput;handle StdError"
Global Const $FO_APPEND = 1
Global Const $FO_OVERWRITE = 2
Global Const $ERROR_NO_TOKEN = 1008
Global Const $SE_PRIVILEGE_ENABLED = 0x00000002
Global Const $TOKEN_QUERY = 0x00000008
Global Const $TOKEN_ADJUST_PRIVILEGES = 0x00000020
Func _WinAPI_GetLastError($curErr=@error, $curExt=@extended)
Local $aResult = DllCall("kernel32.dll", "dword", "GetLastError")
Return SetError($curErr, $curExt, $aResult[0])
EndFunc
Func _WinAPI_SetLastError($iErrCode, $curErr=@error, $curExt=@extended)
DllCall("kernel32.dll", "none", "SetLastError", "dword", $iErrCode)
Return SetError($curErr, $curExt)
EndFunc
Func _Security__AdjustTokenPrivileges($hToken, $fDisableAll, $pNewState, $iBufferLen, $pPrevState = 0, $pRequired = 0)
Local $aResult = DllCall("advapi32.dll", "bool", "AdjustTokenPrivileges", "handle", $hToken, "bool", $fDisableAll, "ptr", $pNewState, _
"dword", $iBufferLen, "ptr", $pPrevState, "ptr", $pRequired)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _Security__ImpersonateSelf($iLevel = 2)
Local $aResult = DllCall("advapi32.dll", "bool", "ImpersonateSelf", "int", $iLevel)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _Security__LookupPrivilegeValue($sSystem, $sName)
Local $aResult = DllCall("advapi32.dll", "int", "LookupPrivilegeValueW", "wstr", $sSystem, "wstr", $sName, "int64*", 0)
If @error Then Return SetError(@error, @extended, 0)
Return SetError(0, $aResult[0], $aResult[3])
EndFunc
Func _Security__OpenThreadToken($iAccess, $hThread = 0, $fOpenAsSelf = False)
If $hThread = 0 Then $hThread = DllCall("kernel32.dll", "handle", "GetCurrentThread")
If @error Then Return SetError(@error, @extended, 0)
Local $aResult = DllCall("advapi32.dll", "bool", "OpenThreadToken", "handle", $hThread[0], "dword", $iAccess, "int", $fOpenAsSelf, "ptr*", 0)
If @error Then Return SetError(@error, @extended, 0)
Return SetError(0, $aResult[0], $aResult[4])
EndFunc
Func _Security__OpenThreadTokenEx($iAccess, $hThread = 0, $fOpenAsSelf = False)
Local $hToken = _Security__OpenThreadToken($iAccess, $hThread, $fOpenAsSelf)
If $hToken = 0 Then
If _WinAPI_GetLastError() <> $ERROR_NO_TOKEN Then Return SetError(-3, _WinAPI_GetLastError(), 0)
If Not _Security__ImpersonateSelf() Then Return SetError(-1, _WinAPI_GetLastError(), 0)
$hToken = _Security__OpenThreadToken($iAccess, $hThread, $fOpenAsSelf)
If $hToken = 0 Then Return SetError(-2, _WinAPI_GetLastError(), 0)
EndIf
Return $hToken
EndFunc
Func _Security__SetPrivilege($hToken, $sPrivilege, $fEnable)
Local $iLUID = _Security__LookupPrivilegeValue("", $sPrivilege)
If $iLUID = 0 Then Return SetError(-1, 0, False)
Local $tCurrState = DllStructCreate($tagTOKEN_PRIVILEGES)
Local $pCurrState = DllStructGetPtr($tCurrState)
Local $iCurrState = DllStructGetSize($tCurrState)
Local $tPrevState = DllStructCreate($tagTOKEN_PRIVILEGES)
Local $pPrevState = DllStructGetPtr($tPrevState)
Local $iPrevState = DllStructGetSize($tPrevState)
Local $tRequired = DllStructCreate("int Data")
Local $pRequired = DllStructGetPtr($tRequired)
DllStructSetData($tCurrState, "Count", 1)
DllStructSetData($tCurrState, "LUID", $iLUID)
If Not _Security__AdjustTokenPrivileges($hToken, False, $pCurrState, $iCurrState, $pPrevState, $pRequired) Then  _
Return SetError(-2, @error, False)
DllStructSetData($tPrevState, "Count", 1)
DllStructSetData($tPrevState, "LUID", $iLUID)
Local $iAttributes = DllStructGetData($tPrevState, "Attributes")
If $fEnable Then
$iAttributes = BitOR($iAttributes, $SE_PRIVILEGE_ENABLED)
Else
$iAttributes = BitAND($iAttributes, BitNOT($SE_PRIVILEGE_ENABLED))
EndIf
DllStructSetData($tPrevState, "Attributes", $iAttributes)
If Not _Security__AdjustTokenPrivileges($hToken, False, $pPrevState, $iPrevState, $pCurrState, $pRequired) Then _
Return SetError(-3, @error, False)
Return True
EndFunc
Global Const $__WINAPICONSTANT_FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x100
Global Const $__WINAPICONSTANT_FORMAT_MESSAGE_FROM_SYSTEM = 0x1000
Global Const $HGDI_ERROR = Ptr(-1)
Global Const $INVALID_HANDLE_VALUE = Ptr(-1)
Global Const $KF_EXTENDED = 0x0100
Global Const $KF_ALTDOWN = 0x2000
Global Const $KF_UP = 0x8000
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)
Func _WinAPI_CloseHandle($hObject)
Local $aResult = DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hObject)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_CreateProcess($sAppName, $sCommand, $pSecurity, $pThread, $fInherit, $iFlags, $pEnviron, $sDir, $pStartupInfo, $pProcess)
Local $pCommand = 0
Local $sAppNameType = "wstr", $sDirType = "wstr"
If $sAppName = "" Then
$sAppNameType = "ptr"
$sAppName = 0
EndIf
If $sCommand <> "" Then
Local $tCommand = DllStructCreate("wchar Text[" & 260 + 1 & "]")
$pCommand = DllStructGetPtr($tCommand)
DllStructSetData($tCommand, "Text", $sCommand)
EndIf
If $sDir = "" Then
$sDirType = "ptr"
$sDir = 0
EndIf
Local $aResult = DllCall("kernel32.dll", "bool", "CreateProcessW", $sAppNameType, $sAppName, "ptr", $pCommand, "ptr", $pSecurity, "ptr", $pThread, _
"bool", $fInherit, "dword", $iFlags, "ptr", $pEnviron, $sDirType, $sDir, "ptr", $pStartupInfo, "ptr", $pProcess)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_FormatMessage($iFlags, $pSource, $iMessageID, $iLanguageID, ByRef $pBuffer, $iSize, $vArguments)
Local $sBufferType = "ptr"
If IsString($pBuffer) Then $sBufferType = "wstr"
Local $aResult = DllCall("Kernel32.dll", "dword", "FormatMessageW", "dword", $iFlags, "ptr", $pSource, "dword", $iMessageID, "dword", $iLanguageID, _
$sBufferType, $pBuffer, "dword", $iSize, "ptr", $vArguments)
If @error Then Return SetError(@error, @extended, 0)
If $sBufferType = "wstr" Then $pBuffer = $aResult[5]
Return $aResult[0]
EndFunc
Func _WinAPI_GetCurrentProcess()
Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentProcess")
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetLastErrorMessage()
Local $tBufferPtr = DllStructCreate("ptr")
Local $pBufferPtr = DllStructGetPtr($tBufferPtr)
Local $nCount = _WinAPI_FormatMessage(BitOR($__WINAPICONSTANT_FORMAT_MESSAGE_ALLOCATE_BUFFER, $__WINAPICONSTANT_FORMAT_MESSAGE_FROM_SYSTEM), _
0, _WinAPI_GetLastError(), 0, $pBufferPtr, 0, 0)
If @error Then Return SetError(@error, 0, "")
Local $sText = ""
Local $pBuffer = DllStructGetData($tBufferPtr, 1)
If $pBuffer Then
If $nCount > 0 Then
Local $tBuffer = DllStructCreate("wchar[" &($nCount+1) & "]", $pBuffer)
$sText = DllStructGetData($tBuffer, 1)
EndIf
_WinAPI_LocalFree($pBuffer)
EndIf
Return $sText
EndFunc
Func _WinAPI_GetModuleHandle($sModuleName)
Local $sModuleNameType = "wstr"
If $sModuleName = "" Then
$sModuleName = 0
$sModuleNameType = "ptr"
EndIf
Local $aResult = DllCall("kernel32.dll", "handle", "GetModuleHandleW", $sModuleNameType, $sModuleName)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_GetWindowLong($hWnd, $iIndex)
Local $sFuncName = "GetWindowLongW"
If @AutoItX64 Then $sFuncName = "GetWindowLongPtrW"
Local $aResult = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_LocalFree($hMem)
Local $aResult = DllCall("kernel32.dll", "handle", "LocalFree", "handle", $hMem)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_OpenProcess($iAccess, $fInherit, $iProcessID, $fDebugPriv = False)
Local $aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $fInherit, "dword", $iProcessID)
If @error Then Return SetError(@error, @extended, 0)
If $aResult[0] Then Return $aResult[0]
If Not $fDebugPriv Then Return 0
Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
If @error Then Return SetError(@error, @extended, 0)
_Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
Local $iError = @error
Local $iLastError = @extended
Local $iRet = 0
If Not @error Then
$aResult = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", $fInherit, "dword", $iProcessID)
$iError = @error
$iLastError = @extended
If $aResult[0] Then $iRet = $aResult[0]
_Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
If @error Then
$iError = @error
$iLastError = @extended
EndIf
EndIf
_WinAPI_CloseHandle($hToken)
Return SetError($iError, $iLastError, $iRet)
EndFunc
Func _WinAPI_SetLayeredWindowAttributes($hWnd, $i_transcolor, $Transparency = 255, $dwFlags = 0x03, $isColorRef = False)
If $dwFlags = Default Or $dwFlags = "" Or $dwFlags < 0 Then $dwFlags = 0x03
If Not $isColorRef Then
$i_transcolor = Hex(String($i_transcolor), 6)
$i_transcolor = Execute('0x00' & StringMid($i_transcolor, 5, 2) & StringMid($i_transcolor, 3, 2) & StringMid($i_transcolor, 1, 2))
EndIf
Local $aResult = DllCall("user32.dll", "bool", "SetLayeredWindowAttributes", "hwnd", $hWnd, "dword", $i_transcolor, "byte", $Transparency, "dword", $dwFlags)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _WinAPI_SetWindowLong($hWnd, $iIndex, $iValue)
_WinAPI_SetLastError(0)
Local $sFuncName = "SetWindowLongW"
If @AutoItX64 Then $sFuncName = "SetWindowLongPtrW"
Local $aResult = DllCall("user32.dll", "long_ptr", $sFuncName, "hwnd", $hWnd, "int", $iIndex, "long_ptr", $iValue)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _WinAPI_WaitForSingleObject($hHandle, $iTimeout = -1)
Local $aResult = DllCall("kernel32.dll", "INT", "WaitForSingleObject", "handle", $hHandle, "dword", $iTimeout)
If @error Then Return SetError(@error, @extended, -1)
Return $aResult[0]
EndFunc
Func _WinAPI_WriteProcessMemory($hProcess, $pBaseAddress, $pBuffer, $iSize, ByRef $iWritten, $sBuffer = "ptr")
Local $aResult = DllCall("kernel32.dll", "bool", "WriteProcessMemory", "handle", $hProcess, "ptr", $pBaseAddress, $sBuffer, $pBuffer, _
"ulong_ptr", $iSize, "ulong_ptr*", 0)
If @error Then Return SetError(@error, @extended, False)
$iWritten = $aResult[5]
Return $aResult[0]
EndFunc
#OnAutoItStartRegister "__ProcCall_Startup" 
Global Const $MEM_COMMIT = 0x00001000
Global Const $MEM_RESERVE = 0x00002000
Global Const $PAGE_EXECUTE_READWRITE = 0x00000040
Global Const $MEM_DECOMMIT = 0x00004000
Global Const $PROCESS_ALL_ACCESS = 0x001F0FFF
Func _MemVirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
Local $aResult = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
If @error Then Return SetError(@error, @extended, 0)
Return $aResult[0]
EndFunc
Func _MemVirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
Local $aResult = DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func _Iif($fTest, $vTrueVal, $vFalseVal)
If $fTest Then
Return $vTrueVal
Else
Return $vFalseVal
EndIf
EndFunc
Func _MouseTrap($iLeft = 0, $iTop = 0, $iRight = 0, $iBottom = 0)
Local $aResult
If @NumParams == 0 Then
$aResult = DllCall("user32.dll", "bool", "ClipCursor", "ptr", 0)
If @error Or Not $aResult[0] Then Return SetError(1, _WinAPI_GetLastError(), False)
Else
If @NumParams == 2 Then
$iRight = $iLeft + 1
$iBottom = $iTop + 1
EndIf
Local $tRect = DllStructCreate($tagRECT)
DllStructSetData($tRect, "Left", $iLeft)
DllStructSetData($tRect, "Top", $iTop)
DllStructSetData($tRect, "Right", $iRight)
DllStructSetData($tRect, "Bottom", $iBottom)
$aResult = DllCall("user32.dll", "bool", "ClipCursor", "ptr", DllStructGetPtr($tRect))
If @error Or Not $aResult[0] Then Return SetError(2, _WinAPI_GetLastError(), False)
EndIf
Return True
EndFunc
Global Enum $ERROR_GETTING_HANDLE = 1, $ERROR_ODD_ARGUMENTS, $ERROR_RETRIEVING_ARGUMENTS, $ERROR_INVALID_TYPE, $ERROR_UNKNOWN_CONVENTION, $ERROR_USERHALT, $ERROR_WRITING_CODE, $ERROR_CREATING_THREAD, $ERROR_INAPPROPIATE_FUNCTION, $ERROR_BAD_CALLBACK, $ERROR_ACCESS_DENIED, $ERROR_INVALID_HANDLE, $ERROR_MODULE_NOT_FOUND, $ERROR_INVALID_PROCESS, $ERROR_GETTING_INFO, $ERROR_SETTING_INFO
Global Const $TH32CS_SNAPHEAPLIST = 0x00000001
Global Const $TH32CS_SNAPPROCESS = 0x00000002
Global Const $TH32CS_SNAPTHREAD = 0x00000004
Global Const $TH32CS_SNAPMODULE = 0x00000008
Global Const $TH32CS_SNAPALL = BitOR($TH32CS_SNAPHEAPLIST,$TH32CS_SNAPPROCESS,$TH32CS_SNAPTHREAD,$TH32CS_SNAPMODULE)
If Not IsDeclared("MAX_PATH") Then Global Const $MAX_PATH = 260
If Not IsDeclared("MAX_MODULE_NAME32") Then Global Const $MAX_MODULE_NAME32 = 255
Global Const $CALL_INSTRUCTION_SIZE = 0x5
Global Enum $DLL_Kernel32 = 1, $DLL_Advapi32, $DLL_User32
Global Enum $EDX = 1, $ECX, $EAX, $EDI, $ESI, $ESP, $EBX, $EBP
Global Const $SE_KERNEL_OBJECT = 6
Global Const $DACL_SECURITY_INFORMATION = 0x00000004
Global Const $ERROR_SUCCESS = 0
Global Const $WRITE_DAC = 0x00040000
Global Const $UNPROTECTED_DACL_SECURITY_INFORMATION = 0x20000000
Global Const $READ_CONTROL = 0x00020000
Global $__Memory_Deallocations[1]
Global $__Memory_Sizes[1]
If Not IsDeclared("__Dll__HandleIndex") Then Global $__Dll__HandleIndex[1] = [0]
Global $_Confirm = False
Global $__ProcCall_Start = 0
Func ProcCall($sProcess, $sCallingConv, $uFunction, $sRet, $Type1 = 0, $Param1 = 0, _
$Type2 = 0, $Param2 = 0, _
$Type3 = 0, $Param3 = 0, _
$Type4 = 0, $Param4 = 0, _
$Type5 = 0, $Param5 = 0, _
$Type6 = 0, $Param6 = 0, _
$Type7 = 0, $Param7 = 0, _
$Type8 = 0, $Param8 = 0, _
$Type9 = 0, $Param9 = 0, _
$Type10 = 0, $Param10 = 0, _
$Type11 = 0, $Param11 = 0, _
$Type12 = 0, $Param12 = 0, _
$Type13 = 0, $Param13 = 0, _
$Type14 = 0, $Param14 = 0, _
$Type15 = 0, $Param15 = 0, _
$Type16 = 0, $Param16 = 0, _
$Type17 = 0, $Param17 = 0, _
$Type18 = 0, $Param18 = 0, _
$Type19 = 0, $Param19 = 0, _
$Type20 = 0, $Param20 = 0)
If($sCallingConv <> "stdcall") AND($sCallingConv <> "fastcall") Then Return SetError($ERROR_UNKNOWN_CONVENTION)
Local $Handle_Passed = False
If Not IsPtr($sProcess) Then
Local $Pid = ProcessExists($sProcess)
Local $pHandle = OpenProcess($Pid, $PROCESS_ALL_ACCESS)
Else
Local $Pid = True
Local $Handle_Passed = True
Local $pHandle = $sProcess
EndIf
If Not $pHandle Or Not $Pid Then Return SetError($ERROR_GETTING_HANDLE)
Local $nParams =(@NumParams - 4) / 2
If Mod(@NumParams, 2) Then Return SetError($ERROR_ODD_ARGUMENTS)
If $nParams And IsArray($Type1) Then
Local $Params = $Param1
Local $Types = $Type1
Else
Local $Params[1] = [$nParams]
Local $Types[1] = [$nParams]
For $i = 1 To $nParams
Execute("_ArrayAdd($Params,$Param" & $i & ")")
If @error Then Return SetError($ERROR_RETRIEVING_ARGUMENTS)
Execute("_ArrayAdd($Types,$Type" & $i & ")")
If @error Then Return SetError($ERROR_RETRIEVING_ARGUMENTS)
Next
EndIf
Local $sCode, $pThread, $iRet, $ThreadID, $pCodePointer, $pParam = 0
Local $Arguments = _CreateArgumentCode($pHandle, $sCallingConv, $Params, $Types)
If @Error Then Return SetError($ERROR_INVALID_TYPE)
$sCode &= "0x" & _
"55" & _
"53" & _
"56" & _
"57" & _
$Arguments & _
"33C0" & _
"BB" & _SwapEndian($uFunction) & _
"FFD3" & _
"5F" & _
"5E" & _
"5B" & _
"5D" & _
_AssembleReturn($sRet) & _
"C3"
$pCodePointer = _Allocate($pHandle, StringLen($sCode) / 2)
_WriteCode($pCodePointer, $pHandle, $sCode)
If $_Confirm Then
ConsoleWrite($pCodePointer & @CRLF)
ClipPut($pCodePointer)
If MsgBox(1, "ProcCall", "Confirm execution of code at " & $pCodePointer & ".") = 2 Then Return SetError($ERROR_USERHALT)
EndIf
$pThread = _CreateRemoteThread($pHandle, 0, 0, $pCodePointer, $pParam, 0, $ThreadID)
$iRet = WaitForThreadAndGetReturnCode($pThread)
For $i = 1 To $__Memory_Deallocations[0]
_VirtualFreeEx($pHandle, $__Memory_Deallocations[$i], $__Memory_Sizes[$i], $MEM_DECOMMIT)
Next
_CloseHandle($pThread)
If Not $Handle_Passed Then _CloseHandle($pHandle)
Return $iRet
EndFunc
Func ProcCallbackRegister($sProcess, $sCallingConv, $uFunction, $sRet, $Type1 = 0, $Param1 = 0, _
$Type2 = 0, $Param2 = 0, _
$Type3 = 0, $Param3 = 0, _
$Type4 = 0, $Param4 = 0, _
$Type5 = 0, $Param5 = 0, _
$Type6 = 0, $Param6 = 0, _
$Type7 = 0, $Param7 = 0, _
$Type8 = 0, $Param8 = 0, _
$Type9 = 0, $Param9 = 0, _
$Type10 = 0, $Param10 = 0, _
$Type11 = 0, $Param11 = 0, _
$Type12 = 0, $Param12 = 0, _
$Type13 = 0, $Param13 = 0, _
$Type14 = 0, $Param14 = 0, _
$Type15 = 0, $Param15 = 0, _
$Type16 = 0, $Param16 = 0, _
$Type17 = 0, $Param17 = 0, _
$Type18 = 0, $Param18 = 0, _
$Type19 = 0, $Param19 = 0, _
$Type20 = 0, $Param20 = 0)
If($sCallingConv <> "stdcall") AND($sCallingConv <> "fastcall") Then Return SetError($ERROR_UNKNOWN_CONVENTION)
Local $Handle_Passed = False
If Not IsPtr($sProcess) Then
Local $Pid = ProcessExists($sProcess)
Local $pHandle = OpenProcess($Pid, $PROCESS_ALL_ACCESS)
Else
Local $Pid = True
Local $Handle_Passed = True
Local $pHandle = $sProcess
EndIf
If Not $pHandle Or Not $Pid Then Return SetError($ERROR_GETTING_HANDLE)
Local $nParams =(@NumParams - 4) / 2
If Mod(@NumParams, 2) Then Return SetError($ERROR_ODD_ARGUMENTS)
If $nParams And IsArray($Type1) Then
Local $Params = $Param1
Local $Types = $Type1
Else
Local $Params[1] = [$nParams]
Local $Types[1] = [$nParams]
For $i = 1 To $nParams
Execute("_ArrayAdd($Params,$Param" & $i & ")")
If @error Then Return SetError($ERROR_RETRIEVING_ARGUMENTS)
Execute("_ArrayAdd($Types,$Type" & $i & ")")
If @error Then Return SetError($ERROR_RETRIEVING_ARGUMENTS)
Next
EndIf
Local $Old_Allocations = $__Memory_Deallocations
Global $__Memory_Deallocations[1] = [0]
Local $sCode, $pThread, $iRet, $ThreadID, $pCodePointer, $pParam = 0
Local $Arguments = _CreateArgumentCode($pHandle, $sCallingConv, $Params, $Types)
If @Error Then Return SetError($ERROR_INVALID_TYPE)
$sCode &= "0x" & _
"55" & _
"53" & _
"56" & _
"57" & _
$Arguments & _
"33C0" & _
"BB" & _SwapEndian($uFunction) & _
"FFD3" & _
"5F" & _
"5E" & _
"5B" & _
"5D" & _
_AssembleReturn($sRet) & _
"C3"
$pCodePointer = _Allocate($pHandle, StringLen($sCode) / 2)
_WriteCode($pCodePointer, $pHandle, $sCode)
Local $Ret[3][$__Memory_Deallocations[0]+5]
For $i = 1 To $__Memory_Deallocations[0]
$Ret[1][$i] = $__Memory_Deallocations[$i]
$Ret[2][$i] = $__Memory_Sizes[$i]
Next
$Ret[0][0] = $__Memory_Deallocations[0]
$Ret[0][1] = $pCodePointer
$Ret[0][2] = $pHandle
$Ret[0][3] = $Handle_Passed
$Ret[0][4] = $sRet
$__Memory_Deallocations = $Old_Allocations
Return $Ret
EndFunc
Func ProcCallback(ByRef $ProcSettings)
If NOT IsArray($ProcSettings) Then Return SetError($ERROR_BAD_CALLBACK)
If $_Confirm Then
ConsoleWrite($ProcSettings[0][1] & @CRLF)
ClipPut($ProcSettings[0][1])
If MsgBox(1, "ProcCall", "Confirm execution of code at " & $ProcSettings[0][1] & ".") = 2 Then Return SetError($ERROR_USERHALT)
EndIf
$pThread = _CreateRemoteThread($ProcSettings[0][2], 0, 0, $ProcSettings[0][1], 0, 0, 0)
Switch $ProcSettings[0][4]
Case "void"
_CloseHandle($pThread)
Return 0
Case Else
$iRet = WaitForThreadAndGetReturnCode($pThread)
_CloseHandle($pThread)
EndSwitch
Return $iRet
EndFunc
Func ProcCallbackFree(ByRef $ProcSettings)
If NOT IsArray($ProcSettings) Then Return SetError($ERROR_BAD_CALLBACK)
For $i = 1 To $ProcSettings[0][0]
_VirtualFreeEx($ProcSettings[0][2], $ProcSettings[1][$i], $ProcSettings[2][$i], $MEM_DECOMMIT)
Next
If $ProcSettings[0][3] Then
_CloseHandle($ProcSettings[0][2])
EndIf
$ProcSettings = 0
Return True
EndFunc
Func OpenProcess($Pid, $Rights,$bCleanUp = True)
$Pid = ProcessExists($Pid)
If Not $Pid Then Return SetError($ERROR_INVALID_PROCESS,@ERROR)
Local $process = _WinAPI_OpenProcess($Rights, False, $Pid, True)
If $process Then Return $process
Local $dacl = DllStructCreate("ptr")
Local $secdesc = DllStructCreate("ptr")
Local $dacl_target = DllStructCreate("ptr")
Local $secdesc_target = DllStructCreate("ptr")
If _GetSecurityInfo(_WinAPI_GetCurrentProcess(), $SE_KERNEL_OBJECT, $DACL_SECURITY_INFORMATION, 0, 0, DllStructGetPtr($dacl, 1), 0, DllStructGetPtr($secdesc, 1)) Then Return SetError($ERROR_GETTING_INFO,@ERROR)
$process = _WinAPI_OpenProcess(BitOR($WRITE_DAC, $READ_CONTROL), 0, $Pid)
If Not $process Then Return False
If _GetSecurityInfo($process, $SE_KERNEL_OBJECT, $DACL_SECURITY_INFORMATION, 0, 0, DllStructGetPtr($dacl_target, 1), 0, DllStructGetPtr($secdesc_target, 1)) Then Return SetError($ERROR_GETTING_INFO,@ERROR)
If _SetSecurityInfo($process, $SE_KERNEL_OBJECT, BitOR($DACL_SECURITY_INFORMATION, $UNPROTECTED_DACL_SECURITY_INFORMATION), 0, 0, DllStructGetData($dacl, 1), 0) Then Return SetError($ERROR_SETTING_INFO,@ERROR)
_CloseHandle($process)
$hProc = _WinAPI_OpenProcess($Rights, False, $Pid, True)
If Not $hProc Then Return SetError($ERROR_GETTING_HANDLE,@Error)
If $bCleanUp Then
If _SetSecurityInfo($hProc, $SE_KERNEL_OBJECT, BitOR($DACL_SECURITY_INFORMATION, $UNPROTECTED_DACL_SECURITY_INFORMATION), 0, 0, DllStructGetData($dacl_target, 1), 0) Then Return SetError($ERROR_SETTING_INFO,@ERROR)
EndIf
Return $hProc
EndFunc
Func _SwapEndian($iValue)
Return Hex(Binary($iValue))
EndFunc
Func _AssembleReturn($sReturn)
Switch StringLower($sReturn)
Case "byte"
Return "33DB" & _
"0FB6D8" & _
"33C0" & _
"8BC3"
Case Else
Return ""
EndSwitch
EndFunc
Func _CreateArgumentCode($hProc, $Conv, ByRef $Pams, ByRef $Types)
If Not $Pams[0] Then Return ""
Local $Code
Switch $Conv
Case "stdcall"
For $i = $Pams[0] To 1 Step -1
$Code &= _Assemble($hProc, $Pams[$i], $Types[$i])
Next
Return $Code
Case "fastcall"
Select
Case $Pams[0] = 1
If DllStructGetSize(DllStructCreate($Types[1])) <= 4 Then
Return _Assemble($hProc, $Pams[1], $Types[1], $ECX)
Else
Return _Assemble($hProc, $Pams[1], $Types[1])
EndIf
Case $Pams[0] = 2
Local $Struct, $Count = 0
For $i = 1 To $Pams[0]
$Struct = DllStructCreate($Types[$i])
If @error Then Return SetError($ERROR_INVALID_TYPE)
If DllStructGetSize($Struct) <= 4 Then
Switch $Count
Case 0
$Code &= _Assemble($hProc, $Pams[$i], $Types[$i], $ECX)
_ArrayDelete($Pams, $i)
_ArrayDelete($Types, $i)
$Pams[0] -= 1
$Types[0] -= 1
$Count += 1
$i -= 1
Case 1
$Code &= _Assemble($hProc, $Pams[$i], $Types[$i], $EDX)
_ArrayDelete($Pams, $i)
_ArrayDelete($Types, $i)
$Pams[0] -= 1
$Types[0] -= 1
ExitLoop
EndSwitch
EndIf
Next
Return $Code
Case $Pams[0] > 2
Local $Struct, $Count = 0
For $i = 1 To $Pams[0]
$Struct = DllStructCreate($Types[$i])
If @error Then Return SetError($ERROR_INVALID_TYPE)
If DllStructGetSize($Struct) <= 4 Then
Switch $Count
Case 0
$Code &= _Assemble($hProc, $Pams[$i], $Types[$i], $ECX)
_ArrayDelete($Pams, $i)
_ArrayDelete($Types, $i)
$Pams[0] -= 1
$Types[0] -= 1
$Count += 1
$i -= 1
Case 1
$Code &= _Assemble($hProc, $Pams[$i], $Types[$i], $EDX)
_ArrayDelete($Pams, $i)
_ArrayDelete($Types, $i)
$Pams[0] -= 1
$Types[0] -= 1
ExitLoop
EndSwitch
EndIf
Next
For $i = $Pams[0] To 1 Step -1
$Code &= _Assemble($hProc, $Pams[$i], $Types[$i])
Next
Return $Code
EndSelect
EndSwitch
EndFunc
Func WaitForThreadAndGetReturnCode($thread)
_WinAPI_WaitForSingleObject($thread)
Return _GetExitCodeThread($thread)
EndFunc
Func _Allocate($hProc, $Size = 512)
Local $pPointer = _VirtualAllocEx($hProc, 0, $Size, BitOR($MEM_RESERVE, $MEM_COMMIT), $PAGE_EXECUTE_READWRITE)
_ArrayAdd($__Memory_Deallocations, $pPointer)
$__Memory_Deallocations[0] += 1
_ArrayAdd($__Memory_Sizes, $Size)
Return $pPointer
EndFunc
Func _WriteCode($pPointer, $hProc, $sCode)
$CodeStruct = DllStructCreate("byte[" & StringLen($sCode) & "]")
DllStructSetData($CodeStruct, 1, $sCode)
Local $BytesWritten
_WriteProcessMemory($hProc, $pPointer, DllStructGetPtr($CodeStruct), DllStructGetSize($CodeStruct), $BytesWritten)
Return $BytesWritten == DllStructGetSize($CodeStruct)
EndFunc
Func _Assemble($hProc, $sParameter, $Type, $Register = 0)
Local $sType = _Iif(StringInStr($Type, "static"), StringTrimLeft($Type, 6), $Type)
Select
Case StringInStr($sType, "*")
If _
StringInStr($sType, "wchar") Or _
StringInStr($sType, "char") Or _
StringInStr($sType, "byte") Then
$CodeStruct = DllStructCreate(StringTrimRight($sType, 1) & "[" & StringLen($sParameter) & "]")
DllStructSetData($CodeStruct, 1, $sParameter)
Else
$CodeStruct = DllStructCreate(StringTrimRight($sType, 1))
DllStructSetData($CodeStruct, 1, $sParameter)
EndIf
If @error Then Return SetError($ERROR_INVALID_TYPE)
Local $pPointer = _VirtualAllocEx($hProc, 0, DllStructGetSize($CodeStruct), BitOR($MEM_RESERVE, $MEM_COMMIT), $PAGE_EXECUTE_READWRITE)
If Not StringInStr($Type, "static") Then
_ArrayAdd($__Memory_Deallocations, $pPointer)
$__Memory_Deallocations[0] += 1
_ArrayAdd($__Memory_Sizes, DllStructGetSize($CodeStruct))
EndIf
Local $BytesWritten
_WriteProcessMemory($hProc, $pPointer, DllStructGetPtr($CodeStruct), DllStructGetSize($CodeStruct), $BytesWritten)
Switch $Register
Case 0
Return "68" & _SwapEndian($pPointer)
Case $ECX
Return "B9" & _SwapEndian($pPointer)
Case $EDX
Return "BA" & _SwapEndian($pPointer)
EndSwitch
Case StringInStr($sType, "&")
Switch $Register
Case 0
Return "FF35" & _SwapEndian($sParameter)
Case $ECX
Return "8B0D" & _SwapEndian($sParameter)
Case $EDX
Return "8B15" & _SwapEndian($sParameter)
EndSwitch
Case Else
Switch $Register
Case 0
Return "68" & _SwapEndian($sParameter)
Case $ECX
Return "B9" & _SwapEndian($sParameter)
Case $EDX
Return "BA" & _SwapEndian($sParameter)
EndSwitch
EndSelect
EndFunc
Func __ProcCall_Startup()
If @AutoItX64 Then
Local $Res = MsgBox(52, "ProcCall Warning", "It seems you are trying to run this program in " & _
"64-bit mode. Please note that this is NOT supported and your program " & _
"will most likely crash. Continue?")
If $Res = 7 Then Exit
EndIf
If Not IsDeclared("__ProcCall_Start") Then Global $__ProcCall_Start = 0
If Not $__ProcCall_Start Then
$__ProcCall_Start += 1
If Not IsDeclared("__Dll__HandleIndex") Then Global $__Dll__HandleIndex[1] = [0]
_ArrayAdd($__Dll__HandleIndex, DllOpen("Kernel32.dll"))
_ArrayAdd($__Dll__HandleIndex, DllOpen("Advapi32.dll"))
_ArrayAdd($__Dll__HandleIndex, DllOpen("User32.dll"))
$__Dll__HandleIndex[0] += 3
OnAutoItExitRegister("__ProcCall_ShutDown")
EndIf
EndFunc
Func __ProcCall_ShutDown()
If $__ProcCall_Start Then
$__ProcCall_Start = 0
For $i = 1 To $__Dll__HandleIndex[0]
DllClose($__Dll__HandleIndex[$i])
Next
Global $__Dll__HandleIndex[1] = [0]
EndIf
EndFunc
Func _GetExitCodeThread($thread)
Local $Dummy = DllStructCreate("uint")
Local $Call = DllCall($__Dll__HandleIndex[$DLL_Kernel32], "BOOL", "GetExitCodeThread", "handle", $thread, "ptr", DllStructGetPtr($Dummy))
Return Dec(Hex(DllStructGetData($Dummy, 1)))
EndFunc
Func _GetSecurityInfo($handle, $ObjectType, $SecurityInfo, $ppsidOwner, $ppsidGroup, $ppDacl, $ppSacl, $ppSecurityDescriptor)
Local $Call = DllCall($__Dll__HandleIndex[$DLL_Advapi32], "long", "GetSecurityInfo", _
"ptr", $handle, _
"int", $ObjectType, _
"dword", $SecurityInfo, _
"ptr", $ppsidOwner, _
"ptr", $ppsidGroup, _
"ptr", $ppDacl, _
"ptr", $ppSacl, _
"ptr", $ppSecurityDescriptor)
Return $Call[0]
EndFunc
Func _SetSecurityInfo($handle, $ObjectType, $SecurityInfo, $psidOwner, $psidGroup, $pDacl, $pSacl)
$Call = DllCall($__Dll__HandleIndex[$DLL_Advapi32], "long", "SetSecurityInfo", _
"ptr", $handle, _
"int", $ObjectType, _
"dword", $SecurityInfo, _
"ptr", $psidOwner, _
"ptr", $psidGroup, _
"ptr", $pDacl, _
"ptr", $pSacl)
Return $Call[0]
EndFunc
Func _WriteProcessMemory($hProcess, $pBaseAddress, $pBuffer, $iSize, ByRef $iWritten)
Local $aResult = DllCall($__Dll__HandleIndex[$DLL_Kernel32], "bool", "WriteProcessMemory", "handle", $hProcess, "ptr", $pBaseAddress, "ptr", $pBuffer, "ulong_ptr", $iSize, "ulong_ptr*", $iWritten)
$iWritten = $aResult[5]
Return $aResult[0]
EndFunc
Func _CloseHandle($aHandle)
Local $aResult = DllCall($__Dll__HandleIndex[$DLL_Kernel32], "bool", "CloseHandle", "handle", $aHandle)
Return $aResult[0]
EndFunc
Func _GetProcAddress($hModule, $lpProcName)
Local $Call = DllCall($__Dll__HandleIndex[$DLL_Kernel32], "handle", "GetProcAddress", _
"handle", $hModule, _
"str", $lpProcName)
Return $Call[0]
EndFunc
Func _CreateRemoteThread($hProcess, $lpThreadAttributes, $dwStackSize, $lpStartAddress, $lpParameter, $dwCreationFlags, $lpThreadId)
Local $Call = DllCall($__Dll__HandleIndex[$DLL_Kernel32], "ptr", "CreateRemoteThread", _
"ptr", $hProcess, _
"ptr", $lpThreadAttributes, _
"uint", $dwStackSize, _
"ptr", $lpStartAddress, _
"ptr", $lpParameter, _
"dword", $dwCreationFlags, _
"ptr", $lpThreadId)
Return $Call[0]
EndFunc
Func _VirtualAllocEx($hProcess, $pAddress, $iSize, $iAllocation, $iProtect)
Local $Call = DllCall($__Dll__HandleIndex[$DLL_Kernel32], "ptr", "VirtualAllocEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iAllocation, "dword", $iProtect)
Return $Call[0]
EndFunc
Func _VirtualFreeEx($hProcess, $pAddress, $iSize, $iFreeType)
Local $Call = DllCall($__Dll__HandleIndex[$DLL_Kernel32], "bool", "VirtualFreeEx", "handle", $hProcess, "ptr", $pAddress, "ulong_ptr", $iSize, "dword", $iFreeType)
Return $Call[0]
EndFunc
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_CHECKED = 1
Global Const $GUI_UNCHECKED = 4
Global Const $GUI_WS_EX_PARENTDRAG = 0x00100000
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_GROUP = 0x00020000
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_POPUP = 0x80000000
Global Const $WS_EX_CLIENTEDGE = 0x00000200
Global Const $WS_EX_TOOLWINDOW = 0x00000080
Global Const $WS_EX_TOPMOST = 0x00000008
Global Const $WS_EX_WINDOWEDGE = 0x00000100
Global Const $WS_EX_LAYERED = 0x00080000
Global Const $WM_WINDOWPOSCHANGED = 0x0047
Global Const $WM_MOUSEMOVE = 0x0200
Global Const $WM_LBUTTONDOWN = 0x0201
Global Const $WM_LBUTTONUP = 0x0202
Global Const $WM_RBUTTONDOWN = 0x0204
Global Const $WM_RBUTTONUP = 0x0205
Global Const $GUI_SS_DEFAULT_GUI = BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU)
Global $ghGDIPDll = 0
Global $ghGDIPPen = 0
Global $giGDIPRef = 0
Global $giGDIPToken = 0
Func _GDIPlus_ArrowCapCreate($fHeight, $fWidth, $bFilled = True)
Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateAdjustableArrowCap", "float", $fHeight, "float", $fWidth, "bool", $bFilled, "ptr*", 0)
If @error Then Return SetError(@error, @extended, 0)
Return SetExtended($aResult[0], $aResult[4])
EndFunc
Func _GDIPlus_ArrowCapDispose($hCap)
Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteCustomLineCap", "handle", $hCap)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0] = 0
EndFunc
Func _GDIPlus_BitmapCreateFromFile($sFileName)
Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateBitmapFromFile", "wstr", $sFileName, "ptr*", 0)
If @error Then Return SetError(@error, @extended, 0)
Return SetExtended($aResult[0], $aResult[2])
EndFunc
Func _GDIPlus_BitmapDispose($hBitmap)
Local $aResult = DllCall($ghGDIPDll, "int", "GdipDisposeImage", "handle", $hBitmap)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0] = 0
EndFunc
Func _GDIPlus_GraphicsCreateFromHWND($hWnd)
Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateFromHWND", "hwnd", $hWnd, "ptr*", 0)
If @error Then Return SetError(@error, @extended, 0)
Return SetExtended($aResult[0], $aResult[2])
EndFunc
Func _GDIPlus_GraphicsDispose($hGraphics)
Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteGraphics", "handle", $hGraphics)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0] = 0
EndFunc
Func _GDIPlus_GraphicsDrawImage($hGraphics, $hImage, $iX, $iY)
Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawImageI", "handle", $hGraphics, "handle", $hImage, "int", $iX, "int", $iY)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0] = 0
EndFunc
Func _GDIPlus_GraphicsDrawLine($hGraphics, $iX1, $iY1, $iX2, $iY2, $hPen = 0)
__GDIPlus_PenDefCreate($hPen)
Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawLineI", "handle", $hGraphics, "handle", $hPen, "int", $iX1, "int", $iY1, _
"int", $iX2, "int", $iY2)
Local $tmpError = @error, $tmpExtended = @extended
__GDIPlus_PenDefDispose()
If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
Return $aResult[0] = 0
EndFunc
Func _GDIPlus_PenCreate($iARGB = 0xFF000000, $fWidth = 1, $iUnit = 2)
Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreatePen1", "dword", $iARGB, "float", $fWidth, "int", $iUnit, "ptr*", 0)
If @error Then Return SetError(@error, @extended, 0)
Return SetExtended($aResult[0], $aResult[4])
EndFunc
Func _GDIPlus_PenDispose($hPen)
Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeletePen", "handle", $hPen)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0] = 0
EndFunc
Func _GDIPlus_PenSetCustomEndCap($hPen, $hEndCap)
Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenCustomEndCap", "handle", $hPen, "handle", $hEndCap)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0] = 0
EndFunc
Func _GDIPlus_Shutdown()
If $ghGDIPDll = 0 Then Return SetError(-1, -1, False)
$giGDIPRef -= 1
If $giGDIPRef = 0 Then
DllCall($ghGDIPDll, "none", "GdiplusShutdown", "ptr", $giGDIPToken)
DllClose($ghGDIPDll)
$ghGDIPDll = 0
EndIf
Return True
EndFunc
Func _GDIPlus_Startup()
$giGDIPRef += 1
If $giGDIPRef > 1 Then Return True
$ghGDIPDll = DllOpen("GDIPlus.dll")
If $ghGDIPDll = -1 Then Return SetError(1, 2, False)
Local $tInput = DllStructCreate($tagGDIPSTARTUPINPUT)
Local $pInput = DllStructGetPtr($tInput)
Local $tToken = DllStructCreate("ulong_ptr Data")
Local $pToken = DllStructGetPtr($tToken)
DllStructSetData($tInput, "Version", 1)
Local $aResult = DllCall($ghGDIPDll, "int", "GdiplusStartup", "ptr", $pToken, "ptr", $pInput, "ptr", 0)
If @error Then Return SetError(@error, @extended, False)
$giGDIPToken = DllStructGetData($tToken, "Data")
Return $aResult[0] = 0
EndFunc
Func __GDIPlus_PenDefCreate(ByRef $hPen)
If $hPen = 0 Then
$ghGDIPPen = _GDIPlus_PenCreate()
$hPen = $ghGDIPPen
EndIf
EndFunc
Func __GDIPlus_PenDefDispose()
If $ghGDIPPen <> 0 Then
_GDIPlus_PenDispose($ghGDIPPen)
$ghGDIPPen = 0
EndIf
EndFunc
Global Const $SS_SUNKEN = 0x1000
Global $Pid, $Diablo_hWnd,$__DLL_Kernel32,$Diablo_MemHandle
Global $x_Diff[2], $y_Diff[2]
Global $ITEM_Ilvl, $ITEM_Lock, $ITEM_Mouse_Lock, $Item_Boxes_Hide
Global $xy_base[2] = [408, 286]
Global $x_Final[2], $y_Final[2], $xy_Final[2]
Global $Coords, $coords2
Global Const $NewDiabloTitle = "[CLASS:Diablo II]"
Global Const $D2CLIENT_OFFSET = 0x6FAB0000
Global Const $D2COMMON_OFFSET = 0x6FD50000
Global Const $D2MULTI_OFFSET = 0x6F9D0000
Global Const $D2WIN_OFFSET = 0x6F8E0000
Global Const $PEN_Colours[8] = [0xFFED1C24, 0xFFFFF200, 0xFF22B14C, 0xFF00A2E8, 0xFFA349A4, 0xFFB97A57, 0xFFFFAEC9, 0xFFC8BFE7]
Global $hPen[8]
Global $Warps, $Area_Old,$Area_New, $newcoords[2], $_newcoords[2], $Changed_Area, $oldcoords[2], $Xp_start
Global $LastGameName, $LastGamePass, $Level, $LastChatMsg1
Global $Xp = False
Global $Ingame, $oog = False
Global $Headerpos[2] = [118, 554]
Global $Join = False
Global $Version = "1.5.1"
Global $Mousepos_new, $Mousepos_old
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
Global Const $GetPlayerUnit = 0x613C0
Global Const $GetLayer = 0x30B00
Global Const $GetLevel = 0x6D440
Global Const $AddRoomData = 0x24990
Global Const $InitAutomapLayer_I = 0x733D0
Global Const $RevealAutoMapRoom = 0x73160
Global Const $InitLevel = 0x6DDF0
Global Const $LoadAct = 0x24810
Global Const $LoadAct_1 = 0x737F0
Global Const $LoadAct_2 = 0x2B420
Global Const $RemoveRoomData = 0x24930
Global Const $p_D2CLIENT_Difficulty = 0x11D1D8
Global Const $p_PlayerUnit = 0x11D050
Global Const $p_D2CLIENT_ExpCharFlag = 0x1087B4
Global Const $p_D2CLIENT_AutomapLayer = 0x11CF28
Global Const $p_ExitGame = 0x43870
Global Const $iDataSize = 1024
$skilldatapart1 = "Attack,Kick,Throw,Unsummon,LeftHandThrow,LeftHandSwing,MagicArrow,FireArrow,InnerSight,CriticalStrike,Jab,ColdArrow,MultipleShot,Dodge,PowerStrike,PoisonJavelin,ExplodingArrow,SlowMissiles,Avoid,Impale,LightningBolt,IceArrow,GuidedArrow,Penetrate,ChargedStrike,PlagueJavelin,Strafe,ImmolationArrow,Dopplezon,Evade,Fend,FreezingArrow,Valkyrie,Pierce,LightningStrike,LightningFury,FireBolt,Warmth,ChargedBolt,IceBolt,FrozenArmor,Inferno,StaticField,Telekinesis,FrostNova,IceBlast,Blaze,FireBall,Nova,Lightning,ShiverArmor,FireWall,Enchant,ChainLightning,Teleport,GlacialSpike,Meteor,ThunderStorm,EnergyShield,Blizzard,ChillingArmor,FireMastery,Hydra,LightningMastery,FrozenOrb,ColdMastery,AmplifyDamage,Teeth,BoneArmor,SkeletonMastery,RaiseSkeleton,DimVision,Weaken,PoisonDagger,CorpseExplosion,ClayGolem,IronMaiden,Terror,BoneWall,GolemMastery,RaiseSkeletalMage,Confuse,LifeTap,PoisonExplosion,BoneSpear,Bloodgolem,Attract,Decrepify,BonePrison,SummonResist,IronGolem,LowerResist,PoisonNova,BoneSpirit,Firegolem,Revive,Sacrifice,Smite,Might,Prayer,ResistFire,HolyBolt,HolyFire,Thorns,Defiance,ResistCold,Zeal,Charge,BlessedAim,Cleansing,ResistLightning,Vengeance,BlessedHammer,Concentration,HolyFreeze,Vigor,Conversion,HolyShield,HolyShock,Sanctuary,Meditation,FistOfTheHeavens,Fanaticism,Conviction,Redemption,Salvation,Bash,SwordMastery,AxeMastery,MaceMastery,Howl,FindPotion,Leap,DoubleSwing,PoleArmMastery,ThrowingMastery,SpearMastery,Taunt,Shout,Stun,DoubleThrow,IncreasedStamina,FindItem,LeapAttack,Concentrate,IronSkin,BattleCry,Frenzy,IncreasedSpeed,BattleOrders,GrimWard,Whirlwind,Berserk,NaturalResistance,WarCry,BattleCommand,FireHit,Unholybolt,Skeletonraise,MaggotEgg,ShamanFire,MagottUp,MagottDown,MagottLay,AndrialSpray,Jump,SwarmMove,Nest,QuickStrike,Vampirefireball,Vampirefirewall,Vampiremeteor,GargoyleTrap,SpiderLay,VampireHeal,VampireRaise,SubMerge,FetishAura,FetishInferno,ZakarumHeal,Emerge,Resurrect,Bestow,MissileSkill1,MonsterTeleport,PrimeLightning,PrimeBolt,PrimeBlaze,PrimeFirewall,PrimeSpike,PrimeIceNova,PrimePoisonBall,PrimePoisonNova,DiabloLight,DiabloCold,DiabloFire,FingerMageSpider,"
$killdatapart2 = "DiabloFirestorm,DiabloRun,DiabloPrison,PoisonBallTrap,AndyPoisonBolt,HireableMissile,DesertTurret,ArcaneTower,MonsterBlizzard,Mosquito,Cursedballtrapright,Cursedballtrapleft,MonsterFrozenArmor,MonsterBoneArmor,MonsterBoneSpirit,MonsterCurseCast,HellMeteor,RegurgitatorEat,MonsterFrenzy,QueenDeath,ScrollOfIdentify,BookOfIdentify,ScrollOfTownportal,BookOfTownportal,Raven,PoisonCreeper,Wearwolf,ShapeShifting,Firestorm,OakSage,SummonSpiritWolf,Wearbear,MoltenBoulder,ArcticBlast,CycleOfLife,FeralRage,Maul,Fissure,CycloneArmor,HeartOfWolverine,SummonDireWolf,Rabies,FireClaws,Twister,Vines,Hunger,ShockWave,Volcano,Tornado,SpiritOfBarbs,SummonGrizzly,Fury,Armageddon,Hurricane,FireBlast,ClawMastery,PsychicHammer,TigerStrike,DragonTalon,ShockWeb,BladeSentinel,BurstOfSpeed,FistsOfFire,DragonClaw,ChargedBoltSentry,WakeOfFire,WeaponBlock,CloakOfShadows,CobraStrike,BladeFury,Fade,ShadowWarrior,ClawsOfThunder,DragonTail,LightningSentry,WakeOfInferno,MindBlast,BladesOfIce,DragonFlight,DeathSentry,BladeShield,Venom,ShadowMaster,PhoenixStrike,WakeOfDestructionSentry,ImpInferno,ImpFireball,BaalTaunt,BaalCorpseExplode,BaalMonsterSpawn,CatapultChargedBall,CatapultSpikeBall,SuckBlood,CryHelp,HealingVortex,Teleport2,Selfresurrect,VineAttack,OverseerWhip,BarbsAura,WolverineAura,OakSageAura,ImpFireMissile,Impregnate,SiegeBeastStomp,MinionSpawner,CatapultBlizzard,CatapultPlague,CatapultMeteor,BoltSentry,CorpseCycler,DeathMaul,DefenseCurse,BloodMana,InfernoSentry2,DeathSentry2,SentryLightning,FenrisRage,BaalTentacle,BaalNova,BaalInferno,BaalColdMissiles,MegaDemonInferno,EvilHutSpawner,CountessFirewall,ImpBolt,HorrorArcticBlast,DeathSentryLightning,VineCycler,BearSmite,Resurrect2,BloodLordFrenzy,BaalTeleport,ImpTeleport,BaalCloneTeleport,ZakarumLightning,VampireMissile,MephistoMissile,DoomKnightMissile,RogueMissile,HydraMissile,NecromageMissile,MonsterBow,MonsterFireArrow,MonsterColdArrow,MonsterExplodingArrow,MonsterFreezingArrow,MonsterPowerStrike,SuccubusBolt,MephistoFrostNova,MonsterIceSpear,ShamanIce,DiabloArmageddon,Delirium,NihlathakCorpseExplosion,SerpentCharge,TrapNova,UnHolyBoltEx,ShamanFireEx,ImpFireMissileEx"
$skilldata = $skilldatapart1 & $killdatapart2
$skilldata = StringSplit($skilldata,",")
Global Const $D2Client = 0x6FAB0000
Local $MK_LBUTTON = 0x0001
Local $MK_RBUTTON = 0x0002
Func _MouseClickMinimized($handle, $Button = "left", $X = "", $Y = "", $Clicks = 1)
Local $ButtonDown, $ButtonUp
Local $i = 0
Select
Case $Button = "right"
$Button = $MK_RBUTTON
$ButtonDown = $WM_RBUTTONDOWN
$ButtonUp = $WM_RBUTTONUP
Case $Button = "left"
$Button = $MK_LBUTTON
$ButtonDown = $WM_LBUTTONDOWN
$ButtonUp = $WM_LBUTTONUP
Case Else
Exit
EndSelect
If $X = "" Or $Y = "" Then
Exit
EndIf
For $i = 1 To $Clicks
DllCall("user32.dll", "int", "SendMessage", _
"hwnd", $handle, _
"int", $WM_MOUSEMOVE, _
"int", 0, _
"long", _MakeLong($X, $Y))
DllCall("user32.dll", "int", "SendMessage", _
"hwnd", $handle, _
"int", $ButtonDown, _
"int", $Button, _
"long", _MakeLong($X, $Y))
DllCall("user32.dll", "int", "SendMessage", _
"hwnd", $handle, _
"int", $ButtonUp, _
"int", $Button, _
"long", _MakeLong($X, $Y))
Next
EndFunc
Func _SendMinimized($handle, $keys)
ControlSend($handle, "", "", $keys)
EndFunc
Func _MakeLong($LoWord, $HiWord)
Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))
EndFunc
Global $Level_Pop[100]
$Level_Pop[1] = 0
$Level_Pop[2] = 500
$Level_Pop[3] = 1500
$Level_Pop[4] = 3750
$Level_Pop[5] = 7875
$Level_Pop[6] = 14175
$Level_Pop[7] = 22680
$Level_Pop[8] = 32886
$Level_Pop[9] = 44396
$Level_Pop[10] = 57715
$Level_Pop[11] = 72144
$Level_Pop[12] = 90180
$Level_Pop[13] = 112725
$Level_Pop[14] = 140906
$Level_Pop[15] = 176132
$Level_Pop[16] = 220165
$Level_Pop[17] = 275207
$Level_Pop[18] = 344008
$Level_Pop[19] = 430010
$Level_Pop[20] = 537513
$Level_Pop[21] = 671891
$Level_Pop[22] = 839864
$Level_Pop[23] = 1049830
$Level_Pop[24] = 1312287
$Level_Pop[25] = 1640359
$Level_Pop[26] = 2050449
$Level_Pop[27] = 2563061
$Level_Pop[28] = 3203826
$Level_Pop[29] = 3902260
$Level_Pop[30] = 4663553
$Level_Pop[31] = 5493363
$Level_Pop[32] = 6397855
$Level_Pop[33] = 7383752
$Level_Pop[34] = 8458379
$Level_Pop[35] = 9629723
$Level_Pop[36] = 10906488
$Level_Pop[37] = 12298162
$Level_Pop[38] = 13815086
$Level_Pop[39] = 15468534
$Level_Pop[40] = 17270791
$Level_Pop[41] = 19235252
$Level_Pop[42] = 21376515
$Level_Pop[43] = 23710491
$Level_Pop[44] = 26254525
$Level_Pop[45] = 29027522
$Level_Pop[46] = 32050088
$Level_Pop[47] = 35344686
$Level_Pop[48] = 38935798
$Level_Pop[49] = 42850109
$Level_Pop[50] = 47116709
$Level_Pop[51] = 51767302
$Level_Pop[52] = 56836449
$Level_Pop[53] = 62361819
$Level_Pop[54] = 68384473
$Level_Pop[55] = 74949165
$Level_Pop[56] = 82104680
$Level_Pop[57] = 89904191
$Level_Pop[58] = 98405658
$Level_Pop[59] = 107672256
$Level_Pop[60] = 117772849
$Level_Pop[61] = 128782495
$Level_Pop[62] = 140783010
$Level_Pop[63] = 153863570
$Level_Pop[64] = 168121381
$Level_Pop[65] = 183662396
$Level_Pop[66] = 200602101
$Level_Pop[67] = 219066380
$Level_Pop[68] = 239192444
$Level_Pop[69] = 261129853
$Level_Pop[70] = 285041630
$Level_Pop[71] = 311105466
$Level_Pop[72] = 339515048
$Level_Pop[73] = 370481492
$Level_Pop[74] = 404234916
$Level_Pop[75] = 441026148
$Level_Pop[76] = 481128591
$Level_Pop[77] = 524840254
$Level_Pop[78] = 572485967
$Level_Pop[79] = 624419793
$Level_Pop[80] = 681027665
$Level_Pop[81] = 742730244
$Level_Pop[82] = 809986056
$Level_Pop[83] = 883294891
$Level_Pop[84] = 963201521
$Level_Pop[85] = 1050299747
$Level_Pop[86] = 1145236814
$Level_Pop[87] = 1248718217
$Level_Pop[88] = 1361512946
$Level_Pop[89] = 1484459201
$Level_Pop[90] = 1618470619
$Level_Pop[91] = 1764543065
$Level_Pop[92] = 1923762030
$Level_Pop[93] = 2097310703
$Level_Pop[94] = 2286478756
$Level_Pop[95] = 2492671933
$Level_Pop[96] = 2717422497
$Level_Pop[97] = 2962400612
$Level_Pop[98] = 3229426756
$Level_Pop[99] = 3520485254
Func Conv_CoordToPixel($_Start_Coords,$Coordx, $Coordy,$b = false,$Compas = False,$Cap = True)
$x_Diff[1] = $Coordx - $_Start_Coords[0]
$y_Diff[1] = $Coordy - $_Start_Coords[1]
Return Conv_Calc($x_Diff[1], $y_Diff[1],$b,$Compas,$Cap)
EndFunc
Func Conv_Calc($X, $Y, $minimap = True,$Compas = False,$Cap = True)
Local $x_temp, $y_temp
If $Compas Then
Local $xy_base_c = $xy_base
Else
Local $xy_base_c[2] = [400,300]
EndIf
If $minimap == True Then
$x_temp = $xy_base_c[0] +((16 * $X)/10) +(($Y * - 16)/10)
$y_temp = $xy_base_c[1] -((-8 * $Y)/10) -(($X * - 8)/10)
$x_temp = Round($x_temp,0)
$y_temp = Round($y_temp,0)
Elseif $minimap == False Then
$x_temp = $xy_base[0] +(16 * $X) +($Y * - 16)
$y_temp = $xy_base[1] -(-8 * $Y) -($X * - 8)
Endif
If $Cap Then
If $x_temp > 800 Then
$xy_Final[0] = 798
ElseIf $x_temp < 0 Then
$xy_Final[0] = 2
Else
$xy_Final[0] = $x_temp
EndIf
If $y_temp > 500 Then
$xy_Final[1] = 500
ElseIf $y_temp < 0 Then
$xy_Final[1] = 10
Else
$xy_Final[1] = $y_temp
EndIf
Else
$xy_Final[0] = $x_temp
$xy_Final[1] = $y_temp
EndIf
Return $xy_Final
EndFunc
Func Difference($coord_x_1, $coord_y_1, $coord_x_2, $coord_y_2, $Difference = 2)
If(($Difference < Abs($coord_x_1 - $coord_x_2)) OR($Difference < Abs($coord_y_1 - $coord_y_2))) Then
Return True
Else
Return False
EndIf
EndFunc
If NOT IsDeclared("SE_KERNEL_OBJECT") Then Global Const $SE_KERNEL_OBJECT = 6
If NOT IsDeclared("DACL_SECURITY_INFORMATION") Then Global Const $DACL_SECURITY_INFORMATION = 0x00000004
If NOT IsDeclared("ERROR_SUCCESS") Then Global Const $ERROR_SUCCESS = 0
If NOT IsDeclared("WRITE_DAC") Then Global Const $WRITE_DAC = 0x00040000
If NOT IsDeclared("UNPROTECTED_DACL_SECURITY_INFORMATION") Then Global Const $UNPROTECTED_DACL_SECURITY_INFORMATION = 0x20000000
If NOT IsDeclared("READ_CONTROL") Then Global Const $READ_CONTROL = 0x00020000
Global $nCount = 0
Global $nStartTime = TimerInit()
Func _ReadD2Memory($aHandle, $Address, $format = "dword",$Debugenabled = False,$hDll = "kernel32.dll")
Local $v_Buffer = DllStructCreate($format)
Local $Result = readProcessMemory($aHandle, $Address, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$hDll)
Local $Temp = DllStructGetData($v_Buffer, 1)
If $Debugenabled Then
ConsoleWrite(@CRLF & $Pid & " <--- pID of process." & @CRLF)
ConsoleWrite($aHandle & " <--- Handle to process." & @CRLF)
ConsoleWrite($format & " <--- DllStruct of format." & @CRLF)
ConsoleWrite($Result & " <--- Result of ReadprocessMemory (1 = success, 0 = failure)." & @CRLF)
ConsoleWrite($Temp & " <--- Memory Read." & @CRLF)
EndIf
Return $Temp
EndFunc
Func readProcessMemory($hProcess, $pBaseAddress, $pBuffer, $iSize,$hDll = "kernel32.dll")
Local $aResult = DllCall($__DLL_Kernel32, "bool", "ReadProcessMemory", "handle", $hProcess,"ptr", $pBaseAddress, "ptr", $pBuffer, "ulong_ptr", $iSize, "ulong_ptr*", 0)
Return $aResult[0]
EndFunc
Func closeProcess($aHandle,$hDll = "kernel32.dll")
Local $aResult = DllCall($hDll, "bool", "CloseHandle", "handle", $aHandle)
If @error Then Return SetError(@error, @extended, False)
Return $aResult[0]
EndFunc
Func setPrivilege($Privilege, $Enable)
Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
If @error Then Return SetError(@error, @extended, 0)
_Security__SetPrivilege($hToken, $Privilege, $Enable)
EndFunc
Func openSecureProcess($Pid, $Rights)
If NOT ProcessExists($Pid) Then Return False
$process = _WinAPI_OpenProcess($Rights, False, $Pid, True)
If $process Then
Return $process
EndIf
Local $process
Local $dacl = DllStructCreate("ptr")
Local $secdesc = DllStructCreate("ptr")
Local $dacl_target = DllStructCreate("ptr")
Local $secdesc_target = DllStructCreate("ptr")
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
$process = _WinAPI_OpenProcess(BitOR($WRITE_DAC, $READ_CONTROL), 0, $Pid)
If NOT $process Then
_WinAPI_LocalFree($secdesc)
Return False
EndIf
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
_WinAPI_LocalFree($secdesc)
_WinAPI_CloseHandle($process)
$hProc = _WinAPI_OpenProcess($Rights, False, $Pid, True)
If NOT $hProc Then
Return False
EndIf
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
EndFunc
Func getSecurityInfo($handle, $ObjectType, $SecurityInfo, $ppsidOwner, $ppsidGroup, $ppDacl, $ppSacl, $ppSecurityDescriptor)
Local $Call = DllCall("Advapi32.dll", "long", "GetSecurityInfo", _
"ptr", $handle, _
"int", $ObjectType, _
"dword", $SecurityInfo, _
"ptr", $ppsidOwner, _
"ptr", $ppsidGroup, _
"ptr", $ppDacl, _
"ptr", $ppSacl, _
"ptr", $ppSecurityDescriptor)
Return $Call[0]
EndFunc
Func setSecurityInfo($handle, $ObjectType, $SecurityInfo, $psidOwner, $psidGroup, $pDacl, $pSacl)
$Call = DllCall("Advapi32.dll", "long", "SetSecurityInfo", _
"ptr", $handle, _
"int", $ObjectType, _
"dword", $SecurityInfo, _
"ptr", $psidOwner, _
"ptr", $psidGroup, _
"ptr", $pDacl, _
"ptr", $pSacl)
Return $Call[0]
EndFunc
Func _MemoryReadWideString($iv_Address,$sv_Type = 'wchar[10]')
Return _ReadD2Memory($Diablo_MemHandle,$iv_Address,$sv_Type,False,$__DLL_Kernel32)
EndFunc
Func MAP_GetWarpPoints()
print("Retrieved new warps for area " & MAP_GetLevelName($Area_New) & ".")
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
$Warps[0][$i] = _ReadD2Memory($Diablo_MemHandle, $LevelStruct + 0x1E0 +($i * 4),"dword",False,$__DLL_Kernel32)
Next
For $i = 0 To $Objects - 1 Step 1
$Warps[1][$i] = _ReadD2Memory($Diablo_MemHandle, $LevelStruct + 0x204 +($i * 4),"dword",False,$__DLL_Kernel32)
Next
Return $Warps
EndFunc
Func MAP_GetEntries()
Return _ReadD2Memory($Diablo_MemHandle, MAP_GetLevelStructPtr() + 0x228,"dword",False,$__DLL_Kernel32)
EndFunc
Func MAP_GetActByArea($nArea)
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
Func MAP_GetLevelStructPtr()
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
Endfunc
Func MAP_GetArea()
Return _ReadD2Memory($Diablo_MemHandle, MAP_GetLevelStructPtr() + 0x1D0, "byte",False,$__DLL_Kernel32)
EndFunc
Func MAP_GetQuickArea()
Return _ReadD2Memory($Diablo_MemHandle,$D2CLIENT_OFFSET + $p_LevelId, "byte",False,$__DLL_Kernel32)
EndFunc
Func MAP_GetLevelName($iArea)
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
Func MAP_GetAutomapToggled()
Local $Temp
$Temp = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_AutoMap, "dword",False,$__DLL_Kernel32)
Return $Temp
EndFunc
Func CHAR_GetCoords()
Dim $Temp[2]
Local $Read = 0
Local $v_Buffer = DllStructCreate("dword")
Local $v_Buffer2 = DllStructCreate("short;short;short")
readProcessMemory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_PlayerUnit, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
$ptr1 = DllStructGetData($v_Buffer, 1)
readProcessMemory($Diablo_MemHandle, $ptr1 + 0x2c, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
$ptr2 = DllStructGetData($v_Buffer, 1)
readProcessMemory($Diablo_MemHandle, $ptr2 + 0x2, DllStructGetPtr($v_Buffer2), DllStructGetSize($v_Buffer2),$__DLL_Kernel32)
$Temp[0] = DllStructGetData($v_Buffer2, 1)
$Temp[1] = DllStructGetData($v_Buffer2, 3)
Return $Temp
EndFunc
Func CHAR_GetPathedCoords()
Return CHAR_GetCoords()
EndFunc
Func CHAR_GetCurrentHp()
Local $Temp
$Temp = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_CurrentHp, "ushort",False,$__DLL_Kernel32)
Return $Temp
EndFunc
Func CHAR_GetRealm()
Local $Temp, $ptr
$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_GameInfo,"dword",False,$__DLL_Kernel32)
$Temp = _ReadD2Memory($Diablo_MemHandle, $ptr + 0xD1, "char[18]",False,$__DLL_Kernel32)
Return $Temp
EndFunc
Func CHAR_GetAccount()
Local $Temp, $ptr
$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_GameInfo,"dword",False,$__DLL_Kernel32)
$Temp = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x89, "char[18]",False,$__DLL_Kernel32)
Return $Temp
EndFunc
Func CHAR_GetName()
Local $Temp, $ptr
$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_GameInfo,"dword",False,$__DLL_Kernel32)
$Temp = _ReadD2Memory($Diablo_MemHandle, $ptr + 0xB9, "char[30]",False,$__DLL_Kernel32)
Return $Temp
EndFunc
Global $pRef_Stat = 7
Global $nStatic = False
Func _DiaAPI_GetStatValue($iStat,$iVector = 0,$iStatlist = 0,$ptr = -1)
Local $Ret, $statcount, $ptr_stats, $statindex, $Startcount = 0
If $ptr = -1 Then
$ptr = _ReadD2Memory($Diablo_MemHandle, 0x5c + _
_ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_PlayerUnit,"dword",False,$__DLL_Kernel32),"dword",False,$__DLL_Kernel32)
EndIf
For $i = 1 to $iStatlist
$ptr = _ReadD2Memory($Diablo_MemHandle,$ptr + 0x3c,"dword",False,$__DLL_Kernel32)
Next
Switch $iVector
Case 0
$ptr_stats = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x24,"dword",False,$__DLL_Kernel32)
$statcount = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x28,"word",False,$__DLL_Kernel32)
Case 1
$ptr_stats = _ReadD2Memory($Diablo_MemHandle,$ptr + 0x48,"dword",False,$__DLL_Kernel32)
$statcount = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x4c,"word",False,$__DLL_Kernel32)
Case 2
$ptr_stats = _ReadD2Memory($Diablo_MemHandle,$ptr + 0x50,"dword",False,$__DLL_Kernel32)
EndSwitch
If $iStat == $pRef_Stat Then
ElseIf $iStat > 3 Then
$Startcount = 5
Else
$Startcount = 0
EndIf
Local $szStruct = "word wSubIndex;word wStatIndex;dword dwStatValue;", $FinalStruct
For $i = 0 to $iStat
$FinalStruct &= $szStruct
Next
Local $Statstruct = DllStructCreate($FinalStruct)
Local $iSize = DllStructGetSize($Statstruct)
Local $iPtr = DllStructGetPtr($Statstruct)
readProcessMemory($Diablo_MemHandle,$ptr_stats, $iPtr,$iSize,$__DLL_Kernel32)
For $i = $Startcount to $statcount
$statindex = DllStructGetData($Statstruct,2 +(3 * $i))
If $statindex == $iStat Then
If $iStat == $pRef_Stat Then
$nStatic = $i
EndIf
$Ret = DllStructGetData($Statstruct,3 +(3 * $i))
Switch $iStat
Case 6 to 11
return $Ret/256
Case Else
return $Ret
EndSwitch
EndIf
Next
Return -1
EndFunc
Func GAME_GetLastChatMsg()
Return ""
$Temp = GAME_GetLastMsg()
$Result = StringInStr($Temp, "ÿc")
Select
Case $Result = 0
$LastMsg = $Temp
Case $Result > 0
$msgarray = StringSplit($Temp, "ÿc", 1)
$Msgarray1 = StringTrimLeft($msgarray[2], 1)
$Msgarray2 = StringTrimLeft($msgarray[3], 1)
$LastMsg = $Msgarray1 & $Msgarray2
EndSelect
Return $LastMsg
EndFunc
Func GAME_GetLastMsg()
Local $ptr
Local $ptr2
$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + 0x113AB0, "dword",False,$__DLL_Kernel32)
$ptr2 = _ReadD2Memory($Diablo_MemHandle, $ptr, "dword",False,$__DLL_Kernel32)
$Temp = _MemoryReadWideString($ptr2,'wchar[396]')
Return $Temp
EndFunc
Func GAME_GetGameName()
Local $Temp
Local $ptr
$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_GameInfo, "dword",False,$__DLL_Kernel32)
$Temp = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x1B, "char[15]",False,$__DLL_Kernel32)
Return $Temp
EndFunc
Func GAME_DetectIngame()
If _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_PlayerUnit, "dword",False,$__DLL_Kernel32) > 0 Then
Return True
Else
Return False
EndIf
EndFunc
Func GAME_GetGamePass()
Local $Temp, $ptr
$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_GameInfo,"dword",False,$__DLL_Kernel32)
$Temp = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x241, "char[18]",False,$__DLL_Kernel32)
Return $Temp
EndFunc
Func GAME_GetServerIp()
Local $Temp
Local $ptr
$ptr = _ReadD2Memory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_GameInfo, "dword",False,$__DLL_Kernel32)
$Temp = _ReadD2Memory($Diablo_MemHandle, $ptr + 0x33, "char[18]",False,$__DLL_Kernel32)
Return $Temp
EndFunc
Func ITEM_GetIlvl()
Local $v_Buffer = DllStructCreate("dword")
readProcessMemory($Diablo_MemHandle, $D2CLIENT_OFFSET + $p_SelItem, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
$ptr1 = DllStructGetData($v_Buffer, 1)
readProcessMemory($Diablo_MemHandle, $ptr1 + 0x14, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
$ptr2 = DllStructGetData($v_Buffer,1)
readProcessMemory($Diablo_MemHandle, $ptr2 + 0x2C, DllStructGetPtr($v_Buffer), DllStructGetSize($v_Buffer),$__DLL_Kernel32)
Return DllStructGetData($v_Buffer,1)
Endfunc
Func DelCCode(Const ByRef $szString)
If StringInStr($szString,"ÿc") > 0 Then
local $sz_Split
$sz_Split = StringSplit($szString,"ÿc",1)
Local $nMsg
For $i = 1 to $sz_Split[0]
$nMsg &= StringTrimLeft($sz_Split[$i],1)
Next
Return $nMsg
Else
Return $szString
EndIf
EndFUnc
Func getText($bItems = False)
If $bItems Then
If ITEM_GetIlvl() = 0 Then Return -1
Local $szMsg,$aMsg,$rMsg
$szMsg = _MemoryReadWideString($D2WIN_OFFSET + $p_ItemText,"wchar[700]")
While StringLen($szMsg) < 5
$szMsg = _MemoryReadWideString($D2WIN_OFFSET + $p_ItemText,"wchar[700]")
Sleep(10)
WEnd
Else
Local $szMsg,$aMsg,$rMsg
$szMsg = _MemoryReadWideString($D2WIN_OFFSET + $p_ItemText,"wchar[700]")
For $i = 0 to 5
$szMsg = _MemoryReadWideString($D2WIN_OFFSET + $p_ItemText,"wchar[700]")
Sleep(10)
If StringLen($szMsg) < 4 Then ExitLoop
Next
EndIf
$aMsg = StringSplit($szMsg,@CRLF,2)
If NOT IsArray($aMsg) Then Return $szMsg
_ArrayReverse($aMsg)
For $i = 0 To UBound($aMsg)-1
$rMsg &= $aMsg[$i] & @CR
Next
Return $rMsg
EndFunc
Func _DiaAPI_CreateDia($sPath, $sTitle = "Diablo II", $Params = "",$WorkingDir = @ScriptDir,$iLeft = "", $iTop = "", $iWidth = "", $iHeight = "")
For $i = 1 To $DiabloList[0]
If IsHwnd($DiabloList[$i]) Then
If NOT _ChangeParent($DiabloList[$i], $hDias) Then MsgBox(16,"Autumn " & $Version & " :: D2Extra","Error code while changing parent: " & _WinAPI_GetLastError() & @CRLF & _WinAPI_GetLastErrorMessage())
EndIf
Next
If $sPath <> "" Then
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
EndFunc
Func _ChangeParent($hWndChild, $hWndParentNew)
$Call = DllCall('user32.dll', 'hWnd', 'SetParent', 'hWnd', $hWndChild, 'hWnd', $hWndParentNew)
Return $Call[0]
EndFunc
Func RevealAct()
BlockInput(1)
Local $iReturn = _RevealAct()
For $i = 0 to 3
BlockInput(0)
Next
Return $iReturn
EndFunc
Func _RevealAct()
$isRevealing = True
SetLastError(0)
Local $BytesWritten
If NOT GAME_DetectIngame() Then
print("Only reveal when you're ingame...")
Return False
EndIf
Local $Injected_Thread_Address = _MemVirtualAllocEx($Diablo_MemHandle,0, $iDataSize, BitOR($MEM_RESERVE, $MEM_COMMIT), $PAGE_EXECUTE_READWRITE)
If NOT $Injected_Thread_Address Then Return False
print("VirtualAllocEx():  " & _WinAPI_GetLastError() & @CRLF & @TAB & _WinAPI_GetLastErrorMessage())
Local $Injected_Thread_Address_ = Ptr(Number($Injected_Thread_Address))
Local $szMaphack = "0x" & _
"55" & _
"8BEC" & _
"83EC2C" & _
"53" & _
"56" & _
"57" & _
"90" & _
"90" & _
"E8" & addressOf($D2CLIENT_OFFSET+$GetPlayerUnit,$Injected_Thread_Address_ + 0xB) & _
"68" & SwapEndian($D2CLIENT_OFFSET+$LoadAct_2) & _
"90" & _
"8B15" & SwapEndian($D2CLIENT_OFFSET+$p_D2CLIENT_Difficulty) & _
"68" & SwapEndian($D2CLIENT_OFFSET + $LoadAct_1) & _
"90" & _
"909090" & _
"8BC8" & _
"8B4118" & _
"8D7485D8" & _
"C745D401000000" & _
"C745D828000000" & _
"C745DC4B000000" & _
"C745E067000000" & _
"C745E46D000000" & _
"C745E889000000" & _
"8B7EFC" & _
"57" & _
"33DB" & _
"53" & _
"52" & _
"8B15" & SwapEndian($D2CLIENT_OFFSET+$p_D2CLIENT_ExpCharFlag) & _
"53" & _
"5290" & _
"894DEC" & _
"8B491C" & _
"FF710C" & _
"50" & _
"E8" & addressOf($D2COMMON_OFFSET + $LoadAct,$Injected_Thread_Address_, 0x73) & _
"8945F4" & _
"3BC3" & _
"0F8412010000" & _
"8B36" & _
"8975F0" & _
"3BFE" & _
"E9D7000000" & _
"8B45F4" & _
"8B4848" & _
"8BB17C040000" & _
"3BF3" & _
"741B" & _
"39BED0010000" & _
"7505" & _
"395E1C" & _
"770A" & _
"8BB6AC010000" & _
"3BF3" & _
"75E9" & _
"3BF3" & _
"7511" & _
"8BD7" & _
"E8" & addressOf($D2COMMON_OFFSET+$GetLevel,$Injected_Thread_Address_,0xBC) & _
"8BF0" & _
"3BF3" & _
"0F8494000000" & _
"395E10" & _
"7506" & _
"56" & _
"E8" & addressOf($D2COMMON_OFFSET+$InitLevel,$Injected_Thread_Address_,0xD1) & _
"8BCF" & _
"E8" & addressOf($D2COMMON_OFFSET+$GetLayer,$Injected_Thread_Address_,0xD8) & _
"3BC3" & _
"0F84B0000000" & _
"8B4808" & _
"E8" & addressOf($Injected_Thread_Address_ + 0x19E,$Injected_Thread_Address_, 0xE8) & _
"8B7E10" & _
"EB69" & _
"885DFF" & _
"395F30" & _
"7522" & _
"8B86B4010000" & _
"53" & _
"FF7738" & _
"FF7734" & _
"FFB6D0010000" & _
"FFB06C040000" & _
"E8" & addressOf($D2COMMON_OFFSET+$AddRoomData,$Injected_Thread_Address_,0x113) & _
"C645FF01" & _
"8B4730" & _
"3BC3" & _
"7435" & _
"8B0D" & SwapEndian($D2CLIENT_OFFSET + $p_D2CLIENT_AutomapLayer) & _
"5190" & _
"6A01" & _
"50" & _
"E8" & addressOf($D2CLIENT_OFFSET+$RevealAutoMapRoom,$Injected_Thread_Address_,0x12E) & _
"385DFF" & _
"7420" & _
"FF7730" & _
"8B86B4010000" & _
"FF7738" & _
"FF7734" & _
"FFB6D0010000" & _
"FFB06C040000" & _
"E8" & addressOf($D2COMMON_OFFSET+$RemoveRoomData,$Injected_Thread_Address_,0x153) & _
"8B7F24" & _
"3BFB" & _
"7593" & _
"8B7DF8" & _
"47" & _
"3B7DF0" & _
"897DF8" & _
"0F8220FFFFFF" & _
"8B45EC" & _
"8B402C" & _
"8B401C" & _
"8B4010" & _
"8B4058" & _
"8B88D0010000" & _
"E8" & addressOf($D2COMMON_OFFSET+$GetLayer,$Injected_Thread_Address_,0x184) & _
"3BC3" & _
"7408" & _
"8B4808" & _
"E8" & addressOf($Injected_Thread_Address_ + 0x19E,$Injected_Thread_Address_, 0x190) & _
"5F" & _
"5E" & _
"33C0" & _
"5B" & _
"C9" & _
"C20400" & _
"50" & _
"8BC1" & _
"E8"& addressOf($D2CLIENT_OFFSET + $InitAutomapLayer_I,$Injected_Thread_Address_,0x1A1) & _
"58" & _
"C3"
$BytesWritten = 0
Local $DataArray = DllStructCreate("byte[" & BinaryLen($szMaphack) & "]")
DllStructSetData($DataArray,1,$szMaphack)
_WinAPI_WriteProcessMemory($Diablo_MemHandle,$Injected_Thread_Address,DllStructGetPtr($DataArray),DllStructGetSize($DataArray),$BytesWritten)
print("WriteProcessMemory(): " & _WinAPI_GetLastError() & @CRLF & @TAB & _WinAPI_GetLastErrorMessage())
print("Address of injected thread: " & $Injected_Thread_Address)
If $BytesWritten Then
Local $thread = CreateRemoteThread($Diablo_MemHandle,0,0,$Injected_Thread_Address,0,0,0)
print("CreateRemoteThread(): " & _WinAPI_GetLastError() & @CRLF & @TAB & _WinAPI_GetLastErrorMessage())
If $thread Then
_WinAPI_WaitForSingleObject($thread,0xFFFFFFFF)
Local $DllStruct = DllStructCreate("dword")
DllCall($__DLL_Kernel32,"BOOL","GetExitCodeThread","handle",$thread,"ptr",DllStructGetPtr($DllStruct))
print("Thread successfully injected: " & DllStructGetData($DllStruct,1) & " (0x" & Hex(DllStructGetData($DllStruct,1)) & ")" & @CRLF & @CRLF)
_WinAPI_CloseHandle($thread)
_MemVirtualFreeEx($Diablo_MemHandle,$Injected_Thread_Address,DllStructGetSize($DataArray),$MEM_DECOMMIT)
print("VirtualFreeEx():  " & _WinAPI_GetLastError() & @CRLF & @TAB & _WinAPI_GetLastErrorMessage())
Return True
Else
_MemVirtualFreeEx($Diablo_MemHandle,$Injected_Thread_Address,DllStructGetSize($DataArray),$MEM_DECOMMIT)
print("VirtualFreeEx():  " & _WinAPI_GetLastError() & @CRLF & @TAB & _WinAPI_GetLastErrorMessage())
EndIf
EndIf
Return False
EndFunc
Func SwapEndian($iValue)
Return Hex(Binary($iValue))
EndFunc
Func CreateRemoteThread($hProcess, $lpThreadAttributes, $dwStackSize, $lpStartAddress, $lpParameter, $dwCreationFlags, $lpThreadId)
Local $Call = DllCall($__DLL_Kernel32, "ptr", "CreateRemoteThread", _
"ptr", $hProcess, _
"ptr", $lpThreadAttributes, _
"uint", $dwStackSize, _
"ptr", $lpStartAddress, _
"ptr", $lpParameter, _
"dword", $dwCreationFlags, _
"ptr", $lpThreadId)
Return $Call[0]
EndFunc
Func addressOf($AbsAddress, $Instruction, $offset = 0)
Return SwapEndian((Number($AbsAddress)-(Number($Instruction)+Number($offset)))-Number($CALL_INSTRUCTION_SIZE))
EndFunc
Global Const $pRoom1 = 0x1C
Global Const $pRoom2First = 0x10
Global Const $pLevel = 0x58
Global Const $pPath = 0x2C
Global Const $pRRoom1 = 0x30
Global Const $pRoom2 = 0x10
Global Const $pUnitFirst = 0x74
Global Const $pRoom2Next = 0x24
Global Const $PlayerUnit = $D2CLIENT_OFFSET + $p_PlayerUnit
Global $_D2net, $std_packet, $stdpacket, $stdpacket_dummy, $stdpacket_size_pointer
Func LoadTPSystem()
$_D2net = ProcCall($Diablo_MemHandle,"stdcall",_GetProcAddress(_WinAPI_GetModuleHandle("Kernel32.dll"),"GetModuleHandleA"),"handle","char*","D2Net.dll")
$std_packet = $_D2net + $f_SendPacket
$stdpacket_size_pointer = _VirtualAllocEx($Diablo_MemHandle, 0, 4, BitOR($MEM_RESERVE, $MEM_COMMIT), $PAGE_EXECUTE_READWRITE)
$stdpacket_dummy = "0x0000000000000000000000000000000000000000000000000000000000000"
$stdpacket = ProcCallbackRegister($Diablo_MemHandle,"stdcall",$std_packet,"int","&int",$stdpacket_size_pointer,"int",1,"byte*",$stdpacket_dummy)
EndFunc
Func TpToTown()
IF NOT IsTown($Area_New) And GAME_DetectIngame() Then
$Time = TimerInit()
SendPacket("0x3Cdc000000FFFFFFFF",9)
$Pos = CHAR_GetCoords()
SendPacket("0x0C" & SwapShort($Pos[0]) & SwapShort($Pos[1]),5)
Do
$Portal = FindUnit(2, 59)
Until $Portal Or TimerDiff($Time) > 3000
If $Portal Then SendPacket("0x13" & _SwapEndian(2) & _SwapEndian(pRead($Portal + 0x0c)),9)
EndIf
EndFunc
Func SendPacket($aPacket,$Size)
$Buf = DllStructCreate("byte[" & $Size & "]")
DllStructSetData($Buf,1, $aPacket)
dWrite($stdpacket_size_pointer,$Size)
Local $BytesWritten
_WinAPI_WriteProcessMemory($Diablo_MemHandle,$stdpacket[1][1],DllStructGetPtr($Buf),DllStructGetSize($Buf),$BytesWritten)
ProcCallback($stdpacket)
EndFunc
Func SwapShort($Short)
Return StringTrimRight(_SwapEndian($Short), 4)
EndFunc
Func pRead($A)
$r = DllCall($__DLL_Kernel32, "bool", "ReadProcessMemory", "handle", $Diablo_MemHandle, "ptr", $A, "int*", 0, "int", 4, "int*", 0)
Return $r[3]
EndFunc
Func dWrite($A,$c)
$r = DllCall($__DLL_Kernel32,"bool","WriteProcessMemory","handle",$Diablo_MemHandle,"ptr",$A,"int*",$c,"int",4,"int*",0)
return $r[0]
EndFunc
Func FindUnit($unittype = -1, $textfileno = -1)
Local $ptRoomOther = pRead($pRoom2First + pRead($pLevel + pRead($pRoom2 + pRead($pRoom1 + pRead($pPath + pRead($PlayerUnit))))))
Local $Unit = 0
while $ptRoomOther
$Unit = pRead($pUnitFirst + pRead($pRRoom1 + $ptRoomOther))
while $Unit
If $unittype <> -1 Then
If pRead($Unit) = $unittype then
If $textfileno <> -1 Then
If pRead($Unit + 0x04) = $textfileno Then return $Unit
Else
Return $Unit
EndIf
EndIf
EndIf
$Unit = pRead($Unit + 0xE8)
wend
$ptRoomOther = pRead($pRoom2Next + $ptRoomOther)
WEnd
return 0
EndFunc
Main()
Func Main()
If @OSVERSION = "WIN_XP" Then
$Answer = MsgBox(36, "AU.Map Warning", "It seems you're runnig Au.Map under Windows Xp. Please note that Au.Map will probably be buggy. Do you want to continue?")
If $Answer = 7 Then
Exit
Else
$Xp = True
Endif
Endif
ReadSettings()
Local $_CMDLINE = $CMDLINE
If $_CMDLINE[0] Then
$_D2Extra = _ArraySearch($_CMDLINE, "-D2Extra") <> -1
$Title = "Diablo II"
$Params = ""
$Path = ""
$FullPath = ""
$BreakValue = 0
For $i = 0 to $_CMDLINE[0]
If FileExists(StringTrimLeft($_CMDLINE[$i],1)) OR FileExists($_CMDLINE[$i]) Then
$Path = StringTrimLeft($_CMDLINE[$i],1)
For $z = $i +1 to $_CMDLINE[0]
If $i <= $BreakValue Then ExitLoop
if $_CMDLINE[$z] == "-title" Then
$Title = $_CMDLINE[$z+1]
_ArrayDelete($_CMDLINE,$z)
_ArrayDelete($_CMDLINE,$z)
$_CMDLINE[0] = $_CMDLINE[0] -2
$z -= 2
$BreakValue = $_CMDLINE[0] -2
EndIf
Next
For $z = $i +1 to $_CMDLINE[0]
$Params &= $_CMDLINE[$z] & " "
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
$Path__ &= $Splitted_string[$i] & "\"
Next
$olol = StringInStr($FullPath,".exe")
If $olol Then $Parameters = StringTrimLeft($FullPath,$olol + StringLen(".exe"))
If $_D2Extra Then
Global $list, $DiabloList
Global $hDias = GUICreate("Diablo II secret area")
$list = Winlist($NewDiabloTitle)
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
$tStruct = _DiaAPI_CreateDia($Path__ & "Game.exe",$Title,$Parameters,StringTrimRight($Path__,1))
If IsDllStruct($tStruct) Then
_WinAPI_CloseHandle(DllStructGetData($tStruct,"hThread"))
GUIDelete($hDias)
Local $_hWnd = $DiabloList[$DiabloList[0]]
$__DLL_Kernel32 = DllOpen("Kernel32.dll")
Autumn(DllStructGetData($tStruct,"ProcessID"),DllStructGetData($tStruct,"hProcess"),$_hWnd)
EndIf
Else
$tStruct = CreateProcess($Path__ & "Game.exe",$Parameters,StringTrimRight($Path__,1))
If IsDllStruct($tStruct) Then
_WinAPI_CloseHandle(DllStructGetData($tStruct,"hThread"))
$__DLL_Kernel32 = DllOpen("Kernel32.dll")
Autumn(DllStructGetData($tStruct,"ProcessID"),DllStructGetData($tStruct,"hProcess"),WinGetHandle($NewDiabloTitle))
EndIf
EndIf
EndIf
End()
Else
$_hGui_main = GuiCreate("Autumn " & $Version,300,220)
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
Case $_hGui_main
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
$hWnd = HWND(StringStripWs($_[2],8))
WinActivate($hWnd)
WinActivate($_hGui_main)
EndIf
Case $Button1
If NOT GuiCtrlRead($List_DiabloWindows) Then ContinueLoop
$_ = StringSplit(GuiCtrlRead($List_DiabloWindows),"HWND",1)
$hWnd = HWND(StringStripWs($_[2],8))
$Diablo_hWnd = $hWnd
$Pid = WinGetProcess($hWnd)
If $Pid == -1 Then ContinueLoop
$__DLL_Kernel32 = DllOpen("Kernel32.dll")
Switch $Pid
Case DllStructGetData($tStruct,"ProcessID")
$Diablo_MemHandle = DllStructGetData($tStruct,"hProcess")
Case Else
setPrivilege("SeDebugPrivilige",True)
$Diablo_MemHandle = openSecureProcess($Pid,BitOR(0x0020,0x0010,0x0008,0x0002,0x0200,0x0400,$WRITE_DAC, $READ_CONTROL))
EndSwitch
$Settings_Preferred_Path = GuiCtrlRead($Input1)
GuiDelete($_hGui_main)
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
$Path__ &= $Splitted_string[$i] & "\"
Next
$olol = StringInStr(GuiCtrlRead($Input1),".exe")
If $olol Then $Parameters = StringTrimLeft(GuiCtrlRead($Input1),$olol + StringLen(".exe"))
If NOT $Path__ OR NOT FileExists($Path__ & "\Game.exe") then
MsgBox(16,"Autumn " & $Version,"Please type in an existing path.")
EndIf
$tStruct = CreateProcess($Path__ & "Game.exe",$Parameters,StringTrimRight($Path__,1))
If IsDllStruct($tStruct) Then _WinAPI_CloseHandle(DllStructGetData($tStruct,"hThread"))
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
$Path__ &= $Splitted_string[$i] & "\"
Next
$olol = StringInStr(GuiCtrlRead($Input1),".exe")
If $olol Then $Parameters = StringTrimLeft(GuiCtrlRead($Input1),$olol + StringLen(".exe"))
$Title = "Diablo II"
$Path__ &= "Game.exe"
If NOT $Path__ OR NOT FileExists($Path__) Then
MsgBox(16,"Autumn " & $Version & " :: D2Extra","Please type in an existing path" & @CRLF & " -> " & $Path__)
EndIf
Global $list, $DiabloList
Global $hDias = GUICreate("Diablo II secret area")
$list = Winlist($NewDiabloTitle)
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
WinActivate($_hGui_main)
Case $Button4
About()
Case $Button5
_UpdateList()
EndSwitch
WEnd
AdlibUnregister("_UpdateList")
EndIf
If($Pid AND $Diablo_MemHandle) AND $Diablo_hWnd THen Autumn($Pid,$Diablo_MemHandle,$Diablo_hWnd)
EndFunc
Func Autumn($ProcessID,$ProcessHandle,$ProcessWindow)
$Diablo_MemHandle = $ProcessHandle
$Diablp_hWnd = $ProcessWindow
WinActivate($Diablo_hWnd)
$Pos = WinGetPos($Diablo_hWnd)
If @error Then
MsgBox(16, "AU.Map ERROR", "No Diablo II window found.")
Exit
EndIf
Opt("WinWaitDelay", 5)
Opt("TrayMenuMode",1)
Opt("TrayOnEventMode",1)
$ITEM_Ilvl = TrayCreateItem("Enable Item lvl viewer")
TrayCreateItem("")
$ITEM_Lock = TrayCreateItem("Lock Labelboxes")
If $ChildWindows_IgnoreInput Then TrayItemSetState($ITEM_Lock,65)
TrayCreateItem("")
$Item_Boxes_Hide = TrayCreateItem("Hide Labelboxes")
TrayCreateItem("")
$ITEM_Mouse_Lock = TrayCreateItem("Lock Mouse")
TrayCreateItem("")
$ITEM_About = TrayCreateItem("About",-1,-1,0)
TrayCreateItem("")
$ITEM_Exit = TrayCreateItem("Exit")
TrayItemSetOnEvent($ITEM_Exit, "End" )
TrayItemSetOnEvent($ITEM_About, "About")
TrayItemSetOnEvent($ITEM_Ilvl, "Ilvl_Viewer" )
TrayItemSetOnEvent($ITEM_Lock,"LockChilds")
TrayItemSetOnEvent($ITEM_Mouse_Lock,"Lock_Mouse")
TrayItemSetOnEvent($Item_Boxes_Hide,"Hide_Windows")
TraySetState()
TraySetToolTip("Autumn " & $Version & " for Diablo II")
If Not IsDeclared("WM_DWMCOMPOSITIONCHANGED") Then Global Const $WM_DWMCOMPOSITIONCHANGED = 0x031E
If $Xp Then
$_hGui_main = GUICreate("Au.Map", $Pos[2] - 10, $Pos[3] - 54, $Pos[0], $Pos[1], -1, BitOR($WS_EX_TOPMOST, $WS_EX_LAYERED))
Else
$_hGui_main = GUICreate("Au.Map", $Pos[2] - 10, $Pos[3] - 54, $Pos[0] + 2, $Pos[1] + 24, -1, BitOR($WS_EX_TOPMOST, $WS_EX_LAYERED))
Endif
GUISetBkColor(0xABCDEF)
_WinAPI_SetLayeredWindowAttributes($_hGui_main, 0xABCDEF, $Settings_LineTrans)
_WinAPI_SetWindowLong($_hGui_main, -20, BitOR(_WinAPI_GetWindowLong($_hGui_main, -20), 0x00000020))
GUISetStyle($WS_POPUP, -1, $_hGui_main)
GUIRegisterMsg($WM_WINDOWPOSCHANGED,"ChildSizing")
_GDIPlus_Startup()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($_hGui_main)
$hEndCap = _GDIPlus_ArrowCapCreate(3, 6)
For $i = 0 To 7
$hPen[$i] = _GDIPlus_PenCreate($PEN_Colours[$i], 1)
_GDIPlus_PenSetCustomEndCap($hPen[$i], $hEndCap)
Next
OnAutoItExitRegister("Terminate")
Opt("GuiOnEventMode",1)
GUISetOnEvent($GUI_EVENT_CLOSE,"End",$_hGui_main)
$_Box_Autumn = CreateLabelBox("Autumn",95, 20,$Pos[0]+400-(95/2), $Pos[1]+24,0xFFFFFFF,0x00000,200,"",False,"AvQest",5,-3)
GUICtrlSetFont($_Box_Autumn[1], 16, 1200, "", "AvQest")
If @error Then GUICtrlSetFont($_Box_Autumn[1], 16, 1200, "", "Arial")
GUICtrlSetColor($_Box_Autumn[1], 0x948064)
GUISetState(@SW_SHOW, $_Box_Autumn[0])
$_Box_GamePass = CreateLabelBox("",339,30,-32000,-32000,0xFFFFFFF,0x00000,200,"",False,"AvQest",5,7)
GUICtrlSetFont($_Box_GamePass[1], 12, 600, "", "AvQest")
If @error Then GUICtrlSetFont($_Box_GamePass[1], 12, 800, "", "Arial")
GuiSetState(@SW_Show,$_Box_GamePass[0])
GUICtrlSetColor($_Box_GamePass[1], 0x948064)
$_Box_IP = CreateLabelBox("",130, 20, $Pos[0]+$_hGui_ChildWindows[1][1],$Pos[0]+$_hGui_ChildWindows[1][2],0x948064,0x00000,150,"",NOT $ChildWindows_IgnoreInput)
$_hGui_ChildWindows[1][0] = $_Box_IP[0]
$_hGui_ChildWindows[1][3] = $_Box_IP[2]
GUICtrlSetColor($_Box_IP[1], 0x948064)
$_Box_Time = CreateLabelBox("",85, 17, $Pos[0]+$_hGui_ChildWindows[1][1],$Pos[0]+$_hGui_ChildWindows[1][2],0x948064,0x00000,150,"",NOT $ChildWindows_IgnoreInput,"AvQest",2,2)
$_hGui_ChildWindows[2][0] = $_Box_Time[0]
$_hGui_ChildWindows[2][3] = $_Box_Time[2]
If $Settings_XpCounter Then
$_Box_Experience = CreateLabelBox("",115, 70, $Pos[0]+$_hGui_ChildWindows[2][1],$Pos[1]+$_hGui_ChildWindows[2][2],0x948064,0x00000,150,"",NOT $ChildWindows_IgnoreInput)
$_hGui_ChildWindows[3][0] = $_Box_Experience[0]
$_hGui_ChildWindows[3][3] = $_Box_Experience[2]
GUICtrlSetColor($_Box_Experience[1], 0x948064)
Else
$_hGui_ChildWindows[0][0] = 2
EndIf
$ptr_Statlist = _ReadD2Memory($Diablo_MemHandle, 0x5c + _
_ReadD2Memory($Diablo_MemHandle, $D2Client + $p_PlayerUnit,"dword",False,$__DLL_Kernel32),"dword",False,$__DLL_Kernel32)
Global $Stats = False
Global $StatsBox = CreateLabelBox("",90,230, $Pos[0]+775,$Pos[1]+110,0x948064,0x00000,150,"",True,"AvQest",-500,-500)
$_hGui_ChildWindows[4][0] = $StatsBox[0]
$_hGui_ChildWindows[4][3] = $StatsBox[2]
$_hGui_ChildWindows[4][1] = 775
$_hGui_ChildWindows[4][2] = 110+24
$_Button = GuiCtrlCreateButton("<<",3,3)
GUICtrlSetFont(-1, 10, 300, "", "AvQest")
$StatsBox_Labels[1][1] = "Stats"
$StatsBox_Labels[2][1] = " Fcr  "
$StatsBox_Labels[3][1] = " Fhr  "
$StatsBox_Labels[4][1] = " Ias   "
$StatsBox_Labels[5][1] = " Mf   "
$StatsBox_Labels[6][1] = " Dr   "
$StatsBox_Labels[7][1] = " Fres: "
$StatsBox_Labels[8][1] = " Cres: "
$StatsBox_Labels[9][1] = " Lres: "
$StatsBox_Labels[10][1] = " PRes: "
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
WinMove($StatsBox[0],"",$Pos[0]+775,$Pos[1]+100,25, 35)
GuiCtrlSetOnEvent($_Button,"Stats")
$_Box_IlvlTip = CreateLabelBox("",60, 15,-100,-100,0x948064,0x00000,200,"",False,"AvQest",0,0)
If $Need_Config Then
$Pid = WinGetProcess($NewDiabloTitle)
$Diablo_hWnd = WinGetHandle($NewDiabloTitle)
$__DLL_Kernel32 = DllOpen("Kernel32.dll")
$Diablo_MemHandle = openSecureProcess($Pid,0x001F0FFF)
setPrivilege("SeDebugPrivilige",True)
EndIf
$Mousepos_old = MouseGetPos()
$oldcoords = CHAR_GetCoords()
$LastChatMsg = GAME_GetLastChatMsg()
$LastChatMsg1 = $LastChatMsg
$Area_Old = MAP_GetArea()
GUISetState(@SW_SHOW, $_hGui_main)
WinActivate($Diablo_hWnd)
$LastGameName = GAME_GetGameName()
$LastGamePass = GAME_GetGamePass()
AdlibRegister("Resize",300)
_FileWriteLog(@ScriptDir & "\Events.log","Autumn " & $Version & " started successfully.")
While 1
If GAME_DetectIngame() Then
Ingame()
Else
OutOfGame()
EndIf
Sleep($Settings_LoopDelay)
Wend
EndFunc
Func Ingame()
print("Starting in game loop")
$nStatic = False
$Area_Old= 0
$ptr_Statlist = _ReadD2Memory($Diablo_MemHandle, 0x5c + _
_ReadD2Memory($Diablo_MemHandle, $D2Client + $p_PlayerUnit,"dword",False,$__DLL_Kernel32),"dword",False,$__DLL_Kernel32)
$Xp_start = _DiaAPI_GetStatValue(13,0,0,$ptr_Statlist)
$Level = _DiaAPI_GetStatValue(12,0,0,$ptr_Statlist)
$LastGameName = GAME_GetGameName()
$LastGamePass = GAME_GetGamePass()
$OMG = 0
$oog = False
ActivateChilds()
GuiSetState(@SW_Hide,$_Box_GamePass[1])
$Headerpos[0] = 118
$Headerpos[1] = 554
$Ingame = True
$starttime = TimerInit()
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
HotKeys(TRUE)
Do
If TimerDiff($starttime) > 5000 Then
$Area_New = MAP_GetQuickArea()
Else
$Area_New = MAP_GetArea()
EndIf
Switch IsTown($Area_New)
Case False
$_newcoords = CHAR_GetPathedCoords()
$Changed_Area =($Area_New <> $Area_Old) OR NOT $_newcoords[1] > 1000
If Difference($_newcoords[0],$_newcoords[1],$oldcoords[0],$oldcoords[1],5) OR $Changed_Area Then
$newcoords = CHAR_GetCoords()
If Difference($newcoords[0],$newcoords[1],$oldcoords[0],$oldcoords[1],3) OR $Changed_Area Then
If $Area_New <> $Area_Old Then
$Area_Old = $Area_New
$Warps = MAP_GetWarpPoints()
Endif
Redraw($Warps)
$oldcoords = $newcoords
EndIf
EndIf
Sleep($Settings_LoopDelay/3)
If $Settings_ChickenPercent <> -1 Then
$Currentlife = CHAR_GetCurrentHp()
If $Currentlife > 0 Then
$MaxLife = _DiaAPI_GetStatValue(7,1,0,$ptr_Statlist)
$LifePercent = Round(($Currentlife / $MaxLife), 3) * 100
If(($Settings_ChickenPercent > $LifePercent) AND($LifePercent > 0)) Then
print("Chickening on "& $LifePercent)
exitGame()
_FileWriteLog(@ScriptDir & "\Events.log", "Game: " & $LastGameName & "-> Chickened on lifepercent " & $LifePercent & "%. Remaining life was " & $Currentlife & ".")
GUISetBkColor(0xABCDEF, $_hGui_main)
EndIf
EndIf
EndIf
Case Else
GUISetBkColor(0xABCDEF, $_hGui_main)
Sleep(400)
EndSwitch
Sleep($Settings_LoopDelay/3)
If $Settings_Logsettings Then
$LastChatMsg = GAME_GetLastChatMsg()
If $LastChatMsg <> $LastChatMsg1 Then
$LastChatMsg1 = $LastChatMsg
If $LastChatMsg1 <> "" Then
_FileWriteLog(@ScriptDir & "\Messages.log",@tab & "• " & $LastChatMsg1,-1,False)
If $Settings_Notify Then
If NOT WinActive($Diablo_hWnd) Then
If StringInStr($LastChatMsg,"Diablo's minions grow stronger") Then
$Player = StringSplit($LastChatMsg,"(")
$Account = StringSplit($Player[2],")")
$Message = "Player " & $Player[1] & " *" & $Account[1] & " joined your game: " & $LastGameName
Traytip("Autumn",$Message,5)
ElseIf StringInStr($LastChatMsg,"Diablo's minions weaken") Then
$Player = StringSplit($LastChatMsg,"(")
$Account = StringSplit($Player[2],")")
$Message = "Player " & $Player[1] & " *" & $Account[1] & " left your game: " & $LastGameName
Traytip("Autumn",$Message,5)
Else
$Message = $LastChatMsg
Traytip("Autumn",$Message,5)
EndIf
Endif
Endif
EndIf
EndIf
EndIf
If $Settings_RevealOnActChange Then
If TimerDiff($starttime) > 2000 Then
If NOT $Revealed_Acts[MAP_GetActByArea($Area_New)-1] Then
BlockInput(1)
RevealAct()
For $i = 0 to 3
BlockInput(0)
Next
$Revealed_Acts[MAP_GetActByArea($Area_New)-1] = True
EndIf
EndIf
EndIf
Sleep($Settings_LoopDelay/3)
Until NOT GAME_DetectIngame()
If $Settings_XpCounter Then GUICtrlSetData($_Box_Experience[1], "")
GUICtrlSetData($_Box_IP[1], "")
AdlibUnRegister("Delayed_Settings")
DeactivateChilds()
GUISetBkColor(0xABCDEF, $_hGui_main)
If $Settings_Logsettings Then
_FileWriteLog(@ScriptDir & "\Messages.log","Left game: " & $LastGameName & "//" & $LastGamePass)
_FileWriteLog(@ScriptDir & "\Messages.log", @CRLF ,-1,False)
EndIf
EndFunc
Func OutOfGame()
print("Starting out of game loop")
$Headerpos[0] = 400-(95/2)
$Headerpos[1] = 24
Sleep(500)
GUISetBkColor(0xABCDEF, $_hGui_main)
$oog = True
GuiSetState(@SW_show,$_Box_GamePass[1])
ForceResize()
HotKeys(FALSE)
Do
If _ReadD2Memory($Diablo_MemHandle, $D2MULTI_OFFSET + $p_GameListUp,"dword",False,$__DLL_Kernel32) = 3 Then
$Join = True
Else
$Join = False
Endif
WriteGameInfo()
Sleep(300)
Until GAME_DetectIngame()
$oog = False
Endfunc
Func Resize()
$Pos = WinGetPos($_hGui_main)
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
If(($pos1[0]+ 2 <> $Pos[0]) OR($pos1[1]+ 24 <> $Pos[1])) Then
$Pos = $pos1
If $Xp == True Then
WinMove($_hGui_main, "", $pos1[0], $pos1[1])
For $i = 1 to $_hGui_ChildWindows[0][0]
WinMove($_hGui_ChildWindows[$i][0], "", $pos1[0]+$_hGui_ChildWindows[$i][1],$pos1[1]+$_hGui_ChildWindows[$i][2])
Next
WinMove($_Box_Autumn[0],"",$pos1[0]+$Headerpos[0], $pos1[1]+$Headerpos[1])
Else
WinMove($_hGui_main, "", $pos1[0] + 2, $pos1[1] + 24)
For $i = 1 to $_hGui_ChildWindows[0][0]
If IsHWnd($_hGui_ChildWindows[$i][0]) Then WinMove($_hGui_ChildWindows[$i][0], "", $pos1[0]+$_hGui_ChildWindows[$i][1],$pos1[1]+$_hGui_ChildWindows[$i][2])
Next
WinMove($_Box_Autumn[0],"",$pos1[0]+$Headerpos[0], $pos1[1]+$Headerpos[1])
If $oog Then
If $Join Then
WinMove($_Box_GamePass[0],"",$pos1[0]+428,$pos1[1]+180)
Endif
Endif
Endif
Endif
IF $Trap_Enabled Then
If NOT $Trap_DO Then
print("trapping mouse")
_MouseTrap($pos1[0]+4, $pos1[1]+25, $pos1[0] + $pos1[2]-4, $pos1[1] + $pos1[3]-4)
$Trap_DO = True
EndIf
If(($pos_old[0] <> $pos1[0]) OR($pos_old[1] <> $pos1[1])) Then
print("retrapping mouse")
$pos_old = $pos1
_MouseTrap($pos1[0], $pos1[1], $pos1[0] + $pos1[2], $pos1[1] + $pos1[3])
$Trap_DO = True
EndIf
EndIf
Else
Local $Search
Local $_hWnd = WinGetHandle("[ACTIVE]")
For $i = 1 to $_hGui_ChildWindows[0][0]
If $_hWnd == $_hGui_ChildWindows[$i][0] Then $Search = True
Next
If((-32000 <> $Pos[0]) OR(-32000 <> $Pos[1])) AND NOT $Search Then
WinMove($_hGui_main, "", -32000, -32000)
For $i = 1 to $_hGui_ChildWindows[0][0]
WinMove($_hGui_ChildWindows[$i][0], "", -32000, -32000)
Next
WinMove($_Box_Autumn[0],"",-32000,-32000)
$Pos[0] = -32000
$Pos[1] = -32000
WinMove($_Box_GamePass[0],"",-32000,-32000)
Endif
If $Trap_Enabled Then
If $Trap_DO Then
print("untrapping mouse")
_MouseTrap()
$Trap_DO = False
EndIf
EndIf
Endif
EndFunc
Func ForceResize()
$Pos = WinGetPos($_hGui_main)
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
$Pos = $pos1
If $Xp == True Then
WinMove($_hGui_main, "", $pos1[0], $pos1[1])
For $i = 1 to $_hGui_ChildWindows[0][0]
WinMove($_hGui_ChildWindows[$i][0], "", $pos1[0]+$_hGui_ChildWindows[$i][1],$pos1[1]+$_hGui_ChildWindows[$i][2])
Next
WinMove($_Box_Autumn[0],"",$pos1[0]+$Headerpos[0], $pos1[1]+$Headerpos[1])
Else
WinMove($_hGui_main, "", $pos1[0] + 2, $pos1[1] + 24)
For $i = 1 to $_hGui_ChildWindows[0][0]
If IsHWnd($_hGui_ChildWindows[$i][0]) Then WinMove($_hGui_ChildWindows[$i][0], "", $pos1[0]+$_hGui_ChildWindows[$i][1],$pos1[1]+$_hGui_ChildWindows[$i][2])
Next
WinMove($_Box_Autumn[0],"",$pos1[0]+$Headerpos[0], $pos1[1]+$Headerpos[1])
If $oog == True Then
If $Join == True Then
WinMove($_Box_GamePass[0],"",$pos1[0]+428,$pos1[1]+180)
Endif
Endif
Endif
IF $Trap_Enabled Then
If NOT $Trap_DO Then
print("trapping mouse")
_MouseTrap($pos1[0]+4, $pos1[1]+25, $pos1[0] + $pos1[2]-4, $pos1[1] + $pos1[3]-4)
$Trap_DO = True
EndIf
If(($pos_old[0] <> $pos1[0]) OR($pos_old[1] <> $pos1[1])) Then
print("retrapping mouse")
$pos_old = $pos1
_MouseTrap($pos1[0], $pos1[1], $pos1[0] + $pos1[2], $pos1[1] + $pos1[3])
$Trap_DO = True
EndIf
EndIf
Else
If((-32000 <> $Pos[0]) OR(-32000 <> $Pos[1])) Then
WinMove($_hGui_main, "", -32000, -32000)
For $i = 1 to $_hGui_ChildWindows[0][0]
WinMove($_hGui_ChildWindows[$i][0], "", -32000, -32000)
Next
WinMove($_Box_Autumn[0],"",-32000,-32000)
$Pos[0] = -32000
$Pos[1] = -32000
WinMove($_Box_GamePass[0],"",-32000,-32000)
Endif
If $Trap_Enabled Then
If $Trap_DO Then
print("untrapping mouse")
_MouseTrap()
$Trap_DO = False
EndIf
EndIf
Endif
EndFunc
Func Redraw($Warps)
GUISetBkColor(0xABCDEF,$_hGui_main)
If MAP_GetAutomapToggled() THen
If $Warps = False Then Return False
If IsArray($Warps) = 0 Then Return False
For $i = 0 to($Warps[2][0] - 1)
$Coords = Conv_CoordToPixel($newcoords,$Warps[0][$i], $Warps[1][$i],True)
_GDIPlus_GraphicsDrawLine($hGraphic, $xy_base[0],$xy_base[1], $Coords[0], $Coords[1], $hPen[$i])
Next
Endif
EndFunc
Func Terminate()
If $Settings_Hotkeys_TownChicken <> -1 Then ProcCallbackFree($stdpacket)
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
EndFunc
Func End()
Exit
EndFunc
Func _End()
If NOT WinActive($Diablo_hWnd) Then Return
Exit
EndFunc
Func exitGame()
If NOT GAME_DetectIngame() Then Return False
If $Settings_ExitUseThread Then
Local $thread = CreateRemoteThread($Diablo_MemHandle,0,0,$D2Client + $p_ExitGame,0,0,0)
_WinAPI_WaitForSingleObject($thread,20000)
_WinAPI_CloseHandle($thread)
Sleep(2000)
Return True
Else
BlockInput(1)
Do
While _ReadD2Memory($Diablo_MemHandle,0x6FA91270,"dword",False,$__DLL_Kernel32) > 0
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
BlockInput(0)
Sleep(100)
Next
EndIf
EndFunc
Func WriteGameInfo()
If $Join Then
$msg = $LastGameName & "   //   " & $LastGamePass
If $msg <> GUICtrlRead($_Box_GamePass[1]) Then GUICtrlSetData($_Box_GamePass[1], $msg)
$_Pos = WinGetPos($_Box_GamePass[0])
$pos1 = WinGetPos($Diablo_hWnd)
If WinActive($Diablo_hWnd) Then
If((-32000 == $_Pos[0]) OR(-32000 == $_Pos[1])) Then WinMove($_Box_GamePass[0],"",$pos1[0]+428,$pos1[1]+180)
Else
If((-32000 <> $_Pos[0]) OR(-32000 <> $_Pos[1])) Then WinMove($_Box_GamePass[0],"",-32000,-32000)
EndIf
Else
WinMove($_Box_GamePass[0],"",-32000,-32000)
EndIf
EndFunc
Func WriteIp()
$ServerIp = GAME_GetServerIp()
If $ServerIp <> GUICtrlRead($_Box_IP[1]) Then GUICtrlSetData($_Box_IP[1], $ServerIp)
EndFunc
Func WriteTime()
$CurrentTime = GetFormattedTimeDiff($starttime)
If $CurrentTime <> GuiCtrlRead($_Box_Time[1]) Then GuiCtrlSetData($_Box_Time[1],$CurrentTime)
EndFunc
Func WriteXp()
If $Settings_XpCounter Then
Local $XP_Current,$level_new,$xp_games,$xp_needed,$xp_earned,$msg
$XP_Current = _DiaAPI_GetStatValue(13,0,0,$ptr_Statlist)
$level_new = _DiaAPI_GetStatValue(12,0,0,$ptr_Statlist)
if $level_new <> $Level Then
If NOT $level_new then Return
If $level_new = -1 then Return
$Level = $level_new
$Xp_start = $Level_Pop[$Level]
Endif
If $level_new >= 99 Then
$xp_games = -1
Else
$xp_needed = $Level_Pop[$Level+1]
$xp_earned = $XP_Current - $Xp_start
EndIf
If $xp_earned = 0 Then
$xp_games = -1
Else
$xp_games = Ceiling(($xp_needed - $XP_Current) / $xp_earned)
Endif
$msg = "Earned Xp: " & @CRLF & $xp_earned & @CRLF _
& "Games till lvl: " & @CRLF & $xp_games
If $msg <> GUICtrlRead($_Box_Experience[1]) Then GUICtrlSetData($_Box_Experience[1], $msg)
EndIf
EndFunc
Func Delayed_Settings()
WriteXp()
WriteTime()
EndFunc
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
EndFunc
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
EndFunc
Func CreateLabelBox($Text,$X = 100,$Y = 100,$xpos = 0,$ypos = 0,$textcolor = 0xFFFFFFF,$boxcolor = 0x00000,$trans = 150,$Title = "",$userinput = True,$_Box_Autumn = "AvQest", $offsetx = 5, $offsety = 5,$style = 0x0)
Local $Return[3]
$Return[0] = GuiCreate($Title,$X,$Y,$xpos,$ypos,$WS_POPUP,BitOR($WS_EX_CLIENTEDGE,$WS_EX_LAYERED,$WS_EX_TOPMOST,$WS_EX_TOOLWINDOW,$style))
$Return[1] = GUICtrlCreateLabel($Text,$offsetx,$offsety, $X, $Y, -1, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetColor($Return[1],$textcolor)
GUICtrlSetFont($Return[1], 10, 800, "", $_Box_Autumn)
If @Error Then
GUICtrlSetFont($Return[1], 10, 800, "", "Arial")
Endif
GuiSetBkColor($boxcolor,$Return[0])
_WinAPI_SetLayeredWindowAttributes($Return[0], 0xABCDEF,$trans)
$Return[2] = _WinAPI_GetWindowLong($Return[0], -20)
If NOT $userinput Then
_WinAPI_SetWindowLong($Return[0], -20, BitOR(_WinAPI_GetWindowLong($Return[0], -20), 0x00000020))
Endif
Return $Return
Endfunc
Func ChildSizing($hWnd, $msg, $wParam, $lParam)
If $hWnd = $_hGui_main Then Return
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
If(($pos_Child[0] < -4000) or($pos_Child[1] < -4000)) Then Return
$_hGui_ChildWindows[$Count][1] = $pos_Child[0] - $pos_Dia[0]
$_hGui_ChildWindows[$Count][2] = $pos_Child[1] - $pos_Dia[1]
EndIf
Endfunc
Func ActivateChilds()
For $i = 1 to $_hGui_ChildWindows[0][0]
GuiSetState(@SW_SHOW,$_hGui_ChildWindows[$i][0])
Next
WinActivate($Diablo_hWnd)
Endfunc
Func DeactivateChilds()
For $i = 1 to $_hGui_ChildWindows[0][0]
GuiSetState(@SW_HIDE,$_hGui_ChildWindows[$i][0])
Next
WinActivate($Diablo_hWnd)
Endfunc
Func Ilvl_Viewer()
If TrayItemGetState($ITEM_Ilvl) = 65 Then
GuiSetState(@SW_Show,$_Box_IlvlTip[0])
AdlibRegister("ToolTip_Ilvl",40)
Else
AdlibUnRegister("ToolTip_Ilvl")
GuiSetState(@SW_HIDE,$_Box_IlvlTip[0])
EndIf
Endfunc
Func About()
$_hGUI_About = GUICreate("Autumn - About", 250, 250, 444, 218,-1, BitOR($WS_EX_WINDOWEDGE,$WS_EX_TOPMOST,$WS_EX_TOOLWINDOW,$WS_EX_LAYERED))
_WinAPI_SetLayeredWindowAttributes($_hGUI_About, 0xABCDEF,230)
Local $msg = _
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
Endfunc
Func ToolTip_Ilvl()
$Mousepos_new = MouseGetPos()
If(($Mousepos_new[0] <> $Mousepos_old[0]) OR($Mousepos_new[1] <> $Mousepos_old[1])) Then
$Mousepos_old = $Mousepos_new
Local $WinPos = WinGetPos($_Box_IlvlTip[0])
$ilvl = ITEM_GetIlvl()
If NOT $ilvl Then
If((-32000 <> $WinPos[0]) OR(-32000 <> $WinPos[1])) Then Winmove($_Box_IlvlTip[0],"",-32000,-32000)
Else
$msg = "Ilvl: " & $ilvl
GuiCtrlSetData($_Box_IlvlTip[1],$msg)
If(($Mousepos_old[0]+15 <> $WinPos[0]) OR($Mousepos_old[1]+15 <> $WinPos[1])) Then WInMove($_Box_IlvlTip[0],"",$Mousepos_old[0]+15,$Mousepos_old[1]+15)
Endif
Endif
Endfunc
Func _DeleteAbout()
_GDIPlus_GraphicsDispose($_hGUI_About_Graphics)
_GDIPlus_BitmapDispose($_hGUI_About_Image)
GuiDelete($_hGUI_About)
EndFunc
Func CopyItem()
If NOT WinActive($Diablo_hWnd) Then Return
Local $sztext, $sz_Split
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
Func LockChilds()
If TrayItemGetState($ITEM_Lock) = 65 Then
$ChildWindows_IgnoreInput = True
For $i = 1 to $_hGui_ChildWindows[0][0]
_WinAPI_SetWindowLong($_hGui_ChildWindows[$i][0], -20, BitOR(_WinAPI_GetWindowLong($_hGui_ChildWindows[$i][0], -20), 0x00000020))
Next
Else
$ChildWindows_IgnoreInput = False
For $i = 1 to $_hGui_ChildWindows[0][0]
_WinAPI_SetWindowLong($_hGui_ChildWindows[$i][0], -20,$_hGui_ChildWindows[$i][3])
Next
EndIf
Endfunc
Func Hide_Windows()
If TrayItemGetState($Item_Boxes_Hide) = 65 Then
DeactivateChilds()
Else
ActivateChilds()
EndIf
Endfunc
Func print($msg = @CRLF)
If $msg = "" then Return
Consolewrite($msg & @CRLF)
EndFunc
Func Lock_Mouse()
If TrayItemGetState($ITEM_Mouse_Lock) == 65 Then
$Pos = WinGetPos($Diablo_hWnd)
MouseMove($Pos[0]+($Pos[2]/2),$Pos[1]+($Pos[3]/2),0)
$Trap_Enabled = True
WinActivate($Diablo_hWnd)
Else
$Trap_Enabled = False
EndIf
EndFunc
Func GetFormattedTimeDiff($starttime)
Local $seconds = "00", $minutes = "00", $hours = "00", $difference_ms
$difference_ms = TimerDiff($starttime)
Select
Case($difference_ms / 3600000) >= 1
$remaining_ms_from_hour = Mod($difference_ms,3600000)
$remaining_ms_from_hour_from_min = Mod($remaining_ms_from_hour,60000)
$seconds = String(Floor($remaining_ms_from_hour_from_min / 1000))
$minutes = String(Floor($remaining_ms_from_hour / 60000))
$hours = String(Floor($difference_ms / 3600000))
If StringLen($seconds) == 1 Then $seconds = "0" & $seconds
If StringLen($minutes) == 1 Then $minutes = "0" & $minutes
If StringLen($hours) == 1 Then $hours = "0" & $hours
Case($difference_ms / 60000) >= 1
$remaining_ms_from_min = Mod($difference_ms,60000)
$seconds = String(Floor($remaining_ms_from_min / 1000))
$minutes = String(Floor($difference_ms / 60000))
If StringLen($seconds) == 1 Then $seconds = "0" & $seconds
If StringLen($minutes) == 1 Then $minutes = "0" & $minutes
Case($difference_ms / 1000) >= 1
$seconds = String(Floor($difference_ms / 1000))
If StringLen($seconds) == 1 Then $seconds = "0" & $seconds
EndSelect
Return $hours & ":" & $minutes & ":" & $seconds
EndFunc
Func SetLastError($iError = 0)
Local $Call = DllCall($__DLL_Kernel32,"none","SetLastError","dword",$iError)
Return $Call[0]
EndFunc
Func CreateProcess($Path,$Params,$Dir = @ScriptDir)
Local $CommandLine = $Path & " " & $Params
Local $STARTUPINFO = DllStructCreate($tagSTARTUPINFO)
DllStructSetData($STARTUPINFO,"Size",DLlStructGetSize($STARTUPINFO))
Local $PROCESS_INFORMATION = DLLStructCreate($tagPROCESS_INFORMATION)
Local $iResult = _WinAPI_CreateProcess($Path, $CommandLine,0, 0, False, 0x04000000, 0, $Dir,DllStructGetPtr($STARTUPINFO),DllStructGetPtr($PROCESS_INFORMATION))
Return _Iif($iResult,$PROCESS_INFORMATION,_WinAPI_GetLastError())
EndFunc
Func _UpdateList()
GuiCtrlSetData($List_DiabloWindows,"")
$_List = WinList("[CLASS:Diablo II]")
For $i = 1 to $_List[0][0]
GUICtrlSetData($List_DiabloWindows, $i & ". " & $_List[$i][0] & " - HWND " & $_List[$i][1] & "|")
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
Global $_hGui_ChildWindows [5][4]
$_hGui_ChildWindows[0][0] = 4
$ChildWindows_IgnoreInput = Execute(Iniread(@Scriptdir & "\Settings.ini","CHILDWINDOWS","Lock",True))
For $i = 1 to $_hGui_ChildWindows[0][0]
$_hGui_ChildWindows[$i][1] = Iniread(@Scriptdir & "\Settings.ini","CHILDWINDOWS","hwnd" & $i & "prefpos.x",0)
$_hGui_ChildWindows[$i][2] = Iniread(@Scriptdir & "\Settings.ini","CHILDWINDOWS","hwnd" & $i &"prefpos.y",0)
Next
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
LoadTPSystem()
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
