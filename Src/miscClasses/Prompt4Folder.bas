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

#Event: SelectedFolder(f as string)

'-------- NOT USED AT THE MOMENT ---------------
'-------- NOT USED AT THE MOMENT ---------------
'-------- NOT USED AT THE MOMENT ---------------
'-------- NOT USED AT THE MOMENT ---------------
'-------- NOT USED AT THE MOMENT ---------------
'-------- NOT USED AT THE MOMENT ---------------



Sub Class_Globals
	Private XUI As XUI
	Private Ion As Object
	Private callback As Object
	Public pSelectedFolder As String = ""
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


'Sub SelectExtFolder2
'	'--- Android 5
'	Dim oo As ExternalStorage
'	oo.Initialize(Me,"folder")
'	oo.SelectDir(True)
'	Wait For folder_ExternalFolderAvailable
'	'------------------------------------
'End Sub
'Sub folder_ExternalFolderAvailable
'End Sub

Public Sub SelectExtFolder(callbackOBJ As Object)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	callback = callbackOBJ
	Dim i As Intent
	i.Initialize("android.intent.action.OPEN_DOCUMENT_TREE", "")
	StartActivityForResult(i)
	Log("dddddddddddddd!!!!!!!!!!!!!!!!")
	Wait For Stump
	Log("ddddddddddddddddddddddddddddddd")
End Sub


Private Sub StartActivityForResult(i As Intent)
	Dim jo As JavaObject = GetBA
	Ion = jo.CreateEvent("anywheresoftware.b4a.IOnActivityResult", "ion", Null)
	jo.RunMethod("startActivityForResult", Array As Object(Ion, i))
End Sub


Private Sub GetBA As Object
    Dim jo As JavaObject = Me
    Return jo.RunMethod("getBA", Null)
End Sub


Private Sub ion_Event(MethodName As String, Args() As Object) As Object
	Dim TreeDirectory As String = ""
	If -1 = Args(0) Then 'resultCode = RESULT_OK
		Dim i As Intent = Args(1)
		TreeDirectory = i.GetData
		pSelectedFolder = HandleTreeDirectoryString(TreeDirectory)
		'Log(TreeDirectory)
	Else
		'Log(Args(0))
	End If
	Stump
	Return Null
End Sub

Private Sub Stump
End Sub


Private Sub HandleTreeDirectoryString(Tree As String) As String
	Dim StoragePath As String = Tree.SubString2(0,Tree.IndexOf("%3A"))
	StoragePath = StoragePath.Replace("content://com.android.externalstorage.documents/tree","") & "/"
	Dim RealPath As String = Tree.SubString2(Tree.IndexOf("%3A"), Tree.Length)
	RealPath = RealPath.Replace("%3A", "") 'StartSlashStorage
	RealPath = RealPath.Replace("%2F","/") 'NormalSlash
	Dim FullPath As String = "/storage" & StoragePath & RealPath
	Return FullPath
	'ToastMessageShow(FullPath, True)
	'Log(FullPath)
End Sub


