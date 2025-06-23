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
		
	Public IsFullScreen As Boolean = False
	
	Private img As sadImageSlider
	Private pnlFullScrn As Panel
	Private imgFullScrn As lmB4XImageViewX
	Private ndxFullScrn As Int = 0
	
	Public tmrPicShow As Timer

	Private lstPics As List
	Private picPath As String = ""
	Private TimeBetweenPics As Long

	Private AutoTextSizeLabel1 As AutoTextSizeLabel
	Private btnFullScreen As B4XView
End Sub


Public Sub Initialize(p As B4XView,pnlImgFS As Panel,imgFS As lmB4XImageViewX)
	pnlMain = p
	pnlMain.LoadLayout("pagePhotosBase2")
	
	pnlFullScrn = pnlImgFS
	imgFullScrn = imgFS
	
	config.ReadPicAlbumSetup
	ReadOptions
	
	guiHelpers.SkinButtonRounded(Array As Button(btnFullScreen))
	
	InitNewListOfPics
	If img.NumberOfImages > 0 Then img.NextImage
	FullScrn(False)
	
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
	Log("set_focus - pics")
	mpage.tmrTimerCallSub.CallSubDelayedPlus(Me,"Build_Side_Menu",250)
	Menus.SetHeader("Photo Album","main_menu_pics.png")
	pnlMain.SetVisibleAnimated(500,True)
	
	If config.MainSetupData.Get(gblConst.KEYS_MAIN_SETUP_PAGE_PHOTO).As(Boolean) Then
		'--- if the pic album viewer timer is on then remove it
		mpage.tmrTimerCallSub.ExistsRemove(Me,"turn_on_pic_album")
	End If
	
End Sub
Public Sub Lost_focus()
	tmrPicShow.Enabled = False
	pnlMain.SetVisibleAnimated(500,False)
	
	'--- this will turn back on the pic album timer if needed.
	CallSubDelayed(mpage,"ResetScrn_SleepCounter") 
	
End Sub

'=============================================================================================
'=============================================================================================
'=============================================================================================
Private Sub Build_Side_Menu
	Dim sh As String = "Start Show"
	If tmrPicShow.Enabled Then 
		sh = "Stop Show"
	End If
	Menus.BuildSideMenu(Array As String("Next","Previous",sh,"Full Screen","Re-Scan"),Array As String("n","p","ss","f","rs"))
End Sub


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
	If IsFullScreen Then
		imgFullScrn.Load(picPath, lstPics.Get(ndxFullScrn))
	End If
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


Public Sub img_GetImage(Index As Int) As ResumableSub
	#if debug
	ShowMemory
	Log(Index)
	#end if
	
	ndxFullScrn = Index - 1
	'Log("ndxFullScrn--------------> "&ndxFullScrn)
	If ndxFullScrn < 0 Then ndxFullScrn = 0
	
	Try
		Return XUI.LoadBitmapResize(picPath, lstPics.Get(Index), img.WindowBase.Width, img.WindowBase.Height, True)
	Catch
	End Try 'ignore
	
	'--- return a NOT FOUND image
	Return XUI.LoadBitmapResize(File.DirAssets, "pic_not_found.png", img.WindowBase.Width, img.WindowBase.Height, True)
	
End Sub

Public Sub Stop_fullScrn
	If IsFullScreen = False Then Return
	FullScrn(False)
	tmrPicShow.Enabled = False
End Sub


Private Sub ReadPicsList() As Boolean
	lstPics.Initialize
	img.NumberOfImages = 0
	ndxFullScrn	= 0
	
	If File.Exists(XUI.DefaultFolder,gblConst.PIC_LIST_FILE) Then
		lstPics = objHelpers.ListFromDisk(XUI.DefaultFolder,gblConst.PIC_LIST_FILE)
		img.NumberOfImages = lstPics.Size
		Return True
	End If
	
	Return False
	
End Sub

Private Sub BuildPicList
	
	lstPics.Initialize
	Try
		For Each f As String In File.ListFiles(picPath)
			If f.ToLowerCase.EndsWith("jpg") Or f.ToLowerCase.EndsWith("png") Then
				lstPics.Add(f)
				Log(f)
			End If
		Next
	Catch
		Log(LastException)
	End Try
	
	objHelpers.List2Disk(XUI.DefaultFolder,gblConst.PIC_LIST_FILE,lstPics)
	'/mnt/sdcard/pics
	Log("ttl pics ---> " & lstPics.Size)
	
	img.NumberOfImages = lstPics.Size
	
	
End Sub

Private Sub SideMenu_ItemClick (Index As Int, Value As Object)
	
	'--- no valid path, do they want a rescan?
	If AutoTextSizeLabel1.BaseLabel.Visible And Value <> "rs" Then Return
	
	Dim HasShowStarted As Boolean = tmrPicShow.Enabled
	
	Select Case Value
		Case "n" '--- next
			If HasShowStarted Then tmrPicShow.Enabled = False
			img.NextImage
			If HasShowStarted Then tmrPicShow.Enabled = True
			
		Case "p" '--- prev pic
			If HasShowStarted Then tmrPicShow.Enabled = False
			img.PrevImage
			If HasShowStarted Then tmrPicShow.Enabled = True
			
		Case "ss" '--- start show
			tmrPicShow.Enabled = Not (tmrPicShow.Enabled )
			If tmrPicShow.Enabled Then mpage.pnlSideMenu.SetVisibleAnimated(380, False) '---  close side menu if open
						
		Case "f" '--- full screen
			FullScrn(True)
			
		Case "rs" '--- rescan pics  TODO!!!!!!  add to menu
			fileHelpers.SafeKill(XUI.DefaultFolder,gblConst.PIC_LIST_FILE)
			InitNewListOfPics
	
	End Select
	'mpage.pnlSideMenu.SetVisibleAnimated(380, False) '---  close side menu
	Build_Side_Menu
	CallSubDelayed(mpage,"ResetScrn_SleepCounter")
	Sleep(0)

	
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


Public Sub Start_full_scrn
	#if debug
	Log("!!! Start_full_scrn from system !!!")
	#End If
	If picPath = "" Then
		#if debug
		Log("!!! Start_full_scrn from system -- no valid path")
		#End If
		Return
	End If
	ReadOptions
	tmrPicShow.Enabled = True
	'Log("FS------------------>"& config.PicAlbumSetupData.Get(gblConst.KEYS_PICS_SETUP_START_IN_FULLSCREEN).As(Boolean))
	If config.PicAlbumSetupData.Get(gblConst.KEYS_PICS_SETUP_START_IN_FULLSCREEN).As(Boolean) Then
		FullScrn(True)
	End If
End Sub


Public Sub FullScrn(Show As Boolean)
	
	pnlFullScrn.Visible = Show
	img.WindowBase.Visible = Not (Show)
	
	If Show Then
		guiHelpers.Show_toast("Touch to exit full screen")
		pnlFullScrn.As(Panel).Elevation = 8dip
		pnlFullScrn.BringToFront
		imgFullScrn.Load(picPath, lstPics.Get(ndxFullScrn))
		btnFullScreen.Visible = False
	Else
		pnlFullScrn.As(Panel).Elevation = -8dip
		pnlFullScrn.SendToBack
		btnFullScreen.Visible = True
	End If
	
	mpage.pnlSideMenu.SetVisibleAnimated(380, False) '---  close side menu if open
	IsFullScreen = Show
	'Sleep(0)
	
End Sub

Private Sub ReadOptions
	
	TimeBetweenPics = _
			config.PicAlbumSetupData.Get(gblConst.KEYS_PICS_SETUP_SECONDS_BETWEEN) * 1000
	tmrPicShow.Initialize("tmrShow",TimeBetweenPics)
	
	If tmrPicShow.Enabled Then
		tmrPicShow.Enabled = False
		Sleep(0)
		tmrPicShow.Enabled = True
	End If
	
	Dim at As String = config.PicAlbumSetupData.Get(gblConst.KEYS_PICS_SETUP_TRANSITION)
	If at = "Slide" Then at = "Horizontal"
	img.AnimationType = at
		
End Sub


Private Sub btnFullScreen_Click
	If picPath = "" Then Return
	FullScrn(True)
	tmrPicShow.Enabled = True
End Sub