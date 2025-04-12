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
	Private Panel1,Panel2,Panel3,Panel4,Panel5,Panel0 As B4XView
	
	'--- screen volume
	Private lblML,lblTSP,lblTBSPb,lblFLOZ,lblCUPSb As Label
	Private lblGAL,lblLiters,lblQuarts,lblPINTS As Label
	Private pnlVolume0,pnlVolume1,pnlVolume2 As Panel
	Private txtPINTS,txtML,txtTSP,txtTBSPb,txtFlOZ,txtCUPSb,txtQuarts,txtLiters,txtGAL As EditText
	
	
	
End Sub

Public Sub Initialize(p As B4XView) 
	pnlMain = p
	p.LoadLayout("pageConversionsBase")
	
	guiHelpers.SetPanelsTranparent(Array As B4XView(pnlBG,pnlNumPad,pnlInput))
	lblWhat.TextColor =clrTheme.txtNormal
	
	guiHelpers.SkinButton(Array As Button(Button1,Button2,Button3,Button4,Button5,Button6,Button7, _
							Button8,Button9,Button10,Button11,Button12))
							
	guiHelpers.ResizeText("1",Button1)
	guiHelpers.SetTextSize(Array As B4XView(Button1,Button2,Button3,Button4,Button5,Button6,Button7, _
							Button8,Button9,Button10,Button11),(Button1.TextSize - 10))							
	
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
		
			guiHelpers.SetPanelsTranparent(Array As B4XView(pnlButter,Panel1,Panel2,Panel3,Panel4,Panel5,Panel0))

			txtGramsB_FocusChanged(True)
		
			guiHelpers.SkinTextEdit(Array As EditText(txtGramsB,txtTBSP,txtStick,txtCUP,txtOZb),0,True)
				
			guiHelpers.ResizeText(lblGramsB.Text,lblGramsB)
			guiHelpers.SetTextSize(Array As B4XView(lblCUP,lblTBSP,lblStick,lblOZb),lblGramsB.TextSize)
		
			guiHelpers.SetTextSize(Array As B4XView(txtCUP,txtTBSP,txtGramsB,txtStick,txtOZb),24)
			guiHelpers.SetTextColor(Array As B4XView(txtCUP,txtTBSP,txtGramsB,txtStick,txtOZb),clrTheme.txtNormal)
			guiHelpers.SetTextColor(Array As B4XView(lblCUP,lblTBSP,lblGramsB,lblStick,lblOZb),clrTheme.txtNormal)
			
			
		Case scrnLength
			guiHelpers.ResizeText("Length",lblWhat)
			pnlInput.LoadLayout("scrnConvLength")
			pnlLength.Color= Colors.Transparent	: pnlLenFrame.Color= Colors.Transparent
			txtMM_FocusChanged(True)
			
			guiHelpers.SkinTextEdit(Array As EditText(txtMM,txtInches,txtCM),0,True)
			
			guiHelpers.SetTextColor(Array As B4XView(txtInches,txtCM,txtMM),clrTheme.txtNormal)
			guiHelpers.SetTextSize(Array As B4XView(txtInches,txtCM,txtMM),24)
			guiHelpers.SetTextColor(Array As B4XView(lblInches,lblCM,lblMM),clrTheme.txtNormal)
			
			guiHelpers.ResizeText(lblMM.Text,lblMM) 
			guiHelpers.SetTextSize(Array As B4XView(lblCM,lblInches),lblMM.TextSize)
			
		Case scrnTemp
			guiHelpers.ResizeText("Temperature",lblWhat)
			pnlInput.LoadLayout("scrnConvTemp")
			pnlTemp.Color = Colors.Transparent
			txtF_FocusChanged(True)
			
			guiHelpers.SkinTextEdit(Array As EditText(txtF,txtC),0,True)
			
			txtF.TextColor = clrTheme.txtNormal : txtC.TextColor = clrTheme.txtNormal
			guiHelpers.SetTextSize(Array As B4XView(txtC,txtF),24)
			lblF.TextColor = clrTheme.txtNormal : lblC.TextColor = clrTheme.txtNormal
			
			guiHelpers.ResizeText(lblF.Text,lblF) : lblC.TextSize = lblF.TextSize
			
		Case scrnVolume
			guiHelpers.ResizeText("Volume",lblWhat)
			pnlInput.LoadLayout("scrnConvVolume")
			guiHelpers.SetPanelsTranparent(Array As B4XView(pnlVolume0,pnlVolume1,pnlVolume2))
			txtML_FocusChanged(True)
	
			guiHelpers.SetTextSize(Array As B4XView(txtPINTS,txtML,txtTSP,txtTBSPb,txtFlOZ,txtCUPSb,txtQuarts,txtLiters,txtGAL),24)
			guiHelpers.SkinTextEdit(Array As EditText(txtPINTS,txtML,txtTSP,txtTBSPb,txtFlOZ,txtCUPSb,txtQuarts,txtLiters,txtGAL),0,True)
			guiHelpers.SetTextColor(Array As B4XView(lblPINTS,lblML,lblTSP,lblTBSPb,lblFLOZ,lblCUPSb,lblQuarts,lblLiters,lblGAL),clrTheme.txtNormal)
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
			guiHelpers.ResizeText(lblML.Text,lblML)
			guiHelpers.SetTextSize(Array As B4XView(lblPINTS,lblTSP,lblTBSPb,lblFLOZ,lblCUPSb,lblQuarts,lblLiters,lblGAL),lblML.TextSize)
			
			
		Case scrnWeight
			guiHelpers.ResizeText("Weight",lblWhat)
			pnlInput.LoadLayout("scrnConvWeight")
			pnlWeight.Color  = Colors.Transparent : pnlWeightF.Color = Colors.Transparent
			
			txtOZ_FocusChanged(True)
			
			guiHelpers.SetTextSize(Array As B4XView(txtOZ,txtPounds,txtKG,txtGrams),24)
			guiHelpers.SkinTextEdit(Array As EditText(txtOZ,txtPounds,txtKG,txtGrams),0,True)
			guiHelpers.SetTextColor(Array As B4XView(lblKG,lblGrams,lblPounds,lblOZ),clrTheme.txtNormal)
			
			guiHelpers.ResizeText(lblOZ.Text,lblOZ) 
			guiHelpers.SetTextSize(Array As B4XView(lblKG,lblGrams,lblPounds),lblOZ.TextSize)
			
	End Select
	
	pnlInput.SetVisibleAnimated(500,True)
	
End Sub



#Region SIDE_MENU

Private Sub SideMenu_ItemClick (Index As Int, Value As Object)
	CallSubDelayed(mpage,"ResetScrn_SleepCounter")
	Select Case Value
		Case "we" : ActiveScrnLoad(scrnWeight)
		Case "vo" : ActiveScrnLoad(scrnVolume	)
		Case "te" : ActiveScrnLoad(scrnTemp)
		Case "bu" : ActiveScrnLoad(scrnButter)
		Case "le" : ActiveScrnLoad(scrnLength)
	End Select
	mpage.pnlSideMenu.SetVisibleAnimated(380, False) '---  close side menu
End Sub

Public Sub BuildSideMenu
	
	Menus.BuildSideMenu(Array As String("Weight","Volume","Temp","Butter","Length"), _
							            Array As String("we","vo","te","bu","le"))
	
End Sub
#End Region


Private Sub btnNums_Click
	Dim txt As String = Sender.As(Button).Text
	'Log(txt)
	'setCurrText(txt)
	curTxt.Text = curTxt.Text & txt
	CallSubDelayed(mpage,"ResetScrn_SleepCounter")
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


