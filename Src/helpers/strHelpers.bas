B4J=true
Group=Helpers-StaticCodeMods
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	June/7/2022
#End Region
'Static code module
Sub Process_Globals
End Sub


'Return PadLeft(n,"0",2)
Public Sub PadZero(n As Int) As String
	Dim s As String = n
	If s.Length = 1 Then
		Return "0" & s
	End If
	Return s
End Sub


Public Sub PadLeft(Source As String, PadChar As String, Length As Int) As String
	'source = numberformat(source,length,0)
	'Log("PadLeft0: " & Source)
	For i = 0 To Length-1
		If Source.Length = Length Then
			Exit
		End If
		Source = PadChar & Source
	Next
	'Log("PadLeft1: " & Source)
	Return Source
	
End Sub


public Sub ConvertLinuxLineEndings2Windows(s As String) As String
	Return s.Replace(Chr(10),Chr(13) & Chr(10))
End Sub


Public Sub ProperCase(s As String) As String
	s = s.ToLowerCase
	Dim m As Matcher = Regex.Matcher("\b(\w)", s)
	Do While m.Find
		Dim i As Int = m.GetStart(1)
		s = s.SubString2(0, i) & s.SubString2(i, i + 1).ToUpperCase & s.SubString(i + 1)
	Loop
	Return s
End Sub


'--- VB style JOIN function
Public Sub Join(sepChar As String, Strings As List) As String
	
	Dim sb As StringBuilder
	sb.Initialize
	
	For Each s As String In Strings
		sb.Append(s).Append(sepChar)
	Next
	
	If sb.Length > 0 Then 
		sb.Remove(sb.Length - sepChar.Length, sb.Length)
	End If
	
	Return sb.ToString
	
End Sub


'--- removes last char if it exists
public Sub TrimLast(s As String, trimchar As String) As String
	
	If s.EndsWith(trimchar) Then
		Return s.SubString2(0,s.Length - 1)
	Else
		Return s
	End If
	
End Sub


'--- tests string for NULL or empty
Public Sub IsNullOrEmpty(s As String) As Boolean
	Return s = Null Or s.CompareTo(Null) = 0 Or s = ""
End Sub

