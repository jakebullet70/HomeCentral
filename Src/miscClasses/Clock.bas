﻿B4J=true
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
	Private tmrClock As Timer
End Sub

Public Sub Initialize()	
	#if release	
	Dim mn As Int = 1000 * 60
	#else
	Dim mn As Int = 2000 * 60
	Log("Clock refresh set = 15min")
	#End If
	tmrClock.Initialize("tmrClock",mn)
	StartClock
End Sub

Private Sub tmrClock_Tick
	Update_Scrn
End Sub

Public Sub StopClock()
	tmrClock.Enabled = False
End Sub
Public Sub StartClock()
	tmrClock.Enabled = True
	Update_Scrn
End Sub

Public Sub Update_Scrn
	If DoNotShow Then 
		Log("Clock.Update_Scrn = DoNotShow")
		Return
	End If
	
	'--- raise the clock event, any object subscribed to it will get it
	B4XPages.MainPage.EventGbl.Raise2(gblConst.EVENT_CLOCK_CHANGE,FormatTime(DateTime.Now))
	
End Sub


Public Sub FormatTime(t As Long) As String
	Dim fmtD As String = DateTime.DateFormat
	Dim fmtT As String = DateTime.TimeFormat
	DateTime.TimeFormat = gblConst.LOCALE_CLOCK
	DateTime.DateFormat = ""
	
	Dim retMe As String = DateUtils.TicksToString(t)
	
	DateTime.TimeFormat = fmtT
	DateTime.DateFormat = fmtD
	
	Return retMe
End Sub

