B4J=true
Group=Helpers-StaticCodeMods
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Jan/01/2024
'			Generic functions / methods
#End Region
'Static code module
Sub Process_Globals
End Sub

Public Sub Init
End Sub



Public Sub int2bool(I As Int) As Boolean  
	Try
		If I = 0 Then Return False Else Return True
	Catch
		Log(LastException)
	End Try
	Return False
End Sub
