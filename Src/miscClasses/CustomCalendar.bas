B4A=true
Group=MiscClasses
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
' Author:  No idea
#Region VERSIONS 
' V. 1.1		Dec/30/2023
'				Converted to B4X from early B4A
' V. 1.0 	Dec/01/2015
'				Got from the B4A forum - tweaked to make work for me
#End Region

Sub Class_Globals
	Private XUI As XUI
	'Type typeCalEvent(CalID As Int, eventName As String, Description As String, StartTime As Long, EndTime As Long, Loc As String, AllDay As Boolean, EventID As Int, thisDay As Int)

	Public callback As Object
	Public eventName As String
	Public hilightDates() As Int

	Private btDays(42) As B4XView 'Button      'Days on 1 month (+ 2)
	'Private btnTitles(7) As Button     'Day of Week (begin Sunday)
	Private lblDayTitle(8) As B4XView     'Day of Week (begin Sunday)
	Private lblTitle As B4XView         'Date	
	
	Private pnl,pnlbackGround As B4XView 
	
	'Public NmFullday(7) As String : NmFullday = Array As String("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Satuday")
	'Public NmFullMonth(12) As String : NmFullMonth = Array As String("January","Febuary","March","April","May","June","July","Augest","September","October","November","December")
	Public NmMonth(12) As String : NmMonth = Array As String("Jan","Feb","Mar","April","May","June","July","Aug","Sept","Oct","Nov","Dec")
	
	Public NmFullday() As String
	Public NmFullMonth() As String 
	
		
	Private CalDay, CalMonth, CalYear As Int
	Private RelativTextSize As Int
	Private SomeTime As Long

	Public oCalNum As Int
	Public oCalLST As List    
	Public oCalDaysMAP As Map  
End Sub



Private Sub lblDayTitle_Click
	lblTitle_Click
End Sub
Private Sub lblTitle_Click
'--- call the android cal
'	Dim pm As PackageManager
'	Dim it As Intent = pm.GetApplicationIntent("com.android.calendar")
'	If it.IsInitialized Then StartActivity(it)
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize( Ww As Int,Hh As Int, BeginDate As Long, txtSize As Int)
	
	NmFullday =  objHelpers.List2StrArray( DateUtils.GetDaysNames)
	NmFullMonth = objHelpers.List2StrArray(DateUtils.GetMonthsNames)
	
	oCalLST.Initialize
	oCalDaysMAP.Initialize
	
	pnl = XUI.CreatePanel("pnl")
	
	pnl.Color = XUI.Color_Transparent
	Dim mx,my,tx,ty As Int
	Dim i,j,z As Int		
	RelativTextSize = txtSize
	
	mx=(Ww/7)'-8
	'mx=(Ww/3)'-8

	my=(Hh/8)'-9
	
	If my > mx Then my = mx
	If ((my * 9) + 10dip) > Hh Then my = ((Hh - 10dip) / 9)
	
	tx = (Ww - ((mx * 7) + 8dip)) / 2
	ty = (Hh - ((my * 9) + 8dip)) / 2
	
	pnlbackGround = XUI.CreatePanel("")
	pnlbackGround.Color = XUI.Color_Transparent
	pnl.addview(pnlbackGround,tx,ty,(mx *  7) + 8dip, (my * 9) + 8dip)
	pnl.Visible = False
	
	lblTitle = XUIViewsUtils.CreateLabel
	
	pnlbackGround.addView(lblTitle,1dip,1dip,pnlbackGround.Width - 2dip, my - 6dip)
	'lblTitle.Typeface=Typeface.DEFAULT_BOLD	
	
	lblTitle.Color = XUI.Color_Transparent
	lblTitle.TextColor =  themes.clrTxtNormal'  g.GetColorTheme(g.ehome_clrTheme,"themeColorText")
	lblTitle.SetTextAlignment("CENTER","CENTER")
	
	
	''''If g.IsCalendarReadOn Then ReadAndroidCals(BeginDate)
	
	For i = 0 To 6 'Days name buttons
	
		lblDayTitle(i) = XUIViewsUtils.CreateLabel
		lblDayTitle(i).SetTextAlignment("CENTER","CENTER")
		lblDayTitle(i).TextSize = (RelativTextSize)
		lblDayTitle(i).TextColor = themes.clrTxtNormal
		pnlbackGround.AddView( lblDayTitle(i), (i * mx) + ((i + 1) * 1dip),  (1 * my) + 1dip, mx + 2dip, my)
		guiHelpers.ResizeText(dayName(i),lblDayTitle(i))
	Next
	
	For j = 0 To 5 'Days buttons		
		For i = 0 To 6	
			z = (j*7)+i
			btDays(z) = XUIViewsUtils.CreateLabel
			btDays(z).SetTextAlignment("CENTER","CENTER")
			btDays(z).Color = XUI.Color_Transparent
			btDays(z).tag = 0	
			'btDays(z).TextSize = RelativTextSize 
			'pnlbackGround.AddView(btDays(z), (i*mx)+((i+1)*1dip), ((j+2)*(my+1dip))+my,  mx,  my) 
			Dim v1 As Int = my / 30 '6           '   left                  top
			pnlbackGround.AddView(btDays(z),(i * mx) + (( i + 1) * 1dip),((j + 2) * (my + v1 + 1dip)),  mx, (my + v1)) 
 		Next
	Next
	
	PrintDate(BeginDate)	
	'If c.ThreeDText Then fn.SetTextShadowAll(pnl,c.CLR_TXT_BRIGHT)
	
End Sub




'====================================================================
'==  read from android cal
'====================================================================

'
'Private Sub ReadAndroidCals(bdate As Long)
'
'	Try
'		Dim m As Map : m.Initialize
'		m = oCal.GetListOfAllCalendars(False)
'		If m.Size = 0 Then
'			Dim msg As String = "No Android cal's are defined."
'			g.ToastMessageShowX(msg,False)
'			g.LogWrite(msg,g.ID_LOG_MSG)
'		Else
'			Dim val As Int = g.INIRead(c.INI_CONST_SETUP,"CAL_READ_NUM")
'			g.debugLog("*** oCalNum = " & val)
'			oCalNum = val
'			Dim tmp As List : tmp.Initialize
'			tmp = oCal.GetListofEventsforCalendarBetweenDates(oCalNum,dt.GetFirstDayOfMonth(bdate),dt.GetLastDayOfMonth(bdate))
'			oCalLST = EnumAllCalEvents(tmp,oCalNum)		
'		End If
'	Catch
'		g.LogWrite("ReadAndroidCals: " & LastException.Message,g.ID_LOG_ERR)
'	End Try
'	
'End Sub


'Private Sub EnumAllCalEvents(calEvents As List, calID As Int)As List
'    Dim Events As List, temp2 As Int
'    Events.Initialize
'    'Log("Checking calendar " & calID & " " & Calendars.GetValueAt(temp) & " = " & (calEvents.Size/7) & " events")
'    For temp2 = 0 To calEvents.Size-1 Step 7
'        Dim Event As  typeCalEvent
'        Event.Initialize
'        Event.calID = calID
'        Event.eventName   = calEvents.Get(temp2)           '(0) Event Name
'        Event.Description = calEvents.Get(temp2+1)         '(1) Description
'        Event.StartTime   = calEvents.Get(temp2+2)         '(2) Start Time
'        Event.EndTime     = calEvents.Get(temp2+3)         '(3) End Time
'        Event.Loc         = calEvents.Get(temp2+4)         '(4) Location
'        Event.AllDay      = calEvents.Get(temp2+5) = "1"   '(5) All day indicator, 1= all day, 0= not
'        Event.EventID     = calEvents.Get(temp2+6)         '(6) Event_ID
'		'--- my own
'		Event.thisDay     = DateTime.GetDayOfMonth(calEvents.Get(temp2+2))
'		'--- 
'		AddDay2MonthEvent(Event.StartTime,Event.EndTime,Event.AllDay)
'		'---
'        Events.Add(Event)
'        'Log(Events.Size & ": " & Event)
'    Next
'    Return Events
'End Sub

'
'Private Sub AddDay2MonthEvent(bDate As Long, eDate As Long, allDay As Object)
'	'Log("b: " & DateTime.date(bDate) & DateTime.time(bDate))
'	'Log("E: " & DateTime.date(eDate) & DateTime.time(eDate))
'	If allDay = True Then bDate = DateTime.Add(bDate,0,0,1)
'	For nDay = DateTime.GetDayOfMonth(bDate) To DateTime.GetDayOfMonth(eDate)
'		oCalDaysMAP.Put(nDay,nDay)
'	Next
'End Sub


'====================================================================
'==  END read from android cal
'====================================================================



'Public Sub PaintHighLightDays(arr() As Int, color As Int)
'  used when you have cal events and want toshow them on the cal
'	Dim offset, x As Int
'	For x = 0 To 15
'		If btDays(x).Text = "1" Then
'			offset = (x - 1)
'			Exit
'		End If
'	Next
'	
'	For x = 0 To arr.Length - 1
'		btDays(arr(x) + offset).Text = UnderScoreCreate(btDays(arr(x) + offset).Text)					
'		'btDays(arr(x) + offset).Typeface = Typeface.CreateNew(Typeface.SANS_SERIF,Typeface.STYLE_BOLD_ITALIC)
'	Next
'End Sub

'Private Sub UnderScoreCreate(str As String) As RichString
''	Dim rStr As RichString 
''	rStr.Initialize(str) 
''	rStr.Underscore(0,rStr.Length)
''	rStr.Color(Colors.White,0,rStr.Length)
'	Return rStr
'End Sub


Public Sub ShowCalendar(b As Boolean)
	pnl.Visible = b	
End Sub

Public Sub dayName(n As Int) As String
		Dim S As String
		S = NmFullday(n)
		Return S.SubString2(0,3)
End Sub

Private Sub PrintDate(dts As Long)
	Dim nbj,nday As Int
	Dim mn1,mn2 As Int
	Dim cdd, cmm, caa As Int
	
	cdd = DateTime.GetDayOfMonth(DateTime.Now)
	cmm = DateTime.GetMonth(DateTime.Now)
	caa = DateTime.GetYear(DateTime.Now)
	
	CalDay   = DateTime.GetDayOfMonth(dts)	
	CalYear  = DateTime.GetYear(dts)	
	CalMonth = DateTime.GetMonth(dts)
	
'	Dim t8 As T8TextSize
'	t8.Initialize
	
	'lblTitle.TextSize = RelativTextSize 
	Dim s As String = NmFullMonth(CalMonth-1)  & "  " &  dtHelpers.ReturnDayExt(CalDay) & "  " & CalYear
	#if b4j
	lblTitle.TextSize = 27
	#End If
	guiHelpers.ResizeText(s,lblTitle)
	'g.setText(NmFullMonth(CalMonth-1)  & "  " & CalDay& "  " & CalYear	,lblTitle)
	'lblTitle.Typeface = Typeface.
	'lblTitle.Text = NmFullMonth(CalMonth-1)  & "  " & CalDay& "  " & CalYear	
'	t8.SingleLineFitText(lblDayTitle,False)
	'g.setText( NmFullMonth(CalMonth-1)  & "  " & CalDay& "  " & CalYear	,lblTitle)
	
'	For mn1=0 To 6
'		lblDayTitle(mn1).TextSize=(RelativTextSize)
'	Next
		
	mn1 = CalMonth - 1 'prev month
	If mn1 < 1 Then mn1 = 12
	'btPrevMonth.TextSize=(RelativTextSize*0.87) '14
	'btPrevMonth.Text=NmMonth(mn1-1)
	
	mn2 = CalMonth + 1 'next month
	If mn2 > 12 Then mn2 = 1
	'btNextMonth.TextSize=(RelativTextSize*0.87) '14
	'btNextMonth.Text=NmMonth(mn2-1)
	
	nbj = LengthMonth(CalYear,CalMonth)
	SomeTime = DateTime.DateParse(CalMonth & "/01/" & CalYear)
	
	nday = (DateTime.GetDayOfWeek(SomeTime)-1)
	
	Dim i,nb As Int
	nb = nday
	
	If nb = 0 Then nb = 7 'decal next line dim 1
	
	For i = 0 To 41 
		btDays(i).TextColor = themes.clrTxtNormal
		'btDays(i).Typeface=Typeface.DEFAULT
		btDays(i).Text = ""
		btDays(i).Tag = 0
		btDays(i).TextSize = lblDayTitle(1).TextSize 'RelativTextSize'(RelativTextSize*0.87)
	Next	
	
	Dim z As Int	
	For i = (nb) To (nb - 1 + nbj)
		z = i-nb+1
		'btDays(i).Typeface=Typeface.DEFAULT_BOLD
		btDays(i).Text=z	
		btDays(i).Tag=z
		
		'SetdayColor(cmm,caa,cdd,z,i)
		
		If (cmm = CalMonth) And (caa = CalYear) Then
			If (z = cdd) Then
				'--- shows the CURRENT day
				btDays(i).TextColor = themes.clrTitleBarTXT
				btDays(i).Color = themes.clrTitleBarBG
				'btDays(i).TextSize = btDays(i).TextSize + 6
				
			End If
		End If
	Next
	
	Dim m2,m3 As Int
	
	m2 = LengthMonth(CalYear,mn1)
	m3 = m2 - (nb - 1)
	For i=0 To (nb - 1) 'Prev month
		btDays(i).TextColor= XUI.Color_LightGray
		'btDays(i).Typeface = Typeface.DEFAULT_BOLD
		btDays(i).Text=m3+i	
		btDays(i).Tag=100+m3+i	
	Next
	
	For i = (nb + nbj) To 41 'Next month
		btDays(i).TextColor=XUI.Color_LightGray
		'btDays(i).Typeface = Typeface.DEFAULT_BOLD
		btDays(i).Text=i-(nb+nbj)+1
		btDays(i).Tag=200+(i-(nb+nbj)+1)
	Next
	
End Sub


Public Sub LengthMonth(yearNum As Int,monthNum As Int) As Int
	Return DateUtils.NumberOfDaysInMonth(monthNum,yearNum)
	'Return DateTime.GetDayOfMonth( dtHelpers.GetLastDayOfMonth(DateTime.DateParse(monthNum & "/1/" & yearNum)) )
End Sub

Public Sub AsView As B4XView
	Return pnl
End Sub


Public Sub SetTextSize(value As Int)
	RelativTextSize = value
	'PrintDate(DateTime.DateParse(CalMonth & "/" & CalDay & "/" & CalYear))
End Sub

'Private Sub btnDays_Click
'	
''	If Not (g.IsCalendarReadOn) Then Return
'
'	Dim eName As String = eventName & "_ItemClick"
'	If SubExists(callback, eName) Then
'		Dim lbl As Label = Sender	
'        CallSub2(callback,eName,lbl.Text)
'	End If
'	
'End Sub


'**************************************************************************************************************
'**************************************************************************************************************
'**************************************************************************************************************
'                                  ORIGINAL CODE WITH THE BTNS TO CHANGE MONTH / YEAR
'**************************************************************************************************************
'**************************************************************************************************************
'**************************************************************************************************************
'**************************************************************************************************************
'**************************************************************************************************************
'**************************************************************************************************************
'**************************************************************************************************************




'''''Class module
''''Sub Class_Globals
''''	Private btDays(42) As Label 'Button      'Days on 1 month (+ 2)
''''	Private lblDayTitle(8) As Button     'Day of Week (begin Sunday)
''''	Private lblTitle As Label         'Date	
''''	Private btNextMonth As Label 'Button    'Next Month
''''	Private btPrevMonth, spLabel As Label 'Button    'Prev Month
''''	Private SpYearsChoice As Spinner 'Years
''''	Private pnl,pnlbackGround As Panel 
''''	Private EventName As String
''''	Private CallBack As Object	
''''	Public NmFullday(7) As String : NmFullday = Main.Local.WeekDays    ' Array As String("Dimanche","Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi")
''''	Public NmMonth(12) As String : NmMonth = Main.Local.ShortMonths    'Array As String("jan","fev","mar","avr","mai","jun","jul","aug","sep","oct","nov","dec")
''''	Public NmFullMonth(12) As String : NmFullMonth = Main.Local.Months 'Array As String("janver","février","mars","avril","mai","juin","juillet","août","septembre","octobre","novembre","décembre")
''''	Private CalDay, CalMonth, CalYear As Int
''''	Private RelativTextSize As Int
''''	Private ColTable As Int : ColTable = Colors.RGB(153,51,0)
''''	Private ColInactive As Int : ColInactive = Colors.RGB(204,102,0)
''''	Private ColFunction As Int : ColFunction = Colors.RGB(255,153,0)
''''	Private ColActive As Int : ColActive = Colors.RGB(255,229,203)
''''	Private ColBackGround As Int : ColBackGround = Colors.Black
''''	Private SD, ED As Int 
''''	Private SomeTime As Long
''''
''''	
''''End Sub
''''
'''''Initializes the object. You can add parameters to this method if needed.
''''Public Sub Initialize(vCallback As Object, vEventName As String, Ww,Hh As Int, BeginDate As Long)
''''	EventName = vEventName
''''	CallBack = vCallback
''''	pnl.Initialize("pnl")	
''''	pnl.Color=ColBackGround
''''	SD = 2000
''''	ED = 2099
''''	
''''	Dim mx,my,tx,ty As Int
''''	Dim i,j,z As Int		
''''	
''''	RelativTextSize = 17
''''	
''''	mx=(Ww/7)'-8
''''	my=(Hh/8)'-9
''''	If my>mx Then 
''''		my=mx
''''	End If
''''	
''''	If ((my*9)+10dip)>Hh Then
''''		my=((Hh-10dip)/9)
''''	End If
''''	
''''	tx=(Ww-((mx*7)+8dip)) / 2
''''	ty=(Hh-((my*9)+8dip)) / 2
''''	
''''	pnlbackGround.Initialize("")
''''	pnlbackGround.Color=ColTable
''''	pnl.addview(pnlbackGround,tx,ty,(mx*7)+8dip, (my*9)+8dip)
''''	pnl.Visible=False
''''	
''''	lblTitle.Initialize("")
''''	pnlbackGround.addView(lblTitle,1dip,1dip,pnlbackGround.Width-2dip, my-6dip)
''''	lblTitle.Gravity=Bit.OR(Gravity.CENTER_VERTICAL, Gravity.CENTER_HORIZONTAL)	
''''	lblTitle.Typeface=Typeface.DEFAULT_BOLD	
''''	lblTitle.Color=Colors.ARGB(255,0,0,0) + ColBackGround
''''	lblTitle.TextColor=Colors.White	
''''		
''''	For i=0 To 6 'Days name buttons
''''		lblDayTitle(i).Initialize ("")
''''		lblDayTitle(i).Color=ColInactive
''''		lblDayTitle(i).Typeface = Typeface.DEFAULT_BOLD
''''		pnlbackGround.AddView(lblDayTitle(i),  (i*mx)+((i+1)*1dip), (2*my)+1dip, mx+2dip, my)
''''	Next
''''	
''''	For j=0 To 5 'Days buttons		
''''		For i=0 To 6	
''''			z = (j*7)+i
''''			btDays(z).Initialize("btnDays")	
''''			btDays(z).tag = 0	
''''			btDays(z).Gravity = Bit.OR(Gravity.Top, Gravity.CENTER_HORIZONTAL)
''''			pnlbackGround.AddView(btDays(z), (i*mx)+((i+1)*1dip), ((j+2)*(my+1dip))+my,  mx,  my) 
'''' 		Next
''''	Next
''''	
''''	btPrevMonth.Initialize("btPrevMonth")
''''	btPrevMonth.Color=ColFunction	
''''	btPrevMonth.Typeface=Typeface.DEFAULT_BOLD
''''	btPrevMonth.TextColor = Colors.Black
''''	btPrevMonth.Gravity = Bit.OR(Gravity.CENTER_VERTICAL, Gravity.CENTER_HORIZONTAL)
''''	pnlbackGround.AddView(btPrevMonth,lblDayTitle(0).Left,my-4dip,(mx*1.5),my+4dip)
''''	
''''	btNextMonth.Initialize("btNextMonth")
''''	btNextMonth.Color= ColFunction
''''	btNextMonth.TextColor = Colors.Black
''''	btNextMonth.Gravity = Bit.OR(Gravity.CENTER_VERTICAL, Gravity.CENTER_HORIZONTAL)
''''	btNextMonth.Typeface=Typeface.DEFAULT_BOLD
''''	pnlbackGround.AddView(btNextMonth,(mx*5.5)+7dip,my-4dip,(mx*1.5),my+4dip)
''''	
''''	SpYearsChoice.Initialize("SpYearsChoice")
''''	SpYearsChoice.Color=ColFunction
''''	pnlbackGround.AddView(SpYearsChoice,btPrevMonth.Width+2dip, my-4dip, (mx*4)+4dip,my+4dip)
''''    SpYearsChoice.Visible = False
''''	
''''		
''''	'********** Hide the spinner (visible = false) and setup the label to do the work **************	
''''	spLabel.Initialize("SpLabel") ' SpLabel click event actually calls the spinner event - see next sub below  
''''	spLabel.Color=ColFunction
''''	spLabel.TextColor = Colors.Black
''''	pnlbackGround.AddView(spLabel,btPrevMonth.Width+2dip, my-4dip, (mx*4)+4dip,my+4dip)
''''	' ********** Label takes the same space as spinner ******************
''''	
''''	
''''	
''''	For i=0 To 6		
''''		lblDayTitle(i).Text=Nmday(i)
''''	Next
''''	
''''	For i = SD To ED 'years in Spinner
''''		SpYearsChoice.add(i)		
''''	Next
''''	
''''	PrintDate(BeginDate)	
''''End Sub
''''
''''
''''
''''
''''' **** Label click calls spinner click - Thanks to Erel the genius
''''Private Sub SpLabel_click
''''
''''	Dim r As Reflector
''''	r.Target = SpYearsChoice
''''	r.RunMethod("performClick")
''''
''''End Sub
''''
''''
''''
''''
''''Public Sub ShowCalendar(b As Boolean)
''''	pnl.Visible=b	
''''End Sub
''''
''''Public Sub Nmday(n As Int) As String
''''	Dim S As String
''''	S=NmFullday(n+1)
''''	Return S.SubString2(0,3)
''''End Sub
''''
''''Private Sub PrintDate(dts As Long)
''''	Dim nbj,nday As Int
''''	Dim mn1,mn2 As Int
''''	Dim cdd, cmm, caa As Int
''''	
''''	cdd=DateTime.GetDayOfMonth(DateTime.Now)
''''	cmm=DateTime.GetMonth(DateTime.Now)
''''	caa=DateTime.GetYear(DateTime.Now)
''''	
''''	CalDay   = DateTime.GetDayOfMonth(dts)	
''''	CalYear  = DateTime.GetYear(dts)	
''''	CalMonth = DateTime.GetMonth(dts)
''''	
''''	SpYearsChoice.TextSize=(RelativTextSize*0.87) '14
''''	SpYearsChoice.SelectedIndex=(CalYear-SD)	
''''
''''
''''' ****  Here we set the label to spinner's selected value *********  
''''	spLabel.TextSize=(RelativTextSize*0.87) '14
''''	spLabel.Gravity = Bit.OR(Gravity.CENTER_VERTICAL, Gravity.CENTER_HORIZONTAL)
''''	spLabel.Text    = SpYearsChoice.SelectedItem '  (CalYear-SD)	
''''	spLabel.Typeface = Typeface.DEFAULT_BOLD
''''' *****************************************************************
''''	
''''	
''''	lblTitle.TextSize=RelativTextSize
''''	lblTitle.Text=NmFullMonth(CalMonth-1)  & "  " & CalDay& "  " & CalYear	
''''	
''''	For mn1=0 To 6
''''		lblDayTitle(mn1).TextSize=(RelativTextSize*0.75) '12		
''''	Next
''''		
''''	mn1=CalMonth-1 'prev month
''''	If mn1<1 Then mn1=12
''''	btPrevMonth.TextSize=(RelativTextSize*0.87) '14
''''	btPrevMonth.Text=NmMonth(mn1-1)
''''	
''''	mn2=CalMonth+1 'next month
''''	If mn2>12 Then mn2=1
''''	btNextMonth.TextSize=(RelativTextSize*0.87) '14
''''	btNextMonth.Text=NmMonth(mn2-1)
''''	
''''	nbj= LengthMonth(CalYear,CalMonth)
''''	SomeTime = DateTime.DateParse(CalMonth & "/01/" & CalYear)
''''	
''''	nday = (DateTime.GetDayOfWeek(SomeTime)-1)
''''	
''''	Dim i,nb As Int
''''	nb=nday
''''	
''''	If nb=0 Then nb=7 'decal next line dim 1
''''	
''''	For i=0 To 41 
''''		btDays(i).TextColor=Colors.Black
''''		btDays(i).Color=ColActive
''''		btDays(i).Typeface=Typeface.DEFAULT
''''		btDays(i).Text=""	
''''		btDays(i).Tag=0
''''		btDays(i).TextSize = (RelativTextSize*0.87)
''''	Next	
''''	
''''	Dim z As Int	
''''	For i=(nb) To (nb-1+nbj)
''''		z = i-nb+1
''''		btDays(i).Typeface=Typeface.DEFAULT_BOLD
''''		btDays(i).Text=z	
''''		btDays(i).Tag=z
''''		
''''		'SetdayColor(cmm,caa,cdd,z,i)
''''		
''''		If (cmm=CalMonth) AND (caa=CalYear) Then
''''			If (z=cdd) Then
''''				btDays(i).Color=ColFunction
''''			End If
''''		End If
''''	Next
''''	
''''	Dim m2,m3 As Int
''''	
''''	m2=LengthMonth(CalYear,mn1)
''''	m3=m2-(nb-1)
''''	For i=0 To (nb-1) 'Prev month
''''		btDays(i).TextColor=ColInactive		
''''		btDays(i).Text=m3+i	
''''		btDays(i).Tag=100+m3+i	
''''	Next
''''	
''''	For i=(nb+nbj) To 41 'Next month
''''		btDays(i).TextColor=ColInactive
''''		btDays(i).Text=i-(nb+nbj)+1
''''		btDays(i).Tag=200+(i-(nb+nbj)+1)
''''	Next
''''	
''''End Sub
''''
''''
''''
''''
''''Public Sub LengthMonth(An,Mois As Int) As Int
''''	Dim i As Int
''''	
''''	If Mois=1 Then
''''		i=31
''''	Else If Mois=2 Then
''''		If (An Mod 4)=0 Then
''''			i=29
''''		Else
''''			i=28
''''		End If
''''	Else If Mois=3 Then
''''		i=31
''''	Else If Mois=4 Then
''''		i=30
''''	Else If Mois=5 Then
''''		i=31
''''	Else If Mois=6 Then
''''		i=30
''''	Else If Mois=7 Then
''''		i=31
''''	Else If Mois=8 Then
''''		i=31
''''	Else If Mois=9 Then
''''		i=30
''''	Else If Mois=10 Then
''''		i=31
''''	Else If Mois=11 Then
''''		i=30
''''	Else If Mois=12 Then
''''		i=31
''''	End If
''''	
''''	Return i
''''End Sub
''''
''''Public Sub AsView As View
''''Return pnl
''''End Sub
''''
''''Private Sub btPrevMonth_Click
''''	Dim mm,aa As Int
''''	
''''	mm=CalMonth-1
''''	aa=CalYear
''''	If mm<1 Then 
''''		mm=12
''''		aa=aa-1
''''	End If
''''	CalMonth = mm
''''	CalYear  = aa
''''	SomeTime = DateTime.DateParse(mm & "/01/" & aa)
''''	PrintDate(SomeTime)
''''End Sub
''''
''''Private Sub SpYearsChoice_ItemClick (Position As Int, Value As Object)
''''	CalYear=Position+SD
''''	SomeTime = DateTime.DateParse(CalMonth & "/" & CalDay & "/" & CalYear)
''''	PrintDate(SomeTime)
''''End Sub
''''
''''Public Sub SetTextSize(value As Int)
''''	RelativTextSize = value
''''	PrintDate(DateTime.DateParse(CalMonth & "/" & CalDay & "/" & CalYear))
''''End Sub
''''
''''Public Sub SetBackGroundColor(vColor As Int)
''''	ColBackGround = vColor
''''	pnl.Color=vColor
''''End Sub
''''
''''Public Sub SetTableColor(vColor As Int)
''''	ColTable = vColor
''''	pnlbackGround.Color=vColor
''''End Sub
''''
''''Public Sub SetActiveButtonColor(vColor As Int)
''''	Dim i As Int
''''	ColActive = vColor
''''	For i=0 To 41 
''''		btDays(i).Color = vColor		
''''	Next		
''''End Sub
''''
''''Public Sub SetFunctionButtonColor(vColor As Int)
''''	ColFunction=vColor
''''	btNextMonth.Color = vColor
''''	btPrevMonth.Color = vColor
''''	SpYearsChoice.Color = vColor
''''End Sub
''''
''''Public Sub SetInactiveButtonColor(vColor As Int)	
''''	Dim i As Int	
''''	ColInactive = vColor
''''	For i=0 To 6
''''		lblDayTitle(i).Color = vColor	
''''	Next	
''''End Sub
''''
''''Private Sub btNextMonth_Click
''''	Dim mm,aa As Int
''''	
''''	mm=CalMonth+1
''''	aa=CalYear
''''	If mm>12 Then 
''''		mm=1
''''		aa=aa+1
''''	End If
''''	CalMonth = mm
''''	CalYear  = aa
''''	SomeTime = DateTime.DateParse(mm & "/01/" & aa)
''''	PrintDate(SomeTime)
''''End Sub
''''
''''
''''Private Sub DayPress As Boolean
''''
''''	Dim v As Label 'Button
''''	Dim mm,aa,dd As Int
''''	
''''	v = Sender
''''	dd=v.tag
''''	aa=CalYear
''''	mm=CalMonth
''''	
''''	If (dd>100) AND (dd<200) Then 'prev month
''''	   Return False
''''	Else If (dd>200) Then 'next month
''''	   Return False
''''	End If
''''	
''''	SomeTime = DateTime.DateParse(mm & "/" & dd & "/" & aa)
''''    lblTitle.Text=NmFullMonth(CalMonth-1)  & "  " & dd& "  " & aa	
''''    Return True
''''
''''End Sub
''''
''''
''''Private Sub btnDays_Click
''''
''''	If SubExists(CallBack, EventName & "_ItemLongClick") Then
''''       DayPress	
''''	End If
''''	
''''End Sub
''''
''''Private Sub btnDays_Down
''''
''''	If SubExists(CallBack, EventName & "_ItemLongClick") Then
''''       DayPress	
''''	End If
''''	
''''End Sub
''''
''''Private Sub btnDays_LongClick
''''	Dim SomeTime As Long
''''
''''	If SubExists(CallBack, EventName & "_ItemLongClick") Then
''''       If DayPress Then
''''	      CallSub2( CallBack, EventName & "_ItemLongClick",SomeTime)	
''''	   End If
''''	End If
''''	
''''End Sub