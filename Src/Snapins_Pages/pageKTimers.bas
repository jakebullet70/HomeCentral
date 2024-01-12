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
	
	Private btnDecrS5,btnDecrS1,btnDecrM5,btnDecrM1 ,btnDecrH5,btnDecrH1 As Button
	Private BtnIncS5,BtnIncS1,btnIncrH5,btnIncrH1,BtnIncM5,BtnIncM1 As Button
	Private btnReset,btnPause As Button
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
	
	guiHelpers.ResizeText("00",lblHrs) : 	lblHrs.TextSize = lblHrs.TextSize - 4
	lblMin.TextSize = lblHrs.TextSize : lblSec.TextSize = lblHrs.TextSize
	
	guiHelpers.SetTextColor(Array As B4XView(lblListHdr,lblHrs,lblMin,lblSec),clrTheme.txtAccent)
	guiHelpers.SetPanelsDividers(Array As B4XView(pnlSplitter,pnlSplitter1,pnlSplitter2,pnlSplitter3,pnlSplitter4) ,clrTheme.DividerColor)
	
	guiHelpers.SetTextColor(Array As B4XView(lblLabelSec,lblLabelMin,lblLabelHr,lblDots1,lblDots2, _
																lblTimersDesc1,lblTimersDesc2,lblTimersDesc3,lblTimersDesc4,lblTimersDesc5, _
																lblTimersTime1,lblTimersTime2,lblTimersTime3,lblTimersTime4,lblTimersTime5),clrTheme.txtNormal)
	
	guiHelpers.ResizeText(lblLabelHr.Text,lblLabelHr) : lblLabelSec.TextSize = lblLabelHr.TextSize : lblLabelMin.TextSize = lblLabelHr.TextSize
	
	guiHelpers.SkinButtonNoBorder(Array As Button(btnDecrS5,btnDecrS1,btnDecrM5,btnDecrM1 ,btnDecrH5,btnDecrH1, _
																BtnIncS5,BtnIncS1,btnIncrH5,btnIncrH1,BtnIncM5,BtnIncM1,btnReset,btnPause))
	
	guiHelpers.ResizeText("+5",BtnIncS5)
	guiHelpers.SetTextSize(Array As B4XView(BtnIncS5,btnDecrS5,btnDecrS1,btnDecrM1,btnDecrM5,btnDecrH1,btnDecrH5, _
																BtnIncS1,BtnIncM1,BtnIncM5,btnIncrH1,btnIncrH5),BtnIncS5.TextSize-4)
	
	guiHelpers.ResizeText("Pause",btnPause)
	guiHelpers.ResizeText("Reset",btnReset)
	kt.SetImages(Array As lmB4XImageViewX(imgTimers1,imgTimers2,imgTimers3,imgTimers4,imgTimers5),gblConst.TIMERS_IMG_STOP)
	
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



Private Sub btnResetPause_Click
	Dim o As B4XView = Sender
	If o.Text = "Pause" Then
	Else
	End If
	
End Sub

Private Sub btnIncr_Click
	Dim o As B4XView = Sender
	Dim txt As String = o.text
	Select Case o.tag
		Case "s"
		Case "m"
		Case "h"
	End Select
End Sub

Private Sub btnDecr_Click
	Dim o As B4XView = Sender
	Dim txt As String = o.text
	Select Case o.tag
		Case "s"
		Case "m"
		Case "h"
	End Select
End Sub