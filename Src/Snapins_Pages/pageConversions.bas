B4J=true
Group=Pages-Snapins
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 2.0 	Dec/26/2023
' V. 1.X	Some time in 2014
#End Region


Sub Class_Globals
	Private XUI As XUI
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private pnlMain As B4XView
	Private cvMenu As CustomListView
	Private pnlBG,pnlNumPad,pnlInput As Panel
	Private oConversion As ConversionMod
	Private curTxt As EditText

	
	'--- number pad buttons
	Private Button1,Button2,Button3,Button4,Button5,Button6,Button7 As Button
	Private Button8,Button9,Button10,Button11,Button12 As Button

	'--- screen crap
	Private currScrn As Int
	Private lblWhat As Label
	'Private Label1,Label2,Label3,Label4,Label5,Label6,Label7,Label8,Label9 As Label
	Private scrnWeight, scrnVolume, scrnTemp, scrnLength, scrnButter As Int
	scrnButter = 0: scrnLength = 1: scrnTemp = 2: scrnVolume = 3: scrnWeight = 4
	
	'--- screen weight
	Private pnlWeight,pnlWeightF As Panel
	Private txtOZ,txtPounds,txtKG,txtGrams As EditText
	Private lblKG,lblGrams,lblPounds,lblOZ As Label
	
	'--- screen temp
	Private pnlTemp As Panel
	Private lblF,lblC As Label
	Private txtC,txtF As EditText
	
	'--- screen length
	Private pnlLength,pnlLenFrame As Panel
	Private txtInches,txtCM,txtMM As  EditText
	Private lblMM,lblCM,lblInches As Label
	
	
	'--- screen butter
	Private pnlButter As Panel
	Private txtGramsB,txtTBSP,txtStick,txtCUP,txtOZb As EditText
	Private lblGramsB,lblTBSP,lblStick,lblCUP,lblOZb As Label
	Private Panel1,Panel2,Panel3,Panel4,Panel5,Panel0 As Panel
	
	'--- screen volume
	Private lblML,lblTSP,lblTBSPb,lblFLOZ,lblCUPSb As Label
	Private lblGAL,lblLiters,lblQuarts,lblPINTS As Label
	Private pnlVolume0,pnlVolume1,pnlVolume2 As Panel
	Private txtPINTS,txtML,txtTSP,txtTBSPb,txtFlOZ,txtCUPSb,txtQuarts,txtLiters,txtGAL As EditText
	
	
	
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	p.LoadLayout("pageConversionsBase")
	
	pnlBG.Color = Colors.Transparent
	pnlNumPad.Color= Colors.Transparent
	pnlInput.Color= Colors.Transparent
	lblWhat.TextColor =clrTheme.txtNormal
	
	guiHelpers.SkinButton(Array As B4XView(Button1,Button2,Button3,Button4,Button5,Button6,Button7, _
							Button8,Button9,Button10,Button11,Button12))
'	For Each v As View In pnlNumPad.GetAllViewsRecursive
'		If(v Is Button) Then
'			Dim btn As Button = v
'			btn.TextColor = g.GetColorTheme(g.ehome_clrTheme,"highlightText")
'			g.SetColorList(btn,g.GetColorTheme(g.ehome_clrTheme,"btnNormal"), _
'		    g.GetColorTheme(g.ehome_clrTheme,"btnPressed"), _
'		    g.GetColorTheme(g.ehome_clrTheme,"btnNormal"), g.GetColorTheme(g.ehome_clrTheme,"btnDisabled"),35dip)
'		End If
'	Next
	
	oConversion.Initialize
	BuildSideMenu
	ActiveScrnLoad(scrnWeight)
	
End Sub

'-------------------------------

Public Sub Set_focus()
	Menus.SetHeader("Conversions","main_menu_conversions.png")
	pnlMain.SetVisibleAnimated(500,True)
End Sub
Public Sub Lost_focus()
	pnlMain.SetVisibleAnimated(500,False)
End Sub
Private Sub Page_Setup
	guiHelpers.Show_toast2("No setup for this page",3500)
End Sub


'=============================================================================================
'=============================================================================================
'=============================================================================================





Private Sub ActiveScrnLoad(scrn As Int)

	If currScrn = scrn Then Return
	currScrn = scrn
	pnlInput.RemoveAllViews
	
	'Dim colorHighlightText As Int = clrTheme.txtAccent
	'--- TODO change the g.GetColorTheme calls below to use the above single var
	
	pnlInput.Visible = False
	Select Case scrn
		Case scrnButter
			guiHelpers.ResizeText("Butter",lblWhat)
			pnlInput.LoadLayout("scrnConvButter")
			pnlButter.Color = Colors.Transparent
			Panel1.Color = Colors.Transparent : Panel2.Color = Colors.Transparent: Panel3.Color = Colors.Transparent
			Panel4.Color = Colors.Transparent : Panel5.Color = Colors.Transparent: Panel0.Color = Colors.Transparent
			txtGramsB_FocusChanged(True)
			txtGramsB.InputType = txtGramsB.INPUT_TYPE_NONE
			txtStick.InputType  = txtStick.INPUT_TYPE_NONE
			txtOZb.InputType    = txtOZb.INPUT_TYPE_NONE
			txtTBSP.InputType   = txtTBSP.INPUT_TYPE_NONE
			txtCUP.InputType    = txtCUP.INPUT_TYPE_NONE
			
			
			guiHelpers.ResizeText(lblGramsB.Text,lblGramsB)
			guiHelpers.ResizeText(lblCUP.Text,lblCUP)
			guiHelpers.ResizeText(lblStick.Text,lblStick)
			guiHelpers.ResizeText(lblTBSP.Text,lblTBSP)
			guiHelpers.ResizeText(lblOZb.Text,lblOZb)
			
			guiHelpers.SetTextSize(Array As B4XView(txtCUP,txtTBSP,txtGramsB,txtStick,txtOZb),24)
			guiHelpers.SetTextColor(Array As B4XView(txtCUP,txtTBSP,txtGramsB,txtStick,txtOZb),clrTheme.txtNormal)
			guiHelpers.SetTextColor(Array As B4XView(lblCUP,lblTBSP,lblGramsB,lblStick,lblOZb),clrTheme.txtNormal)
			
			
		Case scrnLength
			guiHelpers.ResizeText("Length",lblWhat)
			pnlInput.LoadLayout("scrnConvLength")
			pnlLength.Color= Colors.Transparent	: pnlLenFrame.Color= Colors.Transparent
			txtMM_FocusChanged(True)
			txtMM.InputType     = txtMM.INPUT_TYPE_NONE
			txtCM.InputType     = txtCM.INPUT_TYPE_NONE
			txtInches.InputType = txtInches.INPUT_TYPE_NONE
			
'			g.SetColorList(txtMM,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtCM,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtInches,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
			
			guiHelpers.SetTextColor(Array As B4XView(txtInches,txtCM,txtMM),clrTheme.txtNormal)
			guiHelpers.SetTextSize(Array As B4XView(txtInches,txtCM,txtMM),24)
			guiHelpers.SetTextColor(Array As B4XView(lblInches,lblCM,lblMM),clrTheme.txtNormal)
			
			guiHelpers.ResizeText(lblMM.Text,lblMM) 
			guiHelpers.ResizeText(lblCM.Text,lblCM)  
			guiHelpers.ResizeText(lblInches.Text,lblInches)
			
		Case scrnTemp
			guiHelpers.ResizeText("Temperature",lblWhat)
			pnlInput.LoadLayout("scrnConvTemp")
			pnlTemp.Color = Colors.Transparent
			txtF_FocusChanged(True)
			txtF.InputType = txtF.INPUT_TYPE_NONE
			txtC.InputType = txtC.INPUT_TYPE_NONE
			
'			g.SetColorList(txtF,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtC,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),00)
			
			txtF.TextColor = clrTheme.txtNormal : txtC.TextColor = clrTheme.txtNormal
			guiHelpers.SetTextSize(Array As B4XView(txtC,txtF),24)
			lblF.TextColor = clrTheme.txtNormal : lblC.TextColor = clrTheme.txtNormal
			
			guiHelpers.ResizeText(lblF.Text,lblF) 
			guiHelpers.ResizeText(lblC.Text,lblC)
			
		Case scrnVolume
			guiHelpers.ResizeText("Volume",lblWhat)
			pnlInput.LoadLayout("scrnConvVolume")
			pnlVolume0.Color= Colors.Transparent:pnlVolume1.Color=Colors.Transparent:pnlVolume2.Color=Colors.Transparent
			txtML_FocusChanged(True)
			txtGAL.InputType = txtGAL.INPUT_TYPE_NONE
			txtLiters.InputType  = txtLiters.INPUT_TYPE_NONE
			txtQuarts.InputType    = txtQuarts.INPUT_TYPE_NONE
			txtTBSPb.InputType   = txtTBSPb.INPUT_TYPE_NONE
			txtCUPSb.InputType    = txtCUPSb.INPUT_TYPE_NONE
			txtTSP.InputType    = txtTSP.INPUT_TYPE_NONE
			txtML.InputType    = txtML.INPUT_TYPE_NONE
			txtPINTS.InputType    = txtPINTS.INPUT_TYPE_NONE
			txtFlOZ.InputType    = txtFlOZ.INPUT_TYPE_NONE
			
			txtGAL.TextSize = 24
			txtLiters.TextSize = 24
			txtQuarts.TextSize = 24
			txtTBSPb.TextSize = 24
			txtCUPSb.TextSize = 24
			txtTSP.TextSize = 24
			txtML.TextSize = 24
			txtPINTS.TextSize = 24
			txtFlOZ.TextSize = 24
			
'			g.SetColorList(txtGAL,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtLiters,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtQuarts,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtTBSPb,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtCUPSb,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtTSP,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtML,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtPINTS,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtFlOZ,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			
'			txtGAL.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			txtLiters.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			txtQuarts.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			txtTBSPb.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			txtCUPSb.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			txtTSP.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			txtML.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			txtPINTS.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			txtFlOZ.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			
'			lblML.TextColor =  g.GetColorTheme(g.ehome_clrTheme,"themeColorText") : lblTSP.TextColor =  g.GetColorTheme(g.ehome_clrTheme,"themeColorText")
'			lblTBSPb.TextColor =  g.GetColorTheme(g.ehome_clrTheme,"themeColorText") : lblFLOZ.TextColor = g.GetColorTheme(g.ehome_clrTheme,"themeColorText")
'			lblCUPSb.TextColor = g.GetColorTheme(g.ehome_clrTheme,"themeColorText") : lblGAL.TextColor =  g.GetColorTheme(g.ehome_clrTheme,"themeColorText")
'			lblLiters.TextColor =  g.GetColorTheme(g.ehome_clrTheme,"themeColorText") : lblQuarts.TextColor =  g.GetColorTheme(g.ehome_clrTheme,"themeColorText"): lblPINTS.TextColor =  g.GetColorTheme(g.ehome_clrTheme,"themeColorText")
			guiHelpers.ResizeText(lblML.Text,lblML) : guiHelpers.ResizeText(lblTSP.Text,lblTSP)
			guiHelpers.ResizeText(lblTBSPb.Text,lblTBSPb) : guiHelpers.ResizeText(lblFLOZ.Text,lblFLOZ)
			guiHelpers.ResizeText(lblCUPSb.Text,lblCUPSb)
			guiHelpers.ResizeText(lblGAL.Text,lblGAL) : guiHelpers.ResizeText(lblQuarts.Text,lblQuarts)
			guiHelpers.ResizeText(lblLiters.Text,lblLiters) : guiHelpers.ResizeText(lblPINTS.Text,lblPINTS)
			
			
		Case scrnWeight
			guiHelpers.ResizeText("Weight",lblWhat)
			pnlInput.LoadLayout("scrnConvWeight")
			pnlWeight.Color  = Colors.Transparent
			pnlWeightF.Color = Colors.Transparent
			txtOZ_FocusChanged(True)
			txtOZ.InputType     = txtOZ.INPUT_TYPE_NONE
			txtKG.InputType     = txtKG.INPUT_TYPE_NONE
			txtPounds.InputType = txtPounds.INPUT_TYPE_NONE
			txtGrams.InputType  = txtGrams.INPUT_TYPE_NONE
			
			txtOZ.TextSize = 24
			txtKG.TextSize = 24
			txtPounds.TextSize = 24
			txtGrams.TextSize = 24
			
'			g.SetColorList(txtOZ,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtKG,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtPounds,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			g.SetColorList(txtGrams,colorHighlightText,Null,colorHighlightText,g.GetColorTheme(g.ehome_clrTheme,"lstItemPressed"),0)
'			
'			txtOZ.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			txtKG.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			txtPounds.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			txtGrams.TextColor = g.GetColorTheme(g.ehome_clrTheme,"darkText")
'			
'			lblOZ.TextColor     =  g.GetColorTheme(g.ehome_clrTheme,"themeColorText") : lblKG.TextColor =  g.GetColorTheme(g.ehome_clrTheme,"themeColorText")
'			lblPounds.TextColor =  g.GetColorTheme(g.ehome_clrTheme,"themeColorText") : lblGrams.TextColor =  g.GetColorTheme(g.ehome_clrTheme,"themeColorText")
			guiHelpers.ResizeText(lblOZ.Text,lblOZ) : guiHelpers.ResizeText(lblPounds.Text,lblPounds)
			guiHelpers.ResizeText(lblKG.Text,lblKG) : guiHelpers.ResizeText(lblGrams.Text,lblGrams)
			
	End Select
	
	pnlInput.SetVisibleAnimated(500,True)
	
End Sub



#Region SIDE_MENU


Private Sub cvMenu_ItemClick(Position As Int, Value As Object)
'	CallSubDelayed(svrMain,"ResetScrn_SleepCounter")
'	Select Case Value
'		Case "Weight" : 
'			ActiveScrnLoad(scrnWeight)
'		Case "Volume" : ActiveScrnLoad(scrnVolume)
'		Case "Temp"	  : ActiveScrnLoad(scrnTemp)
'		Case "Butter" : ActiveScrnLoad(scrnButter)
'		Case "Length" : ActiveScrnLoad(scrnLength)
'		Case "howto"  : g.ShowWebHelp(act,"conversions")
'	End Select
	
End Sub




Public Sub BuildSideMenu
	
'	cvMenu.CallBack = Me
'	cvMenu.Clear
'	cvMenu.ChangeItemPressedColor(g.GetLstItemPressedCD(9dip))
'
'	g.MenuCreateItem(cvMenu, "Weight", "Weight")
'	g.MenuCreateItem(cvMenu, "Volume", "Volume")
'	g.MenuCreateItem(cvMenu, "Temp", "Temp")
'	g.MenuCreateItem(cvMenu, "Butter", "Butter")
'	g.MenuCreateItem(cvMenu, "Length", "Length")
'	
'	
'	g.MenuCreateItemSeparator(cvMenu)
'	g.MenuCreateItem(cvMenu, "How to", "howto")
'
'	' Fill in any space we can
'	Dim neededAmount As Int = g.MenuGetBlankItemsNeeded(cvMenu)
'	For x = 0 To neededAmount - 1
'		g.MenuCreateItemAt(cvMenu, "", "", cvMenu.count)
'	Next
	
End Sub
#End Region


Private Sub btnNums_Click
	Dim txt As String = Sender.As(Button).Text
	Log(txt)
	'setCurrText(txt)
	curTxt.Text = curTxt.Text & txt
	'CallSubDelayed(svrMain,"ResetScrn_SleepCounter")
End Sub


Sub Button12_Click
	doCalc
End Sub

#End Region


#Region SCRN_WEIGHT

Sub lblKG_Click
	txtKG.RequestFocus
End Sub
Sub lblGrams_Click
	txtGrams.RequestFocus
End Sub
Sub lblPounds_Click
	txtPounds.RequestFocus
End Sub
Sub lblOZ_Click
	txtOZ.RequestFocus
End Sub
Sub txtOZ_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearWeight
		curTxt = txtOZ
	End If
End Sub
Sub txtPounds_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearWeight
		curTxt = txtPounds
	End If
End Sub
Sub txtGrams_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearWeight
		curTxt = txtGrams
	End If
End Sub
Sub txtKG_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearWeight
		curTxt = txtKG
	End If
End Sub

Private Sub ClearWeight()
	txtOZ.Text = ""
	txtPounds.Text = ""
	txtGrams.Text = ""
	txtKG.Text = ""
End Sub

#End Region


#Region SCRN_TEMP
Sub lblC_Click
	txtC.RequestFocus
End Sub
Sub lblF_Click
	txtF.RequestFocus
End Sub
Sub txtC_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearTemp
		curTxt = txtC
	End If
End Sub
Sub txtF_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearTemp
		curTxt = txtF
	End If
End Sub

Private Sub ClearTemp()
	txtC.Text = ""
	txtF.Text = ""
End Sub
#End Region


#Region SCRN_LENGTH
Sub lblInches_Click
	txtInches.RequestFocus
End Sub
Sub lblCM_Click
	txtCM.RequestFocus
End Sub
Sub lblMM_Click
	txtMM.RequestFocus
End Sub

Sub txtInches_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearLength
		curTxt = txtInches
	End If
End Sub
Sub txtCM_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearLength
		curTxt = txtCM
	End If
End Sub
Sub txtMM_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearLength
		curTxt = txtMM
	End If
End Sub
Sub ClearLength
	txtMM.Text = ""
	txtCM.Text = ""
	txtInches.Text = ""
End Sub
#End Region


#Region SCRN_BUTTER
Sub lblStick_Click
	txtStick.RequestFocus
End Sub
Sub lblCup_Click
	txtCUP.RequestFocus
End Sub
Sub lblGramsB_Click
	txtGramsB.RequestFocus
End Sub
Sub lblTBSP_Click
	txtTBSP.RequestFocus
End Sub
Sub lblOZb_Click
	txtOZb.RequestFocus
End Sub
Sub txtGramsB_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearButter
		curTxt = txtGramsB
	End If
End Sub
Sub txtTBSP_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearButter
		curTxt = txtTBSP
	End If
End Sub
Sub txtOZb_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearButter
		curTxt = txtOZb
	End If
End Sub
Sub txtCUP_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearButter
		curTxt = txtCUP
	End If
End Sub
Sub txtStick_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearButter
		curTxt = txtStick
	End If
End Sub
Sub ClearButter
	txtCUP.Text = ""
	txtTBSP.Text = ""
	txtGramsB.Text = ""
	txtOZb.Text = ""
	txtStick.Text = ""
End Sub
#End Region


Private Sub doCalc
	'--- calc!
	
	Dim value As Float
	Select Case currScrn
		Case scrnVolume
			Select Case True
				Case txtGAL.Text.Length <> 0 And txtGAL.Text.trim <> "."
					value = txtGAL.Text
					txtPINTS.Text = oConversion.volume_gal2pints(value)
					txtQuarts.Text = oConversion.volume_gal2quarts(value)
					txtML.Text = oConversion.volume_gal2ml(value)
					txtCUPSb.Text = oConversion.volume_gal2cups(value)
					txtFlOZ.Text = oConversion.volume_gal2floz(value)
					txtLiters.Text = oConversion.volume_gal2liters(value)
					txtTSP.Text = oConversion.volume_gal2tsp(value)
					txtTBSPb.Text = oConversion.volume_gal2tbsp(value)
					
				Case txtFlOZ.Text.Length <> 0   And txtFlOZ.Text.trim <> "."
					value = txtFlOZ.Text
					txtPINTS.Text = oConversion.volume_floz2pints(value)
					txtQuarts.Text = oConversion.volume_floz2quarts(value)
					txtML.Text = oConversion.volume_floz2ml(value)
					txtCUPSb.Text = oConversion.volume_floz2cups(value)
					txtGAL.Text = oConversion.volume_floz2gal(value)
					txtLiters.Text = oConversion.volume_floz2liters(value)
					txtTSP.Text = oConversion.volume_floz2tsp(value)
					txtTBSPb.Text = oConversion.volume_floz2tbsp(value)
					
				Case txtCUPSb.Text.Length <> 0  And txtCUPSb.Text.trim <> "."
					value = txtCUPSb.Text
					txtPINTS.Text = oConversion.volume_cups2pints(value)
					txtQuarts.Text = oConversion.volume_cups2quarts(value)
					txtML.Text = oConversion.volume_cups2ml(value)
					txtFlOZ.Text = oConversion.volume_cups2floz(value)
					txtGAL.Text = oConversion.volume_cups2gal(value)
					txtLiters.Text = oConversion.volume_cups2liters(value)
					txtTSP.Text = oConversion.volume_cups2tsp(value)
					txtTBSPb.Text = oConversion.volume_cups2tbsp(value)
				
				Case txtPINTS.Text.Length <> 0  And txtPINTS.Text.trim <> "."
					value = txtPINTS.Text
					txtCUPSb.Text = oConversion.volume_pints2cups(value)
					txtQuarts.Text = oConversion.volume_pints2quarts(value)
					txtML.Text = oConversion.volume_pints2ml(value)
					txtFlOZ.Text = oConversion.volume_pints2floz(value)
					txtGAL.Text = oConversion.volume_pints2gal(value)
					txtLiters.Text = oConversion.volume_pints2liters(value)
					txtTSP.Text = oConversion.volume_pints2tsp(value)
					txtTBSPb.Text = oConversion.volume_pints2tbsp(value)
					
				Case txtTSP.Text.Length <> 0  And txtTSP.Text.trim <> "."
					value = txtTSP.Text
					txtCUPSb.Text = oConversion.volume_tsp2cups(value)
					txtQuarts.Text = oConversion.volume_tsp2quarts(value)
					txtML.Text = oConversion.volume_tsp2ml(value)
					txtFlOZ.Text = oConversion.volume_tsp2floz(value)
					txtGAL.Text = oConversion.volume_tsp2gal(value)
					txtLiters.Text = oConversion.volume_tsp2liters(value)
					txtPINTS.Text = oConversion.volume_tsp2pints(value)
					txtTBSPb.Text = oConversion.volume_tsp2tbsp(value)
				
				Case txtTBSPb.Text.Length <> 0  And txtTBSPb.Text.trim <> "."
					value = txtTBSPb.Text
					txtCUPSb.Text = oConversion.volume_tbsp2cups(value)
					txtQuarts.Text = oConversion.volume_tbsp2quarts(value)
					txtML.Text = oConversion.volume_tbsp2ml(value)
					txtFlOZ.Text = oConversion.volume_tbsp2floz(value)
					txtGAL.Text = oConversion.volume_tbsp2gal(value)
					txtLiters.Text = oConversion.volume_tbsp2liters(value)
					txtPINTS.Text = oConversion.volume_tbsp2pints(value)
					txtTSP.Text = oConversion.volume_tbsp2tsp(value)
				
				Case txtQuarts.Text.Length <> 0  And txtQuarts.Text.trim <> "."
					value = txtQuarts.Text
					txtCUPSb.Text = oConversion.volume_quart2cups(value)
					txtTBSPb.Text = oConversion.volume_quart2tbsp(value)
					txtML.Text = oConversion.volume_quart2ml(value)
					txtFlOZ.Text = oConversion.volume_quart2floz(value)
					txtGAL.Text = oConversion.volume_quart2gal(value)
					txtLiters.Text = oConversion.volume_quart2liters(value)
					txtPINTS.Text = oConversion.volume_quart2pints(value)
					txtTSP.Text = oConversion.volume_quart2tsp(value)
					
				Case txtML.Text.Length <> 0  And txtML.Text.trim <> "."
					value = txtML.Text
					txtCUPSb.Text = oConversion.volume_ml2cups(value)
					txtTBSPb.Text = oConversion.volume_ml2tbsp(value)
					txtQuarts.Text = oConversion.volume_ml2quart(value)
					txtFlOZ.Text = oConversion.volume_ml2floz(value)
					txtGAL.Text = oConversion.volume_ml2gal(value)
					txtLiters.Text = oConversion.volume_ml2liters(value)
					txtPINTS.Text = oConversion.volume_ml2pints(value)
					txtTSP.Text = oConversion.volume_ml2tsp(value)
				
				Case txtLiters.Text.Length <> 0  And txtLiters.Text.trim <> "."
					value = txtLiters.Text
					txtCUPSb.Text = oConversion.volume_liter2cups(value)
					txtTBSPb.Text = oConversion.volume_liter2tbsp(value)
					txtQuarts.Text = oConversion.volume_liter2quart(value)
					txtFlOZ.Text = oConversion.volume_liter2floz(value)
					txtGAL.Text = oConversion.volume_liter2gal(value)
					txtML.Text = oConversion.volume_liter2ml(value)
					txtPINTS.Text = oConversion.volume_liter2pints(value)
					txtTSP.Text = oConversion.volume_liter2tsp(value)
			
			End Select
		
		Case scrnButter
			Select Case True
				Case txtOZb.Text.Length <> 0  And txtOZb.Text.trim <> "."
					value = txtOZb.Text
					txtGramsB.Text = oConversion.butter_oz2grams(value)
					txtStick.Text  = oConversion.butter_oz2stick(value)
					txtCUP.Text    = oConversion.butter_oz2cup(value)
					txtTBSP.Text   = oConversion.butter_oz2tbsp(value)
					
				Case txtGramsB.Text.Length <> 0	  And txtGramsB.Text.trim <> "."
					value = txtGramsB.Text
					txtOZb.Text    = oConversion.butter_grams2oz(value)
					txtStick.Text  = oConversion.butter_grams2stick(value)
					txtCUP.Text    = oConversion.butter_grams2cup(value)
					txtTBSP.Text   = oConversion.butter_grams2tbsp(value)
				
				Case txtStick.Text.Length <> 0	 And txtStick.Text.trim <> "."
					value = txtStick.Text
					txtOZb.Text    = oConversion.butter_stick2oz(value)
					txtCUP.Text    = oConversion.butter_stick2cups(value)
					txtGramsB.Text = oConversion.butter_stick2gram(value)
					txtTBSP.Text   = oConversion.butter_stick2tbsp(value)
					
				Case txtCUP.Text.Length <> 0	 And txtCUP.Text.trim <> "."
					value = txtCUP.Text
					txtOZb.Text    = oConversion.butter_cup2oz(value)
					txtStick.Text  = oConversion.butter_cup2stick(value)
					txtGramsB.Text = oConversion.butter_cup2gram(value)
					txtTBSP.Text   = oConversion.butter_cup2tbsp(value)
					
				Case txtTBSP.Text.Length <> 0	 And txtTBSP.Text.trim <> "."
					value = txtTBSP.Text
					txtCUP.Text    = oConversion.butter_tbsp2cups(value)
					txtStick.Text  = oConversion.butter_tbsp2stick(value)
					txtGramsB.Text = oConversion.butter_tbsp2gram(value)
					txtOZb.Text    = oConversion.butter_tbsp2oz(value)
					
			End Select
		
		Case scrnWeight
			Select Case True
				Case txtOZ.Text.Length <> 0  And txtOZ.Text.trim <> "."
					value = txtOZ.Text
					txtPounds.Text = oConversion.weight_oz2pounds(value)
					txtGrams.Text  = oConversion.weight_oz2grams(value)
					txtKG.Text     = oConversion.weight_oz2kg(value)
					
				Case txtPounds.Text.Length <> 0  And txtPounds.Text.trim <> "."
					value = txtPounds.Text
					txtOZ.Text    = oConversion.weight_pounds2oz(value)
					txtGrams.Text = oConversion.weight_pounds2grams(value)
					txtKG.Text    = oConversion.weight_pounds2kg(value)
					
				Case txtGrams.Text.Length <> 0	 And txtGrams.Text.trim <> "."
					value = txtGrams.Text
					txtPounds.Text = oConversion.weight_grams2pounds(value)
					txtOZ.Text     = oConversion.weight_grams2oz(value)
					txtKG.Text     = oConversion.weight_grams2kg(value)
					
				Case txtKG.Text.Length <> 0  And txtKG.Text.trim <> "."
					value = txtKG.Text
					txtPounds.Text = oConversion.weight_kg2pounds(value)
					txtOZ.Text     = oConversion.weight_kg2oz(value)
					txtGrams.Text  = oConversion.weight_kg2grams(value)
				
			End Select
		
		Case scrnTemp
			Select Case True
				Case txtC.Text.Length <> 0  And txtC.Text.trim <> "."
					value = txtC.Text
					txtF.Text = oConversion.temp_c2f(value)
					
				Case txtF.Text.Length <> 0	 And txtF.Text.trim <> "."
					value = txtF.Text
					txtC.Text = oConversion.temp_f2c(value)
					
			End Select
	
		Case scrnLength
			Select Case True
				Case txtMM.Text.Length <> 0  And txtMM.Text.trim <> "."
					value = txtMM.Text
					txtCM.Text     = oConversion.length_mm2cm(value)
					txtInches.Text = oConversion.length_mm2inches(value)
					
				Case txtCM.Text.Length <> 0  And txtCM.Text.trim <> "."
					value = txtCM.Text
					txtMM.Text     = oConversion.length_cm2mm(value)
					txtInches.Text = oConversion.length_cm2inches(value)
					
				Case txtInches.Text.Length <> 0  And txtInches.Text.trim <> "."
					value = txtInches.Text
					txtMM.Text = oConversion.length_inches2mm(value)
					txtCM.Text = oConversion.length_inches2cm(value)
					
			End Select
			
			
	End Select
	
End Sub

#Region SCRN_VOLUME
Sub lblML_Click
	txtML.RequestFocus
End Sub
Sub lblTSP_Click
	txtTSP.RequestFocus
End Sub
Sub lblTBSPb_Click
	txtTBSPb.RequestFocus
End Sub
Sub lblFLOZ_Click
	txtFlOZ.RequestFocus
End Sub
Sub lblCUPSb_Click
	txtCUPSb.RequestFocus
End Sub
Sub lblPINTS_Click
	txtPINTS.RequestFocus
End Sub
Sub lblQuarts_Click
	txtQuarts.RequestFocus
End Sub
Sub lblLiters_Click
	txtLiters.RequestFocus
End Sub
Sub lblGAL_Click
	txtGAL.RequestFocus
End Sub
Sub txtPINTS_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearVolume
		curTxt = txtPINTS
	End If
End Sub
Sub txtML_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearVolume
		curTxt = txtML
	End If
End Sub
Sub txtTSP_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearVolume
		curTxt = txtTSP
	End If
End Sub
Sub txtTBSPb_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearVolume
		curTxt = txtTBSPb
	End If
End Sub
Sub txtFlOZ_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearVolume
		curTxt = txtFlOZ
	End If
End Sub
Sub txtCUPSb_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearVolume
		curTxt = txtCUPSb
	End If
End Sub
Sub txtQuarts_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearVolume
		curTxt = txtQuarts
	End If
End Sub
Sub txtLiters_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearVolume
		curTxt = txtLiters
	End If
End Sub
Sub txtGAL_FocusChanged (HasFocus As Boolean)
	If HasFocus Then
		ClearVolume
		curTxt = txtGAL
	End If
End Sub
Sub ClearVolume
	txtPINTS.Text = ""
	txtML.Text = ""
	txtTSP.Text = ""
	txtTBSPb.Text = ""
	txtFlOZ.Text = ""
	txtCUPSb.Text = ""
	txtQuarts.Text = ""
	txtLiters.Text = ""
	txtGAL.Text = ""
End Sub
#End Region


