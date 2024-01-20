B4J=true
Group=MiscClasses
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Jan/20/2024
#End Region


Sub Class_Globals
	Private XUI As XUI
End Sub

Public Sub Initialize()
End Sub

'--- NEEDS WORK !!!!!!!!!!!  AND TESTING !!!!!!!!!!!!!!!!!!!!!!
'--- NEEDS WORK !!!!!!!!!!!  AND TESTING !!!!!!!!!!!!!!!!!!!!!!
'--- NEEDS WORK !!!!!!!!!!!  AND TESTING !!!!!!!!!!!!!!!!!!!!!!

'https://www.b4x.com/android/forum/threads/external-sd-card-on-android-5.75474/
'https://www.b4x.com/android/forum/threads/intent-based-sd-card-folder-picker-how-to-get-the-selected-folder-name.124318/#post-776365
'https://www.b4x.com/android/forum/threads/externalstorage-access-sd-cards-and-usb-sticks.90238/
'https://www.b4x.com/android/forum/threads/manage-external-storage-access-internal-external-storage-sdk-30.130411/


'https://www.b4x.com/android/forum/threads/android-jar-targetsdkversion-minsdkversion.87610/#content


Sub SelectExtFolder
	'--- Android 5
	Dim oo As ExternalStorage
	oo.Initialize(Me,"folder")
	oo.SelectDir(True)
	Wait For folder_ExternalFolderAvailable
	'------------------------------------
End Sub
Sub folder_ExternalFolderAvailable
	
End Sub

