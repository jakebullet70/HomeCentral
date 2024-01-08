B4J=true
Group=MiscClasses
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Jan/08/2024
#End Region


Sub Class_Globals
	Private XUI As XUI
End Sub

Public Sub Initialize()
End Sub




'--- FROM EHOME - ANDROID CODE
'--- FROM EHOME - ANDROID CODE
'--- FROM EHOME - ANDROID CODE


''
''
''public Sub tmrInet_Tick
''	tmrInet.Enabled = False
''	#if Release 
''	Dim cse As CallSubExtended
''	cse.AsyncCallSub(Me,"Check_Inet",4)
''	#else
''	CallSub(Me,"Check_Inet")
''	#end if
''	'Dim cse As CallSubExtended
''	'cse.AsyncCallSub(Me,"CheckInet",1)
''End Sub
''
''
''
''public Sub Check_Inet() 'ignore
''	'g.LogWrite("CheckInet()",g.ID_LOG_MSG)
''	g.bIsInetConectedOld = g.bIsInetConected
''	
''	If Not(wifi.isWifiConnected) Then
''		g.LogWrite4("Wifi was NOT on, Turning on",g.ID_LOG_MSG)
''		wifi.EnableWifi(True)
''		Sleep(300)
''	End If
''
'''	If c.PingTargets.Size = 0 Then 
'''		'--- waiting for decreypt
'''		g.LogWrite4("chk inet, waiting for decreypt",g.ID_LOG_MSG)
'''		tmrInet.Interval = 2000 '--- wait 2 seconds and try again
'''		tmrInet.Enabled = True
'''		Return
'''	End If
''	
''	Dim p As Boolean = IsConn
''	Dim w As Boolean = p
''	'Dim w As Boolean = fn.IsWiFiOnline
''	
''	If Not (w And p) Then
''		g.LogWrite("Wifi is not connected to the inet (CheckInet)",g.ID_LOG_MSG)
''		g.bIsInetConected = False
''		g.oInetEvents.Raise2(False)
''		g.LogWrite("Inet is offline",g.ID_LOG_WARNING)
''	Else
''		'g.LogWrite("Inet was offline, Now on...   Ping:" & p & " WiFi:" & w,g.ID_LOG_MSG)
''		g.bIsInetConected = True
''		If (g.bIsInetConectedOld = False) Then
''			g.debugLog3("Event -  raised weather")
''			g.LogWrite("Event -  raised weather",g.ID_LOG_MSG)
''			g.OnConnectedEventWeather.Raise
''			g.oInetEvents.Raise2(True)
''		End If
''	End If
''	
''	'--- reset the timer
''	If g.bIsInetConected = True Then
''		tmrInet.Interval = PINGslowhowOften
''	Else
''		tmrInet.Interval = PINGfastHowOften
''	End If
''	
''
''	tmrInet.Enabled = True
''		
''End Sub
''
''Sub IsConn As Boolean
''	Dim P As Phone
''	Dim WF As ServerSocket 'ignore
''	Dim B As Boolean = False
''
''	If P.GetDataState="CONNECTED" Then
''		g.debugLog("inet says CONNECTED")
''		B=True
''	End If
''	If WF.GetMyIP<>"127.0.0.1" Then
''		g.debugLog("inet is NOT localhost")
''		B=True
''	End If
''		
''	Return B
''End Sub
''
'''
'''private Sub IsWiFiOnline() As Boolean
'''    Dim r As Reflector
'''   
'''    r.Target = r.GetContext
'''    r.Target = r.RunMethod2("getSystemService", "connectivity", "java.lang.String")
'''    r.Target = r.RunMethod("getActiveNetworkInfo")
'''   
'''    If r.Target <> Null Then
'''        Return r.RunMethod("isConnectedOrConnecting")
'''    End If
'''   
'''    Return False
'''End Sub
''
''
'''private Sub PingMeBaby() As Boolean
'''	
'''	'--- we are paused!!!!
'''	If IsPaused(Main) = True Then  Return True
'''	
'''	If g.ph.SdkVersion >= 14 And g.ph.SdkVersion < 21 Then
'''		mPingTargetIndex = mPingTargetIndex + 1
'''		If mPingTargetIndex > (c.PingTargets.Size - 1) Then mPingTargetIndex = 0
'''		Dim url As String = c.PingTargets.GetValueAt(mPingTargetIndex)
'''		g.debugLog("PING! " & url & "   " & DateTime.Time(DateTime.Now))  
'''		Return fn.Ping(url,1,5,False)
'''	Else
'''		'--- android 5 fails so this is it!
'''		Return True 
'''	End If
'''	
'''End Sub
''
''
''
''
''''ResultsType: Report, Summary, Status
'''private Sub PingA(URL As String, Attempts As Int,	Timeout As Int, Message As Boolean,callBackMod As Object,callBackMethod As String) As Boolean
'''				
''''	If Ping("www.basic4ppc.com", 5, 10, True) Then
''''		'--- all is good !!  Its there!!!!
''''		Log("OK")
''''	Else
''''		Log("Nope!")
''''	End If
''''	
'''	Dim sb As StringBuilder
'''	sb.Initialize
'''
'''	If Message Then
'''		ProgressDialogShow("Pinging " & URL)
'''		DoEvents : DoEvents
'''	End If
'''	Dim ph As Phone
'''	
'''	ph.Shell("ping -c" & Attempts & " -W" & Timeout & "-v " & URL, Null, sb, Null)
'''	
'''	If Message Then ProgressDialogHide
'''
'''	If sb.Length = 0 Then 
'''		Return False
'''	Else
'''		Return True
'''	End If
'''
'''End Sub
''
''
''
