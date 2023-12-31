B4J=true
Group=Helpers-StaticCodeMods
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/Jakebullet
#Region VERSIONS 
' V. 1.0 	June/7/2022
#End Region
'Static code module
Sub Process_Globals
	Private xui As XUI
End Sub


'purpose: Eliminate characters that are not allowed in file/folder name
Public Sub CheckAndCleanFileName(StringToCheck As String) As String

	Dim sIllegal As String = "\`/`:`*`?`" & Chr(34) & "`<`>`|"
	Dim arIllegal() As String = Regex.Split( "`",sIllegal)
	Dim sReturn As String

	sReturn = StringToCheck

	For i = 0 To arIllegal.Length - 1
	    sReturn = sReturn.Replace(arIllegal(i), "_")
	Next

	Return sReturn
 
End Sub
	
'deletes file, will not throw an error if file does not exist
Public Sub SafeKill(folder As String, fname As String)
	
	If File.Exists(folder, fname) Then
		File.Delete(folder, fname)
	End If
	
End Sub


public Sub RemoveExtFromeFileName(fname As String) As String
	
	Try
		Return fname.SubString2(0,fname.LastIndexOf(".")).trim
	Catch
		Return fname
	End Try
	
End Sub


Public Sub BytesToReadableString(Bytes As String) As String
		
	If IsNumber(Bytes) = False Then Return "-"
	Dim Bytes1 As Double = Bytes

	Dim count As Int = 0
	Dim factor As Int = 1024 '--- could be 1000 for HD calc
	Dim Workingnum As Double = Bytes1
	Dim  Suffix As List = Array("Bytes", "KB", "MB", "GB", "TB", "PB")

	Do While Workingnum > factor And count < 5
		Workingnum = Workingnum / factor
		count = count + 1
	Loop
	
	Return $"${NumberFormat(Workingnum,1,2)}${Suffix.Get(count)}"$
	
End Sub

Public Sub FileExist(PathAndFile As String) As Boolean
	Return File.Exists(File.GetFileParent(PathAndFile),File.GetName(PathAndFile))
End Sub

