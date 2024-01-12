B4J=true
Group=Helpers
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Jan/11/2024
'			    kitchen timers Generic functions / methods
#End Region
'Static code module
Sub Process_Globals
	Private XUI As XUI
	
	
	Type typTimers (alarmType As typAlarmTypes, _
					Firing As Boolean, _
					txt As String, _
					nHr As Int, _
					nMin As Int, _
					nSec As Int, _
					active As Boolean, _
					endTime As Long, _
					paused As Boolean) 
					
	Type typAlarmTypes (sendGrowl As Boolean , _
					sendTxtMSG As Boolean , _
					beepMe As Boolean, _
					playFile As Boolean, _
					ShowScreenSmall As Boolean, _
					ShowScreenBig As Boolean)
					
End Sub

'------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------

Public Sub SetImages(Arr() As lmB4XImageViewX,imgName As String)
	For Each o As lmB4XImageViewX In Arr
		o.Bitmap = XUI.LoadBitmap(File.DirAssets, imgName)
	Next
End Sub

Public Sub xStr2Int(s As String) As Int
	Return s
End Sub

Public Sub xIntsStr(n As Int) As String
	Dim s As String = n
	If s.Length = 2 Then
		Return n
	Else
		Return "0" & n
	End If
End Sub

Public Sub PadZero(n As Int) As String
	Return strHelpers.PadLeft(n,"0",2)
End Sub

Public Sub returnNegNum(num As Int) As Int
	num = Abs(num)
	Return (num - (num * 2))
End Sub


'==========================================================

Public Sub Clear_Timer(x As Int)
	
	Dim o As KitchenTmrs = B4XPages.MainPage.oPageTimers.svrKTimers
	o.timers(x).active = False
	o.timers(x).nHr = 0
	o.timers(x).nSec = 0
	o.timers(x).nMin = 0
	o.timers(x).txt= "Open"
	o.timers(x).endTime = 0
	o.timers(x).Firing = False
	o.timers(x).paused = False
	InitAlarmTypes(o,x)
	
End Sub


Private Sub InitAlarmTypes(o As KitchenTmrs,x As Int)

	'--- for now just default to 'PlayFile'
	o.timers(x).alarmType.beepMe = False
	o.timers(x).alarmType.playFile = True
	o.timers(x).alarmType.ShowScreenBig = False
	o.timers(x).alarmType.ShowScreenSmall = False
	o.timers(x).alarmType.sendGrowl = False
	o.timers(x).alarmType.sendTxtMSG = False
	
End Sub

Public Sub AnyTimersFiring() As Boolean
	Dim xx As Int
	For xx = 1 To 5
		If B4XPages.MainPage.oPageTimers.svrKTimers.timers(xx).Firing Then
			Return True
		End If
	Next
	Return False
End Sub