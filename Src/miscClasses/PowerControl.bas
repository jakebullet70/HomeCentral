﻿B4J=true
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
	Private Const SCRN_BRIGHTNESS_NO_SAVE As Boolean = False
	Private Const SCRN_BRIGHTNESS_SAVE As Boolean = True
	Private mTakeOverPower As Boolean = False
	
	
End Sub


Public Sub Initialize(takeOverPower As Boolean)
	
	mTakeOverPower = takeOverPower
	If takeOverPower = False Then Return
	
	pScreenBrightness = Main.kvs.GetDefault(gblConst.INI_SCREEN_BRIGHTNESS_VALUE,.5)
	
	pScreenBrightness = GetScreenBrightness
	If pScreenBrightness = AUTO_BRIGHTNESS Then
		pScreenBrightness = 0.5
		SetScreenBrightnessAndOptionalSave(pScreenBrightness,SCRN_BRIGHTNESS_SAVE)
		Return
	End If
	SetScreenBrightnessAndOptionalSave(pScreenBrightness,SCRN_BRIGHTNESS_NO_SAVE)
	
	Screen_ON(True)
	
End Sub


Public Sub Screen_ON(takeOverPower As Boolean)
	
	ReleaseLocks
	
	If takeOverPower Then
		#if debug
		Log("pws.KeepAlive(True)")
		#End If
		pws.KeepAlive(True)
		SetScreenBrightnessAndOptionalSave(pScreenBrightness,SCRN_BRIGHTNESS_NO_SAVE)
	Else
		'---("KeepAlive - OFF")
	End If
	
	CallSubDelayed2(Main,"Dim_ActionBar",gblConst.ACTIONBAR_ON)
	IsScreenOff = False
	
End Sub


Public Sub Screen_Off
	
	#if debug
	Log("Screen_Off called")
	#End If
	
	If mTakeOverPower Then
		ReleaseLocks
		pws.KeepAlive(True)
		pws.PartialLock
	End If
	
	ph.SetScreenBrightness(.01)
	IsScreenOff = True
	
End Sub

Public Sub ReleaseLocks
	pws.ReleaseKeepAlive
	pws.ReleasePartialLock
End Sub

'=================================================================================
'=================================================================================


' 0 to 1 - so 0.5 is valid
Public Sub SetScreenBrightnessAndOptionalSave(value As Float, SaveMe As Boolean)
	
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
	SetScreenBrightnessAndOptionalSave(pScreenBrightness,SCRN_BRIGHTNESS_NO_SAVE)
	
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
	SetScreenBrightnessAndOptionalSave(v,SCRN_BRIGHTNESS_SAVE)
	pScreenBrightness = v
	
End Sub



Public Sub DimTheScrnBySettingBrightness
	'--- from KitchenEsentials code
	Dim SCRN_DIM_PCT1 As Float = .01
	#if debug
	Log("Public Sub DimTheScrnBySettingBrightness")
	#end if
	Dim f As Float = SCRN_DIM_PCT1
	ph.SetScreenBrightness(f)
End Sub

