B4A=true
Group=MiscClasses\Weather
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
'Class module
Sub Class_Globals
	Public lastUpdatedAt As Long
	Public forecastDays As Int = 5
	
	Public WeatherKey As String
	Public IsError As Boolean
	
	Public Location As String
	Public Precipitation As String
	Public CloudCover As String
	Public Humidity As String
	Public Pressure As String
	Public Visbility As String
	Public WindDirection As String
	Public WindSpeed As String
	Public SunriseTime As String
	Public SunsetTime As String
	Public IconMapNumber As Int
	
	Public TodayQuick As clsWeatherDataDay
	Public OtherDays(forecastDays - 1) As clsWeatherDataDay
	
	Public LastErrorMessage As String
	'Public WeatherUpdatedEvent As clsEvent
	'Public WeatherUpdatedFailEvent As clsEvent
	'Public BeforeWeatherUpdatedEvent As clsEvent
	'Public OnGeoCheckSuccess As clsEvent
	'Public OnGeoCheckFailure As clsEvent
	
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

Sub getDays() As Int
	Return forecastDays
End Sub

Sub setDays(dayCount As Int)
	forecastDays = dayCount
	'Dim OtherDays(forecastDays - 1) As clsWeatherDataDay
	'TryUpdate
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	IsInitialize = True
'	WeatherUpdatedEvent.Initialize
'	WeatherUpdatedFailEvent.Initialize
'	BeforeWeatherUpdatedEvent.Initialize
'	OnGeoCheckSuccess.Initialize
'	OnGeoCheckFailure.Initialize
	
	lastUpdatedAt = 1
	
	 'ggg.OnConnectedEventWeather.Subscribe(Me, "Internet_OnConnected")
	Main.EventsGlobal.Subscribe(cnst.EVENT_INET_ON_CONNECT,Me, "Internet_OnConnected")
	tmrErrorInRecievingWeather.Initialize("ErrorGettingWeather",1000 * 60) '--- every 1 minute
	
End Sub

Sub Internet_OnConnected
	TryUpdate
End Sub

Sub	ErrorGettingWeather_Tick
	tmrErrorInRecievingWeather.Enabled = False
	TryUpdateBecauseOfError
End Sub


Public Sub TryUpdate
	If lastUpdatedAt <> 0 Then
		If dtHelpers.HoursBetween(DateTime.now, lastUpdatedAt) >= 1 Then
			If (LastUpdatedCity = "") Then
				Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_BEFORE_UPDATE)
				'BeforeWeatherUpdatedEvent.Raise()
				Update_Weather_Default_City
			Else
				Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_BEFORE_UPDATE)
				'BeforeWeatherUpdatedEvent.Raise()
				'If  ggg.IsDebuggerAttatch Then
				Update_Weather(LastUpdatedCity)
				'Else
				'	threadWeather.Start(Me, "Update_Weather", Array As Object(LastUpdatedCity))
				'End If
				
			End If
		End If
	End If
End Sub


Public Sub TryUpdateBecauseOfError
	If dtHelpers.HoursBetween(DateTime.now, lastUpdatedAt) >= 1 Then
		If (LastUpdatedCity = "") Then
			'BeforeWeatherUpdatedEvent.Raise()
			Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_BEFORE_UPDATE)
			Update_Weather_Default_City
		Else
			'BeforeWeatherUpdatedEvent.Raise()
			Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_BEFORE_UPDATE)
			Update_Weather(LastUpdatedCity)
		End If
	End If
End Sub


Private Sub GetStringFromJSONObject(theArray As List) As String
	Dim tempMap As Map = theArray.Get(0)
	Return tempMap.Get("value")
End Sub

Private Sub ParseWeatherJob(Job As HttpJob)
	If (Job.Success) Then
		Try
			Dim UseCelsius As Boolean = Main.kvs.GetDefault("usecelsius", False)
			Dim parser As JSONParser
			Dim result As String = Job.GetString()
			' ggg.LogWrite(result, ggg.ID_LOG_MSG)
			parser.Initialize(result)
			
			Dim dataMap As Map = parser.NextObject.Get("data")
			If (dataMap.ContainsKey("error")) Then
				Dim errorArray As List = dataMap.Get("error")
				Dim errorMap As Map = errorArray.Get(0)
				IsError = True
				LastErrorMessage = "Failed to update weather: " & errorMap.Get("msg")
				LogIt.LogWrite(LastErrorMessage,  1)
			Else
				IsError = False
				
				Dim dayArray As List
				dayArray.Initialize
				
				Dim weatherArray As List
				Dim weatherMap As Map
				Dim astronomyArray As List
				Dim astronomyMap As Map
				Dim hourlyArray As List
				Dim hourlyMap As Map
				Dim currentArray As List = dataMap.Get("current_condition")
				Dim currentMap As Map = currentArray.Get(0)
				' ggg.debugLog(currentMap) 'ignore
				
				CloudCover = currentMap.Get("cloudcover")
				Humidity = currentMap.Get("humidity")
				Pressure = currentMap.Get("pressure")
				Precipitation = currentMap.Get("precipMM")
				Visbility = currentMap.Get("visibility")
				WindDirection = currentMap.Get("winddir16Point")
				WindSpeed = currentMap.Get("windspeedMiles")
				IconMapNumber  = currentMap.Get("weatherCode")
				
				' Get everything for Today
				weatherArray = dataMap.Get("weather")
				weatherMap = weatherArray.Get(0)
				
				astronomyArray = weatherMap.Get("astronomy")
				astronomyMap = astronomyArray.Get(0)
				
				Dim localTimeArray As List
				localTimeArray.Initialize
				localTimeArray = dataMap.Get("time_zone")
				Dim localTimeMap As Map
				localTimeMap.Initialize
				localTimeMap = localTimeArray.Get(0)
				'Log( localTimeMap.Get("localtime"))
				TodayQuick.LocalTime = localTimeMap.Get("localtime")
				
				hourlyArray = weatherMap.Get("hourly")
				hourlyMap = hourlyArray.Get(0)
				
				SunriseTime = astronomyMap.Get("sunrise")
				SunsetTime = astronomyMap.Get("sunset")
				TodayQuick.Sunrise = astronomyMap.Get("sunrise")
				TodayQuick.Sunset = astronomyMap.Get("sunset")
				TodayQuick.IconMapNumber = currentMap.Get("weatherCode")
				
				
				TodayQuick.Day = "Today"
				TodayQuick.Description = GetStringFromJSONObject(currentMap.Get("weatherDesc"))
	
				If (UseCelsius) Then
					TodayQuick.Tempurature = currentMap.Get("temp_C")
					TodayQuick.High = weatherMap.Get("maxtempC")
					TodayQuick.Low = weatherMap.Get("mintempC")
				Else
					TodayQuick.Tempurature = currentMap.Get("temp_F")
					TodayQuick.High = weatherMap.Get("maxtempF")
					TodayQuick.Low = weatherMap.Get("mintempF")
				End If
				
				' Get the forecast days
				For i = 1 To forecastDays - 1
					weatherMap = weatherArray.Get(i)
				
					astronomyArray = weatherMap.Get("astronomy")
					astronomyMap = astronomyArray.Get(0)
					
					hourlyArray = weatherMap.Get("hourly")
					hourlyMap = hourlyArray.Get(0)
					
'					Log("------------------------------------------------------------------------")
'					
'					For x = 0 To  hourlyMap.Size - 1
'						Log(hourlyMap.GetKeyAt(x))
'						Log(hourlyMap.GetValueAt(x))
'					Next
'					Log("------------------------------------------------------------------------")
					
'					Log(hourlyArray)
'					Log(hourlyMap)
'					
					OtherDays(i - 1).IconMapNumber = hourlyMap.Get("weatherCode")
					'OtherDays(i - 1).IconMapNumber = currentMap.Get("weatherCode")
					'OtherDays(i - 1).ImageUrl = GetStringFromJSONObject(hourlyMap.Get("weatherIconUrl"))
					'If File.Exists(File.DirAssets, "weathericon" & fn.GetLastUrlPart(OtherDays(i - 1).ImageUrl)) Then
					'Dim fname As String = GetWeatherIcon(OtherDays(i - 1).IconMapNumber)
					'OtherDays(i - 1).Image = LoadBitmap(File.DirAssets, "weathericon" & fn.GetLastUrlPart(OtherDays(i - 1).ImageUrl))
					'OtherDays(i - 1).Image = LoadBitmap(File.DirAssets, "weathericon\" & fname)
					'End If
					OtherDays(i - 1).Description = GetStringFromJSONObject(hourlyMap.Get("weatherDesc"))
					OtherDays(i - 1).Day = DateUtils.GetDayOfWeekName(DateTime.Add(DateTime.Now,0,0,i))
					
					If (UseCelsius) Then
						OtherDays(i - 1).High = weatherMap.Get("maxtempC")
						OtherDays(i - 1).Low = weatherMap.Get("mintempC")
					Else
						OtherDays(i - 1).High = weatherMap.Get("maxtempF")
						OtherDays(i - 1).Low = weatherMap.Get("mintempF")
					End If

				Next
				
				lastUpdatedAt = DateTime.Now
				
			End If
			
			'Alert everyone that the weather has updated information
			'WeatherUpdatedEvent.Raise
			Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_UPDATED)
		Catch
			Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_UPDATE_FAILED)
			'WeatherUpdatedFailEvent.Raise
			LastErrorMessage = "Unable to update weather due to an error."
			LogIt.LogException(LastException, True)
		End Try
	Else
		Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_UPDATE_FAILED)
		'WeatherUpdatedFailEvent.Raise
		LastErrorMessage = "Failed to update weather: " + Job.ErrorMessage
		LogIt.LogWrite(LastErrorMessage,  1)
	End If
End Sub


Private Sub JobDone(Job As HttpJob)
	
	
	If (Job.JobName = "weather" And Job.Success = True) Then
		Log("Recieved weather data")
		ParseWeatherJob(Job)
		
	Else if (Job.JobName = "weather" And Job.Success = False) Then
		Log("Recieving weather data FAILED")
		Main.EventsGlobal.Raise(cnst.EVENT_INET_ON_CONNECT)
		 'ggg.WeatherData.WeatherUpdatedFailEvent.Raise
		tmrErrorInRecievingWeather.Enabled = True
		
		
	Else If (Job.JobName = "geocheck") Then
		If (Job.Success) Then
			Try
				Dim parser As JSONParser
				Dim result As String = Job.GetString()
				 LogIt.LogDebug1(result)
				parser.Initialize(result)
				
				Dim dataMap As Map = parser.NextObject.Get("data")
				If (dataMap.ContainsKey("error")) Then
					Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_GEO_FAILED)
					'OnGeoCheckFailure.Raise
				Else
					Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_GEO_OK)
					'OnGeoCheckSuccess.Raise
				End If
			Catch
				Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_GEO_FAILED)
				'OnGeoCheckFailure.Raise
			End Try
		Else
			Main.EventsGlobal.Raise(cnst.EVENT_WEATHER_GEO_FAILED)
			'OnGeoCheckFailure.Raise
		End If
	End If
	
	Job.Release

End Sub

'Update the weather for a specific City
Private Sub Update_Weather(city As Object) As Boolean
	Dim realCity As String = city
	CheckLocationValid(city)
	LastUpdatedCity = realCity
	Try

		If  Main.isInterNetConnected = False Then
			Try
				LastErrorMessage = "Internet is not connected. Cannot update weather."
				LogIt.LogWrite4(LastErrorMessage,  1)
			Catch
				'--- do nothing
				'--- should only error out the first time
				 LogIt.LogDebug1("GetWeather - only 1st time OK")
			End Try 'ignore
		
'		waitForInternetTimer.Interval = 5000
'		waitForInternetTimer.Enabled = True
			lastUpdatedAt = 1
		
			Return False
		End If
	
		Log("Requesting weather data")
		Dim job As HttpJob
		job.Initialize("weather", Me)
		job.Download2("http://api.worldweatheronline.com/free/v2/weather.ashx",  _
				Array As String("key",  WeatherKey, "q", city, "num_of_days", _
				forecastDays, "format", "json", "showlocaltime", "yes"))
	
		Location = city
	
		Return True
	Catch
		' Something with weather has failed. We should try and setup for a quick refresh
		 LogIt.LogException3(LastException, True,"Something with weather has failed:")
	
		LastUpdatedCity = realCity
		'waitForInternetTimer.Interval = 1000
		'waitForInternetTimer.Enabled = True
	End Try
	Return False
End Sub




'Update the weather for the current (default) city
Private Sub Update_Weather_Default_City()
	
	Dim defaultCityIndex As Int = Main.kvs.GetDefault( "default_city_index", "-1")
	Dim defaultCityMissing As Boolean

	If (defaultCityIndex = -1) Then
		'' Choose the first city
		Dim resultValue As String = Main.sql.ExecQuerySingleResult("select location from weather limit 1")
		
		'' Bad state here. No cities..
		If strHelpers.IsNullOrEmpty( resultValue) Then
			defaultCityMissing = True
		Else
			'If  ggg.IsDebuggerAttatch Then
			Update_Weather(resultValue)
			'Else
			'	threadWeather.Start(Me, "Update_Weather", Array As Object(resultValue))
			'End If
		End If
	Else
		'' Validate the default city exists.
		Dim cityName As String = Main.sql.ExecQuerySingleResult2("select location from weather where weather_id = ?", Array As String(defaultCityIndex))
		
		If  strHelpers.IsNullOrEmpty (cityName) Then
			defaultCityMissing = True
		Else
			'If  ggg.IsDebuggerAttatch Then
			Update_Weather(cityName)
			'Else
			'	threadWeather.Start(Me, "Update_Weather", Array As Object(cityName))
			'End If
		End If
	End If
	
	'' Unable to determine default city
	If (defaultCityMissing) Then
		'If  ggg.IsDebuggerAttatch Then
		Update_Weather("Seattle, Washington")
		'Else
		'	threadWeather.Start(Me, "Update_Weather", Array As Object("Seattle, Washington"))
		'End If
	End If

End Sub

Public Sub ResetWeatherTimer()
	lastUpdatedAt = 1
End Sub

Private Sub waitForInternetTimer_Tick
	'waitForInternetTimer.Enabled = False
	Update_Weather(LastUpdatedCity)
End Sub

Public Sub CheckLocationValid(locationToCheck As String)
	If Main.isInterNetConnected = False Then Return
	'Log("CheckLocationValid")
	Dim job As HttpJob
	job.Initialize("geocheck", Me)
	job.Download2("http://api.worldweatheronline.com/free/v2/weather.ashx", Array As String("key",  WeatherKey, "q", locationToCheck, "format", "json"))
End Sub

