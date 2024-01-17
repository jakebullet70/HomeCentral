B4A=true
Group=MiscClasses\KitchenTimers
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.1 	Jan/12/2024
' V. 1.0 Sometime in 2015
#End Region
Sub Class_Globals

	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private mTimers() As typTimers
	Private mTmrAlarmFire As Timer
	Private bpr As Beeper
	Private mMediaPlayer(6) As MediaPlayer
	Private ph As Phone
	
	Public mbActive As Boolean
	
	Private mpOldVol As Int
	

End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(oTimers() As typTimers)
	mTimers = oTimers
End Sub


Public Sub AlarmStop(alarmNum As Int)
	
	mbActive = False
	If mTimers(alarmNum).alarmType.beepMe Then 
		mTmrAlarmFire.Enabled = False
		bpr.Release
	End If
	
	If mTimers(alarmNum).alarmType.playFile Then
		AlarmSoundStop(alarmNum)
	End If

	'CallSub(Main,"AlarmFired_PlayRadio")
	
End Sub


Public Sub AlarmStart(alarmNum As Int)

	mbActive = True
	CallSub(Main,"Alarm_Fired")
	
	'--- sed out the UDP notice
	'Dim sParams As String = "ALARMFIRED"
'	CallSub3(Main,"UDP_SendMsg",sParams,c.UDP_2ALL)
	
	If mTimers(alarmNum).alarmType.sendTxtMSG Then
		If mpage.DebugLog Then Log("AlarmFired-sendTxtMSG")
	End If
	'---
	If mTimers(alarmNum).alarmType.beepMe Then 
		If mpage.DebugLog Then Log("AlarmFired-beepMe")
		InitBeeper
		mTmrAlarmFire.Initialize("tmrBeep",700)
		mTmrAlarmFire.Enabled = True
	End If
	'---
	If mTimers(alarmNum).alarmType.playFile Then
		If mpage.DebugLog Then Log("AlarmFired-playFile")
		mMediaPlayer(alarmNum).Initialize2("mp")
		AlarmSoundPlay(Main.kvs.Get(gblConst.INI_SOUND_ALARM_FILE),alarmNum)
	End If
	'---
	If mTimers(alarmNum).alarmType.sendGrowl Then
		If mpage.DebugLog Then Log("AlarmFired-sendGrowl")
	End If
	'---
	If mTimers(alarmNum).alarmType.ShowScreenBig Then
		If mpage.DebugLog Then Log("AlarmFired-ShowScreenBig")
	End If
	'---
	If mTimers(alarmNum).alarmType.ShowScreenSmall Then
		If mpage.DebugLog Then Log("AlarmFired-ShowScreenSmall")
		guiHelpers.Show_toast("Alarm #" & alarmNum & " Has fired: " & mTimers(alarmNum).txt)	
	End If	
End Sub


Private Sub tmrBeep_Tick
	bpr.Release
	InitBeeper
	bpr.beep
End Sub


Private Sub InitBeeper
	bpr.Initialize(300,1000)
End Sub


Public Sub AlarmSoundStop(alarmNum As Int)

	Try
		'CallSub(Main,"FireKAlarm_stop")
		Log("AlarmSoundStop (alarmNum As Int)-->" & alarmNum)
		mMediaPlayer(alarmNum).Stop
		mMediaPlayer(alarmNum).Release
		ph.SetVolume(ph.VOLUME_MUSIC, mpOldVol, False)	'--- restore old volume
	Catch
		guiHelpers.Show_toast2(gblConst.VOLUME_ERR,4500)
		Log(LastException)
	End Try
	
End Sub


Public Sub AlarmSoundPlay(sfile As String,alarmNum As Int)
	Try
		Dim vol As Int = Main.kvs.Get(gblConst.INI_SOUND_ALARM_VOLUME) * ("0." & ph.GetMaxVolume(ph.VOLUME_MUSIC))
		mpOldVol = ph.GetVolume(ph.VOLUME_MUSIC) '--- save old volume
		ph.SetVolume(ph.VOLUME_MUSIC, vol, False)
		mMediaPlayer(alarmNum).Initialize
		mMediaPlayer(alarmNum).Load(File.DirAssets,sfile)
		mMediaPlayer(alarmNum).Looping = True
		mMediaPlayer(alarmNum).Play
	Catch
		guiHelpers.Show_toast2(gblConst.VOLUME_ERR,4500)
		Log(LastException)
	End Try
	
End Sub

