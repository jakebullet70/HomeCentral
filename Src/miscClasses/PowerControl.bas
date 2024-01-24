B4J=true
Group=MiscClasses
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
' V. 2.0	Jan/23/2024
'			Converted to a class
' V. 1.1 	Jan/11/2024
'			Refactor for KVS storage
' V. 1.0 	Aug/15/2022
'			1st run
#End Region


'--- Code to turn on / off CPU - Screen - brightness
'--- Code to turn on / off CPU - Screen - brightness
'--- Code to turn on / off CPU - Screen - brightness



Sub Class_Globals
	Private XUI As XUI
	
	Private pws As PhoneWakeState, ph As Phone
	Public IsScreenOff As Boolean = False
	Public pScreenBrightness As Float = -1
	Private Const AUTO_BRIGHTNESS As Float = -1
	
End Sub


Public Sub Initialize(takeOverPower As Boolean)
	
	If takeOverPower = False Then Return
	pScreenBrightness = Main.kvs.GetDefault(gblConst.INI_SCREEN_BRIGHTNESS_VALUE,.5)
	
	pScreenBrightness = GetScreenBrightness
	If pScreenBrightness = AUTO_BRIGHTNESS Then
		pScreenBrightness = 0.5
		SetScreenBrightnessAndSave(pScreenBrightness,True)
		Return
	End If
	SetScreenBrightnessAndSave(pScreenBrightness,False)
	
	Screen_ON(True)
	
End Sub


Public Sub Screen_ON(takeOverPower As Boolean)
	
	ReleaseLocks
	
	If takeOverPower Then
		pws.KeepAlive(True)
	Else
		'---("KeepAlive - OFF")
	End If
	
	CallSubDelayed2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_ON)
	IsScreenOff = False
	
End Sub


Public Sub Screen_Off
	
	pws.ReleaseKeepAlive
	pws.PartialLock
	ph.SetScreenBrightness(0)
	IsScreenOff = True
	
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


'========================================================================
'  GUI, change screen brightness

Public Sub DoBrightnessDlg
	
'	Dim o1 As dlgBrightness
'	B4XPages.MainPage.pObjCurrentDlg1 = o1.Initialize("Screen Brightness",Me,"Brightness_Change")
'	o1.Show(IIf(PowerCtrl.pScreenBrightness < 0.05,0.1,PowerCtrl.pScreenBrightness) * 100)
	
End Sub
Private Sub Brightness_Change(value As Float)
	
	'--- callback for btnBrightness_Click
	Dim v As Float = value / 100
	SetScreenBrightnessAndSave(v,True)
	pScreenBrightness = v
	
End Sub



