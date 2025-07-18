B4J=true
Group=Pages-Snapins
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Apr15/2025
#End Region


Sub Class_Globals
	Private XUI As XUI
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private pnlMain As B4XView
	Private homePage As String = ""
	Private CurrentPage As String

	
	Private wv As WebView
#IF NON_FOSS	
   Private  wvs As WebViewSettings
	Private WebViewExtras1 As WebViewExtras
	Private WebChromeClient1 As DefaultWebChromeClient 'ignore
	Private JavascriptInterface1 As DefaultJavascriptInterface
	Private WebViewClient1 As DefaultWebViewClient
#End if
	
	Private btnMoveH,btnMoveB,btnMoveF,btnMoveR As Button
	
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pageWebBase")
	
	guiHelpers.SkinButton(Array As Button(btnMoveB,btnMoveF,btnMoveH,btnMoveR))
	
	web.InitSql
	Get_homepage ' TODO!!!!!!!!!!!
		
	guiHelpers.ResizeText(Chr(0xE88A),btnMoveH)
	btnMoveH.TextSize = btnMoveH.TextSize - IIf(guiHelpers.gScreenSizeAprox > 7.5,22,14)
	guiHelpers.SetTextSize(Array As B4XView(btnMoveB,btnMoveF,btnMoveR),btnMoveH.TextSize)
	
	
	
	#IF NON_FOSS	
	'--- web extra's 
	Dim ph As Phone 
	Dim JavascriptInterface1 As DefaultJavascriptInterface
	JavascriptInterface1.Initialize
	WebViewExtras1.Initialize(wv)
	'   WebViewExtras1 now has all the methods and properties of WebView1 plus it's additonal methods and properties
	'   so you can use WebView1 to get/set WebView properties/methods
	'   or use WebViewExtras1 to get/set WebView1 properties/methods with the additional properties/method of WebViewExtras
	Dim WebViewClient1 As DefaultWebViewClient
	WebViewClient1.Initialize("WebViewClient1")
	Try
		If ph.SdkVersion >= gblConst.API_ANDROID_4_2 Then
			WebViewExtras1.JavaScriptEnabled = True
		End If
	Catch
		LogIt.LogWrite("WebViewExtras1.JavaScriptEnabled FAILED: " & LastException,0)
	End Try
	WebViewExtras1.SetWebViewClient(WebViewClient1)
	wvs.setUseWideViewPort(wv, True)
	wvs.setDisplayZoomControls(wv, False)
	wvs.setLoadsImagesAutomatically(wv, True)
	#end if

	CallSubDelayed2(Me,"Load_Page",homePage)
	
End Sub


'-------------------------------
Public Sub Set_focus()
	Get_homepage
	Menus.SetHeader("Web","main_menu_web.png")
	mpage.tmrTimerCallSub.CallSubDelayedPlus(Me,"Build_Side_Menu",250)
	pnlMain.SetVisibleAnimated(500,True)
End Sub
Public Sub Lost_focus()
	pnlMain.SetVisibleAnimated(500,False)
End Sub

'=============================================================================================
'=============================================================================================
'=============================================================================================

#Region SIDE_MENU

Private Sub SideMenu_ItemClick (Index As Int, Value As Object)
	CallSubDelayed(mpage,"ResetScrn_SleepCounter")
	Load_page(Value)
	mpage.pnlSideMenu.SetVisibleAnimated(380, False) '---  close side menu
End Sub
Public Sub Build_Side_Menu
		
	'Menus.BuildSideMenu(Array As String(""),Array As String(""))	
	Dim l1 As List : l1.Initialize
	Dim l2 As List : l2.Initialize
	Dim c As Cursor = web.targets_get_all
	For i = 0 To c.RowCount - 1
		c.Position = i
		l1.Add(c.GetString("description"))
		l2.Add(c.GetString("addr"))
	Next
		
	Menus.BuildSideMenu(l1,l2)
	
End Sub
#End Region

Private Sub Get_homepage
	homePage = Main.kvs.oSql.ExecQuerySingleResult("SELECT addr FROM web_targets WHERE home_page='1'")
End Sub

Private Sub Load_page(page As String)
	wv.LoadUrl(page)
	CurrentPage = page
End Sub



Private Sub btnMove_Click
	Dim b As String = Sender.As(B4XView).Tag
	Select Case b
		Case "f" '--- forward
			wv.Forward
		Case "h" '--- home
			Get_homepage
			CallSubDelayed2(Me,"Load_page",homePage)
		Case "b" '--- back
			wv.Back
		Case "r" '--- refresh			
			If CurrentPage = "" Then Return
			CallSubDelayed2(Me,"Load_page",CurrentPage)
	End Select
End Sub