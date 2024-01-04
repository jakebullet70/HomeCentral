B4A=true
Group=MiscClasses\Weather
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
'Class module
'https://www.weatherapi.com/docs/
Sub Class_Globals
	Private xui As XUI
	Public IsInitialize As Boolean
	Type typeWeatherCodeData(DayDesc As String, NightDesc As String, IconID As Int)
	
	Public LastUpdatedAt As Long
	Public WeatherKey As String
	Public WeatherAPICodes As Map
	Public WeatherAPIcode As Int
	Public IsError As Boolean
	Public LastErrorMessage As String
	Public LastUpdatedCity As String
	
	'--- quick - current conditions	
	Public qDescription As String
	Public qLocation, qCountry As String
	Public qPrecipitation_mm,qPrecipitation_inches As String
	Public qCloudCover As String
	Public qHumidity As String
	Public qPressure As String
	Public qIsDay As Boolean
	Public qWindDirection As String
	Public qWindSpeed_mph,qWindSpeed_kph As String
	Public qGustSpeed_mph,qGustSpeed_kph As String
	Public qFeelsLike_f,qFeelsLike_c As String
	Public qTemp_f,qTemp_c As String
	Public qVisibility_km,qVisibility_miles As String
	Public qLocalTime As String, qLocalTime_Epoch As Long
		
	Public ForcastDays(3) As clsWeatherDataDay 

	Private tmrErrorInRecievingWeather As Timer
	
End Sub

Sub getIsWeatherUpToDate As Boolean
	If LastUpdatedAt <> 0 And dtHelpers.HoursBetween(DateTime.now, LastUpdatedAt) >= 1 Then
		Return False
	Else
		Return True
	End If
End Sub

'========================  these where in a public aobject ========================
Public Sub GetWeather_Icon2(id As Int, img As lmB4XImageViewX)
	
	If id <= 0 Then Return
	Try
		
		If Not (img.IsInitialized) Then
			img.Initialize("","")
		End If
		
		'Dim daytime As Boolean =  dtHelpers.IsItDayTime(SunriseTime,SunsetTime,LocalTime)
		img.Bitmap =  xui.LoadBitmap(File.DirAssets, _ 
							"weathericon/" & cnst.WEATHERicons & IIf(qIsDay,"/day/","/night/") & id & ".png")
		
	Catch
		Log(LastException)
	End Try
End Sub

'===============================================================

Public Sub Initialize
	IsInitialize = True
	
	LastUpdatedAt = 1
	
	WeatherKey = cnst.WeatherAPIKey
	ReadApiCodes
	
	Main.EventGbl.Subscribe(cnst.EVENT_INET_ON_CONNECT,Me, "Internet_OnConnected")

	tmrErrorInRecievingWeather.Initialize("ErrorGettingWeather",1000 * 60) '--- every 1 minute
	
End Sub

Private Sub ReadApiCodes()
	Dim parser As JSONParser
	parser.Initialize(File.ReadString(File.DirAssets,"weatherAPI_codes.json"))
	Dim root As List = parser.NextArray
	WeatherAPICodes.Initialize
	For Each colroot As Map In root
		Dim m As Map : 	m.Initialize
		Dim o As typeWeatherCodeData
		o.DayDesc = colroot.Get("day")
		o.NightDesc = colroot.Get("night")
		o.IconID = colroot.Get("icon")
		WeatherAPICodes.Put(colroot.Get("code").As(Int),o)
	Next
End Sub

Sub Internet_OnConnected
	TryUpdate
End Sub

Sub	ErrorGettingWeather_Tick
	tmrErrorInRecievingWeather.Enabled = False '--- turn off the timer
	TryUpdateBecauseOfError
End Sub

Public Sub TryUpdate
	If LastUpdatedAt <> 0 Then
		If dtHelpers.HoursBetween(DateTime.now, LastUpdatedAt) >= 1 Then
			If (LastUpdatedCity = "") Then
				Main.EventGbl.Raise(cnst.EVENT_WEATHER_BEFORE_UPDATE)
				Update_Weather_Default_City
			Else
				Main.EventGbl.Raise(cnst.EVENT_WEATHER_BEFORE_UPDATE)
				Update_Weather(LastUpdatedCity)
			End If
		End If
	End If
End Sub

Public Sub TryUpdateBecauseOfError
	If dtHelpers.HoursBetween(DateTime.now, LastUpdatedAt) >= 1 Then
		Main.EventGbl.Raise(cnst.EVENT_WEATHER_BEFORE_UPDATE)
		If (LastUpdatedCity = "") Then
			Update_Weather_Default_City
		Else
			Update_Weather(LastUpdatedCity)
		End If
	End If
End Sub

Private Sub ParseDateStr2Ticks(utc As String) As Long
	'TODO
	Dim df As String = DateTime.DateFormat
	Dim res As Long
	Try
		'2023-12-31 19:45
		DateTime.DateFormat = "yyyy MM dd HH:mm"
		res = DateTime.DateParse(utc)
	Catch
		res = 0
		Log("Error parsing Date 2: " & utc)
	End Try
	DateTime.DateFormat = df
	Return res
End Sub

Private Sub ParseWeatherJob(s As String)
	LastUpdatedAt = DateTime.Now
	
	Dim parser As JSONParser : parser.Initialize(s)
	Dim root As Map = parser.NextObject
	
	Try
		Dim current As Map = root.Get("current")
		qFeelsLike_f  = current.Get("feelslike_f")
		qFeelsLike_c = current.Get("feelslike_c")
		'Dim uv As Double = current.Get("uv")
		'Dim last_updated As String = current.Get("last_updated")
		'Dim wind_degree As Int = current.Get("wind_degree")
		'Dim last_updated_epoch As Int = current.Get("last_updated_epoch")
		qIsDay = fnct.int2bool(current.Get("is_day").As(Int))
		qPrecipitation_inches = current.Get("precip_in")
		qPrecipitation_mm =  current.Get("precip_mm")
		qWindDirection = current.Get("wind_dir")
		qGustSpeed_mph = current.Get("gust_mph") & "mph"
		qGustSpeed_kph = current.Get("gust_kph") & "kph"
		qTemp_c = current.Get("temp_c")
		qTemp_f  = current.Get("temp_f")
		qPressure = current.Get("pressure_in")
		qCloudCover = current.Get("cloud")
		qWindSpeed_kph  = current.Get("wind_kph") & "kph"
		qWindSpeed_mph  = current.Get("wind_mph")
		qHumidity = current.Get("humidity")
		qPressure = current.Get("pressure_mb") & "mb"
		qVisibility_miles = current.Get("vis_miles")
		qVisibility_km  = current.Get("vis_km")
	
		'--- Condition info
		Dim condition As Map = current.Get("condition")
		'Dim code As Int = condition.Get("code")
		'IconURL = condition.Get("icon")
		qDescription = condition.Get("text")
	
		'--- Location info
		Dim Location As Map = root.Get("location")
		qLocalTime = Location.Get("localtime")
		qCountry = Location.Get("country")
		qLocalTime_Epoch = Location.Get("localtime_epoch")
		qLocation = Location.Get("name")
		'Dim lon As Double = Location.Get("lon")
		'Dim region As String = Location.Get("region")
		'Dim lat As Double = Location.Get("lat")
		'Dim tz_id As String = Location.Get("tz_id")
	
		'--- forcast
		Dim forcastSlot As Int = 0
		Dim forecast As Map = root.Get("forecast")
		Dim forecastday As List = forecast.Get("forecastday")
	
		Dim conv As ConversionMod 
		conv.Initialize
		For Each colforecastday As Map In forecastday
			ForcastDays(forcastSlot).Day = colforecastday.Get("date") '--- format to day
			
			'--- astro
			Dim astro As Map = colforecastday.Get("astro")
			'Dim moonset As String = astro.Get("moonset")
			'Dim moon_illumination As Int = astro.Get("moon_illumination")
			ForcastDays(forcastSlot).Sunrise = FormatTimeStr(astro.Get("sunrise"))
			ForcastDays(forcastSlot).Sunset = FormatTimeStr(astro.Get("sunset"))
			'Dim moon_phase As String = astro.Get("moon_phase")
			'Dim is_moon_up As Int = astro.Get("is_moon_up")
			'Dim is_sun_up As Int = astro.Get("is_sun_up")
			'Dim moonrise As String = astro.Get("moonrise")
			'Dim date_epoch As Int = colforecastday.Get("date_epoch")
		
			'--- day info
			Dim day As Map = colforecastday.Get("day")
			'Dim avgvis_km As Double = day.Get("avgvis_km")
			'Dim avgvis_miles As Double = day.Get("avgvis_miles")
			ForcastDays(forcastSlot).uv = day.Get("uv")
			ForcastDays(forcastSlot).AverageTemp_f = day.Get("avgtemp_f")
			ForcastDays(forcastSlot).AverageTemp_c = day.Get("avgtemp_c")
			ForcastDays(forcastSlot).ChanceOfSnow = day.Get("daily_chance_of_snow")
			ForcastDays(forcastSlot).ChanceOfRain = day.Get("daily_chance_of_rain")
			ForcastDays(forcastSlot).Low_c = day.Get("mintemp_c")
			ForcastDays(forcastSlot).Low_f = day.Get("mintemp_f")
			ForcastDays(forcastSlot).High_f = day.Get("maxtemp_f")
			ForcastDays(forcastSlot).High_c = day.Get("maxtemp_c")
		
			ForcastDays(forcastSlot).WillItRain = day.Get("daily_will_it_rain")
			ForcastDays(forcastSlot).WillItSnow = day.Get("daily_will_it_snow")
			ForcastDays(forcastSlot).IconURL = condition.Get("icon")
			ForcastDays(forcastSlot).Percip_inches = day.Get("totalprecip_in")
			ForcastDays(forcastSlot).Percip_mm = day.Get("totalprecip_mm")
		
			ForcastDays(forcastSlot).Snow_cm = day.Get("totalsnow_cm")
			Try
				If Not (strHelpers.IsNullOrEmpty(day.Get("totalsnow_cm"))) Then
					ForcastDays(forcastSlot).Snow_inches = conv.length_mm2inches((ForcastDays(forcastSlot).Snow_cm.As(Double) * 10))
				End If
			Catch
				Log(LastException)
			End Try
			ForcastDays(forcastSlot).Humidity = day.Get("avghumidity")
		
			'--- conditions ???
			Dim condition As Map = day.Get("condition")
			ForcastDays(forcastSlot).APIcode = condition.Get("code")
			ForcastDays(forcastSlot).IconID = GetIconFromApi(ForcastDays(forcastSlot).APIcode)
			ForcastDays(forcastSlot).Description = condition.Get("text")
			ForcastDays(forcastSlot).Max_Wind_kph = day.Get("maxwind_kph")
			ForcastDays(forcastSlot).Max_Wind_mph = day.Get("maxwind_mph")
		
			forcastSlot = forcastSlot + 1
		Next
	
	Catch
		Log(LastException)
	End Try
	

End Sub

Private Sub GetIconFromApi(code As Int) As Int
	Try
		
		Dim o As typeWeatherCodeData
		o = WeatherAPICodes.Get(code).As(typeWeatherCodeData)
		Return o.IconID
		
	Catch
		Log(LastException)
	End Try
	Return -1
	
End Sub


Private Sub FormatTimeStr(ti As String) As String
	'--- The JSON is in AM/PM by default
	Log("TODO - fmtTimeStr")
	Return ti
End Sub

Sub Update_Weather_Default_City
	Update_Weather(Main.kvs.GetDefault(cnst.INI_WEATHER_DEFAULT_CITY,"Seattle"))
End Sub

Private Sub Update_Weather(city As String) As ResumableSub
	
	Dim realCity As String = city
	LastUpdatedCity = realCity
	
	Try

		If  Main.isInterNetConnected = False Then
			Try
				Log("Internet is not connected. Cannot update weather.")
				'--- log to disk?
			Catch
				'--- do nothing, --- should only error out the first time
				 LogIt.LogDebug1("GetWeather - only 1st time OK")
			End Try 'ignore
			
			LastUpdatedAt = 1
		
			Return False
		End If
	
		Log("Requesting weather data")
		
		Dim retVal As Boolean,  job As HttpJob
		job.Initialize("", Me)
		job.Download($"http://api.weatherapi.com/v1/forecast.json?key=${WeatherKey}&q=kherson&days=3&aqi=no&alerts=no"$)
		Wait For (job) JobDone(job As HttpJob)
		retVal = job.Success
		
		If job.Success Then
			'File.WriteString(xui.DefaultFolder,"1.txt",job.GetString)
			ParseWeatherJob(job.GetString)   
			Main.EventGbl.Raise(cnst.EVENT_WEATHER_UPDATED)
			'Location = city
		Else
			Log("weather call failed - responce code = " & job.Response.StatusCode)	
			Main.EventGbl.Raise(cnst.EVENT_WEATHER_UPDATE_FAILED)
		End If
		
		job.Release
		Return retVal
		
	Catch
		'--- Something with weather has failed. We should try and setup for a quick refresh
		 Log("Something with weather has failed:")
		LastUpdatedCity = realCity
		
	End Try
	Return False
End Sub

Public Sub ResetWeatherTimer()
	LastUpdatedAt = 1
End Sub

Private Sub waitForInternetTimer_Tick
	'waitForInternetTimer.Enabled = False
	Update_Weather(LastUpdatedCity)
End Sub


