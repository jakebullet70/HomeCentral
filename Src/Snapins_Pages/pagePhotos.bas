B4J=true
Group=Pages-Snapins
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' End of May 2025, still war. Lets give it another try
' V. 1.0 	Dec/26/2023
#End Region


Sub Class_Globals
	Private XUI As XUI
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private pnlMain As B4XView
	Private Const PIC_LIST_FILE As String = "pics.lst"
	
	Private img As sadImageSlider
	
	Private pnlBtns As Panel
	Private btnStart,btnFullScrn,btnNext,btnPrev As Button
	
	Public tmrPicShow As Timer

	Private lstPics As List
	Private picPath As String = ""
	Private TimeBetweenPics As Long = 8000

	Private pnlSplitter As B4XView
	
	Private AutoTextSizeLabel1 As AutoTextSizeLabel
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pagePhotosBase")
	
	guiHelpers.SkinButton(Array As Button(btnStart,btnFullScrn,btnNext,btnPrev))
	guiHelpers.SetPanelsDividers(Array As B4XView(pnlSplitter),clrTheme.txtNormal)
	
	tmrPicShow.Initialize("tmrShow",TimeBetweenPics)
	tmrPicShow.Enabled = False
	
	pnlBtns.Visible = True
	InitNewListOfPics
	If img.NumberOfImages > 0 Then img.NextImage
	
	
End Sub

Private Sub InitNewListOfPics
	picPath = GetPhotosShowPath
	If picPath <> "" Then
		If ReadPicsList = False Then
			BuildPicList
		End If
	End If

End Sub

'-------------------------------
Public Sub Set_focus()
	'mpage.tmrTimerCallSub.CallSubDelayedPlus(Me,"Build_Side_Menu",250)
	Menus.SetHeader("Photo Album","main_menu_pics.png")
	pnlMain.SetVisibleAnimated(500,True)
	btnStart.Text = "Start Show"
End Sub
Public Sub Lost_focus()
	tmrPicShow.Enabled = False
	pnlMain.SetVisibleAnimated(500,False)
End Sub

'=============================================================================================
'=============================================================================================
'=============================================================================================
'Private Sub Build_Side_Menu
'	Menus.BuildSideMenu(Array As String(""),Array As String(""))
'End Sub


'https://www.b4x.com/android/forum/threads/view-utils.39347/#post-233788
Sub setRotationY(v As B4XView, Angle As Float)'ignore
	Dim jo = v As JavaObject
	jo.RunMethod("setRotationY", Array As Object(Angle))
End Sub
Sub setRotationX(v As B4XView, Angle As Float)'ignore
	Dim jo = v As JavaObject
	jo.RunMethod("setRotationX", Array As Object(Angle))
End Sub

Private Sub tmrShow_Tick
	tmrPicShow.Enabled = False
	img.NextImage
	tmrPicShow.Enabled = True
End Sub

#if debug
Private Sub ShowMemory
	Try
		Dim r As Reflector
		r.Target = r.RunStaticMethod("java.lang.Runtime", "getRuntime", Null, Null)
		Log("available Memory = " & ((r.RunMethod("maxMemory") - r.RunMethod("totalMemory"))/(1024*1024)) & " MB")
	Catch
		Log(LastException)
	End Try
End Sub
#end if

Sub img_GetImage(Index As Int) As ResumableSub
	#if debug
	ShowMemory
	Log(Index)
	#end if
	Return XUI.LoadBitmapResize(picPath, lstPics.Get(Index), img.WindowBase.Width, img.WindowBase.Height, True)
End Sub

Private Sub ReadPicsList() As Boolean
	lstPics.Initialize
	
	If File.Exists(XUI.DefaultFolder,PIC_LIST_FILE) Then
		lstPics = objHelpers.ListFromDisk(XUI.DefaultFolder,PIC_LIST_FILE)
		img.NumberOfImages = lstPics.Size
		Return True
	End If
	
	Return False
	
End Sub

Private Sub BuildPicList
	
	lstPics.Initialize
	Try
		For Each f As String In File.ListFiles(picPath)
			If f.EndsWith("jpg") Or f.EndsWith("png") Then
				lstPics.Add(f)
			End If
		Next
	Catch
		Log(LastException)
	End Try
	
	objHelpers.List2Disk(XUI.DefaultFolder,PIC_LIST_FILE,lstPics)
	'/mnt/sdcard/pics
	Log("ttl pics ---> " & lstPics.Size)
	img.NumberOfImages = lstPics.Size
	
	
End Sub


Private Sub btnPressed_Click
		
	Dim b As Button = Sender
	Log("btn tag --> " & b.Tag)
	
	'--- no valid path, do they want a rescan?
	If AutoTextSizeLabel1.BaseLabel.Visible And b.Tag <> "rs" Then Return
			
	Select Case b.Tag 'IGNORE
		Case "n" '--- next
			If btnStart.Text.StartsWith("Sto") Then tmrPicShow.Enabled = False
			img.NextImage
			If btnStart.Text.StartsWith("Sto") Then tmrPicShow.Enabled = True
			
			
		Case "p" '--- prev pic
			If btnStart.Text.StartsWith("Sto") Then tmrPicShow.Enabled = False
			img.PrevImage
			If btnStart.Text.StartsWith("Sto") Then tmrPicShow.Enabled = True
			
		Case "ss" '--- start show
			tmrPicShow.Enabled = Not (tmrPicShow.Enabled )
			If tmrPicShow.Enabled Then 
				btnStart.Text = "Stop Show"
			Else
				btnStart.Text = "Start Show"
			End If
						
		Case "f" '--- full screen
			guiHelpers.Show_toast("TODO")
			Return
			
		Case "rs" '--- rescan pics  TODO!!!!!!  add to menu
			
			fileHelpers.SafeKill(XUI.DefaultFolder,PIC_LIST_FILE)
			InitNewListOfPics
'			
'			Dim oo As Prompt4Folder'ignore
'			oo.Initialize
'			oo.SelectExtFolder(Me)
'			Wait For Selected_Folder(f As String)
'			Log("OK --> " & oo.pSelectedFolder)
	
	End Select
	CallSubDelayed(mpage,"ResetScrn_SleepCounter")
	
End Sub




Private Sub GetPhotosShowPath() As String
	
	#if debug
	Log("File.DirRootExternal:"&File.DirRootExternal)
	Log("File.DirRootExternalPics:"&File.DirRootExternal & "/Pictures/")
	Log("Main.Provider.SharedFolder:"&Main.Provider.SharedFolder)
	Log("File.DirInternal:"&File.DirInternal)
	#end if
	
	AutoTextSizeLabel1.BaseLabel.Visible = False
	AutoTextSizeLabel1.BaseLabel.SendToBack
	Dim ppath As String = ""
	Dim retPath As String = ""
		
	Do While True
	
		'--- just try the extenal folder
		If File.ExternalReadable Then
			ppath = File.DirRootExternal & "/" & gblConst.PHOTOS_PATH
			If File.Exists(ppath ,"") Then
				retPath = ppath : Exit 'Do
			End If
		End If
		
		'--- just try the extenal folder with pictures folders
		Try
			ppath = File.DirRootExternal & "/Pictures/" & gblConst.PHOTOS_PATH
			If File.Exists(ppath ,"") Then
				retPath = ppath : Exit 'Do
			End If
		Catch
		End Try 'ignore
		
		'--- Main.Provider.SharedFolder
		ppath = Main.Provider.SharedFolder & "/" & gblConst.PHOTOS_PATH
		If File.Exists(ppath ,"") Then
			retPath = ppath : Exit 'Do
		End If
		
		'--- File.DirInternal
		ppath = File.DirInternal & "/" & gblConst.PHOTOS_PATH
		If File.Exists(ppath ,"") Then
			retPath = ppath : Exit 'Do
		End If
						
		ppath = "/Removable/MicroSD/" & gblConst.PHOTOS_PATH
		If File.Exists(ppath ,"") Then
			retPath = ppath : Exit 'Do
		End If
		
		Exit '--- just bail
	Loop
	
	If retPath = "" Then
		AutoTextSizeLabel1.BaseLabel.BringToFront
		Dim aa As StringBuilder : aa.Initialize
		guiHelpers.Show_toast2("Valid path not found",2200)
		aa.Append("Valid path not found, Paths checked:").Append(CRLF)
		aa.Append(File.DirRootExternal & "/Pictures/" & gblConst.PHOTOS_PATH).Append(CRLF)
		aa.Append(File.DirRootExternal& "/" & gblConst.PHOTOS_PATH).Append(CRLF)
		aa.Append(Main.Provider.SharedFolder& "/" & gblConst.PHOTOS_PATH).Append(CRLF)
		aa.Append(File.DirInternal& "/" & gblConst.PHOTOS_PATH).Append(CRLF)	
		AutoTextSizeLabel1.TextColor = clrTheme.txtNormal
		AutoTextSizeLabel1.Text = aa.ToString
		AutoTextSizeLabel1.BaseLabel.Visible = True
		Return ""
	End If
	
	#if debug
	guiHelpers.Show_toast2("Path:" & ppath,2500)
	#end if
	Return ppath
	
End Sub



