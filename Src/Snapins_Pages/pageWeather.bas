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
	Private lblCurrentLow,lblCurrentHigh As B4XView
	Private lblCurrDesc As B4XView
	Private lblCurrTXT As B4XView
	Private lblLocation As B4XView
	Private btnCurrTemp As B4XView
	Private imgCurrent As lmB4XImageViewX
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
	
	Main.EventGbl.Subscribe(cnst.EVENT_WEATHER_UPDATED,Me, "WeatherData_RefreshScrn")
	Main.EventGbl.Subscribe(cnst.EVENT_WEATHER_UPDATE_FAILED,Me, "WeatherData_Fail")
	
	'guiHelpers.SetPanelsTranparent(Array As B4XView(pnlCurrentQuickInfo))
	guiHelpers.SetEnableDisableColorBtnNoBoarder(Array As B4XView(btnCurrTemp))
	
	'BuildSide_Menu
	imgCurrent.Bitmap = XUI.LoadBitmap(File.DirAssets, "no weather.png")
	
	guiHelpers.SetTextColor(Array As B4XView(lblCurrentLow,lblCurrentHigh,lblCurrTXT,lblCurrDesc,lblLocation),themes.clrTxtNormal)

	btnCurrTemp.TextSize = 54
	
	#if b4j
	'https://www.b4x.com/android/forum/threads/multiline-labels-text-alignment.95494/#content
	Dim jo As JavaObject = lblCurrTXT.As(Label)
	jo.RunMethod("setTextAlignment", Array("CENTER"))
	lvForecast.sv.As(ScrollPane).Style="-fx-background:transparent;-fx-background-color:transparent;"
	#End If
	
	lvForecast.sv.As(ScrollPane).SetVScrollVisibility("NEVER")  'scrollbar?
End Sub

'-------------------------------
#if b4j
public Sub resize_me (width As Int, height As Int)
	pnlMain.width = width
	pnlMain.height = height
End Sub
#end if
Public Sub Set_focus()
	#if b4j
	resize_me(mpage.xWidth,mpage.xHeight)
	#end if
	Menus.SetHeader("Weather","main_menu_weather.png")
	pnlMain.SetVisibleAnimated(500,True)
	WeatherData_RefreshScrn
End Sub

Private Sub Page_Setup
	guiHelpers.Show_toast2("TODO",3500)
End Sub
Public Sub Lost_focus()
	pnlMain.SetVisibleAnimated(500,False)
End Sub


'=============================================================================================
'=============================================================================================
'=============================================================================================

Public Sub WeatherData_Fail
	'guiHelpers.ResizeText("Updating failed... Trying again in 1 minute", lblHeader)

End Sub

Public Sub WeatherData_RefreshScrn
	
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
	guiHelpers.ResizeText(details.Trim, lblCurrTXT)
	guiHelpers.ResizeText("High: " & highTemp, lblCurrentHigh)
	guiHelpers.ResizeText("Low: " & lowTemp, lblCurrentLow)
	guiHelpers.ResizeText(mpage.WeatherData.qLocation, lblLocation)
	guiHelpers.ResizeText(TempCurr , btnCurrTemp)
	
	#if b4a
	lblCurrTXT.TextSize = lblCurrTXT.TextSize - 4
	#end if

	#if b4j
	'--------- these will be auto sized in Android
	lblLocation.TextSize = IIf(lblLocation.Text.Length < 20,40,24)
	lblCurrDesc.TextSize = IIf(lblCurrDesc.Text.Length < 24,34,22)
	#end if
	
	CallSubDelayed3(mpage.WeatherData,"GetWeather_Icon2",mpage.WeatherData.ForcastDays(0).IconID,imgCurrent)
	
	'fn.SetTextShadow(lblCurrTemp, 1, 1, 1, Colors.ARGB(255, 0, 0, 0))
	
'	If mpage.WeatherData.lastUpdatedAt <> lastWeatherCall Then
'		lastWeatherCall = mpage.WeatherData.lastUpdatedAt
'	End If

	
	lvForecast.Clear
	lvForecast.Add(CreateListItemWeather(0,480dip,150),"0")
	lvForecast.Add(CreateListItemWeather(1,480dip,160),"1")
	lvForecast.Add(CreateListItemWeather(2,480dip,170),"2")

End Sub


Private Sub btnCurrTemp_Click
	mpage.useCel = Not (mpage.useCel)
	WeatherData_RefreshScrn
End Sub



Private Sub CreateListItemWeather(arrID As Int, Width As Int, Height As Int) As B4XView
	
	Dim p As B4XView = XUI.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0,Width, Height)
	p.LoadLayout("pageWeatherForcast")
	
	Dim lowTemp,highTemp As String
	highTemp  = "High " & IIf(mpage.useCel, mpage.WeatherData.ForcastDays(0).High_c & "°c",mpage.WeatherData.ForcastDays(0).High_f & "°f")
	lowTemp   = "Low" & IIf(mpage.useCel, mpage.WeatherData.ForcastDays(0).Low_c & "°c",mpage.WeatherData.ForcastDays(0).Low_f & "°f")
	
	CallSub3(mpage.WeatherData,"GetWeather_Icon2",mpage.WeatherData.ForcastDays(arrID).IconID,imgForecastIcon1)
	lblForecastDay1.Text = mpage.WeatherData.ForcastDays(arrID).Day
	lblForecastDesc1.Text = mpage.WeatherData.ForcastDays(arrID).Description
	lblForecastHigh1.Text  = highTemp
	lblForecastLow1.Text  = lowTemp
	
	Return p
End Sub