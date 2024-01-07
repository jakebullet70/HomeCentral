B4J=true
Group=Pages-Snapins
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
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private pnlMain As B4XView
	Private csCal As CustomCalendar
	
	Private pnlClock As B4XView
	Private pnlCal As B4XView
	Private lblClock As B4XView
	
	'--- weather crap
	Private lblFeelsLike As B4XView
	Private pnlCurrent As B4XView
	Private lblCurrentHigh As B4XView
	Private lblCurrDesc As B4XView
	Private lblCurrTXT As B4XView
	Private lblLocation As B4XView
	Private btnCurrTemp As B4XView
	Private imgCurrent As lmB4XImageViewX	
	'---

	Private pnlCurrent As B4XView
	
	
End Sub



Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pageHomeBase")
	pnlCurrent.LoadLayout("viewWeatherCurrent")
	'pnlCurrent.SetLayoutAnimated(0,0,0,pnlCurrent.Width,pnlCurrent.Height-50dip)
	
	'--- weather stuff
	Main.EventGbl.Subscribe(cnst.EVENT_WEATHER_UPDATED,Me, "WeatherData_RefreshScrn")
	Main.EventGbl.Subscribe(cnst.EVENT_WEATHER_UPDATE_FAILED,Me, "WeatherData_Fail")
	Main.EventGbl.Subscribe(cnst.EVENT_CLOCK_CHANGE, Me,"clock_event")
	
	guiHelpers.SetPanelsTranparent(Array As B4XView(pnlClock,pnlCal))
	
	'BuildSide_Menu
	
	guiHelpers.SetEnableDisableColorBtnNoBoarder(Array As B4XView(btnCurrTemp))
	guiHelpers.SetTextColor(Array As B4XView(lblCurrentHigh, lblLocation,lblCurrTXT,lblClock,lblFeelsLike),themes.clrTxtNormal)
	
	imgCurrent.Bitmap = XUI.LoadBitmap(File.DirAssets, "no weather.png")
	guiHelpers.ResizeText("     Getting Weather Data...     ",lblCurrTXT)
	
	If (mpage.WeatherData.IsWeatherUpToDate = True) Then
		WeatherData_RefreshScrn
	Else
		mpage.WeatherData.Try_Update
	End If
	btnCurrTemp.TextSize = 50
	
	#if b4j
	'https://www.b4x.com/android/forum/threads/multiline-labels-text-alignment.95494/#content
	Dim jo As JavaObject = lblCurrTXT.As(Label)
	jo.RunMethod("setTextAlignment", Array("CENTER"))
	#End If
	
End Sub

'-------------------------------
#if b4j
Public Sub resize_me (width As Double, height As Double)
	If width <> 0 Then
		pnlMain.width = width
		pnlMain.height = height
		Main.tmrTimerCallSub.ExistsRemoveAdd_DelayedPlus2(Me,"Build_Cal",800,Null)
	End If
End Sub
#end if

Public Sub Set_focus()
	#if b4j
	resize_me(mpage.snapInWidth,mpage.snapInHeight)
	#end if
	Menus.SetHeader("Home","main_menu_home.png")
	pnlMain.SetVisibleAnimated(500,True)
	mpage.oClock.Update_Scrn 'UpdateDateTime
	WeatherData_RefreshScrn
	Main.tmrTimerCallSub.CallSubDelayedPlus(Me,"Build_Cal",200)
End Sub

Public Sub Lost_focus()
	pnlMain.SetVisibleAnimated(500,False)
End Sub

Private Sub Page_Setup
	guiHelpers.Show_toast2("TODO",3500)
End Sub

Public Sub clock_event(s As String)
	If pnlMain.Visible = False Then Return
	guiHelpers.ResizeText(s,lblClock)
End Sub

'=============================================================================================
'=============================================================================================
'=============================================================================================


Private Sub Build_Cal()
	'--- show cal
	pnlCal.RemoveAllViews
	csCal.Initialize(pnlCal.Width,pnlCal.Height,DateTime.Now,16dip * guiHelpers.SizeFontAdjust)
	csCal.callback = Me
	csCal.eventName = "Cal"
'	If g.IsCalendarReadOn Then
'		If csCal.oCalDaysMAP.Size <> 0 Then
'			csCal.PaintHighLightDays(Map2IntArray(csCal.oCalDaysMAP),g.GetColorTheme(g.ehome_clrTheme,"highlightText"))
'		End If
'	End If
	pnlCal.AddView(csCal.AsView.As(B4XView) ,0,0,pnlCal.Width,pnlCal.Height)
	'pnlCal.AddView(csCal.,0,0,100%x,100%y)
	csCal.ShowCalendar(True)
End Sub

Sub WeatherData_RefreshScrn
		
	Dim lowTemp,highTemp,TempCurr,Precipitation,WindSpeed,FeelsLike As String
	TempCurr     = IIf(mpage.useCel, mpage.WeatherData.qTemp_c & "°c",mpage.WeatherData.qTemp_f & "°f")
	highTemp      = IIf(mpage.useCel, mpage.WeatherData.ForcastDays(0).High_c & "°",mpage.WeatherData.ForcastDays(0).High_f & "°")
	lowTemp       = IIf(mpage.useCel, mpage.WeatherData.ForcastDays(0).Low_c & "°",mpage.WeatherData.ForcastDays(0).Low_f & "°")
	Precipitation = IIf(mpage.useMetric, mpage.WeatherData.qPrecipitation_mm & "mm",mpage.WeatherData.qPrecipitation_inches & "inches")
	WindSpeed   = IIf(mpage.useMetric, mpage.WeatherData.qWindSpeed_kph & "km/h" ,mpage.WeatherData.qWindSpeed_mph & "mph")
	FeelsLike      = IIf(mpage.useCel, mpage.WeatherData.qFeelsLike_c & "°",mpage.WeatherData.qFeelsLike_f & "°")
	
	Dim details As String =   _
			  "Precipitation: " & Precipitation & CRLF & _	
			  "Humidity: " & mpage.WeatherData.qHumidity & "%" & CRLF & _
			  "Pressure: " & mpage.WeatherData.qPressure  & CRLF & _
			  "Wind Speed: " & WindSpeed  & CRLF & _
			  "Wind Direction: " & mpage.WeatherData.qWindDirection & CRLF & _
			  "Cloud Cover: " & mpage.WeatherData.qCloudCover & "%" & CRLF & _
			  "Sunrise: " & mpage.WeatherData.ForcastDays(0).Sunrise &  " - Sunset: " & mpage.WeatherData.ForcastDays(0).Sunset
	
	guiHelpers.ResizeText(mpage.WeatherData.qDescription, lblCurrDesc)
	guiHelpers.ResizeText(details.Trim, lblCurrTXT)
	guiHelpers.ResizeText("High " & highTemp   & "  /  Low " & lowTemp, lblCurrentHigh)
	guiHelpers.ResizeText(mpage.WeatherData.qLocation, lblLocation)
	guiHelpers.ResizeText(TempCurr , btnCurrTemp)
	guiHelpers.ResizeText("Feels like: " & FeelsLike , lblFeelsLike)
	
	#if b4a
	lblCurrTXT.TextSize = lblCurrTXT.TextSize - 4
	#else if b4j
	'--------- these will be auto sized in Android
	lblLocation.TextSize = IIf(lblLocation.Text.Length < 20,38,24)
	lblCurrDesc.TextSize = IIf(lblCurrDesc.Text.Length < 24,38,22)
	lblCurrentHigh.TextSize = 20
	lblCurrTXT.TextSize = 18		
	#end if
	
'	Try
'		Dim jo As JavaObject = lblLocation.As(Label)
'		jo.RunMethod("setEllipsisString", Array("/003"))
'		lblLocation.Text = "string - make me fit, OK? - do I overflow? please! -- BIG string - make me fit, OK? - do I overflow? please!  -- BIG string - make me fit, OK? - do I overflow? please!"
'		lblLocation.TextSize = 30
'		Sleep(100)
'		Dim jo1 As JavaObject = lblLocation.As(Label)
'		Log(jo1.RunMethodjo("lookup", Array As Object(".text")))
'		Dim jl As JavaObject = (jo1.RunMethodjo("lookup", Array As Object(".text")))
'		Log(jl.As(String))
'		'Log(jl.RunMethodjo("getText",Null))
'				
'		'Log(out.As(String).Contains("\003"))
'		'Log(out.As(String).Contains(Chr(3)))
'		
'	Catch
'		
'		Log(LastException)
'	End Try
	
	
	mpage.WeatherData.LoadWeatherIcon(mpage.WeatherData.ForcastDays(0).IconID ,imgCurrent,mpage.WeatherData.qIsDay)
	
	'SetTextShadow(btnCurrTemp.As(Button). , 1, 1, 1,  XUI.Color_ARGB(255, 0, 0, 0))
	
'	If mpage.WeatherData.lastUpdatedAt <> lastWeatherCall Then
'		lastWeatherCall = mpage.WeatherData.lastUpdatedAt
'	End If

End Sub

Sub WeatherData_Fail
	guiHelpers.ResizeText("Error, trying again in 1 minute", lblLocation)
End Sub

Private Sub btnCurrTemp_Click
	mpage.useCel = Not (mpage.useCel)
	WeatherData_RefreshScrn	
End Sub