B4J=true
Group=Pages-Snapins
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.1 	Dec/26/2023

#End Region


Sub Class_Globals
	Private XUI As XUI
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private pnlMain As B4XView
	
	Private mTmrAlarmFire As Timer
	
	Private lblListHdr As B4XView
	Private lblTimersDesc1,lblTimersDesc2,lblTimersDesc3,lblTimersDesc4,lblTimersDesc5 As B4XView
	Private lblTimersTime1,lblTimersTime2,lblTimersTime3,lblTimersTime4,lblTimersTime5 As B4XView
	Private imgTimers5,imgTimers4,imgTimers3,imgTimers2,imgTimers1 As lmB4XImageViewX
	
	Private pnlBtnsTop As B4XView
	Private pnlLCD As B4XView
	Private lblHrs As Label
	Private lblMin As Label
	Private lblSec As Label
	Private lblDots1 ,lblDots2 As Label
	
	Private pnlBtnsBottom As B4XView
	Private pnlBtnsMenu As B4XView
	Private pnlSplitterMnu As B4XView
	Private pnlHrsMinSecsLbl As B4XView
	Private lblLabelSec,lblLabelMin,lblLabelHr As Label
	
	Private TimerFont As Typeface
	
	
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	p.LoadLayout("pageKitchenTimersBase")
	mTmrAlarmFire.Initialize("tmrAlarmFire",400)
	mTmrAlarmFire.Enabled = False
	
	BuildGUI
End Sub

Private Sub BuildGUI
	TimerFont = Typeface.LoadFromAssets("Digital.ttf")
	lblHrs.Typeface = TimerFont :lblMin.Typeface = TimerFont :lblSec.Typeface = TimerFont
	lblDots1.Typeface = TimerFont:lblDots2.Typeface = TimerFont
	
	guiHelpers.SetTextColor(Array As B4XView(lblLabelSec,lblLabelMin,lblLabelHr,lblDots1,lblDots2,lblSec,lblMin,lblMin),clrTheme.txtNormal)
	guiHelpers.SetTextColor(Array As B4XView(lblTimersDesc1,lblTimersDesc2,lblTimersDesc3,lblTimersDesc4,lblTimersDesc5),clrTheme.txtNormal)
	guiHelpers.SetTextColor(Array As B4XView(lblTimersTime1,lblTimersTime2,lblTimersTime3,lblTimersTime4,lblTimersTime5),clrTheme.txtNormal)
End Sub
'-------------------------------

Public Sub Set_focus()
	Menus.SetHeader("Timers","main_menu_timers.png")
	pnlMain.SetVisibleAnimated(500,True)
End Sub
Private Sub Page_Setup
	guiHelpers.Show_toast2("TODO",3500)
End Sub
Public Sub Lost_focus()
	pnlMain.SetVisibleAnimated(500,False)
End Sub


'=============================================================================================
'=============================================================================================
'=============================================================================================




