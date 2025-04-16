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

	
	Private wv As WebView
	Dim wvs As WebViewSettings
	Dim WebViewExtras1 As WebViewExtras
	Dim WebChromeClient1 As DefaultWebChromeClient
	Dim JavascriptInterface1 As DefaultJavascriptInterface
	Dim WebViewClient1 As DefaultWebViewClient
	'Dim JavascriptInterface1 As DefaultJavascriptInterface
	
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	pnlMain.LoadLayout("pageWebBase")
	
	'guiHelpers.SkinButton(Array As Button(btnStart,btnFullScrn,btnNext,btnPrev))
	
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
		LogIt.LogWrite("WebViewExtras1.JavaScriptEnabled FAILED",0)
		Log(LastException)
	End Try
	
	WebViewExtras1.SetWebViewClient(WebViewClient1)

	wvs.setUseWideViewPort(wv, True)
	wvs.setDisplayZoomControls(wv, False)
	wvs.setLoadsImagesAutomatically(wv, True)

	mpage.tmrTimerCallSub.CallSubDelayedPlus(Me,"Load_Page",1000)
End Sub


'-------------------------------
Public Sub Set_focus()
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



Private Sub Load_page
	
	wv.LoadUrl("http://sadlogic.com")
End Sub

