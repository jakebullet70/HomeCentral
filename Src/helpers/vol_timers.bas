B4J=true
Group=Helpers
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Apr/2025
'			kitchen timers and Generic functions for volume
#End Region
'Static code module
Sub Process_Globals
	Private MP_Test As MediaPlayer
	Private ph As Phone
	Private MaxVolumeMusic,MaxVolumeNotifaction,MaxVolumeSys As Int 'ignore
End Sub

'------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------


'--- called from dlgVol and dlgSetupTimers
Public Sub SetTimerSoundFiles(b As B4XComboBox,selectFile As String)
	b.cmbBox.AddAll(Array As String( _
				"Beep01","Beep02","Beep03","Rooster","Space"))
	selectFile = selectFile.ToLowerCase
	If selectFile.Contains("beep01") Then
		b.cmbBox.SelectedIndex = 0
	Else If selectFile.Contains("beep02") Then
		b.cmbBox.SelectedIndex = 1
	Else If selectFile.Contains("beep03") Then
		b.cmbBox.SelectedIndex = 2
	Else If selectFile.Contains("rooster") Then
		b.cmbBox.SelectedIndex = 3
	Else If selectFile.Contains("space") Then
		b.cmbBox.SelectedIndex = 4
	End If
End Sub


Public Sub BuildAlarmFile(s As String) As String
	Return "ktimers_" & s & ".ogg".As(String).ToLowerCase
End Sub


Public Sub SaveTimerVolume(f As String,vol As Int)
	Main.kvs.Put(gblConst.INI_TIMERS_ALARM_FILE,BuildAlarmFile(f))
	Main.kvs.Put(gblConst.INI_TIMERS_ALARM_VOLUME,vol)
End Sub

Public Sub PlaySound(sbVol As Int,sFile As String)
	Try
		'--- sbVol is from the scroller bar 'value'
		Dim b As Boolean = False
		ph.SetMute(ph.VOLUME_MUSIC,b)
		ph.SetMute(ph.VOLUME_SYSTEM,b)
		Dim beforeVol As Int 
		Dim Vol As Int = sbVol * ("0." & ph.GetMaxVolume(ph.VOLUME_MUSIC))
		beforeVol = ph.GetVolume(ph.VOLUME_MUSIC) '--- save old volume
		ph.SetVolume(ph.VOLUME_MUSIC, Vol, False)
		MP_Test.Initialize()
		MP_Test.Load(File.DirAssets, sFile)
		MP_Test.Play
		Do While MP_Test.IsPlaying
			Sleep(200)
		Loop		
		ph.SetVolume(ph.VOLUME_MUSIC, beforeVol, False)
	Catch
		guiHelpers.Show_toast2(gblConst.VOLUME_ERR,3500)
	End Try
	
End Sub
