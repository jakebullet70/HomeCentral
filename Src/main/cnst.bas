B4J=true
Group=Main
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Dec/23/2023
#End Region
'Static code module
Sub Process_Globals
	
	'--- Versioning - app name
	Public Const APP_NAME As String = "Home Central"
	Public Const APP_DISPLAY_VERSION As String = "0.5.0" '--- what the user see's
	Public Const APP_FILE_VERSION As Int = 1
	
	
	'--- KVS setting const
	Public Const INI_INSTALL_DATE As String = "instdt"
	Public Const INI_CURRENT_VER As String = "appver"
		
	
	'--- String constants (not really...) these are left as string for multi language support
	'--- will need a refactor if multi language support is to be supported, but for now...
	
	'Public INI_CONST_SETUP_COLORS As String = "colors"
	'Public INI_CONST_SETUP As String = "setup"
	'Public INI_CONST_MAIN As String = "main"
	'Public INI_CONST_MENUKEYS As String = "menu"
	'Public INI_CONST_SNAPINS As String = "snapins"
	Public INI_CONST_WEATHER As String = "weather"
	
	Public const DarkSkyAPIKey As String = "ebc4475b049026afc9d48e6e5c331738"
	Public const OpenWeatherAPI As String = "517f35137e222f9ef3ae5010ee14cffa"
	Public const WeatherAPIxuKey As String = "97599cd456e24caf85c143130182403"

	
	
End Sub


