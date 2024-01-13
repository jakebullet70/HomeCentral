B4J=true
Group=Helpers
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
' V. 1.1 	Jan/11/2024
'			Refactor for KVS storage
' V. 1.0 	Aug/15/2022
'			1st run
#End Region
'Static code module

'--- Code to turn on / off CPU - Screen - brightness
'--- Code to turn on / off CPU - Screen - brightness
'--- Code to turn on / off CPU - Screen - brightness

Sub Process_Globals
	Private xui As XUI
	
	Private pws As PhoneWakeState, ph As Phone
	
	Public pScreenBrightness As Float = -1
	Private Const AUTO_BRIGHTNESS As Float = -1
	
End Sub

Public Sub Init(takeOverPower As Boolean)
	
	'TODO  brightness needs to be seperated from takeoverpower
	'If config.ChangeBrightnessSettingsFLAG = False Then Return
	
	If takeOverPower = False Then Return
	
	If LoadBrightnesFromfile = False Then
		pScreenBrightness = GetScreenBrightness
		If pScreenBrightness = AUTO_BRIGHTNESS Then
			pScreenBrightness = 0.5
			SetScreenBrightnessAndSave(pScreenBrightness,True)
			Return
		End If
	End If
	SetScreenBrightnessAndSave(pScreenBrightness,False)
	
End Sub


Public Sub ScreenON(takeOverPower As Boolean)
	
	ReleaseLocks
	
	If takeOverPower Then 
		pws.KeepAlive(True)
	Else
		'---("KeepAlive - OFF")
	End If
	
	CallSubDelayed2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_ON) 
	
End Sub


Public Sub ScreenOff
	
	pws.ReleaseKeepAlive
	pws.PartialLock
	ph.SetScreenBrightness(0)
	
End Sub

Public Sub ReleaseLocks
	'pws.ReleasePartialLock
	pws.ReleaseKeepAlive
End Sub

'=================================================================================
'=================================================================================

' 0 to 1 - so 0.5 is valid
Public Sub SetScreenBrightnessAndSave(value As Float, SaveMe As Boolean)
	
	'If config.ChangeBrightnessSettingsFLAG = False Then Return
	
	Try
		If pScreenBrightness = AUTO_BRIGHTNESS Then
			Log("cannot set brightness, brightness is in automode")
			Return
		End If
		
		ph.SetScreenBrightness(value)
		If SaveMe Then 
			Main.kvs.Put(gblConst.INI_SCREEN_BRIGHTNESS_VALUE,value)
		End If
		
	Catch
		Log(LastException)
	End Try 
	
End Sub

Public Sub SetScreenBrightness2
	
	'If config.ChangeBrightnessSettingsFLAG = False Then Return
	SetScreenBrightnessAndSave(pScreenBrightness,False)
	
End Sub


Private Sub LoadBrightnesFromfile() As Boolean
	pScreenBrightness = Main.kvs.GetDefault(gblConst.INI_SCREEN_BRIGHTNESS_VALUE,.5)
	Return True
End Sub


' 0 to 1  - so 0.5 is valid
Public Sub GetScreenBrightness() As Float
	'--- returns -1 if set to auto
	' https://www.b4x.com/android/forum/threads/get-set-brightness.107899/#content
	' https://www.b4x.com/android/forum/threads/setscreenbrightness-not-working.31606/
	Dim ref As Reflector
    ref.Target = ref.GetActivity
    ref.Target = ref.RunMethod("getWindow")
    ref.Target = ref.RunMethod("getAttributes")
    Dim brightness As Float = ref.GetField("screenBrightness")
	If B4XPages.MainPage.DebugLog Then Log("screen brightness is: " & brightness)
	Return brightness
	
End Sub



'Public Sub SetBrightnessToNormalMode
'	'--- NEEDS TESTING, SEE BELOW
'	'  https://www.b4x.com/android/forum/threads/permission-write_settings.94311/#post-597465
'	Dim jo As JavaObject
'	jo.InitializeContext
'	Dim System As JavaObject
'	System.InitializeStatic("android.provider.Settings.System")
'	System.RunMethod("putInt", Array( _
'       jo.RunMethod("getContentResolver", Null), _
'       System.GetField("SCREEN_BRIGHTNESS_MODE"), _
'       System.GetField("SCREEN_BRIGHTNESS_MODE_MANUAL")))
'End Sub

