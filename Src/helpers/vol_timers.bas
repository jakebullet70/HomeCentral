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
End Sub

'------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------


'--- called from dlgVol and dlgSetupTimers
Public Sub SetTimerSoundFiles(b As B4XComboBox)
	b.cmbBox.AddAll(Array As String( _
				"Beep01","Beep02","Beep03","Rooster","Space"))
End Sub


Public Sub BuildAlarmFile(s As String) As String
	Return "ktimers_" & s & ".ogg".As(String).ToLowerCase
End Sub


Public Sub SaveTimerVolume(f As String,vol As Int)
	Main.kvs.Put(gblConst.INI_TIMERS_ALARM_FILE,BuildAlarmFile(f))
	Main.kvs.Put(gblConst.INI_TIMERS_ALARM_VOLUME,vol)
End Sub


