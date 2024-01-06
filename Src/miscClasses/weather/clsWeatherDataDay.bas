B4A=true
Group=MiscClasses\Weather
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
'Class module
Sub Class_Globals
	Public Day As String = "N/A"
	Public AverageTemp_c As String = "N/A"
	Public AverageTemp_f As String = "N/A"
	Public High_c As Int 
	Public Low_c As Int
	Public High_f As Int
	Public Low_f As Int
	Public FeelsLike_c As String 
	Public FeelsLike_f As String 
	Public Description As String = "N/A"
	Public Sunrise As String = "N/A"
	Public Sunset As String = "N/A"
	Public IconID As Int = -1
	Public IconURL As String = "N/A"
	Public APIcode As Int = -1
	Public LocalTime As String = "N/A"
	Public ChanceOfSnow As String = "N/A"
	Public ChanceOfRain As String = "N/A"
	Public WillItRain As String = "N/A"
	Public WillItSnow As String = "N/A"
	Public Percip_mm As String = "N/A"
	Public Percip_inches As String = "N/A"
	Public UV As String = "N/A"
	Public Snow_cm As String = "N/A"
	Public Snow_inches As String = "N/A"
	Public Max_Wind_kph As String  = "N/A"
	Public Max_Wind_mph As String = "N/A"
	Public Humidity As String 
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
End Sub