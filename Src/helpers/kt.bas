B4J=true
Group=Helpers
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Jan/11/2024
'			    kitchen timers Generic functions / methods
#End Region
'Static code module
Sub Process_Globals
	Private XUI As XUI
	
End Sub



Public Sub SetImages(Arr() As lmB4XImageViewX,imgName As String)
	For Each o As lmB4XImageViewX In Arr
		o.Bitmap = XUI.LoadBitmap(File.DirAssets, imgName)
	Next
End Sub


