B4J=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Dec/21/2023
#End Region


Sub Class_Globals
	Private XUI As XUI
	Private dlg As B4XDialog
	Private lblAboutTop As Label
	Private dlgHelper As sadB4XDialogHelper
	Private iv As lmB4XImageViewX
	Private MadeWithLove1 As MadeWithLove
	Private lblEULA As Label
	Private tmr As Timer
	Private cs As CSBuilder
	Private ELUA_Mode As Boolean = False
	
	Private credits As CreditsRollView
	Private creditsMax As Int = 30000, creditsPos As Int = 0
End Sub


Public Sub Initialize(Dialog As B4XDialog)
	dlg = Dialog
End Sub
Public Sub Close_Me
	dlg.Close(XUI.DialogResponse_Cancel)
End Sub


Public Sub Show()
		
	dlg.Initialize((B4XPages.MainPage.Root))
	dlgHelper.Initialize(dlg)
		
	Dim p As B4XView = XUI.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0,430dip,400dip)
	p.LoadLayout("dlgAbout")
	
	iv.Bitmap = XUI.LoadBitmap(File.DirAssets,"logo02.png")
	
	
	dlgHelper.ThemeDialogForm( "About")
	Dim rs As ResumableSub = dlg.ShowCustom(p, "", "", "OK")
	dlgHelper.ThemeDialogBtnsResize
		
	'--- interesting text goes here
	lblAboutTop.TextSize = 18
	guiHelpers.SetTextColor(Array As B4XView(lblAboutTop),clrTheme.txtNormal)
	credits.TextColor = clrTheme.txtNormal
	InitCredits
	Dim lbl As Label = MadeWithLove1.mBase.GetView(0) : lbl.TextColor= clrTheme.txtNormal
	BuildLicLabel
	
	Dim msg As StringBuilder : msg.Initialize
	msg.Append("(©)sadLogic 2015-25").Append(CRLF)
	msg.Append("Kherson Ukraine!").Append(CRLF)
	msg.Append("AGPL-3.0 license")
	lblAboutTop.Text = msg.ToString
	
	Wait For (rs) Complete (Result As Int)
	CallSubDelayed(B4XPages.MainPage,"ResetScrn_SleepCounter")
	tmr.Enabled = False
	
End Sub


Private Sub license_Click
	If lblEULA.Text.ToLowerCase.Contains("license") Then
		lblEULA.Text = cs.Initialize.Underline.Color(clrTheme.txtNormal).Append("About").PopAll
		ELUA_Mode = True
		InitCredits
	Else
		lblEULA.Text = cs.Initialize.Underline.Color(clrTheme.txtNormal).Append("License").PopAll
		ELUA_Mode = False
		InitCredits
	End If
End Sub


Private Sub BuildLicLabel

	lblEULA.Initialize("license")
	lblEULA.TextSize = 20
	dlg.Base.AddView(lblEULA,14dip,dlg.Base.Height - 47dip, _
			(dlg.Base.Width - dlg.GetButton(XUI.DialogResponse_Cancel).Width - 20dip),36dip)
	lblEULA.Text = cs.Initialize.Underline.Color(clrTheme.txtNormal).Append("License").PopAll
	
End Sub


Sub timer_Tick
	If creditsPos < creditsMax Then
		creditsPos = creditsPos +1
	End If
	'Log((creditsPos/1000))
	If (creditsPos/1000) >= 1 Then
		tmr.Enabled = False
		creditsPos = 0
		InitCredits
	End If
	credits.ScrollPosition = (creditsPos/1000)
	credits.DistanceFromText = 50dip
	credits.Angle = 20
	'credits.Height = 100%y
	'credits.Width = 100%x
	credits.TextSize = 40
	
	
End Sub


Private Sub InitCredits

	Dim ver As String = "HomeCentral™ V" & Application.VersionName
	
	If ELUA_Mode Then
		
		credits.TextSize = 20
		credits.EndScrollMult = 1
		credits.Text = CRLF & CRLF & $"
Released under the GNU AFFERO GENERAL PUBLIC LICENSE
Version 3, 19 November 2007

This is free software. In a nutshell...

When we speak of free software, we are referring to freedom, not price.  
Our General Public Licenses are designed to make sure that you have the freedom to distribute copies of free software (and charge for them if you wish), that you receive source code or can get it if you want it, that you can change the software or use pieces of it in new free programs, and that you know you can do these things.
 
See the complete text on the license in the folder where this software is installed or search the internet for:
'GNU AFFERO GENERAL PUBLIC LICENSE V3'
"$
		
		tmr.Initialize("timer",30)
		
	Else
		credits.TextSize = 24
		credits.EndScrollMult = 1
		
		credits.Text = CRLF & CRLF & ver & $"
		
---------------------------

- Legal Crap -
(©)sadLogic 2015-25
(©)eHomeCreations 2002 - 2015
(©)Humankind - Forever


- About - 
A dedicated tablet application for your kitchen / home using older Android devices. 
HomeCentral was created by a family for other families. It has been a work of love for over 20 years. 
At this point though the kids are grown and gone and its time to just release this into the wild as FOSS.

We sincerely hope you enjoy using it and welcome any and all feedback you can share with us.

Thanks!


- Programmers - 
---------------------------
Steven De George SR
Steven De George JR
Bogdan De George


- Art Work -
--------------------------
Stacey (De George) Hafner
openclipart.org
  
  
- Thanks to - 
--------------------------
b4a Language: Erel
b4a forum: klaus (Switzerland)
b4a forum: agraham (UK)
b4a forum: Alexander Stolte (Germany)
b4a forum: Informatix (France)
b4a forum: DonManfred (Germany)
b4a forum: Magma (Greece)
b4a forum: CableGuy (France)
b4a forum: thedesolatesoul (UK)
And many many many others...

And my poor wife who puts up with me.
"$

		tmr.Initialize("timer",50)
	End If
			
	creditsPos = 0
	'tmr.Initialize("timer",50)
	tmr.Enabled = True
	

End Sub

