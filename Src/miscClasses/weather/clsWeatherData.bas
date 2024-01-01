B4A=true
Group=MiscClasses\Weather
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
'Class module
Sub Class_Globals
	Private xui As XUI
	Public lastUpdatedAt As Long
	
	Public WeatherKey As String
	Public IsError As Boolean
	
	Public Description As String
	Public Location1, Country As String
	Public Precipitation_mm,Precipitation_inches As String
	Public CloudCover As String
	Public Humidity As String
	Public Pressure As String
	Public IsDay As String
	Public WindDirection As String
	Public WindSpeed_mph,WindSpeed_kph As String
	Public GustSpeed_mph,GustSpeed_kph As String
	Public IconMapNumber As Int
	Public IconURL As String
	Public FeelsLike_f,FeelsLike_c As String
	Public Temp_f,Temp_c As String
	Public Visibility_km,Visibility_miles As String
	Public LocalTime As String, LocalTime_Epoch As Long
		
	Public ForcastDays(3) As clsWeatherDataDay 
	
	Public LastErrorMessage As String
	
	Public IsInitialize As Boolean
	Public LastUpdatedCity As String
	Private tmrErrorInRecievingWeather As Timer
	
End Sub

Sub getIsWeatherUpToDate As Boolean
	If lastUpdatedAt <> 0 And dtHelpers.HoursBetween(DateTime.now, lastUpdatedAt) >= 1 Then
		Return False
	Else
		Return True
	End If
End Sub

'========================  these where in a public aobject ========================
public Sub GetWeather_Icon2(id As Int, img As lmB4XImageViewX)
	
	If id <= 0 Then Return
	Try
		
		If Not (img.IsInitialized) Then
			img.Initialize("","")
		End If
		
		'Dim daytime As Boolean =  dtHelpers.IsItDayTime(SunriseTime,SunsetTime,LocalTime)
		img.Bitmap =  xui.LoadBitmap(File.DirAssets,GetWeather_IconFileName(id,IsDay.As(Boolean)))
		
	Catch
		Log(LastException)
	End Try
End Sub

private Sub GetWeather_IconFileName(id As Int,daytime As Boolean) As String
	Dim DayOrNight As String

	If daytime Then
		DayOrNight = "/day/"
	Else
		DayOrNight = "/night/"
	End If
	Dim fname As String =  "weathericon/" & cnst.WEATHERicons & DayOrNight & id & ".png"
	Return fname
	
End Sub
'===============================================================

Public Sub Initialize
	IsInitialize = True
	
	lastUpdatedAt = 1
	
	WeatherKey = cnst.OpenWeatherAPI
	
	Main.EventsGlobal.Subscribe(cnst.EVENT_INET_ON_CONNECT,Me, "Internet_OnConnected")

	tmrErrorInRecievingWeather.Initialize("ErrorGettingWeather",1000 * 60) '--- every 1 minute
	
End Sub

Sub Internet_OnConnected
	TryUpdate
End Sub

Sub	ErrorGettingWeather_Tick
	tmrErrorInRecievingWeather.Enabled = False '--- turn off the timer
	TryUpdateBecauseOfError
End Sub

Public Sub TryUpdate
	If lastUpdatedAt <> 0 Then
		If dtHelpers.HoursBetween(DateTime.now, lastUpdatedAt) >= 1 Then
			If (LastUpdatedCity = "") Then
				Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_BEFORE_UPDATE)
				Update_Weather_Default_City
			Else
				Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_BEFORE_UPDATE)
				Update_Weather(LastUpdatedCity)
			End If
		End If
	End If
End Sub

Public Sub TryUpdateBecauseOfError
	If dtHelpers.HoursBetween(DateTime.now, lastUpdatedAt) >= 1 Then
		Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_BEFORE_UPDATE)
		If (LastUpdatedCity = "") Then
			Update_Weather_Default_City
		Else
			Update_Weather(LastUpdatedCity)
		End If
	End If
End Sub

Private Sub ParseDateStr2Ticks(utc As String) As Long
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
	lastUpdatedAt = DateTime.Now
	
	Dim parser As JSONParser : parser.Initialize(s)
	Dim root As Map = parser.NextObject
	
	Try
		Dim current As Map = root.Get("current")
		FeelsLike_f  = current.Get("feelslike_f")
		FeelsLike_c = current.Get("feelslike_c")
		'Dim uv As Double = current.Get("uv")
		'Dim last_updated As String = current.Get("last_updated")
		'Dim wind_degree As Int = current.Get("wind_degree")
		'Dim last_updated_epoch As Int = current.Get("last_updated_epoch")
		IsDay = current.Get("is_day")
		Precipitation_inches = current.Get("precip_in")
		Precipitation_mm =  current.Get("precip_mm")
		WindDirection = current.Get("wind_dir")
		GustSpeed_mph = current.Get("gust_mph") & "mph"
		GustSpeed_kph = current.Get("gust_kph") & "kph"
		Temp_c = current.Get("temp_c")
		Temp_f  = current.Get("temp_f")
		Pressure = current.Get("pressure_in")
		CloudCover = current.Get("cloud")
		WindSpeed_kph  = current.Get("wind_kph") & "kph"
		WindSpeed_mph  = current.Get("wind_mph")
		Humidity = current.Get("humidity")
		Pressure = current.Get("pressure_mb") & "mb"
		Visibility_miles = current.Get("vis_miles")
		Visibility_km  = current.Get("vis_km")
	
		'--- Condition info
		Dim condition As Map = current.Get("condition")
		'Dim code As Int = condition.Get("code")
		IconURL = condition.Get("icon")
		Description = condition.Get("text")
	
		'--- Location info
		Dim Location As Map = root.Get("location")
		LocalTime = Location.Get("localtime")
		Country = Location.Get("country")
		LocalTime_Epoch = Location.Get("localtime_epoch")
		Location1 = Location.Get("name")
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
			ForcastDays(forcastSlot).Sunrise = astro.Get("sunrise")
			ForcastDays(forcastSlot).Sunset = astro.Get("sunset")
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
			'Dim code As Int = condition.Get("code")
			ForcastDays(forcastSlot).Description = condition.Get("text")
			ForcastDays(forcastSlot).Max_Wind_kph = day.Get("maxwind_kph")
			ForcastDays(forcastSlot).Max_Wind_mph = day.Get("maxwind_mph")
		
			forcastSlot = forcastSlot + 1
		Next
	
	Catch
		Log(LastException)
	End Try
	

End Sub

Sub Update_Weather_Default_City
	Update_Weather(Main.kvs.GetDefault(cnst.INI_WEATHER_DEFAULT_CITY,"Seattle"))
End Sub

'Update the weather for a specific City
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
			
			lastUpdatedAt = 1
		
			Return False
		End If
	
		Log("Requesting weather data")
		
		Dim retVal As Boolean,  job As HttpJob
		job.Initialize("", Me)
		job.Download("http://api.weatherapi.com/v1/forecast.json?key=b48d92cda3b045938a7174835233112&q=kherson&days=3&aqi=no&alerts=no")
		Wait For (job) JobDone(job As HttpJob)
		retVal = job.Success
		
		If job.Success Then
			'File.WriteString(xui.DefaultFolder,"1.txt",job.GetString)
			ParseWeatherJob(job.GetString)   
			Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_UPDATED)
			'Location = city
		Else
			Log("weather call failed - responce code = " & job.Response.StatusCode)	
			Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_UPDATE_FAILED)
		End If
		
		job.Release
		Return retVal
		
	Catch
		' Something with weather has failed. We should try and setup for a quick refresh
		 Log("Something with weather has failed:")
		LastUpdatedCity = realCity
		
	End Try
	Return False
End Sub


Public Sub ResetWeatherTimer()
	lastUpdatedAt = 1
End Sub

Private Sub waitForInternetTimer_Tick
	'waitForInternetTimer.Enabled = False
	Update_Weather(LastUpdatedCity)
End Sub
