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
	Main.tmrTimerCallSub.CallSubDelayedPlus(Me,"Update_Scrn", 15000 * 60)
	Log("Clock refresh set = 15min")
	#End If
End Sub
Public Sub StopClock()
	Main.tmrTimerCallSub.ExistsRemove(Me,"Update_Scrn")
End Sub

Private Sub Update_Scrn
	If DoNotShow Then Return
	Dim fmtD As String = DateTime.DateFormat
	Dim fmtT As String = DateTime.TimeFormat
	DateTime.TimeFormat = "EEE h:mm a"
	DateTime.DateFormat = ""
	guiHelpers.ResizeText(DateUtils.TicksToString(DateTime.Now), B4XPages.MainPage.lblHdrTxt2)
	DateTime.TimeFormat = fmtT
	DateTime.DateFormat = fmtD
	StartClock
End Sub

