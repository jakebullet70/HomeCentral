﻿B4J=true
Group=MiscClasses
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
End Sub

Public Sub Initialize()
End Sub

Public Sub CheckAndUpgrade
	
	If gblConst.APP_FILE_VERSION > Main.kvs.Get(gblConst.INI_CURRENT_VER) Then
		'--- do we need to upgade settings files? new stuff?
		'--- tell user of any new features?
		Log("this is a new app version!!!")
		
		'--- now update the app version to the settings file
		Main.kvs.Put(gblConst.INI_CURRENT_VER,gblConst.APP_FILE_VERSION)
	End If
	
End Sub
