;Common algorithms used in Au.Map

;##################################################
;~ Function Conv_CoordToPixel
;~ Converts a given set of coordinates to corrosponding x,y pixels
;##################################################
Func Conv_CoordToPixel($_Start_Coords,$Coordx, $Coordy,$b = false,$Compas = False,$Cap = True)
	$x_Diff[1] = $Coordx - $_Start_Coords[0]
	$y_Diff[1] = $Coordy - $_Start_Coords[1]
	Return Conv_Calc($x_Diff[1], $y_Diff[1],$b,$Compas,$Cap)
EndFunc   ;==>Conv_CoordToPixel

;##################################################
;~ Function Conv_Calc
;~ Internal functions
;##################################################
Func Conv_Calc($x, $y, $minimap = True,$Compas = False,$Cap = True)
	Local $x_temp, $y_temp
	If $Compas Then
		Local $xy_base_c = $xy_base
	Else
		Local $xy_base_c[2] = [400,300]
	EndIf
	If $minimap == True Then ;this scales the lines so they fit onto automap
		$x_Temp =  $xy_base_c[0] + ((16 * $x)/10) + (($y * - 16)/10)
		$y_Temp =  $xy_base_c[1] - ((-8 * $y)/10) - (($x * - 8)/10)
		$x_Temp = Round($x_Temp,0)
		$y_Temp = Round($y_Temp,0)
	Elseif $minimap == False Then ;this converts the coords to onscreen pixels
		$x_Temp = $xy_base[0] + (16 * $x) + ($y * - 16)
		$y_Temp = $xy_base[1] - (-8 * $y) - ($x * - 8)
	Endif
	If $Cap Then
		If $x_Temp > 800 Then
			$xy_Final[0] = 798
		ElseIf $x_Temp < 0 Then
			$xy_Final[0] = 2
		Else
			$xy_Final[0] = $x_Temp
		EndIf
		If $y_Temp > 500 Then
			$xy_Final[1] = 500
		ElseIf $y_Temp < 0 Then
			$xy_Final[1] = 10
		Else
			$xy_Final[1] = $y_Temp
		EndIf
	Else
		$xy_Final[0] = $x_Temp
		$Xy_Final[1] = $y_Temp
	EndIf
	Return $xy_Final
EndFunc   ;==>Conv_Calc

;##################################################
;~ Function Difference
;~ Calculates if the difference between two set of coords is bigger or lower than the set difference
;##################################################
Func Difference($coord_x_1, $coord_y_1, $coord_x_2, $coord_y_2, $Difference = 2)
	If (($Difference < Abs($coord_x_1 - $coord_x_2)) OR ($Difference < Abs($coord_y_1 - $coord_y_2))) Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>Difference
