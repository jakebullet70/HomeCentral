B4J=true
Group=MiscClasses
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
	Public DoNotShow As Boolean = False
End Sub

Public Sub Initialize()	
	Update_Scrn
End Sub

Public Sub StartClock()
	#if release	
	Main.tmrTimerCallSub.CallSubDelayedPlus(Me,"Update_Scrn",1000 * 60)
	#else
	Main.tmrTimerCallSub.CallSubDelayedPlus(Me,"Update_Scrn", 1000 * 60)
	Log("Clock refresh set = 15min")
	#End If
End Sub
Public Sub StopClock()
	Main.tmrTimerCallSub.ExistsRemove(Me,"Update_Scrn")
End Sub

Public Sub Update_Scrn
	If DoNotShow Then Return
	Dim fmtD As String = DateTime.DateFormat
	Dim fmtT As String = DateTime.TimeFormat
	DateTime.TimeFormat = "EEE h:mm a"
	DateTime.DateFormat = ""
	
	'--- raise the clock event, any subscribed to it will get it
	Main.EventsGlobal.Raise2(cnst.EVENT_CLOCK_CHANGE,DateUtils.TicksToString(DateTime.Now))
	
	DateTime.TimeFormat = fmtT
	DateTime.DateFormat = fmtD
	StartClock
	Sleep(0)
End Sub

