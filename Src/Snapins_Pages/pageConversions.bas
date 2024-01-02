B4J=true
Group=Pages-Snapins
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
	Private pnlMain As B4XView
	
	
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
End Sub

'-------------------------------
#if b4j
public Sub resize_me (width As Int, height As Int)
	pnlMain.width = width
	pnlMain.height = height
	Sleep(0)
End Sub
#end if
Public Sub Set_focus()
	Menus.SetHeader("Conversions","main_menu_conversions.png")
	pnlMain.SetVisibleAnimated(500,True)
End Sub
Public Sub Lost_focus()
	pnlMain.SetVisibleAnimated(500,False)
End Sub


'=============================================================================================
'=============================================================================================
'=============================================================================================




