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
	
	Private pnlBase As B4XView
	Private pnlWeather As B4XView
	Private pnlClock As B4XView
	Private pnlCal As B4XView
	Private lblClock As B4XView
	
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pageHomeBase")
	mpage.oClock.oEventsClock.Subscribe(Me,"clock_event") '--- fired whenever clock changes
	
	pnlWeather.SetColorAndBorder(XUI.Color_Transparent,0,XUI.Color_Transparent,0)
	pnlClock.SetColorAndBorder(XUI.Color_Transparent,0,XUI.Color_Transparent,0)
	pnlCal.SetColorAndBorder(XUI.Color_Transparent,0,XUI.Color_Transparent,0)
	
End Sub

'-------------------------------
Public Sub Set_focus()
	Menus.SetHeader("Home","main_menu_home.png")
	pnlMain.SetVisibleAnimated(500,True)
	mpage.oClock.Update_Scrn
End Sub

Public Sub Lost_focus()
	pnlMain.SetVisibleAnimated(500,False)
End Sub

Public Sub clock_event(s As String)
	If pnlMain.Visible = False Then Return
	guiHelpers.ResizeText(s,lblClock)
End Sub

'=============================================================================================
'=============================================================================================
'=============================================================================================




