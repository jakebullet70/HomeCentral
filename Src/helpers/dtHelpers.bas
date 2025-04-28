B4J=true
Group=Helpers
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  lots of people!
#Region VERSIONS 
' V. 1.0 	Dec/22/2023
#End Region
'Static code module


'--- Date / time methods -----------------------------
'--- Date / time methods -----------------------------
'--- Date / time methods -----------------------------

'--- these shouls all be in DateUtils NOW
'--- these shouls all be in DateUtils NOW

Sub Process_Globals
	Private XUI As XUI
End Sub


Public Sub StrTime2Ticks(hours As String, minutes As String) As Long
	Return (hours * DateTime.TicksPerHour) + (minutes * DateTime.TicksPerMinute) 
End Sub

public Sub IsTimeBetween(CurrentTime As Long, StartTime As Long, EndTime As Long) As Boolean
	If StartTime <= EndTime Then
		'--- Normal case (e.g., 08:00 to 17:00)
		'Return CurrentTime >= StartTime And CurrentTime <= EndTime 
		If CurrentTime >= StartTime And CurrentTime <= EndTime Then
			Log("before midnight: Time is in range.")
			Return True
		Else
			Log("before midnight: Time is outside range.")
			Return False
		End If
	Else
		'--- Over midnight (e.g., 22:00 to 02:00)
		'Return CurrentTime >= StartTime Or CurrentTime <= EndTime
		If CurrentTime >= StartTime Or CurrentTime <= EndTime Then
			Log("after midnight: Time is in range.")
			Return True
		Else
			Log("after midnight: Time is outside range.")
			Return False
		End If
	End If
	
	'		Dim p As Period =DateUtils.PeriodBetween(DateTime.DateParse( "2020-12-20 20:10:13" ), DateTime.DateParse( "2020-12-20 22:14:50" ))
	'		Log($"${p.Hours}:${p.Minutes}:${p.Seconds}"$) 'displays: 2:4:37
	'		Log($"$2.0{p.Hours}:$2.0{p.Minutes}:$2.0{p.Seconds}"$)  'displays: 02:04:37
		

End Sub


Public Sub ReturnDayExt(n As Int) As String
	Select Case n
		Case 1 : Return n & "st"
		Case 2 : Return n & "nd"
		Case 3 : Return n & "rd"
		'Case 4,5,6,7,8,9 : Return n & "th"
	End Select
	Return n & "th"
End Sub

Public Sub HoursBetween(d1 As Long, d2 As Long) As Int
	Return ((d1 - d2) / DateTime.TicksPerHour)
End Sub

Public Sub GetLastDayOfMonth(thisDate As Long) As Long

	Dim DayOfMonth As Int = DateTime.GetDayOfMonth(thisDate)   'Get the day of the month
	Dim FirstDayOfMonth As Long = DateTime.Add(thisDate, 0, 0, (DayOfMonth * -1) + 1)   ' change the day to 1
	Dim LastDayOfMonth As Long = DateTime.Add(FirstDayOfMonth, 0, 1, -1)  ' Add one month AND subtract 1 day

	Return LastDayOfMonth

End Sub


Public Sub IsItDayTime(sunrise As String, sunset As String,CityLocalTime As String) As Boolean
	
	#if release
	Try
	#end if
		
	Dim sunrise1,sunset1,curTime As Float
	CityLocalTime = CityLocalTime.SubString(10).trim
	Log(CityLocalTime)
		
	DateTime.TimeFormat = "H:mm"
	Dim tmpCur As String = DateTime.Time(DateTime.TimeParse(CityLocalTime))
	Dim tmpSunset As String = ChangeTime12To24Hours(sunset)
	Dim tmpSunrise As String = ChangeTime12To24Hours(sunrise)
		
	sunrise1 = tmpSunrise.Replace(":",".")
	sunset1 = tmpSunset.Replace(":",".")
	curTime = tmpCur.Replace(":",".")

	'Log(dt.ChangeTime12To24Hours("11:30 pm"))
		
	If curTime > (sunrise1 + .5) And curTime < (sunset1 + 1) Then
		Return True
	Else
		Return False
	End If

	#if release
	Catch
		Log(LastException)
		Return True
	End Try
	#end if

End Sub

Public Sub FormatTime(mask As String,ticks As Int) As String
	Dim ret As String
	Dim fmtD As String = DateTime.DateFormat
	Dim fmtT As String = DateTime.TimeFormat
	DateTime.TimeFormat = mask
	DateTime.DateFormat = ""
	
	ret = DateUtils.TicksToString(ticks)
	
	DateTime.TimeFormat = fmtT
	DateTime.DateFormat = fmtD
	Return ret
End Sub

'---------------------------------------------------------
' returns a 24 hr long
'---------------------------------------------------------
Public Sub ChangeTime12To24Hours3(a As String) As Long
	Try
		'Dim a As String = "4:31 PM"
		a = a.ToUpperCase.replace("PM"," PM").Replace("AM"," AM")
		DateTime.TimeFormat = "h:mm a"
		Return DateTime.TimeParse(a)
	Catch
		Log(LastException)
		'g.LogWrite2("(ChangeTime12To24Hours) Failed to convert time 24/12: " & a,g.ID_LOG_ERR)
		Return "12:00"
	End Try
End Sub


'---------------------  NEEDS TO BE REFACTORED -------------------------------
'---------------------  NEEDS TO BE REFACTORED -------------------------------
'---------------------------------------------------------
' returns a 24 hr string
'---------------------------------------------------------
Public Sub ChangeTime12To24Hours2(a As String) As String
	Try
		'Dim a As String = "4:31 PM"
		a = a.ToUpperCase.replace("PM"," PM").Replace("AM"," AM")
		DateTime.TimeFormat = "hh:mm a"
		Dim b As Long = DateTime.TimeParse(a)
		'Log(FormatTime( "k:mm",b))
		Return  FormatTime( "k:mm",b)
	Catch
		Log(LastException)
		'g.LogWrite2("(ChangeTime12To24Hours) Failed to convert time 24/12: " & a,g.ID_LOG_ERR)
		Return "12:00"
	End Try
End Sub


Public Sub ChangeTime12To24Hours(s As String) As String
	Try
	
		's = CleanUpAMPM_issues(s)
'	
'		'---  why????
'		If s.Contains("amam") Then 
'			g.LogWrite("(ChangeTime12To24Hours) Failed to convert time 24/12: " & s,g.ID_LOG_ERR)
'			s = s.Replace("amam","am")
'		End If
'		If s.Contains("pmam") Then 
'			g.LogWrite("(ChangeTime12To24Hours) Failed to convert time 24/12: " & s,g.ID_LOG_ERR)
'			s = s.Replace("pmam","pm")
'		End If
'	
		'Log("time----   " & s)
		
		s = s.Replace(":",".").Replace(" ","") '--- remove the : so we can add 12 if needed
		Dim ret As String
		
		If s.Contains("AM") Or s.Contains("am") Then
			Return s.Replace("AM","").Replace("am","").Trim
		Else
			ret = s.Replace("PM","").Replace("pm","").Trim
			Dim f1 As Float = 12 + ret
			Dim f2 As String = Round2(f1,2)
			If f2.Length = 4 Then f2 = f2 & "0"
			Return f2
		End If
	Catch
		'g.LogWrite2("(ChangeTime12To24Hours) Failed to convert time 24/12: " & s,g.ID_LOG_ERR)
		Return "12:00"
	End Try
	
	
End Sub
'=============================================================================================



' many of these are now built into b4x
'
''************************************************************************************************************
''************************************************************************************************************
''*************************************    DATE AND TIME FUNCTION S AND CRAP !!!         *********************
''************************************************************************************************************
''************************************************************************************************************
'
'
'
'' HH - hours, always 2 digit, 24 hour
'' H - hours, possibly 1 digit, 24 hour
'' hh - hours, always 2 digit, 12 hour
'' h - hours, possibly 1 digit, 12 hour
'' mm - minutes, always 2 digit
'' m - minutes, possibly 1 digit
'' ss - seconds, always 2 digits' yyyy - full year value (4 digits)
'' yy - truncated year (2 digits)
'' MMM - month three letter abrev.
'' MM - month, always 2 digits
'' M - month, possibly 1 digit
'' dd - day of month, always 2 digits
'' d - day of month, possibly 1 digit
'
'' DD - day of month, always 2 digits and day extention
'' D - day of month, possibly 1 digit  and day extention
'' MMMM - full month name
'
'
'Public Sub FormatDateTime(fmt As String, dt1 As Long) As String
'  Dim i, j As Int
'  Dim s, T, so, MonthNames(12) As String
'  
'  s = fmt
'  so = ""
'  MonthNames = Array As String("Jan", "Feb", "Mar", "Apr", _
'    "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
'  
'  
'  
'  Do While (s.Length > 0)
'    If (s.StartsWith("HH")) Then
'      T = NumberFormat2(DateTime.GetHour(dt1), 2, 0, 0, False)
'      j = 2
'    Else If (s.StartsWith("H")) Then
'      T = NumberFormat2(DateTime.GetHour(dt1), 1, 0, 0, False)
'      j = 1
'    Else If (s.StartsWith("hh")) Then
'      i = DateTime.GetHour(dt1)
'      If (i > 12) Then i = i - 12
'      T = NumberFormat2(i, 2, 0, 0, False)
'      j = 2
'    Else If (s.StartsWith("h")) Then
'      i = DateTime.GetHour(dt1)
'      If (i > 12) Then i = i - 12
'      T = NumberFormat2(i, 1, 0, 0, False)
'      j = 1
'    Else If (s.StartsWith("mm")) Then
'      T = NumberFormat2(DateTime.GetMinute(dt1), 2, 0, 0, False)
'      j = 2
'    Else If (s.StartsWith("m")) Then
'      T = NumberFormat2(DateTime.GetMinute(dt1), 1, 0, 0, False)
'      j = 1
'    Else If (s.StartsWith("ss")) Then
'      T = NumberFormat2(DateTime.GetSecond(dt1), 2, 0, 0, False)
'      j = 2
'    Else If (s.StartsWith("yyyy")) Then
'      T = NumberFormat2(DateTime.GetYear(dt1), 1, 0, 0, False)
'      j = 4
'    Else If (s.StartsWith("yy")) Then
'      T = NumberFormat2(DateTime.GetYear(dt1), 1, 0, 0, False)
'      i = Max(T.Length - 2, 0)
'      T = T.SubString(i)
'      j = 2
'    Else If (s.StartsWith("MMMM")) Then
'	  Dim oo As List = DateUtils.GetMonthsNames
'	  i = DateTime.GetMonth(dt1)
'	  T = oo.Get(i - 1)
'	  j = 4
'	Else If (s.StartsWith("MMM")) Then
'      i = DateTime.GetMonth(dt1)
'      T = MonthNames(i - 1)
'      j = 3
'    Else If (s.StartsWith("MM")) Then
'      T = NumberFormat2(DateTime.GetMonth(dt1), 2, 0, 0, False)
'      j = 2
'    Else If (s.StartsWith("M")) Then
'      T = NumberFormat2(DateTime.GetMonth(dt1), 1, 0, 0, False)
'      j = 1
'    Else If (s.StartsWith("dd")) Then
'      T = NumberFormat2(DateTime.GetDayOfMonth(dt1), 2, 0, 0, False)
'      j = 2
'    Else If (s.StartsWith("d")) Then
'      T = NumberFormat2(DateTime.GetDayOfMonth(dt1), 1, 0, 0, False)
'      j = 1
'	Else If (s.StartsWith("DD")) Then
'      T = NumberFormat2(DateTime.GetDayOfMonth(dt1), 2, 0, 0, False)
'	  T = ReturnDayExt(T)
'      j = 2
'    Else If (s.StartsWith("D")) Then
'      T = NumberFormat2(DateTime.GetDayOfMonth(dt1), 1, 0, 0, False)
'	  T = ReturnDayExt(T)
'      j = 1
'    Else
'      T = s.SubString2(0, 1)
'      j = 1
'    End If
'    
'    so = so & T
'    s = s.SubString(j)
'  Loop
'  
'  Return(so)
'End Sub
'
'
'Private Sub ReturnDayExt(n As Int) As String
'	Select Case n
'		Case 1 : Return n & "st"
'		Case 2 : Return n & "nd"
'		Case 3 : Return n & "rd"
'		'Case 4,5,6,7,8,9 : Return n & "th"
'	End Select
'	Return n & "th"
'End Sub
'
'
''' ************* JAVA crap!!!
'''D	day In year	(Number)	189
'''E	day of week	(Text)	Tuesday
'''F	day of week In month	(Number)	2 (2nd Wed In July)
'''G	era designator	(Text)	AD
'''H	hour In day (0-23)	(Number)	0
'''K	hour In am/pm (0-11)	(Number)	0
'''L	stand-alone month	(Text/Number)	July / 07
'''M	month In year	(Text/Number)	July / 07
'''S	fractional seconds	(Number)	978
'''W	week In month	(Number)	2
'''Z	time zone (RFC 822)	(Timezone)	-0800
'''a	am/pm marker	(Text)	PM
'''c	stand-alone day of week	(Text/Number)	Tuesday / 2
'''d	day In month	(Number)	10
'''h	hour In am/pm (1-12)	(Number)	12
'''k	hour In day (1-24)	(Number)	24
'''m	minute In hour	(Number)	30
'''s	second In minute	(Number)	55
'''w	week In year	(Number)	27
'''y	year	(Number)	2010
'''z	time zone	(Timezone)	Pacific Standard Time
''''	escape for text	(Delimiter)	'Date='
'''''	single quote	(Literal)	'o''clock'
'
''Public Sub FormatTime(fmt As String,n As Long) As String
''
''	Dim du As AHDateTime : du.Initialize
''	du.Pattern = fmt
''	Return du.Format(n)
''	
''End Sub
'
'
'Public Sub HoursBetween(d1 As Long, d2 As Long) As Int
'	Return ((d1 - d2) / DateTime.TicksPerHour)
'End Sub
'
''
'Public Sub IsDate(strDate As String) As Boolean
'
'	DateTime.DateFormat = "MM/dd/yy"
'	Try
'		DateTime.DateParse(strDate)
'	Catch
'		DateTime.DateFormat = "MM/dd/yyyy"
'		Return False
'	End Try
'	DateTime.DateFormat = "MM/dd/yyyy"
'	Return True
'End Sub
'
'
'
'
'
'
''============================================================================================
'
'

'Public Sub GetLastDayOfMonth2(thisDate As Long) As String
'	Dim LastDayOfMonth As Long = GetLastDayOfMonth(thisDate)
'	Return DateTime.Date( LastDayOfMonth )
'End Sub
'
'
'
'Public Sub GetFirstDayOfMonth(thisDate As Long) As Long
'
'	Dim DayOfMonth As Int = DateTime.GetDayOfMonth(thisDate)   'Get the day of the month
'	Dim FirstDayOfMonth As Long = DateTime.Add(thisDate, 0, 0,  (DayOfMonth * -1) + 1)   ' change the day to 1
'	'Dim LastDayOfMonth As Long = DateTime.Add(FirstDayOfMonth, 0, 1, -1)  ' Add one month AND subtract 1 day
'
'	Return FirstDayOfMonth
'End Sub
'Public Sub GetFirstDayOfMonth2(thisDate As Long) As String
'	Dim FirstDayOfMonth As Long = GetFirstDayOfMonth(thisDate)
'	Return DateTime.Date( FirstDayOfMonth )
'End Sub
'
'
'
''============================================================================================
'
'
'
'Public Sub formatDayOfWeek(day As Int) As String
'	Select Case day
'	Case 1 : Return "Sunday"
'	Case 2 : Return "Monday"
'	Case 3 : Return "Tuesday"
'	Case 4 : Return "Wednesday"
'	Case 5 : Return "Thursday"
'	Case 6 : Return "Friday"
'	End Select
'	Return "Saturday"
'End Sub
'Public Sub GetFirstDayOfWeek(thisDate As Long) As Long
'
'	Dim DayOfWeek As Int = DateTime.GetDayOfWeek(thisDate)   'Get the day of the week
'	Dim FirstDayOfWeek As Long = DateTime.Add(thisDate, 0, 0, (DayOfWeek * -1) + 1)   ' change the day to 1
'
'	Return FirstDayOfWeek
'
'End Sub
'
'
'
'Public Sub ChangeStr24hrTimeTo12hr(s As String) As String
'
'	Try
'		Dim strSplit() As String = Regex.Split(":",s )
'		Dim hr As Int = strSplit(0)
'		If hr < 12 Then
'			Return s & "am"
'		Else
'			Return (hr - 12) & ":" & strHelpers.PadLeft(strSplit(1),"0",2) & "pm"
'		End If
'	Catch
'		Log("(ChangeStr24hrTimeTo12hr) Failed to convert time 24/12: " & s)
'		
'	End Try
'	Return ""
'	
'End Sub
'
'
'
''Private Sub CleanUpAMPM_issues(s As String) As String
''
''	Try
''
''		'--- find the 1st NON nummeric char
''		For x = 0 To s.trim.Length
''			Dim t1 As String = s.SubString2(x,x+1)
''			If Not (IsNumber(t1)) Then
''				If Not(t1 = ":")  Then
''					Exit
''				End If
''			End If
''		Next
''		
''		'--- now add the proper AM or PM crap
''		s = (s.SubString2(0,x+1) & "m")
''		Return s
''	Catch
''		Log("CleanUpAMPM_issues: " & s)
''		g.LogWrite2("CleanUpAMPM_issues: " & s,g.ID_LOG_ERR)
''	
''		If Regex.Split(":",s)(0) <= 12 Then
''			Return s & "am"
''		Else
''				Return (s - 12) & "pm"
''		End If
''		Return s & "am"
''	End Try	
''End Sub
'
'
'
''---------------------------------------------------------
'' returns a 24 hr long
''---------------------------------------------------------
'Public Sub ChangeTime12To24Hours3(a As String) As Long
'	Try
'		'Dim a As String = "4:31 PM"
'		a = a.ToUpperCase.replace("PM"," PM").Replace("AM"," AM")
'		DateTime.TimeFormat = "h:mm a"
'		Return DateTime.TimeParse(a) 
'	Catch
'		Log(LastException)
'		'g.LogWrite2("(ChangeTime12To24Hours) Failed to convert time 24/12: " & a,g.ID_LOG_ERR)
'		Return "12:00"
'	End Try
'End Sub
'
'
'
''---------------------------------------------------------
'' returns a 24 hr string
''---------------------------------------------------------
'Public Sub ChangeTime12To24Hours2(a As String) As String
''	Try
''		'Dim a As String = "4:31 PM"
''		a = a.ToUpperCase.replace("PM"," PM").Replace("AM"," AM")
''		DateTime.TimeFormat = "hh:mm a"
''		Dim b As Long = DateTime.TimeParse(a)
''		Log(FormatTime( "k:mm",b))
''		Return FormatTime( "k:mm",b)
''	Catch
''		Log(LastException)
''		'g.LogWrite2("(ChangeTime12To24Hours) Failed to convert time 24/12: " & a,g.ID_LOG_ERR)
''		Return "12:00"
''	End Try
'End Sub
'
'
'Public Sub ChangeTime12To24Hours(s As String) As String
'	Try
'	
'		's = CleanUpAMPM_issues(s)
''	
''		'---  why????
''		If s.Contains("amam") Then 
''			g.LogWrite("(ChangeTime12To24Hours) Failed to convert time 24/12: " & s,g.ID_LOG_ERR)
''			s = s.Replace("amam","am")
''		End If
''		If s.Contains("pmam") Then 
''			g.LogWrite("(ChangeTime12To24Hours) Failed to convert time 24/12: " & s,g.ID_LOG_ERR)
''			s = s.Replace("pmam","pm")
''		End If
''	
'		'Log("time----   " & s)
'		
'		s = s.Replace(":",".").Replace(" ","") '--- remove the : so we can add 12 if needed
'		Dim ret As String
'		
'		If s.Contains("AM") Or s.Contains("am") Then
'			Return s.Replace("AM","").Replace("am","").Trim
'		Else
'			ret = s.Replace("PM","").Replace("pm","").Trim
'			Dim f1 As Float = 12 + ret
'			Dim f2 As String = Round2(f1,2)
'			If f2.Length = 4 Then f2 = f2 & "0"
'			Return f2
'		End If
'	Catch
'		'g.LogWrite2("(ChangeTime12To24Hours) Failed to convert time 24/12: " & s,g.ID_LOG_ERR)
'		Return "12:00"
'	End Try
'	
'	
'End Sub
'
'
'
'
'
'
'
'
'
'
'
'
'
