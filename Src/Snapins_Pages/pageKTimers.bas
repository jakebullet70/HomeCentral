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
	Private pnlSplitter,pnlSplitter1,pnlSplitter2,pnlSplitter3,pnlSplitter4 As B4XView
	
	Private pnlSplitter2 As B4XView
	Private pnlSplitter3 As B4XView
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
	
	guiHelpers.ResizeText("00",lblHrs) : guiHelpers.ResizeText("00",lblMin) : guiHelpers.ResizeText("00",lblSec)
	
	guiHelpers.SetTextColor(Array As B4XView(lblListHdr,lblHrs,lblMin,lblSec),clrTheme.txtAccent)
	guiHelpers.SetPanelsDividers(Array As B4XView(pnlSplitter,pnlSplitter1,pnlSplitter2,pnlSplitter3,pnlSplitter4) ,clrTheme.DividerColor)
	
	guiHelpers.SetTextColor(Array As B4XView(lblLabelSec,lblLabelMin,lblLabelHr,lblDots1,lblDots2),clrTheme.txtNormal)
	guiHelpers.SetTextColor(Array As B4XView(lblTimersDesc1,lblTimersDesc2,lblTimersDesc3,lblTimersDesc4,lblTimersDesc5),clrTheme.txtNormal)
	guiHelpers.SetTextColor(Array As B4XView(lblTimersTime1,lblTimersTime2,lblTimersTime3,lblTimersTime4,lblTimersTime5),clrTheme.txtNormal)
	
	guiHelpers.ResizeText(lblLabelHr.Text,lblLabelHr)
	guiHelpers.ResizeText(lblLabelSec.Text,lblLabelSec)
	guiHelpers.ResizeText(lblLabelMin.Text,lblLabelMin)
	
	imgTimers1.Bitmap = XUI.LoadBitmap(File.DirAssets, gblConst.TIMERS_IMG_STOP)
	imgTimers2.Bitmap = XUI.LoadBitmap(File.DirAssets, gblConst.TIMERS_IMG_STOP)
	imgTimers3.Bitmap = XUI.LoadBitmap(File.DirAssets, gblConst.TIMERS_IMG_STOP)
	imgTimers4.Bitmap = XUI.LoadBitmap(File.DirAssets, gblConst.TIMERS_IMG_STOP)
	imgTimers5.Bitmap = XUI.LoadBitmap(File.DirAssets, gblConst.TIMERS_IMG_STOP)
	
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




