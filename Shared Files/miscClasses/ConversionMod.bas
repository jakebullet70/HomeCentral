B4A=true
Group=MiscClasses
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
'Class module
Sub Class_Globals
End Sub

Public Sub Initialize
End Sub


'-----------------------------------------------------------------------------------
'---
'---  Cooking conversions
'---  (c) all of Humankind
'---
'---  jakebullet70 on the B4A forums
'---
'-----------------------------------------------------------------------------------



#Region WEIGHT
Public Sub weight_pounds2oz(value As Float) As Float
	Return (16.0000 * value)
End Sub
Public Sub weight_pounds2grams(value As Float) As Float
	Return (453.59232 * value)
End Sub
Public Sub weight_pounds2kg(value As Float) As Float
	Return (0.45359 * value)
End Sub
'--------------------------------------------------------------
'--------------------------------------------------------------
Public Sub weight_oz2pounds(value As Float) As Float
	Return (0.06250 * value)
End Sub
Public Sub weight_oz2grams(value As Float) As Float
	Return (28.34952 * value)
End Sub
Public Sub weight_oz2kg(value As Float) As Float
	Return (0.02835 * value)
End Sub
'--------------------------------------------------------------
'--------------------------------------------------------------
Public Sub weight_grams2oz(value As Float) As Float
	Return (0.03527 * value)
End Sub
Public Sub weight_grams2pounds(value As Float) As Float
	Return (0.00220 * value)
End Sub
Public Sub weight_grams2kg(value As Float) As Float
	Return (0.00100 * value)
End Sub
'--------------------------------------------------------------
'--------------------------------------------------------------
Public Sub weight_kg2pounds(value As Float) As Float
	Return (2.20462 * value)
End Sub
Public Sub weight_kg2oz(value As Float) As Float
	Return (35.27397 * value)
End Sub
Public Sub weight_kg2grams(value As Float) As Float
	Return (1000.00000 * value)
End Sub
#End Region



#Region TEMP
Public Sub temp_c2f(value As Float) As Float
	Return (value * 1.8) + 32
End Sub
Public Sub temp_f2c(value As Float) As Float
	Return (value - 32.0) * 0.5555555
End Sub
#End Region



#Region LENGTH
Public Sub length_mm2cm(value As Float) As Float
	Return (value * 0.10)
End Sub
Public Sub length_mm2inches(value As Float) As Float
	Return length_cm2inches(length_mm2cm(value))
End Sub
Public Sub length_cm2mm(value As Float) As Float
	Return (value / 0.10)
End Sub
Public Sub length_cm2inches(value As Float) As Float
	Return value * 0.39370
End Sub
Public Sub length_inches2mm(value As Float) As Float
	Return length_cm2mm(value * 2.54000)
End Sub
Public Sub length_inches2cm(value As Float) As Float
	Return (value * 2.54000) 
End Sub

#End Region



#Region BUTTER
Public Sub butter_oz2grams(value As Float) As Float
	Return (value * 28.35)
End Sub
Public Sub butter_oz2stick(value As Float) As Float
	Return value / 4.0
End Sub
Public Sub butter_oz2cup(value As Float) As Float
	Return (value * 0.12500)
End Sub
Public Sub butter_oz2tbsp(value As Float) As Float
	Return (value * 2.0)
End Sub
'==========================================================
Public Sub butter_grams2oz(value As Float) As Float
	Return (value *  0.0352739619)
End Sub
Public Sub butter_grams2stick(value As Float) As Float
	Return butter_grams2cup(value) * 2
End Sub
Public Sub butter_grams2cup(value As Float) As Float
	Return (value * 0.00423)
End Sub
Public Sub butter_grams2tbsp(value As Float) As Float
	Return (value * 0.06763)
End Sub
'==========================================================
Public Sub butter_cup2oz(value As Float) As Float
	Return (value * 8.0)
End Sub
Public Sub butter_cup2stick(value As Float) As Float
	Return (value * 2.0)
End Sub
Public Sub butter_cup2gram(value As Float) As Float
	Return (value * 226.8) '--- butter
End Sub
Public Sub butter_cup2tbsp(value As Float) As Float
	Return (value * 16)
End Sub
'==========================================================
Public Sub butter_tbsp2oz(value As Float) As Float
	Return (value * 0.5)
End Sub
Public Sub butter_tbsp2stick(value As Float) As Float
	Return (value * 0.125)
End Sub
Public Sub butter_tbsp2gram(value As Float) As Float
	Return (value * 14.18) '--- butter
End Sub
Public Sub butter_tbsp2cups(value As Float) As Float
	Return (value * 0.0625)
End Sub
'==========================================================
Public Sub butter_stick2oz(value As Float) As Float
	Return (value * 4.0)
End Sub
Public Sub butter_stick2tbsp(value As Float) As Float
	Return (value * 8.0)
End Sub
Public Sub butter_stick2gram(value As Float) As Float
	Return (value * 113.0) '--- butter
End Sub
Public Sub butter_stick2cups(value As Float) As Float
	Return (value * 0.5)
End Sub
#End Region



#Region VOLUME
Public Sub volume_gal2floz(value As Float) As Float
	Return (value * 128.0)
End Sub
Public Sub volume_gal2tsp(value As Float) As Float
	Return (value * 768.0)
End Sub
Public Sub volume_gal2tbsp(value As Float) As Float
	Return (value * 256.0)
End Sub
Public Sub volume_gal2pints(value As Float) As Float
	Return (value * 8.0)
End Sub
Public Sub volume_gal2quarts(value As Float) As Float
	Return (value * 4.0)
End Sub
Public Sub volume_gal2liters(value As Float) As Float
	Return (value * 3.78541)
End Sub
Public Sub volume_gal2ml(value As Float) As Float
	Return (value * 3785.41)
End Sub
Public Sub volume_gal2cups(value As Float) As Float
	Return (value * 16.0)
End Sub
'======================================================
Public Sub volume_floz2gal(value As Float) As Float
	Return (value * 0.0078125)
End Sub
Public Sub volume_floz2cups(value As Float) As Float
	Return (value * 0.125)
End Sub
Public Sub volume_floz2ml(value As Float) As Float
	Return (value * 29.5735)
End Sub
Public Sub volume_floz2liters(value As Float) As Float
	Return (value * 0.0295735)
End Sub
Public Sub volume_floz2quarts(value As Float) As Float
	Return (value * 0.03125)
End Sub
Public Sub volume_floz2pints(value As Float) As Float
	Return (value * 0.0625)
End Sub
Public Sub volume_floz2tbsp(value As Float) As Float
	Return (value * 2)
End Sub
Public Sub volume_floz2tsp(value As Float) As Float
	Return (value * 6)
End Sub
'======================================================
Public Sub volume_cups2gal(value As Float) As Float
	Return (value * 0.0625)
End Sub
Public Sub volume_cups2floz(value As Float) As Float
	Return (value * 8.0)
End Sub
Public Sub volume_cups2ml(value As Float) As Float
	Return (value * 236.588)
End Sub
Public Sub volume_cups2liters(value As Float) As Float
	Return (value * 0.236588)
End Sub
Public Sub volume_cups2quarts(value As Float) As Float
	Return (value * 0.25)
End Sub
Public Sub volume_cups2pints(value As Float) As Float
	Return (value * 0.5)
End Sub
Public Sub volume_cups2tbsp(value As Float) As Float
	Return (value * 16.0)
End Sub
Public Sub volume_cups2tsp(value As Float) As Float
	Return (value * 48.0)
End Sub
'======================================================
Public Sub volume_pints2gal(value As Float) As Float
	Return (value * 0.125)
End Sub
Public Sub volume_pints2floz(value As Float) As Float
	Return (value * 16.0)
End Sub
Public Sub volume_pints2ml(value As Float) As Float
	Return (value * 473.176)
End Sub
Public Sub volume_pints2liters(value As Float) As Float
	Return (value * 0.473176)
End Sub
Public Sub volume_pints2quarts(value As Float) As Float
	Return (value * 0.5)
End Sub
Public Sub volume_pints2cups(value As Float) As Float
	Return (value * 2.0)
End Sub
Public Sub volume_pints2tbsp(value As Float) As Float
	Return (value * 32.0)
End Sub
Public Sub volume_pints2tsp(value As Float) As Float
	Return (value * 96.0)
End Sub
'======================================================
Public Sub volume_tsp2gal(value As Float) As Float
	Return (value * 0.00130208)
End Sub
Public Sub volume_tsp2floz(value As Float) As Float
	Return (value * 0.166667)
End Sub
Public Sub volume_tsp2ml(value As Float) As Float
	Return (value * 4.92892)
End Sub
Public Sub volume_tsp2liters(value As Float) As Float
	Return (value * 0.00492892)
End Sub
Public Sub volume_tsp2quarts(value As Float) As Float
	Return (value * 0.00520833)
End Sub
Public Sub volume_tsp2cups(value As Float) As Float
	Return (value * 0.0208333)
End Sub
Public Sub volume_tsp2tbsp(value As Float) As Float
	Return (value * 0.333333)
End Sub
Public Sub volume_tsp2pints(value As Float) As Float
	Return (value * 0.0104167)
End Sub
'======================================================
Public Sub volume_tbsp2gal(value As Float) As Float
	Return (value * 0.00390625)
End Sub
Public Sub volume_tbsp2floz(value As Float) As Float
	Return (value * 0.5)
End Sub
Public Sub volume_tbsp2ml(value As Float) As Float
	Return (value * 14.7868)
End Sub
Public Sub volume_tbsp2liters(value As Float) As Float
	Return (value * 0.0147868)
End Sub
Public Sub volume_tbsp2quarts(value As Float) As Float
	Return (value * 0.015625)
End Sub
Public Sub volume_tbsp2cups(value As Float) As Float
	Return (value * 0.0625)
End Sub
Public Sub volume_tbsp2tsp(value As Float) As Float
	Return (value * 3.0)
End Sub
Public Sub volume_tbsp2pints(value As Float) As Float
	Return (value * 0.03125)
End Sub
'======================================================
Public Sub volume_quart2gal(value As Float) As Float
	Return (value * 0.25)
End Sub
Public Sub volume_quart2floz(value As Float) As Float
	Return (value * 32)
End Sub
Public Sub volume_quart2ml(value As Float) As Float
	Return (value * 946.353)
End Sub
Public Sub volume_quart2liters(value As Float) As Float
	Return (value * 0.946353)
End Sub
Public Sub volume_quart2tbsp(value As Float) As Float
	Return (value * 64.0)
End Sub
Public Sub volume_quart2cups(value As Float) As Float
	Return (value * 4.0)
End Sub
Public Sub volume_quart2tsp(value As Float) As Float
	Return (value * 192.0)
End Sub
Public Sub volume_quart2pints(value As Float) As Float
	Return (value * 2.0)
End Sub
'======================================================
Public Sub volume_ml2gal(value As Float) As Float
	Return (value * 0.000264172)
End Sub
Public Sub volume_ml2floz(value As Float) As Float
	Return (value * 0.033814)
End Sub
Public Sub volume_ml2quart(value As Float) As Float
	Return (value * 0.00105669)
End Sub
Public Sub volume_ml2liters(value As Float) As Float
	Return (value * 0.001)
End Sub
Public Sub volume_ml2tbsp(value As Float) As Float
	Return (value * 0.067628)
End Sub
Public Sub volume_ml2cups(value As Float) As Float
	Return (value * 0.00422675)
End Sub
Public Sub volume_ml2tsp(value As Float) As Float
	Return (value * 0.202884)
End Sub
Public Sub volume_ml2pints(value As Float) As Float
	Return (value * 0.00211338)
End Sub
'======================================================
Public Sub volume_liter2gal(value As Float) As Float
	Return (value * 0.264172)
End Sub
Public Sub volume_liter2floz(value As Float) As Float
	Return (value * 33.814)
End Sub
Public Sub volume_liter2quart(value As Float) As Float
	Return (value * 1.05669)
End Sub
Public Sub volume_liter2ml(value As Float) As Float
	Return (value * 1000.0)
End Sub
Public Sub volume_liter2tbsp(value As Float) As Float
	Return (value * 67.628)
End Sub
Public Sub volume_liter2cups(value As Float) As Float
	Return (value * 4.22675)
End Sub
Public Sub volume_liter2tsp(value As Float) As Float
	Return (value * 202.884)
End Sub
Public Sub volume_liter2pints(value As Float) As Float
	Return (value * 2.11338)
End Sub


#End Region