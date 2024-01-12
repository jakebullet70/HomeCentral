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

'
Sub Class_Globals
	Private XUI As XUI
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private pnlMain As B4XView
	
	Public svrKTimers As KitchenTmrs '--- RENAME after refactor
	Private msAlarmFireRollover As String
	Private mTmrAlarmFire As Timer
	
	Private lblListHdr As B4XView
	Private lblTimersDesc1,lblTimersDesc2,lblTimersDesc3,lblTimersDesc4,lblTimersDesc5 As B4XView
	Private lblTimersTime1,lblTimersTime2,lblTimersTime3,lblTimersTime4,lblTimersTime5 As B4XView
	Private imgTimers5,imgTimers4,imgTimers3,imgTimers2,imgTimers1 As lmB4XImageViewX
	
	Private pnlBtnsBottom,pnlBtnsTop As B4XView
	Private pnlLCD As B4XView
	Private lblSec,lblMin,lblHrs As Label
	Private lblDots1 ,lblDots2 As Label
	Private pnlBtnsMenu As B4XView
	Private pnlSplitterMnu As B4XView
	Private pnlHrsMinSecsLbl As B4XView
	Private lblLabelSec,lblLabelMin,lblLabelHr As Label
	
	Private TimerFont As Typeface
	Private pnlSplitter,pnlSplitter1,pnlSplitter2,pnlSplitter3,pnlSplitter4 As B4XView
	
	Private btnDecrS5,btnDecrS1,btnDecrM5,btnDecrM1 ,btnDecrH5,btnDecrH1 As Button
	Private BtnIncS5,BtnIncS1,btnIncrH5,btnIncrH1,BtnIncM5,BtnIncM1 As Button
	Private btnReset,btnPause As Button
	Private pnlSplitterTopBtn2,pnlSplitterBottomBtn1,pnlSplitterTopBtn1,pnlSplitterBottomBtn2 As B4XView
	
End Sub

Public Sub Initialize(p As B4XView) 
	
	pnlMain = p
	p.LoadLayout("pageKitchenTimersBase")
	svrKTimers.Initialize
	mTmrAlarmFire.Initialize("tmrAlarmFire",400)
	mTmrAlarmFire.Enabled = False
	
	BuildGUI
End Sub

Private Sub BuildGUI
	
	TimerFont = Typeface.LoadFromAssets("Digital.ttf")
	lblHrs.Typeface = TimerFont :lblMin.Typeface = TimerFont :lblSec.Typeface = TimerFont
	lblDots1.Typeface = TimerFont:lblDots2.Typeface = TimerFont
	
	guiHelpers.ResizeText("00",lblHrs) : 	lblHrs.TextSize = lblHrs.TextSize - 6
	lblMin.TextSize = lblHrs.TextSize : lblSec.TextSize = lblHrs.TextSize
	
	guiHelpers.SetTextColor(Array As B4XView(lblListHdr,lblHrs,lblMin,lblSec),clrTheme.txtAccent)
	
	guiHelpers.SetPanelsDividers(Array As B4XView(pnlSplitterMnu,pnlSplitter,pnlSplitter1,pnlSplitter2,pnlSplitter3,pnlSplitter4, _
										pnlSplitterTopBtn2,pnlSplitterBottomBtn1,pnlSplitterTopBtn1,pnlSplitterBottomBtn2) ,clrTheme.DividerColor)
	
'	pnlSplitterTopBtn2.BringToFront
'	pnlSplitterTopBtn1.BringToFront
'	pnlSplitterBottomBtn1.BringToFront
'	pnlSplitterBottomBtn2.BringToFront
	
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
			Dim I As Int,  per As Period
			'''''CallSubDelayed(svrMain,"ResetScrn_SleepCounter")
			If txt.Contains("5") Then
				'--- 5 has been pressed
				I = kt.xStr2Int(lblHrs.Text) + 5
				If I > 23 Then
					Return
				Else
					lblHrs.Text = kt.xIntsStr(I)
					If svrKTimers.timers(svrKTimers.CurrentTimer).active Then
						per.Hours = 5
						AdjustTime(per)
					End If
				End If
			Else '--- 1 has been pressed
				I = kt.xStr2Int(lblHrs.Text) + 1
				If I > 23 Then 
					Return
				Else
					lblHrs.Text = kt.xIntsStr(I)
					If svrKTimers.timers(svrKTimers.CurrentTimer).active Then
						per.Hours = 1
						AdjustTime(per)
					End If
				End If
			End If
	End Select
End Sub

Public Sub ClearLarge_TimerTxt
	'lblHrs.TextColor =  g.GetColorTheme(g.ehome_clrTheme,"themeColorText")
	lblHrs.Text = "00": lblMin.Text = "00" : lblSec.Text = "00"
	
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

Public Sub UpdateRunning_Tmr(S As String)
	If S.Length = 7 Then S = "0" & S
	Dim tm() As String = Regex.Split(":",S)
	
	lblSec.Text = tm(2)
	lblMin.Text = tm(1)
	If kt.xStr2Int( tm(0) ) = 0  Then
		lblHrs.TextColor = clrTheme.txtNormal
	Else
		lblHrs.TextColor = clrTheme.txtNormal
	End If
	lblHrs.Text = kt.xStr2Int(tm(0))
	
End Sub

Public Sub Update_ListOfTimersIMG(xx As Int, sPic As String)

	Select Case xx
		Case 1 : imgTimers1.Bitmap = LoadBitmap(File.DirAssets,sPic)
		Case 2 : imgTimers2.Bitmap = LoadBitmap(File.DirAssets,sPic)
		Case 3 : imgTimers3.Bitmap = LoadBitmap(File.DirAssets,sPic)
		Case 4 : imgTimers4.Bitmap = LoadBitmap(File.DirAssets,sPic)
		Case 5 : imgTimers5.Bitmap = LoadBitmap(File.DirAssets,sPic)
	End Select
	
	Select Case sPic
		Case gblConst.TIMERS_IMG_STOP,gblConst.TIMERS_IMG_PAUSE
			btnPause.Text = "Start"
			'mnuBtnsMenu.SetText(btnPlayPause,"Start",-1,-1)
			'BuildSideMenu(False)
		Case gblConst.TIMERS_IMG_GO
			btnPause.Text = "Pause"
			'mnuBtnsMenu.SetText(btnPlayPause,"Pause",-1,-1)
			'BuildSideMenu(True)
	End Select
	
End Sub

Private Sub AdjustTime(per As Period)

	svrKTimers.timers(svrKTimers.CurrentTimer).endTime = _
				      DateUtils.AddPeriod(svrKTimers.timers(svrKTimers.CurrentTimer).endTime,per)
End Sub

Public Sub AlarmStart(xx As Int)
	
	svrKTimers.timers(xx).Firing = True
	svrKTimers.moAlarm(xx).Initialize(svrKTimers.timers)
	svrKTimers.moAlarm(xx).AlarmStart(xx)
	
	msAlarmFireRollover = gblConst.TIMERS_IMG_STOP
	mTmrAlarmFire.Enabled = True
	
	'DoEvents
	CallSubDelayed2(mpage,"segTabMenu_TabChanged",-3)
	'CallSubDelayed2(Main,"Change_Snapin",c.SNAPIN_MENU_TIMERS_NDX)
	
	UpdateListOfTimers(xx)
	lblHrs.Text = "00" : lblSec.Text = "00" : 	lblMin.Text = "00"
	
End Sub

Public Sub UpdateListOfTimers(x As Int)
	Dim s As String = BuildTimerStr4List( _
			kt.PadZero(svrKTimers.timers(x).nHr),kt.PadZero(svrKTimers.timers(x).nMin),kt.PadZero(svrKTimers.timers(x).nSec))
		
	Select Case x
		Case 1 : lblTimersTime1.Text = s
		Case 2 : lblTimersTime2.Text = s
		Case 3 : lblTimersTime3.Text = s
		Case 4 : lblTimersTime4.Text = s
		Case 5 : lblTimersTime5.Text = s
	End Select
	
End Sub
Private Sub BuildTimerStr4List(hr As String,nnMin As String,sec As String) As String
	Return (hr & ":" & nnMin & ":" & sec)
End Sub
