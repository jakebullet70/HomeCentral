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
		
	Private pnlCurrentQuickInfo As B4XView
	
	'--- main today forcast view
	Private lblCurrTemp As B4XView
	Private lblCurrentHigh As B4XView
	Private lblCurrentLow As B4XView
	Private lblCurrentDesc As B4XView
	Private lblCurrTXT As B4XView
	Private imgCurrentWeather As lmB4XImageViewX
	
	'--- scroll panel forcast days
	Private imgForecastIcon1 As lmB4XImageViewX
	Private lblForecastDay1 As B4XView
	Private lblForecastDesc1 As B4XView
	Private lblForecastHigh1 As B4XView
	Private lblForecastLow1 As B4XView
	
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pageWeatherBase")
	
	pnlCurrentQuickInfo.SetColorAndBorder(XUI.Color_Transparent,0,XUI.Color_Transparent,0)
	
	imgCurrentWeather.Bitmap = XUI.LoadBitmap(File.DirAssets, "no weather.png")
	
	lblCurrentDesc.TextColor = themes.clrTxtNormal
	lblCurrTXT.TextColor =  themes.clrTxtNormal
	lblCurrTemp.TextColor=  themes.clrTxtNormal
	lblCurrentHigh.TextColor=  themes.clrTxtNormal
	lblCurrentLow.TextColor=  themes.clrTxtNormal
	
	Main.EventGbl.Subscribe(cnst.EVENT_WEATHER_UPDATED,Me, "WeatherData_RefreshScrn")
	Main.EventGbl.Subscribe(cnst.EVENT_WEATHER_UPDATE_FAILED,Me, "WeatherData_Fail")
	
End Sub

'-------------------------------
#if b4j
public Sub resize_me (width As Int, height As Int)
	pnlMain.width = width
	pnlMain.height = height
End Sub
#end if
Public Sub Set_focus()
	Menus.SetHeader("Weather","main_menu_weather.png")
	pnlMain.SetVisibleAnimated(500,True)
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
	
	Dim useCel As Boolean = Main.kvs.GetDefault(cnst.INI_WEATHER_USE_CELSIUS,True)
	Dim useMetric As Boolean = Main.kvs.GetDefault(cnst.INI_WEATHER_USE_METRIC,False)
	
	Dim lowTemp,highTemp,TempCurr,Precipitation,WindSpeed As String
	TempCurr     = IIf(useCel, mpage.WeatherData.qTemp_c & "°c",mpage.WeatherData.qTemp_f & "°f")
	highTemp      = IIf(useCel, mpage.WeatherData.ForcastDays(0).High_c & "°c",mpage.WeatherData.ForcastDays(0).High_f & "°f")
	lowTemp       = IIf(useCel, mpage.WeatherData.ForcastDays(0).Low_c & "°c",mpage.WeatherData.ForcastDays(0).Low_f & "°f")
	Precipitation = IIf(useMetric, mpage.WeatherData.qPrecipitation_mm & "mm",mpage.WeatherData.qPrecipitation_inches & "inches")
	WindSpeed   = IIf(useMetric, mpage.WeatherData.qWindSpeed_kph & "Kph" ,mpage.WeatherData.qWindSpeed_mph & "Mph")
	
	Dim details As String = "Low: " & lowTemp & " / High: " & highTemp  & CRLF &  _
			  "Precipitation: " & Precipitation & CRLF & _	
			  "Humidity: " & mpage.WeatherData.qHumidity & "%" & CRLF & _
			  "Pressure: " & mpage.WeatherData.qPressure  & CRLF & _
			  "Wind Speed: " & WindSpeed  & CRLF & _
			  "Wind Direction: " & mpage.WeatherData.qWindDirection & CRLF & _
			  "Cloud Cover: " & mpage.WeatherData.qCloudCover & "%" & CRLF & _
			  "Sunrise: " & mpage.WeatherData.ForcastDays(0).Sunrise &  " - Sunset: " & mpage.WeatherData.ForcastDays(0).Sunset
	
	guiHelpers.ResizeText(mpage.WeatherData.qDescription, lblCurrDesc)
	guiHelpers.ResizeText(details, lblCurrTXT)
	#if b4a
	lblCurrTXT.TextSize = lblCurrTXT.TextSize - 4
	#end if
		
	guiHelpers.ResizeText(TempCurr , lblCurrTemp)
	guiHelpers.ResizeText(mpage.WeatherData.qLocation, lblLocation)
	
	CallSubDelayed3(mpage.WeatherData,"GetWeather_Icon2",mpage.WeatherData.ForcastDays(0).IconID,imgCurrentWeather)
	
	'fn.SetTextShadow(lblCurrTemp, 1, 1, 1, Colors.ARGB(255, 0, 0, 0))
	
'	If mpage.WeatherData.lastUpdatedAt <> lastWeatherCall Then
'		lastWeatherCall = mpage.WeatherData.lastUpdatedAt
'	End If
	
	#if b4j
	' NOT WORKING!!!!
	'https://www.b4x.com/android/forum/threads/multiline-labels-text-alignment.95494/#content
	Dim jo As JavaObject = lblCurrDesc.As(Label)
	jo.RunMethod("setTextAlignment", Array("CENTER"))
	#end if

End Sub
