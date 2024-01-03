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
	Private lblCurrentHigh As B4XView
	Private lblCurrentLow As B4XView
	Private lblCurrTXT As B4XView
	Private lblLocation As B4XView
	Private imgCurrent As lmB4XImageViewX
	Private lastWeatherCall As Long
	Private btnCurrTemp As B4XView
	'---

	Private lblCurrentHigh As B4XView
	Private lblCurrentLow As B4XView
	Private lblCurrDesc As B4XView
	Private pnlCurrentQuickInfo As B4XView
	
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pageHomeBase")
	pnlWeather.LoadLayout("viewWeatherCurrent")
	
	Main.EventGbl.Subscribe(cnst.EVENT_CLOCK_CHANGE, Me,"clock_event")
	
	guiHelpers.SetPanelsTranparent(Array As B4XView(pnlWeather,pnlClock,pnlCal))
	
	'BuildSide_Menu
	
	'--- weather stuff
	Main.EventGbl.Subscribe(cnst.EVENT_WEATHER_UPDATED,Me, "WeatherData_RefreshScrn")
	Main.EventGbl.Subscribe(cnst.EVENT_WEATHER_UPDATE_FAILED,Me, "WeatherData_Fail")
	
	guiHelpers.SetEnableDisableColorBtnNoBoarder(Array As B4XView(btnCurrTemp))
	guiHelpers.SetTextColor(Array As B4XView(lblCurrentHigh,lblCurrentLow, lblLocation,lblCurrTXT,lblClock),themes.clrTxtNormal)
	
	imgCurrent.Bitmap = XUI.LoadBitmap(File.DirAssets, "no weather.png")
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
	Main.tmrTimerCallSub.CallSubDelayedPlus(Me,"Build_Cal",800)
	
End Sub
#end if

Public Sub Set_focus()
	Menus.SetHeader("Home","main_menu_home.png")
	pnlMain.SetVisibleAnimated(500,True)
	mpage.oClock.Update_Scrn 'UpdateDateTime
	WeatherData_RefreshScrn
	Main.tmrTimerCallSub.CallSubDelayedPlus(Me,"Build_Cal",300)
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
	
		
	Dim lowTemp,highTemp,TempCurr,Precipitation,WindSpeed As String
	TempCurr     = IIf(mpage.useCel, mpage.WeatherData.qTemp_c & "°c",mpage.WeatherData.qTemp_f & "°f")
	highTemp      = IIf(mpage.useCel, mpage.WeatherData.ForcastDays(0).High_c & "°c",mpage.WeatherData.ForcastDays(0).High_f & "°f")
	lowTemp       = IIf(mpage.useCel, mpage.WeatherData.ForcastDays(0).Low_c & "°c",mpage.WeatherData.ForcastDays(0).Low_f & "°f")
	Precipitation = IIf(mpage.useMetric, mpage.WeatherData.qPrecipitation_mm & "mm",mpage.WeatherData.qPrecipitation_inches & "inches")
	WindSpeed   = IIf(mpage.useMetric, mpage.WeatherData.qWindSpeed_kph & "Kph" ,mpage.WeatherData.qWindSpeed_mph & "Mph")
	
	Dim details As String =   _
			  "Precipitation: " & Precipitation & CRLF & _	
			  "Humidity: " & mpage.WeatherData.qHumidity & "%" & CRLF & _
			  "Pressure: " & mpage.WeatherData.qPressure  & CRLF & _
			  "Wind Speed: " & WindSpeed  & CRLF & _
			  "Wind Direction: " & mpage.WeatherData.qWindDirection & CRLF & _
			  "Cloud Cover: " & mpage.WeatherData.qCloudCover & "%" & CRLF & _
			  "Sunrise: " & mpage.WeatherData.ForcastDays(0).Sunrise &  " - Sunset: " & mpage.WeatherData.ForcastDays(0).Sunset
	
	guiHelpers.ResizeText(mpage.WeatherData.qDescription, lblCurrDesc)
	guiHelpers.ResizeText(details, lblCurrTXT)
	guiHelpers.ResizeText("High: " & highTemp, lblCurrentHigh)
	guiHelpers.ResizeText("Low: " & lowTemp, lblCurrentLow)
	guiHelpers.ResizeText(mpage.WeatherData.qLocation, lblLocation)
	guiHelpers.ResizeText(TempCurr , btnCurrTemp)
	
	#if b4a
	lblCurrTXT.TextSize = lblCurrTXT.TextSize - 4
	#end if

	#if b4j
	'https://www.b4x.com/android/forum/threads/multiline-labels-text-alignment.95494/#content
	Dim jo As JavaObject = lblCurrTXT.As(Label)
	jo.RunMethod("setTextAlignment", Array("CENTER"))
	'--------- these will be auto sized in Android
	lblLocation.TextSize = IIf(lblLocation.Text.Length < 20,40,24)
	lblCurrDesc.TextSize = IIf(lblLocation.Text.Length < 24,34,22)
	#end if
	
	
	'guiHelpers.ResizeText(mpage.WeatherData.qLocation, lblLocation)  TODO
	
	CallSubDelayed3(mpage.WeatherData,"GetWeather_Icon2",mpage.WeatherData.ForcastDays(0).IconID,imgCurrent)
	
	'fn.SetTextShadow(lblCurrTemp, 1, 1, 1, Colors.ARGB(255, 0, 0, 0))
	
'	If mpage.WeatherData.lastUpdatedAt <> lastWeatherCall Then
'		lastWeatherCall = mpage.WeatherData.lastUpdatedAt
'	End If
	Return
	
'	
'	Dim lowTemp,highTemp,TempCurr,Precipitation,WindSpeed As String
'	TempCurr     = IIf(mpage.useCel, mpage.WeatherData.qTemp_c & "°c",mpage.WeatherData.qTemp_f & "°f")
'	highTemp      = IIf(mpage.useCel, mpage.WeatherData.ForcastDays(0).High_c & "°c",mpage.WeatherData.ForcastDays(0).High_f & "°f")
'	lowTemp       = IIf(mpage.useCel, mpage.WeatherData.ForcastDays(0).Low_c & "°c",mpage.WeatherData.ForcastDays(0).Low_f & "°f")
'	Precipitation = IIf(mpage.useMetric, mpage.WeatherData.qPrecipitation_mm & "mm",mpage.WeatherData.qPrecipitation_inches & "inches")
'	WindSpeed   = IIf(mpage.useMetric, mpage.WeatherData.qWindSpeed_kph & "Kph" ,mpage.WeatherData.qWindSpeed_mph & "Mph")
'	
'	Dim details As String =   _
'			  "Precipitation: " & Precipitation & CRLF & _	
'			  "Humidity: " & mpage.WeatherData.qHumidity & "%" & CRLF & _
'			  "Pressure: " & mpage.WeatherData.qPressure  & CRLF & _
'			  "Wind Speed: " & WindSpeed  & CRLF & _
'			  "Wind Direction: " & mpage.WeatherData.qWindDirection & CRLF & _
'			  "Cloud Cover: " & mpage.WeatherData.qCloudCover & "%" & CRLF & _
'			  "Sunrise: " & mpage.WeatherData.ForcastDays(0).Sunrise &  " - Sunset: " & mpage.WeatherData.ForcastDays(0).Sunset
'	
'	'guiHelpers.ResizeText(mpage.WeatherData.qDescription, lblCurrDesc)
'	guiHelpers.ResizeText(details,lblCurrTXT)
'	guiHelpers.ResizeText("Low: " & lowTemp & " / High: " & highTemp, lblHighLowTemps)
'	#if b4a
'	lblCurrTXT.TextSize = lblCurrTXT.TextSize - 4
'	#end if
'		
'	guiHelpers.ResizeText(TempCurr , btnCurrTemp)
'	guiHelpers.ResizeText(mpage.WeatherData.qLocation, lblLocation)
'	
'	CallSubDelayed3(mpage.WeatherData,"GetWeather_Icon2",mpage.WeatherData.ForcastDays(0).IconID,imgCurrent)
'	
'	'fn.SetTextShadow(lblCurrTemp, 1, 1, 1, Colors.ARGB(255, 0, 0, 0))
'	
'	If mpage.WeatherData.lastUpdatedAt <> lastWeatherCall Then
'		lastWeatherCall = mpage.WeatherData.lastUpdatedAt
'	End If
'	
'	#if b4j
'	'https://www.b4x.com/android/forum/threads/multiline-labels-text-alignment.95494/#content
'	Dim jo As JavaObject = lblCurrTXT.As(Label)
'	jo.RunMethod("setTextAlignment", Array("CENTER"))
'	#end if

End Sub


Sub WeatherData_Fail
	guiHelpers.ResizeText("Error, trying again in 1 minute", lblLocation)
End Sub

Private Sub btnCurrTemp_Click
	mpage.useCel = Not (mpage.useCel)
	WeatherData_RefreshScrn	
End Sub