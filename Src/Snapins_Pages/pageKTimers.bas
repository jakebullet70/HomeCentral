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
	
	Public clsKTimers As KitchenTmrs '--- RENAME after refactor
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
	clsKTimers.Initialize
	mTmrAlarmFire.Initialize("tmrAlarmFire",400)
	mTmrAlarmFire.Enabled = False
	
	BuildGUI
	
	For x = 1 To 5 '--- init the timers
		clsKTimers.timers(x).Initialize
		kt.Clear_Timer(x)
		TimerUnSelect(x)
	Next
	TimerSelect(1)
	
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
	
	
	guiHelpers.SetTextColor(Array As B4XView(lblLabelSec,lblLabelMin,lblLabelHr,lblDots1,lblDots2, _
										lblTimersDesc1,lblTimersDesc2,lblTimersDesc3,lblTimersDesc4,lblTimersDesc5, _
										lblTimersTime1,lblTimersTime2,lblTimersTime3,lblTimersTime4,lblTimersTime5),clrTheme.txtNormal)
										
	guiHelpers.ResizeText("Open",lblTimersDesc3)
	guiHelpers.SetTextSize(Array As B4XView(lblTimersDesc1,lblTimersDesc2,lblTimersDesc3,lblTimersDesc4,lblTimersDesc5, _
										lblTimersTime1,lblTimersTime2,lblTimersTime3,lblTimersTime4,lblTimersTime5),lblTimersDesc3.TextSize)
	
	guiHelpers.ResizeText(lblLabelHr.Text,lblLabelHr) : lblLabelSec.TextSize = lblLabelHr.TextSize : lblLabelMin.TextSize = lblLabelHr.TextSize
	
	guiHelpers.SkinButtonNoBorder(Array As Button(btnDecrS5,btnDecrS1,btnDecrM5,btnDecrM1 ,btnDecrH5,btnDecrH1, _
										BtnIncS5,BtnIncS1,btnIncrH5,btnIncrH1,BtnIncM5,BtnIncM1,btnReset,btnPause))
	
	guiHelpers.ResizeText("+5",BtnIncS5)
	guiHelpers.SetTextSize(Array As B4XView(BtnIncS5,btnDecrS5,btnDecrS1,btnDecrM1,btnDecrM5,btnDecrH1,btnDecrH5, _
										BtnIncS1,BtnIncM1,BtnIncM5,btnIncrH1,btnIncrH5),BtnIncS5.TextSize-4)
	
	guiHelpers.ResizeText("Pause",btnPause)
	btnReset.Text = "Reset" : btnReset.TextSize = btnPause.TextSize
	kt.SetImages(Array As lmB4XImageViewX(imgTimers1,imgTimers2,imgTimers3,imgTimers4,imgTimers5),gblConst.TIMERS_IMG_STOP)
	
	clsKTimers.CurrentTimer = 0
	TimerSelect(0)
End Sub
'-------------------------------

Public Sub Set_focus()
	mpage.tmrTimerCallSub.CallSubDelayedPlus(Me,"Build_Side_Menu",250)
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

Private Sub IsTimerBlank() As Boolean
	If (kt.xStr2Int(lblHrs.Text) = 0 And lblMin.Text = "00" And lblSec.Text = "00") Then
		Return True
	Else
		Return False
	End If
End Sub

Private Sub GetEndTime() As Long

	Dim nEndTime As Long,  p1,p2,p3 As Period
	p1.Hours   = lblHrs.Text : nEndTime = DateUtils.AddPeriod(DateTime.Now,p1)
	p2.Minutes = lblMin.Text : nEndTime = DateUtils.AddPeriod(nEndTime,p2)
	p3.Seconds = lblSec.Text : nEndTime = DateUtils.AddPeriod(nEndTime,p3)
	Return nEndTime
	
End Sub

Private Sub UpdateListOfTimersDesc(x As Int, txt As String)
	Select Case x
		Case 1 : lblTimersDesc1.Text = txt
		Case 2 : lblTimersDesc2.Text = txt
		Case 3 : lblTimersDesc3.Text = txt
		Case 4 : lblTimersDesc4.Text = txt
		Case 5 : lblTimersDesc5.Text = txt
	End Select
End Sub

Private Sub StartTimer(txt As String)
	
	'--- is timer blank?
	If IsTimerBlank Then Return
	
	If txt <> "" Then
		clsKTimers.timers(clsKTimers.CurrentTimer).txt = txt
	Else
		txt = clsKTimers.timers(clsKTimers.CurrentTimer).txt
	End If
	
	clsKTimers.timers(clsKTimers.CurrentTimer).active = True
	clsKTimers.timers(clsKTimers.CurrentTimer).nHr = lblHrs.Text
	clsKTimers.timers(clsKTimers.CurrentTimer).nSec = lblSec.Text
	clsKTimers.timers(clsKTimers.CurrentTimer).nMin = lblMin.Text
	clsKTimers.timers(clsKTimers.CurrentTimer).endTime = GetEndTime
	clsKTimers.timers(clsKTimers.CurrentTimer).Firing = False
	clsKTimers.timers(clsKTimers.CurrentTimer).paused = False
	
	UpdateListOfTimersDesc(clsKTimers.CurrentTimer,txt)
	UpdateListOfTimers(clsKTimers.CurrentTimer)
	Update_ListOfTimersIMG(clsKTimers.CurrentTimer,gblConst.TIMERS_IMG_GO)
	'tmrTimers_Tick
	CallSub(clsKTimers,"tmr_TimersCheck")

	btnPause.Text = "Pause"
	'BuildSideMenu(True)
	
End Sub


Private Sub btnResetPause_Click
	Dim o As B4XView = Sender
	
	Select Case  o.Text
		Case "Reset"
			If clsKTimers.moAlarm(clsKTimers.CurrentTimer).mbActive  Then
				'--- stop the BEEPING!!!
				TimerSelect(clsKTimers.CurrentTimer)
			End If
			kt.Clear_Timer(clsKTimers.CurrentTimer)
			'CallSubDelayed3(Me,"clear_timer",clsKTimers.CurrentTimer)
			'CallSub2(clsKTimers,"ClearTimer",clsKTimers.CurrentTimer)
			ClearLarge_TimerTxt
			Update_ListOfTimersIMG(clsKTimers.CurrentTimer,gblConst.TIMERS_IMG_STOP)
			UpdateListOfTimers(clsKTimers.CurrentTimer)
			
			UpdateListOfTimersDesc(clsKTimers.CurrentTimer,"Open")
			
		Case "Start"
			If clsKTimers.timers(clsKTimers.CurrentTimer).paused = False Then
				If IsTimerBlank Then
					guiHelpers.Show_toast("Cannot start timer. Timer is blank")
					Return
				End If
				StartTimer("Open")

			Else
				StartTimer("") '--- restarts the timer
			End If
		
		Case "Pause"
			clsKTimers.timers(clsKTimers.CurrentTimer).active = False
			clsKTimers.timers(clsKTimers.CurrentTimer).paused = True
			Update_ListOfTimersIMG(clsKTimers.CurrentTimer,gblConst.TIMERS_IMG_PAUSE)
			btnPause.Text = "Start"
			'BuildSideMenu(False)
		
'		Case "QStart"
'			Dim o1 As puKTimersPresets
'			o1.Initialize(act,Me,"QStart_Me")
		
	End Select
	
End Sub

Private Sub TimerUnSelect(n As Int)
	TimerSetColor(n,clrTheme.txtNormal)
End Sub

Private Sub TimerSetColor(n As Int,clr As Int)
	Select Case n
		Case 1 : lblTimersDesc1.TextColor=clr : lblTimersTime1.TextColor=clr
		Case 2 : lblTimersDesc2.TextColor=clr : lblTimersTime2.TextColor=clr
		Case 3 : lblTimersDesc3.TextColor=clr : lblTimersTime3.TextColor=clr
		Case 4 : lblTimersDesc4.TextColor=clr : lblTimersTime4.TextColor=clr
		Case 5 : lblTimersDesc5.TextColor=clr : lblTimersTime5.TextColor=clr
	End Select
End Sub

Private Sub TimerSelect(x As Int)
	#if debug
	Log("pageKTimers ------>  --------TimerSelect")
	#end if
	TimerSetColor(clsKTimers.CurrentTimer,clrTheme.txtNormal)
	TimerSetColor(x,clrTheme.txtAccent)
	
	clsKTimers.CurrentTimer = x
	lblHrs.Text = kt.PadZero(clsKTimers.timers(x).nHr)
	lblMin.Text = kt.PadZero(clsKTimers.timers(x).nMin)
	lblSec.Text = kt.PadZero(clsKTimers.timers(x).nSec)
	
	If clsKTimers.timers(x).active Then
	
		btnPause.Text = "Pause"
		'BuildSideMenu(True)
	Else
		lblHrs.TextColor =  clrTheme.txtAccent
		btnPause.Text ="Start"
		'BuildSideMenu(False)
	End If
	
	If clsKTimers.moAlarm(x).IsInitialized Then
		If clsKTimers.moAlarm(x).mbActive Then
			clsKTimers.timers(x).Firing = False
			clsKTimers.moAlarm(x).AlarmStop(x)
			'clsKTimers.ClearTimer(x)
			CallSubDelayed2(Me,"Clear_Timer",x)
			Update_ListOfTimersIMG(x,gblConst.TIMERS_IMG_STOP)
		End If
	End If
	 
	If kt.AnyTimersFiring() = False Then mTmrAlarmFire.Enabled = False
	CallSubDelayed(mpage,"ResetScrn_SleepCounter")
	
End Sub

#Region NUM_DIGIT_BTNS
Private Sub btnIncr_Click
	Dim o As B4XView = Sender
	Dim txt As String = o.text
	Dim I As Int,  per As Period
	CallSubDelayed(mpage,"ResetScrn_SleepCounter")
	Select Case o.tag
		Case "s"
			If txt.Contains("5") Then '--- 5 has been pressed
				I = kt.xStr2Int(lblSec.Text) + 5
				If I > 59 Then Return
				lblSec.Text = kt.xIntsStr(I)
				If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
					per.Seconds = 5 : AdjustTime(per)
				End If
			Else '--- 1 has been pressed
				I = kt.xStr2Int(lblSec.Text) + 1
				If I > 59 Then Return
				lblSec.Text = kt.xIntsStr(I)
				If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
					per.Seconds = 1 : AdjustTime(per)
				End If
			End If
			
		Case "m" '--- minutes
			If txt.Contains("5") Then '--- 5 has been pressed
				I = kt.xStr2Int(lblMin.Text) + 5
				If I > 59 Then Return
				lblMin.Text = kt.xIntsStr(I)
				If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
					per.Minutes = 5 : AdjustTime(per)
				End If
			Else '--- 1 has been pressed
				I = kt.xStr2Int(lblMin.Text) + 1
				If I > 59 Then Return
				lblMin.Text = kt.xIntsStr(I)
				If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
					per.Minutes = 1 : AdjustTime(per)
				End If
			End If
			
		Case "h" '--- hours
			If txt.Contains("5") Then '--- 5 has been pressed
				I = kt.xStr2Int(lblHrs.Text) + 5
				If I > 23 Then Return
				lblHrs.Text = kt.xIntsStr(I)
				If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
					per.Hours = 5 : AdjustTime(per)
				End If
			Else '--- 1 has been pressed
				I = kt.xStr2Int(lblHrs.Text) + 1
				If I > 23 Then Return
				lblHrs.Text = kt.xIntsStr(I)
				If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
					per.Hours = 1 : AdjustTime(per)
				End If
			End If
			
	End Select
End Sub

Private Sub btnDecr_Click
	Dim o As B4XView = Sender
	Dim txt As String = o.text
	Dim I As Int,  per As Period
	Select Case o.tag
		Case "s" '--- seconds
			If txt.Contains("5") Then '--- 5 has been pressed
				I = kt.xStr2Int(lblSec.Text) - 5
				If I <= 0 Then
					lblSec.Text = "00" : Return
				Else
					lblSec.Text = kt.xIntsStr(I)
					If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
						per.Seconds = -5 : 	AdjustTime(per)
					End If
				End If
			Else '--- 1 has been pressed
				I = kt.xStr2Int(lblSec.Text) - 1
				If I <= 0 Then
					lblSec.Text = "00" : Return
				Else
					lblSec.Text = kt.xIntsStr(I)
					If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
						per.Seconds = -1 : AdjustTime(per)
					End If
				End If
			End If
			
		Case "m" '--- minutes
			If txt.Contains("5") Then '--- 5 has been pressed
				i = kt.xStr2Int(lblMin.Text) - 5
				If i <= 0 Then
					lblMin.Text = "00"
					If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
						per.Minutes = kt.returnNegNum(5 - Abs(i)) : AdjustTime(per)
					End If
				Else
					lblMin.Text = kt.xIntsStr(i)
					If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
						per.Minutes = -5 : AdjustTime(per)
					End If
				End If
			Else '--- 1 has been pressed
				i = kt.xStr2Int(lblMin.Text) - 1 '--- 1 has been pressed
				If i < 0 Then 
					lblMin.Text = "00"
				Else
					lblMin.Text = kt.xIntsStr(i)
					If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
						per.Minutes = -1 : AdjustTime(per)
					End If
				End If
			End If
			
		Case "h" '--- Hours
			If txt.Contains("5") Then '--- 5 has been pressed
				I = kt.xStr2Int(lblHrs.Text) - 5
				If I <= 0 Then
					lblHrs.Text = "00"
					If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
						per.Hours = kt.returnNegNum(5 - Abs(I)) : AdjustTime(per)
					End If
				Else '--- 1 has been pressed
					lblHrs.Text = kt.xIntsStr(I)
					If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
						per.Hours = -5 : AdjustTime(per)
					End If
				End If
			Else
				I = kt.xStr2Int(lblHrs.Text) - 1 '--- 1 has been pressed
				If I < 0 Then 
					lblHrs.Text = "00" 
				Else
					lblHrs.Text = kt.xIntsStr(I)
					If clsKTimers.timers(clsKTimers.CurrentTimer).active Then
						per.Hours = -1 : AdjustTime(per)
					End If
				End If
			End If
	End Select
	
End Sub
#end region

Public Sub ClearLarge_TimerTxt
	lblHrs.TextColor =  clrTheme.txtAccent
	lblHrs.Text = "00": lblMin.Text = "00" : lblSec.Text = "00"
End Sub

Public Sub UpdateRunning_Tmr(S As String)
	If S.Length = 7 Then S = "0" & S
	Dim tm() As String = Regex.Split(":",S)
	
	lblSec.Text = tm(2)
	lblMin.Text = tm(1)
	If kt.xStr2Int( tm(0) ) = 0  Then
		lblHrs.TextColor = clrTheme.txtAccent
	Else
		lblHrs.TextColor = clrTheme.txtAccent
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
			'BuildSideMenu(False)
		Case gblConst.TIMERS_IMG_GO
			btnPause.Text = "Pause"
			'BuildSideMenu(True)
	End Select
	
End Sub

Private Sub AdjustTime(per As Period)

	clsKTimers.timers(clsKTimers.CurrentTimer).endTime = _
				      DateUtils.AddPeriod(clsKTimers.timers(clsKTimers.CurrentTimer).endTime,per)
End Sub

Public Sub AlarmStart(xx As Int)
	Log("-----------------------------PageKTimers ---> AlarmStart-" & xx)
	TimerSelect(xx)
	
	clsKTimers.timers(xx).Firing = True
	clsKTimers.moAlarm(xx).Initialize(clsKTimers.timers)
	clsKTimers.moAlarm(xx).AlarmStart(xx)
	
	msAlarmFireRollover = gblConst.TIMERS_IMG_STOP
	mTmrAlarmFire.Enabled = True
	
	'DoEvents
	If mpage.oPageCurrent <> mpage.oPageTimers Then 
		CallSubDelayed2(mpage,"Change_Pages2","tm") '--- switch pages
	End If
	
	UpdateListOfTimers(xx)
	CallSubDelayed(Me,"ClearLarge_TimerTxt")
	
	
End Sub


Public Sub UpdateListOfTimers(x As Int)
	Dim s As String = BuildTimerStr4List( _
			kt.PadZero(clsKTimers.timers(x).nHr),kt.PadZero(clsKTimers.timers(x).nMin),kt.PadZero(clsKTimers.timers(x).nSec))
		
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

Private Sub pnlTimers_Click
	'Dim P As Panel = Sender
	TimerSelect(Sender.As(Panel).Tag.As(Int))
End Sub


Private Sub SideMenu_ItemClick (Index As Int, Value As Object)
	'guiHelpers.Show_toast("TODO")
	Select Case Value
		Case "pr" : Show_Presets
	End Select
	mpage.pnlSideMenu.SetVisibleAnimated(380, False) '---  close side menu
End Sub

Private Sub Build_Side_Menu
	Menus.BuildSideMenu(Array As String("Presets"),Array As String("pr"))
End Sub


Private Sub Show_Presets
	
	'mpage.pnlSideMenu.SetVisibleAnimated(380, False)
	'CallSub(Main,"Set_ScreenTmr") '--- reset the power / screen on-off

	Dim gui As guiMsgs : gui.Initialize
	Dim o1 As dlgListbox
	
	o1.Initialize("Timer Presets",Me,"Presets_Event",mpage.Dialog)
	o1.IsMenu = True
	o1.Show(440dip,430dip,gui.BuildPresets())
	'mpage.pnlSideMenuTouchOverlay_show(False)
	
End Sub


Private Sub Presets_Event(id As String,o As Object)
	If strHelpers.IsNullOrEmpty(id) Then Return
	
	Dim cur As Cursor = Main.kvs.oSql.ExecQuery("SELECT * FROM timers WHERE id =" & id)
	cur.Position = 0
	
	clsKTimers.timers(clsKTimers.CurrentTimer).nHr = Regex.Split(":", cur.GetString("time"))(0)
	clsKTimers.timers(clsKTimers.CurrentTimer).nMin = Regex.Split(":", cur.GetString("time"))(1)
	clsKTimers.timers(clsKTimers.CurrentTimer).nSec = Regex.Split(":", cur.GetString("time"))(2)
		
	lblHrs.Text = kt.PadZero(clsKTimers.timers(clsKTimers.CurrentTimer).nHr)
	lblMin.Text = kt.PadZero(clsKTimers.timers(clsKTimers.CurrentTimer).nMin)
	lblSec.Text = kt.PadZero(clsKTimers.timers(clsKTimers.CurrentTimer).nSec)

	StartTimer(cur.GetString("description"))
'	btnResetPause_Click
End Sub

Sub tmrAlarmFire_Tick
	
	'--- blinks the little image from red to green
	'--- while the alarm is firing
	Dim sPic As String
	If msAlarmFireRollover = gblConst.TIMERS_IMG_GO Then
		sPic = gblConst.TIMERS_IMG_STOP
	Else
		sPic = gblConst.TIMERS_IMG_GO
	End If
	
	Dim xx As Int
	For xx = 1 To 5
		If clsKTimers.timers(xx).Firing Then
			Select Case xx
				Case 1 : imgTimers1.Bitmap = LoadBitmap(File.DirAssets,sPic)
				Case 2 : imgTimers2.Bitmap = LoadBitmap(File.DirAssets,sPic)
				Case 3 : imgTimers3.Bitmap = LoadBitmap(File.DirAssets,sPic)
				Case 4 : imgTimers4.Bitmap = LoadBitmap(File.DirAssets,sPic)
				Case 5 : imgTimers5.Bitmap = LoadBitmap(File.DirAssets,sPic)
			End Select
		End If
	Next
	
	msAlarmFireRollover = sPic
End Sub	



