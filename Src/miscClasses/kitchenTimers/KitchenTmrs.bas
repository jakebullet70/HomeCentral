B4J=true
Group=MiscClasses\KitchenTimers
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.1 	Jan/12/2024
' V. 1.0 	Sometime in 2015 - as a b4a service - now just a class
#End Region


Sub Class_Globals
	
	Public phw As PhoneWakeState
	Public tmrTimers As Timer
	
	Public timers(6) As typTimers
	Public CurrentTimer As Int = 1
	Public moAlarm(6) As clsKAlarms
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore

End Sub

Public Sub Initialize()
	'g.LogWrite("svrKTimers service start... ",g.ID_LOG_MSG)
	'---
	
	tmrTimers.Initialize("tmrTimers",1000)
	tmrTimers.Enabled = False
	
	'Dim n As Notification
	'n.Initialize
	'n.Icon = Null
	'n.Sound = False
	'n.SetInfo("Home Central is running", "", Main)
	'Service.StartForeground(9, n)
	
''	Dim p As Period : p.Initialize : p.Seconds = 1
''	Dim oneSecFromNow As Long = DateUtils.AddPeriod(DateTime.Now,p)
''	StartServiceAt("", oneSecFromNow, True)

End Sub


Private Sub tmrTimers_Tick
	tmrTimers.Enabled = False
	tmrTimers.Interval = 1000
	tmrTimers.Enabled = True
	Dim p As Period : p.Initialize : p.Seconds = 1
	'Dim oneSecFromNow As Long = DateUtils.AddPeriod(DateTime.Now,p)
	tmr_TimersCheck
	'StartServiceAt("", oneSecFromNow, True)
	
End Sub



Public Sub tmr_TimersCheck
	
	Dim xx As Int
	Dim bIsActive As Boolean = False
	tmrTimers.Enabled = False
	
	For xx = 1 To 5
		If timers(xx).active = True Then
			
			wait for (ProcessTimerCheck4Expire(xx)) Complete (i As Boolean)
			If i Then
				timers(xx).active = False
				bIsActive = IIf(bIsActive,True,False)
				'If IsPaused(Main) Then StartActivity(Main)
				CallSubDelayed2(B4XPages.MainPage,"Alarm_Start",xx)
			Else
				bIsActive = True
			End If
			
		End If
	Next

	'--- if nothing is active so die earth timer!!!
	tmrTimers.Enabled = bIsActive
	
End Sub


Private Sub ProcessTimerCheck4Expire(x As Int) As ResumableSub
	Dim ret As Boolean = False
	Dim nNow As Long = DateTime.Now
	Dim P1 As Period = DateUtils.PeriodBetween(nNow,timers(x).endTime)
	
	Dim scrnOn As Boolean = Not (gblConst.IS0SCREEN0OFF)
	
	If P1.Hours <= 0 And P1.Minutes <= 0 And P1.Seconds <= 0 Then
		'--- timer expired
		
		'g.debugLog("KTimer fire: WakeupFromSleep?????")
		'phw.ReleaseKeepAlive
		'phw.KeepAlive(True)
		scrnOn = True
		
		'If IsPaused(Main) Then StartActivity(Main)
		Sleep(0)
		
		If x = CurrentTimer Then
			If scrnOn Then
				If Not (IsPaused(Main)) Then
					CallSub(mpage.oPageTimers ,"ClearLarge_TimerTxt")
				End If
			End If
			'ClearLargeTimerTxt
		End If
		timers(x).nHr = 0 : timers(x).nSec = 0 : timers(x).nMin = 0
		If scrnOn Then
			CallSubDelayed3(mpage.oPageTimers,"Update_ListOfTimersIMG",x,gblConst.TIMERS_IMG_STOP)
		End If
		'UpdateListOfTimersIMG(x,c.TIMERS_IMG_STOP)
		
		ret = True
	Else
		'--- timer is still running
		If x = CurrentTimer Then
			Dim s1 As String = kt.PadZero(P1.Hours) & ":" & kt.PadZero(P1.Minutes) & ":" & kt.PadZero(P1.Seconds)
			If scrnOn Then
				If Not (IsPaused(Main)) Then
					CallSubDelayed2(mpage.oPageTimers,"UpdateRunning_Tmr",s1)
				End If
			End If
			'oTMR.lblHrs.Text = g.PadZero(P1.Hours)
			'oTMR.lblMin.Text = g.PadZero(P1.Minutes)
			'oTMR.lblSec.Text = g.PadZero(P1.Seconds)
		End If
		timers(x).nHr = P1.Hours : timers(x).nSec = P1.Seconds : timers(x).nMin = P1.Minutes
	End If
	
	If scrnOn Then
		If Not (IsPaused(Main)) Then
			CallSubDelayed2(mpage.oPageTimers,"UpdateListOfTimers",x)
		End If
	End If
	
	'CallSub2(Main,"UpdateListOfTimers",x)
	Return ret
	
End Sub



''--- called from puSetVolume
'Public Sub FireKAlarmTEST()
''	Log("FireKAlarm **********************")
''	MP_KTimers.Initialize2("FireKAlarm")
''	MP_KTimers.Load(File.DirAssets,c.ALARM_SOUND_FILE)
''	MP_KTimers.Looping = False
''	MP_KTimers.Play
'End Sub
'
'Private Sub FireKAlarm_Complete
'	'Log("FireKAlarm_complete **********************")
'	'MP_KTimers.Release
'End Sub
