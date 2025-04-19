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
'
' Old code from 2014
'
#End Region
'Static code module
Sub Process_Globals
	Private XUI As XUI
	Private oSQL As SQL
	
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
	
	Dim o As KitchenTmrs = B4XPages.MainPage.oPageTimers.clsKTimers
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
		If B4XPages.MainPage.oPageTimers.clsKTimers.timers(xx).Firing Then
			Return True
		End If
	Next
	Return False
End Sub


Public Sub InitSql
	oSQL = B4XPages.MainPage.sql
	Try
		oSQL.ExecNonQuery($"DROP TABLE timers"$)
	Catch
		Log(LastException)
	End Try
	oSQL.ExecNonQuery($"CREATE TABLE IF NOT EXISTS "timers" (
		"id"	INTEGER,
		"description"	TEXT,"time" TEXT,
		PRIMARY KEY("id" AUTOINCREMENT));"$)
	Log(oSQL.ExecQuerySingleResult($"SELECT COUNT(*) FROM timers"$))
	Dim count As Int = oSQL.ExecQuerySingleResult($"SELECT COUNT(*) FROM timers"$)
	If count = 0 Then
		oSQL.ExecNonQuery($"CREATE INDEX "ndx_desc" ON "timers" ("description");"$)
		timers_insert_new("Long Pasta","00:09:00")
		timers_insert_new("Bake Bread","00:45:00")
		timers_insert_new("Boiled Eggs","00:09:00")
	End If
End Sub

Public Sub timers_insert_new(desc As String, theTime As String)
	oSQL.ExecNonQuery2($"INSERT INTO timers ("description","time") VALUES (?,?);"$,Array As String(desc,theTime))
End Sub

Public Sub timers_delete(id As String)
	oSQL.ExecNonQuery("DELETE FROM timers WHERE id=" & id)
End Sub

Public Sub timers_get_all() As Cursor
	Return oSQL.ExecQuery("SELECT * FROM timers ORDER BY description")
End Sub




