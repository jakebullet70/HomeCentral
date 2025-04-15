B4J=true
Group=Pages-Snapins
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Apr15/2025
#End Region


Sub Class_Globals
	Private XUI As XUI
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private pnlMain As B4XView
	
	
	
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pageWebBase")
	
	'guiHelpers.SkinButton(Array As Button(btnStart,btnFullScrn,btnNext,btnPrev))
	
End Sub


'-------------------------------
Public Sub Set_focus()
	'Menus.SetHeader("Weather","main_menu_weather.png")
	mpage.tmrTimerCallSub.CallSubDelayedPlus(Me,"Build_Side_Menu",250)
	Menus.SetHeader("Web","main_menu_web.png")
	pnlMain.SetVisibleAnimated(500,True)
End Sub
Public Sub Lost_focus()
	'tmrPicShow.Enabled = False
	pnlMain.SetVisibleAnimated(500,False)
End Sub

'=============================================================================================
'=============================================================================================
'=============================================================================================

Private Sub Build_Side_Menu
	Menus.BuildSideMenu(Array As String(""),Array As String(""))
End Sub
