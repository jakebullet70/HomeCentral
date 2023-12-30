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
	Private mPnlMain As B4XView
	
	
End Sub

Public Sub Initialize(p As B4XView) 
	mPnlMain = p
End Sub

'-------------------------------
Public Sub Set_focus()
	Menus.SetHeader("Calculator","main_menu_calc.png")
	mPnlMain.SetVisibleAnimated(500,True)
End Sub
Public Sub Lost_focus()
	mPnlMain.SetVisibleAnimated(500,False)
End Sub


'=============================================================================================
'=============================================================================================
'=============================================================================================




