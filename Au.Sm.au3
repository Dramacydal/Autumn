#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;######################################################
;~>													<~;
;~>		AutoIt Version: 3.3.6.1						<~;
;~>		Author:        Shaggi						<~;
;~>		Version:		1.0							<~;
;~>		Scriptname:		D2SM						<~;
;~>			<Diablo II Simple Maphack>				<~;
;~>													<~;
;~>		Script Function:							<~;
;~>		Reveals current act in Diablo				<~;
;~>		Requirements: 								<~;
;~>			Os: Xp++								<~;
;~>			Diablo: Patch 1.13d					<~;
;~>													<~;
;~>		Credits:									<~;
;~>		Rain and asp for openSecureProcess			<~;
;~>													<~;
;~>		McGod (mMap) and emjay (lolwut) for their 	<~;
;~>		maphacks, which this maphack is based upon.	<~;
;~>													<~;
;~>		Notes:										<~;
;~>			Documentation for the opcode can be 	<~;
;~>			found at the bottom of the script		<~;
;######################################################

;Global Const $CALL_INSTRUCTION_SIZE 				= 0x5



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
		Print("Only reveal when you're ingame...")
		Return False
	EndIf
	Local $Injected_Thread_Address = _MemVirtualAllocEx($Diablo_MemHandle,0, $iDataSize, BitOR($MEM_RESERVE, $MEM_COMMIT), $PAGE_EXECUTE_READWRITE)
	If NOT $Injected_Thread_Address Then Return False
		print("VirtualAllocEx():  " & _WinAPI_GetLastError() & @CRLF & @TAB & _WinAPI_GetLastErrorMessage())

	Local $Injected_Thread_Address_ = Ptr(Number($Injected_Thread_Address))
	Local $szMaphack = "0x" & _
				"55" & _               																		;PUSH EBP
				"8BEC" & _             																		;MOV EBP,ESP
				"83EC2C" & _          																		;SUB ESP,2C
				"53" & _               																		;PUSH EBX
				"56" & _               																		;PUSH ESI
				"57" & _               																		;PUSH EDI
				"90" & _               																		;NOP
				"90" & _               																		;NOP
				"E8" & AddressOf($D2Client_OFFSET+$GetPlayerUnit,$Injected_Thread_Address_ + 0xB) & _      		;CALL D2CLIENT_GetPlayerUnit
				"68" & SwapEndian($D2Client_OFFSET+$LoadAct_2) & _    												;PUSH DWORD PTR DS:[D2CLIENT_LoadAct_2]   ; D2Client.6FB12760 // Fixed too PUSH 6FB12760
				"90" & _ 																					;Needed an extra NOP
				"8B15" & SwapEndian($D2Client_OFFSET+$p_D2CLIENT_Difficulty) & _    								;MOV EDX,DWORD PTR DS:[p_D2CLIENT_Difficu>; D2Client.6FBCC390
				"68" & SwapEndian($D2Client_OFFSET + $LoadAct_1) & _    											;PUSH DWORD PTR DS:[D2CLIENT_LoadAct_1]   ; D2Client.6FB12AA0
				"90" & _ 																					;Needed an extra NOP
				"909090" & _            																	;MOVZX EDX,BYTE PTR DS:[EDX] //Fixed to NOPNOPNOP
				"8BC8" & _             																		;MOV ECX,EAX
				"8B4118" & _          																		;MOV EAX,DWORD PTR DS:[ECX+18]
				"8D7485D8" & _        																		;LEA ESI,DWORD PTR SS:[EBP+EAX*4-28]
				"C745D401000000" & _ 																		;MOV DWORD PTR SS:[EBP-2C],1
				"C745D828000000" & _ 																		;MOV DWORD PTR SS:[EBP-28],28
				"C745DC4B000000" & _ 																		;MOV DWORD PTR SS:[EBP-24],4B
				"C745E067000000" & _ 																		;MOV DWORD PTR SS:[EBP-20],67
				"C745E46D000000" & _ 																		;MOV DWORD PTR SS:[EBP-1C],6D
				"C745E889000000" & _ 																		;MOV DWORD PTR SS:[EBP-18],89
				"8B7EFC" & _          																		;MOV EDI,DWORD PTR DS:[ESI-4]
				"57" & _               																		;PUSH EDI
				"33DB" & _             																		;XOR EBX,EBX
				"53" & _               																		;PUSH EBX
				"52" & _               																		;PUSH EDX
				"8B15" & SwapEndian($D2Client_OFFSET+$p_D2CLIENT_ExpCharFlag) & _    								;MOV EDX,DWORD PTR DS:[p_D2CLIENT_ExpChar>; D2Client.6FBC9854
				"53" & _               																		;PUSH EBX
				"5290" & _             																		;PUSH DWORD PTR DS:[EDX] //Fixed to PUSH EDX + NOP
				"894DEC" & _          																		;MOV DWORD PTR SS:[EBP-14],ECX
				"8B491C" & _          																		;MOV ECX,DWORD PTR DS:[ECX+1C]
				"FF710C" & _          																		;PUSH DWORD PTR DS:[ECX+C]
				"50" & _               																		;PUSH EAX
				"E8" & AddressOf($D2COMMON_OFFSET + $LoadAct,$Injected_Thread_Address_, 0x73) & _      			;CALL D2COMMON_LoadAct
				"8945F4" & _          																		;MOV DWORD PTR SS:[EBP-C],EAX
				"3BC3" & _             																		;CMP EAX,EBX
				"0F8412010000" & _    																		;JE 725A1415
				"8B36" & _             																		;MOV ESI,DWORD PTR DS:[ESI]
				"8975F0" & _          																		;MOV DWORD PTR SS:[EBP-10],ESI
				"3BFE" & _             																		;CMP EDI,ESI
				"E9D7000000" & _      																		;JMP 725A13E6
				"8B45F4" & _          																		;MOV EAX,DWORD PTR SS:[EBP-C]
				"8B4848" & _          																		;MOV ECX,DWORD PTR DS:[EAX+48]
				"8BB17C040000" & _    																		;MOV ESI,DWORD PTR DS:[ECX+47C]
				"3BF3" & _             																		;CMP ESI,EBX
				"741B" & _            																		;JE SHORT 725A133A
				"39BED0010000" & _    																		;CMP DWORD PTR DS:[ESI+1D0],EDI
				"7505" & _            																		;JNZ SHORT 725A132C
				"395E1C" & _          																		;CMP DWORD PTR DS:[ESI+1C],EBX
				"770A" & _            																		;JA SHORT 725A1336
				"8BB6AC010000" & _    																		;MOV ESI,DWORD PTR DS:[ESI+1AC]
				"3BF3" & _             																		;CMP ESI,EBX
				"75E9" & _            																		;JNZ SHORT 725A131F
				"3BF3" & _             																		;CMP ESI,EBX
				"7511" & _            																		;JNZ SHORT 725A134B
				"8BD7" & _             																		;MOV EDX,EDI
				"E8" & AddressOf($D2COMMON_OFFSET+$GetLevel,$Injected_Thread_Address_,0xBC) & _      				;CALL D2COMMON_GetLevel
				"8BF0" & _             																		;MOV ESI,EAX
				"3BF3" & _             																		;CMP ESI,EBX
				"0F8494000000" & _    																		;JE 725A13DF
				"395E10" & _          																		;CMP DWORD PTR DS:[ESI+10],EBX
				"7506" & _            																		;JNZ SHORT 725A1356
				"56" & _               																		;PUSH ESI
				"E8" & AddressOf($D2COMMON_OFFSET+$InitLevel,$Injected_Thread_Address_,0xD1) & _      				;CALL D2COMMON_InitLevel
				"8BCF" & _             																		;MOV ECX,EDI
				"E8" & AddressOf($D2COMMON_OFFSET+$GetLayer,$Injected_Thread_Address_,0xD8) & _      				;CALL D2COMMON_GetLayer
				"3BC3" & _             																		;CMP EAX,EBX
				"0F84B0000000" & _    																		;JE 725A1415
				"8B4808" & _         	 																	;MOV ECX,DWORD PTR DS:[EAX+8]
				"E8" & AddressOf($Injected_Thread_Address_ + 0x19E,$Injected_Thread_Address_, 0xE8) & _ 	;CALL D2CLIENT_InitAutomapLayer
				"8B7E10" & _         											 							;MOV EDI,DWORD PTR DS:[ESI+10]
				"EB69" & _            																		;JMP SHORT 725A13DB
				"885DFF" & _          																		;MOV BYTE PTR SS:[EBP-1],BL
				"395F30" & _          																		;CMP DWORD PTR DS:[EDI+30],EBX
				"7522" & _            																		;JNZ SHORT 725A139C
				"8B86B4010000" & _    																		;MOV EAX,DWORD PTR DS:[ESI+1B4]
				"53" & _               																		;PUSH EBX
				"FF7738" & _          																		;PUSH DWORD PTR DS:[EDI+38]
				"FF7734" & _          																		;PUSH DWORD PTR DS:[EDI+34]
				"FFB6D0010000" & _    																		;PUSH DWORD PTR DS:[ESI+1D0]
				"FFB06C040000" & _    																		;PUSH DWORD PTR DS:[EAX+46C]
				"E8" & AddressOf($D2COMMON_OFFSET+$AddRoomData,$Injected_Thread_Address_,0x113) & _      			;CALL D2COMMON_AddRoomData
				"C645FF01" & _       																		;MOV BYTE PTR SS:[EBP-1],1
				"8B4730" & _          																		;MOV EAX,DWORD PTR DS:[EDI+30]
				"3BC3" & _             																		;CMP EAX,EBX
				"7435" & _            																		;JE SHORT 725A13D8
				"8B0D" & SwapEndian($D2Client_OFFSET + $p_D2CLIENT_AutomapLayer) & _    							;MOV ECX,DWORD PTR DS:[p_D2CLIENT_Automap>; D2Client.6FBCC1C4
				"5190" & _ 																					;PUSH DWORD PTR DS:[ECX] //Fixed to PUSH ECX + NOP
				"6A01" & _            																		;PUSH 1
				"50" & _               																		;PUSH EAX
				"E8" & AddressOf($D2Client_OFFSET+$RevealAutoMapRoom,$Injected_Thread_Address_,0x12E) & _      	;CALL D2CLIENT_RevealAutomapRoom
				"385DFF" & _          																		;CMP BYTE PTR SS:[EBP-1],BL
				"7420" & _            																		;JE SHORT 725A13D8
				"FF7730" & _          																		;PUSH DWORD PTR DS:[EDI+30]
				"8B86B4010000" & _    																		;MOV EAX,DWORD PTR DS:[ESI+1B4]
				"FF7738" & _          																		;PUSH DWORD PTR DS:[EDI+38]
				"FF7734" & _          																		;PUSH DWORD PTR DS:[EDI+34]
				"FFB6D0010000" & _    																		;PUSH DWORD PTR DS:[ESI+1D0]
				"FFB06C040000" & _    																		;PUSH DWORD PTR DS:[EAX+46C]
				"E8" & AddressOf($D2COMMON_OFFSET+$RemoveRoomData,$Injected_Thread_Address_,0x153) & _      		;CALL D2COMMON_RemoveRoomData
				"8B7F24" & _          																		;MOV EDI,DWORD PTR DS:[EDI+24]
				"3BFB" & _             																		;CMP EDI,EBX
				"7593" & _            																		;JNZ SHORT 725A1372
				"8B7DF8" & _          																		;MOV EDI,DWORD PTR SS:[EBP-8]
				"47" & _               																		;INC EDI
				"3B7DF0" & _          																		;CMP EDI,DWORD PTR SS:[EBP-10]
				"897DF8" & _          																		;MOV DWORD PTR SS:[EBP-8],EDI
				"0F8220FFFFFF" & _    																		;JB 725A130F
				"8B45EC" & _          																		;MOV EAX,DWORD PTR SS:[EBP-14]
				"8B402C" & _          																		;MOV EAX,DWORD PTR DS:[EAX+2C]
				"8B401C" & _          																		;MOV EAX,DWORD PTR DS:[EAX+1C]
				"8B4010" & _          																		;MOV EAX,DWORD PTR DS:[EAX+10]
				"8B4058" & _          																		;MOV EAX,DWORD PTR DS:[EAX+58]
				"8B88D0010000" & _    																		;MOV ECX,DWORD PTR DS:[EAX+1D0]
				"E8" & AddressOf($D2COMMON_OFFSET+$GetLayer,$Injected_Thread_Address_,0x184) & _      				;CALL D2COMMON_GetLayer
				"3BC3" & _             																		;CMP EAX,EBX
				"7408" & _            																		;JE SHORT 725A1415
				"8B4808" & _          																		;MOV ECX,DWORD PTR DS:[EAX+8]
				"E8" & AddressOf($Injected_Thread_Address_ + 0x19E,$Injected_Thread_Address_, 0x190) & _ 	;CALL D2CLIENT_InitAutomapLayer
				"5F" & _               																		;POP EDI
				"5E" & _               																		;POP ESI
				"33C0" & _             																		;XOR EAX,EAX
				"5B" & _               																		;POP EBX
				"C9" & _               																		;LEAVE
				"C20400" & _          																		;RETN 4
				"50" & _               																		;PUSH EAX
				"8BC1" & _             																		;MOV EAX,ECX
				"E8"& AddressOf($D2Client_OFFSET + $InitAutomapLayer_I,$Injected_Thread_Address_,0x1A1) & _      	;CALL D2CLIENT_InitAutomapLayer_I
				"58" & _               																		;POP EAX
				"C3"              																			;RETN


	$BytesWritten = 0

		Local $DataArray = DllStructCreate("byte[" & BinaryLen($szMaphack) & "]")
		DllStructSetData($DataArray,1,$szMaphack)
		_WinApi_WriteProcessMemory($Diablo_MemHandle,$Injected_Thread_Address,DllStructGetPtr($Dataarray),DllStructGetSize($DataArray),$BytesWritten)
			print("WriteProcessMemory(): " & _WinAPI_GetLastError() & @CRLF & @TAB & _WinAPI_GetLastErrorMessage())
	Print("Address of injected thread: " & $Injected_Thread_Address)
	If $BytesWritten Then
		Local $Thread = CreateRemoteThread($Diablo_MemHandle,0,0,$Injected_Thread_Address,0,0,0)
			print("CreateRemoteThread(): " & _WinAPI_GetLastError() & @CRLF & @TAB & _WinAPI_GetLastErrorMessage())
		If $Thread Then
			_WinAPI_WaitForSingleObject($Thread,0xFFFFFFFF)
			Local $DllStruct = DllStructCreate("dword")
			DllCall($__DLL_Kernel32,"BOOL","GetExitCodeThread","handle",$Thread,"ptr",DllStructGetPtr($DllStruct))
			Print("Thread successfully injected: " & DllStructGetData($DllStruct,1) & " (0x" &  Hex(DllStructGetData($DllStruct,1)) & ")" & @CRLF & @CRLF)
			_WinApi_CloseHandle($Thread)
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
EndFunc ;==>SwapEndian


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

Func addressOf($AbsAddress, $Instruction, $offset = 0)
	; Relative address = (ABSOLUTE_CALL_ADDRESS - (START_OF_CURRENT_ROUTINE + OFFSET_OF_CURRENT_INSTRUCTION)) - CALL_INSTRUCTION_SIZE
	Return SwapEndian((Number($AbsAddress)-(Number($Instruction)+Number($offset)))-Number($CALL_INSTRUCTION_SIZE))
EndFunc
