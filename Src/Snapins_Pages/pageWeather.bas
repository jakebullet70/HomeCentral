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
	
	'--- weather	
	Private pnlCurrent As B4XView
	Private lblCurrentHigh As B4XView
	Private lblCurrDesc As B4XView
	Private lblCurrTXT As B4XView
	Private lblLocation As B4XView
	Private btnCurrTemp As B4XView
	Private imgCurrent As lmB4XImageViewX
	Private lblFeelsLike As B4XView
	'---
	
	'--- scroll panel forcast days
	Private imgForecastIcon1 As lmB4XImageViewX
	Private lblForecastDay1 As B4XView
	Private lblForecastDesc1 As B4XView
	Private lblForecastHigh1 As B4XView
	Private lblForecastLow1 As B4XView

	
	Private lvForecast As CustomListView
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pageWeatherBase")
	pnlCurrent.LoadLayout("viewWeatherCurrent")
	'pnlCurrent.SetLayoutAnimated(0,0,0,pnlCurrent.Width,)
	
	B4XPages.MainPage.EventGbl.Subscribe(gblConst.EVENT_WEATHER_UPDATED,Me, "WeatherData_RefreshScrn")
	B4XPages.MainPage.EventGbl.Subscribe(gblConst.EVENT_WEATHER_UPDATE_FAILED,Me, "WeatherData_Fail")
	
	guiHelpers.SetPanelsTranparent(Array As B4XView(pnlCurrent))
	guiHelpers.SetEnableDisableColorBtnNoBoarder(Array As B4XView(btnCurrTemp))
	
	'BuildSide_Menu
	imgCurrent.Bitmap = XUI.LoadBitmap(File.DirAssets, "no weather.png")
	
	guiHelpers.SetTextColor(Array As B4XView(lblCurrentHigh,lblCurrTXT,lblCurrDesc,lblLocation,lblFeelsLike),clrTheme.txtNormal)

	btnCurrTemp.TextSize = 54
	
End Sub

'-------------------------------

Public Sub Set_focus()
	Menus.SetHeader("Weather","main_menu_weather.png")
	pnlMain.SetVisibleAnimated(500,True)
	mpage.tmrTimerCallSub.CallSubDelayedPlus(Me,"Build_Side_Menu",250)
	WeatherData_RefreshScrn
End Sub

Public Sub Lost_focus()
	pnlMain.SetVisibleAnimated(500,False)
End Sub

Private Sub Build_Side_Menu()
	
	Dim ll() As String = Regex.Split(";;", Main.kvs.Get(gblConst.INI_WEATHER_CITY_LIST))
	Dim DefCity As String  = Main.kvs.Get(gblConst.INI_WEATHER_DEFAULT_CITY)
	
	Dim mnus As List : 	mnus.Initialize
	mnus.Add("Refresh") 
	mnus.Add(DefCity)

	For x = 0 To ll.Length - 1
		If ll(x) <> DefCity Then
			mnus.Add(ll(x))
		End If
	Next
	
	Menus.BuildSideMenu(mnus, objHelpers.CopyObject(mnus))
	
End Sub

'=============================================================================================
'=============================================================================================
'=============================================================================================

Private Sub WeatherData_BeforeUpdated
	guiHelpers.ResizeText("Updating weather...", lblCurrDesc)
End Sub

Sub WeatherData_Fail
	guiHelpers.ResizeText("Error, trying again in 1 minute", lblLocation)
End Sub

Sub WeatherData_RefreshScrn
	
	If pnlMain.Visible = False Then Return
	If B4XPages.MainPage.DebugLog Then Log("WeatherData_RefreshScrn")
	
	Sleep(0)
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
			  "Sunrise: " & mpage.WeatherData.ForcastDays(0).Sunrise &  " - Sunset: " & mpage.WeatherData.ForcastDays(0).Sunset & CRLF & _
			  "Last Updated At: " &  mpage.oClock.FormatTime(mpage.WeatherData.LastUpdatedAt)
	
	
	guiHelpers.ResizeText(mpage.WeatherData.qDescription, lblCurrDesc)
	guiHelpers.ResizeText(mpage.WeatherData.qLocation, lblLocation)
	guiHelpers.ResizeText(details.Trim, lblCurrTXT)
	guiHelpers.ResizeText("High " & highTemp   & "  /  Low " & lowTemp, lblCurrentHigh)
	guiHelpers.ResizeText(TempCurr , btnCurrTemp)
	guiHelpers.ResizeText("Feels like: " & FeelsLike , lblFeelsLike)
	
	lblCurrTXT.TextSize = lblCurrTXT.TextSize - 4
	btnCurrTemp.TextSize = btnCurrTemp.TextSize - 9
	
	mpage.WeatherData.LoadWeatherIcon(mpage.WeatherData.ForcastDays(0).IconID ,imgCurrent,mpage.WeatherData.qIsDay)
	
	'SetTextShadow(btnCurrTemp.As(Button). , 1, 1, 1,  XUI.Color_ARGB(255, 0, 0, 0))
	
'	If mpage.WeatherData.lastUpdatedAt <> lastWeatherCall Then
'		lastWeatherCall = mpage.WeatherData.lastUpdatedAt
'	End If

	lvForecast.Clear
	Dim size As Int = lvForecast.AsView.Height / 3
	lvForecast.Add(CreateListItemWeather(0,lvForecast.AsView.Width,size),"0")
	lvForecast.Add(CreateListItemWeather(1,lvForecast.AsView.Width,size),"1")
	lvForecast.Add(CreateListItemWeather(2,lvForecast.AsView.Width,size),"2")
	Sleep(0)

End Sub

Private Sub btnCurrTemp_Click
	mpage.useCel = Not (mpage.useCel)
	WeatherData_RefreshScrn
End Sub

Private Sub CreateListItemWeather(arrID As Int, Width As Int, Height As Int) As B4XView
	
	Try
	
		Dim p As B4XView = XUI.CreatePanel("")
		p.SetLayoutAnimated(0, 0, 0,Width, Height)
		p.LoadLayout("viewWeatherForcast")
		guiHelpers.SetTextColor(Array As B4XView(lblForecastLow1,lblForecastHigh1,lblForecastDay1,lblForecastDesc1),clrTheme.txtNormal)
	
		Dim lowTemp,highTemp As String
		highTemp  = "High " & IIf(mpage.useCel, mpage.WeatherData.ForcastDays(arrID).High_c & "°c",mpage.WeatherData.ForcastDays(arrID).High_f & "°f")
		lowTemp   = "Low " & IIf(mpage.useCel, mpage.WeatherData.ForcastDays(arrID).Low_c & "°c",mpage.WeatherData.ForcastDays(arrID).Low_f & "°f")
	
		mpage.WeatherData.LoadWeatherIcon(mpage.WeatherData.ForcastDays(arrID).IconID , imgForecastIcon1, True)
	
		lblForecastDay1.Text   = mpage.WeatherData.ForcastDays(arrID).Day
		lblForecastDesc1.Text = mpage.WeatherData.ForcastDays(arrID).Description
		lblForecastHigh1.Text  = highTemp
		lblForecastLow1.Text  = lowTemp
		
	Catch
		Log(LastException)
	End Try
	
	Return p
End Sub

Private Sub Page_Setup
	Dim o As dlgSetupWeather : o.Initialize(mpage.Dialog)
	o.Show
End Sub

Private Sub SideMenu_ItemClick (Index As Int, Value As Object)
	Try
		Select Case  Value
			Case "Refresh"
				guiHelpers.Show_toast("Refreshing Weather")
				CallSubDelayed(mpage.WeatherData,"Try_Update")
			Case Else
				CallSubDelayed2(mpage.WeatherData,"Update_Weather",Value)
		End Select
		mpage.pnlSideMenu.SetVisibleAnimated(380, False) '---  close side menu
	Catch
		Log(LastException)
	End Try
	
End Sub

