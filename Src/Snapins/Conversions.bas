B4J=true
Group=Snapins
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Dec/26/2023
#End Region


Sub Class_Globals
	Private XUI As XUI
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private Parent As B4XView
	
	
	Private oConversion As ConversionMod
End Sub

Public Sub Initialize(p As B4XView) As Object
	Parent = p	
	oConversion.Initialize
	Return Me
End Sub

Public Sub Show
	
End Sub


'-------------------------------
Public Sub Lost_Focus
	
End Sub
Public Sub Got_Focus
	
End Sub


'=============================================================================================
'=============================================================================================
'=============================================================================================




