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
	Private pnlBtns As B4XView
	Private btnStart,btnFullScrn,btnNext,btnPrev As Button
	

	
	Private lvPics As CustomListView
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pagePhotosBase")
	
	guiHelpers.SkinButton(Array As Button(btnStart,btnFullScrn,btnNext,btnPrev))
	LoadFrame
	
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

Private Sub LoadFrame
	img.Bitmap = LoadBitmapResize(File.DirAssets,"pframe.png",img.Width,img.Height,False)
End Sub

Private Sub btnPressed_Click
	Dim o As Button = Sender
	
	Select Case o.Tag
		Case "ss" '--- start show
		Case "n" '--- next
		Case "p" '--- prev
		Case "f" '--- full screen
	End Select
	
End Sub