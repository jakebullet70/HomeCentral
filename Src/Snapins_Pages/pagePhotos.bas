B4J=true
Group=Pages-Snapins
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
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private pnlMain As B4XView
	
	Private img As lmB4XImageViewX
	
	Private pnlBtns As Panel
	Private btnStart,btnFullScrn,btnNext,btnPrev As Button
	
	Private lvPics As CustomListView
	Private PCLV As PreoptimizedCLV
	Private tmrPicShow  As Timer

	Private lstPics As List
	Private picPath As String = "/Removable/MicroSD/pics"
	'Private picPath As String = "/storage/D409-BC20/pics"
	Private picPointer As Int = 1
	Private lvPointerHigh,lvPointerLow As Int 'ignore
	
	Private img As lmB4XImageViewX
	Private lmB4XImageViewX1 As lmB4XImageViewX
	Private pnlSplitter As B4XView
	
	
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pagePhotosBase")
	
	guiHelpers.SkinButton(Array As Button(btnStart,btnFullScrn,btnNext,btnPrev))
	guiHelpers.SetPanelsDividers(Array As B4XView(pnlSplitter),clrTheme.txtNormal)
	
	tmrPicShow.Initialize("tmrShow",8000)
	tmrPicShow.Enabled = False
	
	pnlBtns.Visible = True
		
	ScanPics

	lvPics.AsView.Color = XUI.Color_Transparent
	img.Bitmap = LoadBitmapResize(File.DirAssets,"pframe.png",img.Width,img.Height,False)
	PCLV.Initialize(Me, "PCLV", lvPics)
	PCLV.ShowScrollBar = False
	Dim size As Float = lvPics.AsView.Height
	For x = 0 To lstPics.Size - 1
		PCLV.AddItem(size, XUI.Color_Transparent, x & "::" & lstPics.Get(x))
	Next
	PCLV.Commit
	img.mBase.Visible = False
	
End Sub


'-------------------------------
Public Sub Set_focus()
	Menus.SetHeader("Photo Album","main_menu_pics.png")
	pnlMain.SetVisibleAnimated(500,True)
End Sub
Public Sub Lost_focus()
	pnlMain.SetVisibleAnimated(500,False)
End Sub

'=============================================================================================
'=============================================================================================
'=============================================================================================


'Return the hint that will be displayed when the user fast scrolls the list. It can be a string or CSBuilder.
Sub PCLV_HintRequested (Index As Int) As Object
	Dim word As String = lvPics.GetValue(Index)
	Return word
End Sub

Sub  lvPics_VisibleRangeChanged (FirstIndex As Int, LastIndex As Int)
	For Each i As Int In PCLV.VisibleRangeChanged(FirstIndex, LastIndex)
		Dim item As CLVItem = lvPics.GetRawListItem(i)
		Dim pnl As B4XView = XUI.CreatePanel("")
		item.Panel.AddView(pnl, 0, 0, item.Panel.Width, item.Panel.Height)
		pnl.LoadLayout("viewPhotoItem")
		lmB4XImageViewX1.Load(picPath, lstPics.Get(i))
		lmB4XImageViewX1.Tag = i & "::" & lstPics.Get(i)
		'setRotationY(lmB4XImageViewX1.mBase,15)
	Next
	lvPointerLow  = FirstIndex
	lvPointerHigh = LastIndex
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
	NextPic
	tmrPicShow.Enabled = True
End Sub

Private Sub ShowPic(index As Int,fname As String)'ignore
	Try
		
		'Log(fname) : Log(index)
		Dim r As Reflector
		r.Target = r.RunStaticMethod("java.lang.Runtime", "getRuntime", Null, Null)
		Log("available Memory = " & ((r.RunMethod("maxMemory") - r.RunMethod("totalMemory"))/(1024*1024)) & " MB")
		
		img.Load(picPath,fname)
				
	Catch
		Log(LastException)
	End Try
End Sub

Private Sub lvPics_ItemClick (Index As Int, Value As Object)
	lvPics.AsView.Visible = False
	img.mBase.Visible = True
	'picPointer = Index
	ShowPic(Index,Regex.Split("::",Value)(1))
End Sub

Private Sub lmB4XImageViewX1_Click
	Dim o As lmB4XImageViewX = Sender
	lvPics.AsView.Visible = False
	img.mBase.Visible = True
	tmrPicShow.Enabled = False
	ShowPic(Regex.Split("::",o.Tag)(0),Regex.Split("::",o.Tag)(1))
End Sub

Private Sub ScanPics
	lstPics.Initialize
	Try
		For Each f As String In File.ListFiles(picPath)
			If picPath = File.DirAssets Then
				If f.EndsWith("jpg") Then
					lstPics.Add(f)
				End If
			Else
				lstPics.Add(f)
			End If
		Next
	Catch
		Log(LastException)
	End Try
	'/mnt/sdcard/pics
	Log("ttl pics ---> " & lstPics.Size)
	
End Sub


Private Sub img_Click
	Log("img_Click")
	lvPics.AsView.Visible = True
	img.mBase.Visible = False
	lvPics.JumpToItem(picPointer) '--- keep the ListView in sync
End Sub

Private Sub NextPic
	picPointer = picPointer + 1
	If picPointer > (lstPics.Size -1) Then
		picPointer = 0
	End If
	ShowPic(picPointer,lstPics.Get(picPointer))
End Sub

Private Sub btnPressed_Click
	Dim b As Button = Sender
	Log("btn tag --> " & b.Tag)
	Select Case b.Tag
		Case "n" '--- next
			NextPic
			
		Case "p" '--- prev pic
			picPointer = picPointer - 1
			If picPointer < 0 Then
				picPointer = (lstPics.Size -1)
			End If
			ShowPic(picPointer,lstPics.Get(picPointer))
			
		Case "ss" '--- start show
			lvPics.AsView.Visible = False
			img.mBase.Visible = True
			tmrPicShow.Enabled = True
			ShowPic(picPointer,lstPics.Get(picPointer))
			
		Case "f" '--- full screen
			
			guiHelpers.Show_toast("TODO")
			Return
			
			Dim oo As Prompt4Folder'ignore
			oo.Initialize
			oo.SelectExtFolder(Me)
			Wait For Selected_Folder(f As String)
			Log("OK --> " & oo.pSelectedFolder)
	
	End Select
	
End Sub






