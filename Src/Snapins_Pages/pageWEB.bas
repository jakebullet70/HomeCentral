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

	
	Private wv As WebView,  wvs As WebViewSettings
	Private WebViewExtras1 As WebViewExtras
	Private WebChromeClient1 As DefaultWebChromeClient 'ignore
	Private JavascriptInterface1 As DefaultJavascriptInterface
	Private WebViewClient1 As DefaultWebViewClient
	'Dim JavascriptInterface1 As DefaultJavascriptInterface
	
	Private btnMoveH,btnMoveB,btnMoveF,btnMoveR As Button
	
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pageWebBase")
	
	guiHelpers.SkinButton(Array As Button(btnMoveB,btnMoveF,btnMoveH,btnMoveR))
	Get_homepage
		
	guiHelpers.ResizeText(Chr(0xE88A),btnMoveH)
	btnMoveH.TextSize = btnMoveH.TextSize - IIf(guiHelpers.gScreenSizeAprox > 7.5,22,14)
	guiHelpers.SetTextSize(Array As B4XView(btnMoveB,btnMoveF,btnMoveR),btnMoveH.TextSize)
	
	Dim ph As Phone
	
	'--- web extra's 
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

Private Sub Build_Side_Menu
	Menus.BuildSideMenu(Array As String(""),Array As String(""))
End Sub

Private Sub Get_homepage
	homePage = Main.kvs.Get(gblConst.INI_WEB_HOME)
	If strHelpers.IsNullOrEmpty(homePage) Then
		Main.kvs.Put(gblConst.INI_WEB_HOME,"http://sadlogic.com")
		homePage = Main.kvs.Get(gblConst.INI_WEB_HOME)
	End If
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
			CallSubDelayed2(Me,"Load_page",homePage)
		Case "b" '--- back
			wv.Back
		Case "r" '--- refresh			
			If CurrentPage = "" Then Return
			CallSubDelayed2(Me,"Load_page",CurrentPage)
	End Select
End Sub