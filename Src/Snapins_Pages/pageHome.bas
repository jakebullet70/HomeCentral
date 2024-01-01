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
	
	Private pnlBase As B4XView
	Private pnlWeather As B4XView
	Private pnlClock As B4XView
	Private pnlCal As B4XView
	Private lblClock As B4XView
	
	'--- weather crap
	Private lblCurrTemp As B4XView
	Private lblCurrTXT As B4XView
	Private lblLocation As B4XView
	Private imgCurrent As lmB4XImageViewX
	Private lastWeatherCall As Long
	'---

	
	Private lblCurrDesc As B4XView
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pageHomeBase")
	
	Main.EventGbl.Subscribe(cnst.EVENT_CLOCK_CHANGE, Me,"clock_event")
	
	pnlWeather.SetColorAndBorder(XUI.Color_Transparent,0,XUI.Color_Transparent,0)
	pnlClock.SetColorAndBorder(XUI.Color_Transparent,0,XUI.Color_Transparent,0)
	pnlCal.SetColorAndBorder(XUI.Color_Transparent,0,XUI.Color_Transparent,0)
	
	'BuildSide_Menu
	lblClock.TextColor = themes.clrTxtNormal
	
	'--- weather stuff
	
	Main.EventGbl.Subscribe(cnst.EVENT_WEATHER_UPDATED,Me, "WeatherData_RefreshScrn")
	Main.EventGbl.Subscribe(cnst.EVENT_WEATHER_UPDATE_FAILED,Me, "WeatherData_Fail")
	
	lblCurrTXT.TextColor = themes.clrTxtNormal
	lblCurrTemp.TextColor = themes.clrTxtNormal
	lblLocation.TextColor = themes.clrTxtNormal
	lblClock.TextColor = themes.clrTxtNormal
	
'	lstViewCalDays.DefaultTextColor = g.GetColorTheme(g.ehome_clrTheme,"themeColorText")
'	lstViewCalDays.DefaultTextBackgroundColor  = Colors.Transparent
'	lstViewCalDays.DefaultTextSize = 16
	
	'CallSubDelayed(Me,"Build_Cal")
	
	
	guiHelpers.ResizeText("     Getting Weather Data...     ",lblCurrTXT)
	
	'If the weather doesn't need an update, then someone else already updated it before we loaded. So refresh our UI.
	If (mpage.WeatherData.IsWeatherUpToDate = True) Then
		WeatherData_RefreshScrn
	Else
		mpage.WeatherData.TryUpdate
	End If
	
	'Init_setup_menu
	
	
End Sub

'-------------------------------
#if b4j
public Sub resize_me (width As Int, height As Int)
	pnlMain.width = width
	pnlMain.height = height
	
	Main.tmrTimerCallSub.ExistsRemove(Me,"Build_Cal")
	Main.tmrTimerCallSub.CallSubDelayedPlus(Me,"Build_Cal",1000)
	
End Sub
#end if

Public Sub Set_focus()
	Menus.SetHeader("Home","main_menu_home.png")
	pnlMain.SetVisibleAnimated(500,True)
	mpage.oClock.Update_Scrn 'UpdateDateTime
	WeatherData_RefreshScrn
	Main.tmrTimerCallSub.CallSubDelayedPlus(Me,"Build_Cal",500)
End Sub

Public Sub Lost_focus()
	pnlMain.SetVisibleAnimated(500,False)
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
	
	Dim useCel As Boolean = Main.kvs.GetDefault(cnst.INI_WEATHER_USE_CELSIUS,True)
	Dim useMetric As Boolean = Main.kvs.GetDefault(cnst.INI_WEATHER_USE_METRIC,False)
	
	Dim lowTemp,highTemp,TempCurr,Precipitation,WindSpeed As String
	TempCurr     = IIf(useCel, mpage.WeatherData.Temp_c & "°c",mpage.WeatherData.Temp_f & "°f")
	highTemp      = IIf(useCel, mpage.WeatherData.ForcastDays(0).High_c & "°c",mpage.WeatherData.ForcastDays(0).High_f & "°f")
	lowTemp       = IIf(useCel, mpage.WeatherData.ForcastDays(0).Low_c & "°c",mpage.WeatherData.ForcastDays(0).Low_f & "°f")
	Precipitation = IIf(useMetric, mpage.WeatherData.Precipitation_mm & "mm",mpage.WeatherData.Precipitation_inches & "inches")
	WindSpeed   = IIf(useMetric, mpage.WeatherData.WindSpeed_kph & "Kph" ,mpage.WeatherData.WindSpeed_mph & "Mph")
	
	Dim details As String = "Low: " & lowTemp & " / High: " & highTemp  & CRLF &  _
			  "Precipitation: " & Precipitation & CRLF & _	
			  "Humidity: " & mpage.WeatherData.Humidity & "%" & CRLF & _
			  "Pressure: " & mpage.WeatherData.Pressure  & CRLF & _
			  "Wind Speed: " & WindSpeed  & CRLF & _
			  "Wind Direction: " & mpage.WeatherData.WindDirection & CRLF & _
			  "Cloud Cover: " & mpage.WeatherData.CloudCover & "%" & CRLF & _
			  "Sunrise: " & mpage.WeatherData.ForcastDays(0).Sunrise &  " - Sunset: " & mpage.WeatherData.ForcastDays(0).Sunset
	
	guiHelpers.ResizeText(mpage.WeatherData.Description, lblCurrDesc)
	guiHelpers.ResizeText(details, lblCurrTXT)
	#if b4a
	lblCurrTXT.TextSize = lblCurrTXT.TextSize - 4
	#end if
		
	guiHelpers.ResizeText(TempCurr , lblCurrTemp)
	guiHelpers.ResizeText(mpage.WeatherData.Location1, lblLocation)
	
	CallSubDelayed3(mpage.WeatherData,"GetWeather_Icon2",mpage.WeatherData.ForcastDays(0).IconID,imgCurrent)
	
	'fn.SetTextShadow(lblCurrTemp, 1, 1, 1, Colors.ARGB(255, 0, 0, 0))
	
	If mpage.WeatherData.lastUpdatedAt <> lastWeatherCall Then
		lastWeatherCall = mpage.WeatherData.lastUpdatedAt
	End If

End Sub


Sub WeatherData_Fail
	guiHelpers.ResizeText("Error, trying again in 1 minute", lblLocation)
End Sub


