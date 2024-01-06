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

' Counts the number of times a char appears in a string.
' Param - searchMe, the string to be searched
' Param - findMe, the single char to search for
Public Sub CountChar(searchMe As String, findMe As Char) As Int
	If Not(searchMe.Contains(findMe)) Then Return 0
	Dim CountMe As Int = 0

	For x = 0 To searchMe.Length - 1
		If searchMe.CharAt(x) = findMe Then
			CountMe = CountMe + 1
		End If
	Next
	Return CountMe
End Sub

