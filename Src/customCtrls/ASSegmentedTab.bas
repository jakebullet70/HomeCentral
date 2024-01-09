B4A=true
Group=CustomControls
ModulesStructureVersion=1
Type=Class
Version=10.5
@EndOfDesignText@
#If Documentation
Updates
	V1.01
		-BugFix the selected tab is now keeping if the view is resizing
	V1.02
		-Adds getSelectionPanel - gets the selection panel - the panel that highlight a tab on click
		-Adds getBackgroundPanel - the child panel of mBase
		-TabChanged is now only triggered on a new tab, if you click on the same tab, nothing happens
	V1.03
		-Adds getItemTextProperties - change the properties before you add atab, then this settings will be change the on the next added tab
			-now you can add Material- or FontAwesome-Icons on the Text parameter
	V1.04
		-B4A and B4J - Corner Radius Fix
		-Add DesignerProperty CornerRadiusBackground - changes the CornerRadius of the view
		-Add DesignerProperty CornerRadiusSelectionPanel - changes the CornerRadius of the selector
		-Add DesignerProperty PaddingSelectionPanel - set a distance from the corners for the selector
	V1.05
		-Add Seperators - displays seperator items between non selected tabs
			-Add Designer Property "ShowSeperators" - default: False
			-Add UpdateSeperators - commit style changes
			-Add get SeperatorProperties - change the properties and call UpdateSeperators
	V1.06
		-Performance Improvements
			-Seperators only added if ShowSeperators = True
				-If you set the ShowSeperators = False then the seperators will be removed and vice versa
		-Seperators - Add HeightPercentage - default:50% - 50% from the view height
			-ASSegmentedTab1.SeperatorProperties.HeightPercentage = 50
		-Seperators - Add CornerRadius - default:0 - set the corner radius of the seperators
			-ASSegmentedTab2.SeperatorProperties.CornerRadius = ASSegmentedTab2.SeperatorProperties.Width/2'round seperators
		-Add get SeperatorProperties - gets the seperators height
		-B4J and B4I Resize BugFixes
		-Add set ImageHeight - sets the image Height/Width
	V1.07
		-BugFix - SelectedIndex the index was not set
		-Add set Index - change the index without animation, do the same as SelectedIndex(1,0)
	V1.08
		-BugFix - get Index
	V1.09
		-BugFix - The new index at getIndex was assigned only after the TabChanged event
	V1.10
		-BugFix - SelectedIndex the PaddingSelectionPanel is now observed with
	V1.11
		-Add get and set AutoDecreaseTextSize - The text size is automatically adjusted to the space, if the text should not fit on one line
	V1.12
		-Add GetTab - Gets the tab text, icon and the text properties
		-Add RefreshTab - If you change something on the tab, then call this
	V1.13
		-Add Designer Porperty TabBackgroundColor
		-Add Designer Porperty SelectionColor
		-Add Designer Porperty SeperatorColor
		-Add Designer Porperty TextColor
	V1.14
		-Designer Properties are now converted into dip
	V1.15
		-Add AddTab2
		-Add GetValue
		-Add Value to Type ASSegmentedTab_Tab
	V1.16
		-Add Designer Property SelectionTextColor
		-Add SelectionTextColor to Type ASSegmentedTab_ItemTextProperties
	V1.17
		-BugFixes
	V1.18
		-Add get Size - Number of tabs
	V1.19
		-Add AddTabAdvanced - Add a tab with the ASSegmentedTab_Tab type
		-Add Width to the ASSegmentedTab_Tab type
			-It's a optional tab property
			-If 0, then the width of the tab is calculated automatically
			-Default: 0
#End If

#DesignerProperty: Key: CornerRadiusBackground, DisplayName: Corner Radius Background, FieldType: Int, DefaultValue: 0, MinRange: 0
#DesignerProperty: Key: CornerRadiusSelectionPanel, DisplayName: Corner Radius Selection Panel, FieldType: Int, DefaultValue: 0, MinRange: 0
#DesignerProperty: Key: PaddingSelectionPanel, DisplayName: Padding Selection Panel, FieldType: Int, DefaultValue: 0, MinRange: 0
#DesignerProperty: Key: ShowSeperators, DisplayName: Show Seperators, FieldType: Boolean, DefaultValue: False

#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0xFF000000
#DesignerProperty: Key: SelectionColor, DisplayName: Selection Color, FieldType: Color, DefaultValue: 0xFF2D8879
#DesignerProperty: Key: SelectionTextColor, DisplayName: SelectionTextColor, FieldType: Color, DefaultValue: 0xFFFFFFFF
#DesignerProperty: Key: SeperatorColor, DisplayName: Seperator Color, FieldType: Color, DefaultValue: 0x98FFFFFF
#DesignerProperty: Key: TextColor, DisplayName: Text Color, FieldType: Color, DefaultValue: 0xFFFFFFFF

#Event: TabChanged(index as int)

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI 'ignore
	Public Tag As Object
	
	Type ASSegmentedTab_ItemTextProperties(TextColor As Int,SelectedTextColor As Int,TextFont As B4XFont,TextAlignment_Vertical As String,TextAlignment_Horizontal As String,BackgroundColor As Int)
	Type ASSegmentedTab_SeperatorProperties(Color As Int,Width As Float,HeightPercentage As Int,CornerRadius As Float)
	Type ASSegmentedTab_Tab(Text As String,Icon As B4XBitmap,Value As Object,Width As Float,ItemTextProperties As ASSegmentedTab_ItemTextProperties)
	
	Private g_ItemTextProperties As ASSegmentedTab_ItemTextProperties
	Private g_SeperatorProperties As ASSegmentedTab_SeperatorProperties
	
	Private g_CornerRadiusBackground As Float
	Private g_CornerRadiusSelectionPanel As Float
	Private g_PaddingSelectionPanel As Float
	Private g_ShowSeperators As Boolean
	Private g_ImageHeight As Float = 0
	
	Private g_index As Int = 0
	Public mAutoDecreaseTextSize As Boolean = False
	
	'Views
	Private xpnl_background As B4XView
	Private xpnl_seperators_background As B4XView
	Private xpnl_selector As B4XView
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
    Tag = mBase.Tag
    mBase.Tag = Me 
	
	xpnl_background = xui.CreatePanel("")
	xpnl_seperators_background = xui.CreatePanel("")
	xpnl_selector = xui.CreatePanel("")
	
	ini_props(Props)
	
	mBase.AddView(xpnl_selector,0,0,0,0)
	mBase.AddView(xpnl_background,0,0,0,0)
	mBase.AddView(xpnl_seperators_background,0,0,0,0)

	#if B4J
	Dim jo As JavaObject = xpnl_seperators_background
	jo.RunMethod("setMouseTransparent", Array(True))
	#Else If B4I
	Dim tmp_pnl As Panel = xpnl_seperators_background
	tmp_pnl.UserInteractionEnabled = False
    #End If
	
	#If B4A
	Base_Resize(mBase.Width,mBase.Height)
	#End If
End Sub

Private Sub ini_props(Props As Map)	
	g_ItemTextProperties = CreateASSegmentedTab_ItemTextProperties(xui.PaintOrColorToColor(Props.GetDefault("TextColor",0xFFFFFFFF)),xui.PaintOrColorToColor(Props.GetDefault("SelectionTextColor",0xFFFFFFFF)),xui.CreateDefaultFont(15),"CENTER","CENTER",xui.Color_Transparent)
	g_SeperatorProperties = CreateASSegmentedTab_SeperatorProperties(xui.PaintOrColorToColor(Props.GetDefault("SeperatorColor",0x98FFFFFF)),2dip,50,0)
	
	g_CornerRadiusBackground = DipToCurrent(Props.GetDefault("CornerRadiusBackground",0))
	g_CornerRadiusSelectionPanel = DipToCurrent(Props.GetDefault("CornerRadiusSelectionPanel",0))
	g_PaddingSelectionPanel = DipToCurrent(Props.GetDefault("PaddingSelectionPanel",0))
	g_ShowSeperators = Props.GetDefault("ShowSeperators",False)
	
	mBase.Color = xui.PaintOrColorToColor(Props.GetDefault("BackgroundColor",0xFF000000))
	xpnl_selector.Color = xui.PaintOrColorToColor(Props.GetDefault("SelectionColor",0xFF2D8879))
End Sub

Public Sub Base_Resize2()
	Base_Resize(mBase.Width,mBase.Height)
	RefreshTabs
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
	
	xpnl_background.SetLayoutAnimated(0,0,0,Width,Height)
	xpnl_seperators_background.SetLayoutAnimated(0,0,0,Width,Height)
	
	If xpnl_background.NumberOfViews > 0 Then
		
		Dim CustomTabWidths As Float = 0
		Dim CustomTabWidthCounter As Int = 0
		For i = 0 To xpnl_background.NumberOfViews -1
			If xpnl_background.GetView(i).Tag.As(ASSegmentedTab_Tab).Width > 0 Then
				CustomTabWidths = CustomTabWidths + xpnl_background.GetView(i).Tag.As(ASSegmentedTab_Tab).Width
				CustomTabWidthCounter = CustomTabWidthCounter +1
			End If
		Next
		
		Dim tab_width As Float = (Width-CustomTabWidths)/(xpnl_background.NumberOfViews-CustomTabWidthCounter)
		For i = 0 To xpnl_background.NumberOfViews -1
			Dim xpnl_tab_background As B4XView = xpnl_background.GetView(i)
			Dim xTab As ASSegmentedTab_Tab = xpnl_tab_background.Tag
			Dim xlbl_text As B4XView = xpnl_tab_background.GetView(0)
			Dim xiv_icon As B4XView = xpnl_tab_background.GetView(1)
			
			Dim ThisTabWidth As Float = tab_width
			If xTab.Width > 0 Then ThisTabWidth = xTab.Width
			
			xpnl_tab_background.SetLayoutAnimated(0,IIf(i=0,0,xpnl_background.GetView(i-1).Left + xpnl_background.GetView(i-1).Width),0,ThisTabWidth,Height)
			xlbl_text.SetLayoutAnimated(0,0,0,ThisTabWidth,Height)
			xiv_icon.SetLayoutAnimated(0,ThisTabWidth/2 - IIf(g_ImageHeight = 0,Height,g_ImageHeight)/2,Height/2 - IIf(g_ImageHeight = 0,Height,g_ImageHeight)/2,IIf(g_ImageHeight = 0,Height,g_ImageHeight),IIf(g_ImageHeight = 0,Height,g_ImageHeight))
			If mAutoDecreaseTextSize = True Then CheckTextSize(xlbl_text)
		Next
		'xpnl_selector.SetLayoutAnimated(0,Width * g_index + g_PaddingSelectionPanel,g_PaddingSelectionPanel,ThisTabWidth - (g_PaddingSelectionPanel*2),Height - (g_PaddingSelectionPanel*2))
		xpnl_selector.SetLayoutAnimated(0,xpnl_background.GetView(g_index).Left + g_PaddingSelectionPanel,g_PaddingSelectionPanel,xpnl_background.GetView(g_index).Width - (g_PaddingSelectionPanel*2),xpnl_background.GetView(g_index).Height - (g_PaddingSelectionPanel*2))'normal
	
	End If
	SetCircleClip(mBase,g_CornerRadiusBackground)
	SetCircleClip(xpnl_selector,g_CornerRadiusSelectionPanel)
	UpdateSeperators
	
End Sub

Private Sub CheckTextSize(xview As B4XView)
	If (MeasureTextWidth(xview.Text,g_ItemTextProperties.TextFont) + IIf(xui.IsB4J = True,4,8)) <= xview.Width Then Return
	Dim StartTextSize As Float = xview.TextSize
	Dim Found As Boolean = False
	For i = StartTextSize To 0 Step -1
		If (MeasureTextWidth(xview.Text,xui.CreateFont(g_ItemTextProperties.TextFont.ToNativeFont,i)) + IIf(xui.IsB4J = True,4,8)) <= xview.Width Then
			xview.Font = xui.CreateFont(g_ItemTextProperties.TextFont.ToNativeFont,i)
			Found = True
			Exit
		End If
	Next
	If Found = False Then xview.Font = xui.CreateFont(g_ItemTextProperties.TextFont.ToNativeFont,1)
End Sub

Private Sub CreateSeperator
	Dim xpnl_seperator As B4XView = xui.CreatePanel("")
	xpnl_seperator.Visible = False
	xpnl_seperators_background.AddView(xpnl_seperator,0,0,0,0)
End Sub

Public Sub UpdateSeperators
	For i = 0 To xpnl_seperators_background.NumberOfViews -1
		Dim xpnl_seperator As B4XView = xpnl_seperators_background.GetView(i)
		'xpnl_seperator.Color = g_SeperatorProperties.Color
		Dim xpnl_tmp_tab As B4XView = xpnl_background.GetView(i)
		xpnl_seperator.SetLayoutAnimated(0,xpnl_tmp_tab.Left + xpnl_tmp_tab.Width - (g_SeperatorProperties.Width/2),xpnl_tmp_tab.Height/2 - (xpnl_tmp_tab.Height*g_SeperatorProperties.HeightPercentage/100)/2,g_SeperatorProperties.Width,xpnl_tmp_tab.Height*g_SeperatorProperties.HeightPercentage/100)
		xpnl_seperator.Visible = g_ShowSeperators And i < (xpnl_background.NumberOfViews -1) And i <> g_index And i <> (g_index -1)
		xpnl_seperator.SetColorAndBorder(g_SeperatorProperties.Color,0,0,g_SeperatorProperties.CornerRadius)
	Next
End Sub

Public Sub AddTab2(Text As String,icon As B4XBitmap,Value As Object)
	Dim xTab As ASSegmentedTab_Tab = CreateASSegmentedTab_Tab(Text,icon,Value,CreateASSegmentedTab_ItemTextProperties(g_ItemTextProperties.TextColor,g_ItemTextProperties.SelectedTextColor,g_ItemTextProperties.TextFont,g_ItemTextProperties.TextAlignment_Vertical,g_ItemTextProperties.TextAlignment_Horizontal,g_ItemTextProperties.BackgroundColor))
	AddTabIntern(xTab)
End Sub

Public Sub AddTab(Text As String,icon As B4XBitmap)
	Dim xTab As ASSegmentedTab_Tab = CreateASSegmentedTab_Tab(Text,icon,"",CreateASSegmentedTab_ItemTextProperties(g_ItemTextProperties.TextColor,g_ItemTextProperties.SelectedTextColor,g_ItemTextProperties.TextFont,g_ItemTextProperties.TextAlignment_Vertical,g_ItemTextProperties.TextAlignment_Horizontal,g_ItemTextProperties.BackgroundColor))
	AddTabIntern(xTab)
End Sub

Public Sub AddTabAdvanced(xTab As ASSegmentedTab_Tab)
	If xTab.ItemTextProperties.IsInitialized = False Then xTab.ItemTextProperties = CreateASSegmentedTab_ItemTextProperties(g_ItemTextProperties.TextColor,g_ItemTextProperties.SelectedTextColor,g_ItemTextProperties.TextFont,g_ItemTextProperties.TextAlignment_Vertical,g_ItemTextProperties.TextAlignment_Horizontal,g_ItemTextProperties.BackgroundColor)
	AddTabIntern(xTab)
End Sub

Private Sub AddTabIntern(xTab As ASSegmentedTab_Tab)
	Dim xpnl_tab_background As B4XView = xui.CreatePanel("xpnl_tab_background")
	Dim lbl_text As Label
	lbl_text.Initialize("")
	#If B4A
	lbl_text.SingleLine = True
	#End If
	Dim xlbl_text As B4XView = lbl_text
	xpnl_tab_background.AddView(xlbl_text,0,0,0,0)
	
	Dim iv_icon As ImageView
	iv_icon.Initialize("")
	Dim xiv_icon As B4XView = iv_icon
	
	xpnl_tab_background.AddView(xiv_icon,0,0,IIf(g_ImageHeight = 0,mBase.Height,g_ImageHeight),IIf(g_ImageHeight = 0,mBase.Height,g_ImageHeight))
	

	
	If xTab.icon.IsInitialized = True And xTab.icon <> Null Then
		
		SetIconsWithColor(xiv_icon,xTab,xpnl_background.NumberOfViews = 0)
		
		xiv_icon.Visible = True
		xlbl_text.Visible = False
	Else
		xiv_icon.Visible = False
		xlbl_text.Visible = True
	End If
	
	xpnl_tab_background.Color = xui.Color_Transparent
	
	xlbl_text.Text = xTab.Text
	
	If xpnl_background.NumberOfViews = 0 Then
		xlbl_text.TextColor = g_ItemTextProperties.SelectedTextColor
		Else
		xlbl_text.TextColor = g_ItemTextProperties.TextColor
	End If
	xlbl_text.SetColorAndBorder(g_ItemTextProperties.BackgroundColor,0,0,5dip)
	xlbl_text.Font = g_ItemTextProperties.TextFont
	xlbl_text.SetTextAlignment(g_ItemTextProperties.TextAlignment_vertical,g_ItemTextProperties.TextAlignment_Horizontal)
	
	xpnl_tab_background.Tag = xTab
	
	xpnl_background.AddView(xpnl_tab_background,0,0,0,0)
	If g_ShowSeperators = True Then CreateSeperator
	
	Base_Resize(mBase.Width,mBase.Height)
End Sub

'Call RefreshTabs if you change something
Public Sub GetTab(Index As Int) As ASSegmentedTab_Tab
	Return xpnl_background.GetView(Index).Tag
End Sub

Public Sub GetValue(Index As Int) As Object
	Return xpnl_background.GetView(Index).Tag.As(ASSegmentedTab_Tab).Value
End Sub

Public Sub RefreshTabs
	For i = 0 To xpnl_background.NumberOfViews -1
		Dim xpnl_tab_background As B4XView = xpnl_background.GetView(i)
		Dim xlbl_text As B4XView = xpnl_tab_background.GetView(0)
		Dim xiv_icon As B4XView = xpnl_tab_background.GetView(1)
	
		Dim xTab As ASSegmentedTab_Tab = xpnl_tab_background.Tag
	
		xlbl_text.Text = xTab.Text
		If i = g_index Then
			xlbl_text.TextColor = xTab.ItemTextProperties.SelectedTextColor
		Else
			xlbl_text.TextColor = xTab.ItemTextProperties.TextColor
		End If
		
		xlbl_text.SetColorAndBorder(xTab.ItemTextProperties.BackgroundColor,0,0,5dip)
		xlbl_text.Font = xTab.ItemTextProperties.TextFont
		xlbl_text.SetTextAlignment(xTab.ItemTextProperties.TextAlignment_vertical,xTab.ItemTextProperties.TextAlignment_Horizontal)
	
		If xTab.Icon.IsInitialized = True And xTab.Icon <> Null Then
			
			SetIconsWithColor(xiv_icon,xTab,i = g_index)
						
			xiv_icon.Visible = True
			xlbl_text.Visible = False
		Else
			xiv_icon.Visible = False
			xlbl_text.Visible = True
		End If
	
	Next
End Sub

Public Sub setImageHeight(height As Float)
	g_ImageHeight = height
	Base_Resize(mBase.Width,mBase.Height)
End Sub
Public Sub getSeperatorProperties As ASSegmentedTab_SeperatorProperties
	Return g_SeperatorProperties
End Sub
Public Sub getSeperatorsHeight As Float
	Return mBase.Height*g_SeperatorProperties.HeightPercentage/100
End Sub
'change the properties before you add atab, then this settings will be change the on the next added tab
'<code>ASSegmentedTab1.ItemTextProperties.TextFont = xui.CreateDefaultBoldFont(15)</code>
Public Sub getItemTextProperties As ASSegmentedTab_ItemTextProperties
	Return g_ItemTextProperties
End Sub
Public Sub getIndex As Int
	Return g_index
End Sub
'get or sets the index - sets the index without animation
Public Sub setIndex(Index As Int)
	g_index = Index
	SelectedIndex(Index,0)
End Sub
'changes the CornerRadius of the view
Public Sub setCornerRadiusBackground(corner_radius As Float)
	g_CornerRadiusBackground = corner_radius
	SetCircleClip(mBase,corner_radius)
End Sub
'changes the CornerRadius of the selector
Public Sub setCornerRadiusSelectionPanel(corner_radius As Float)
	g_CornerRadiusSelectionPanel = corner_radius
	SetCircleClip(xpnl_selector,corner_radius)
End Sub
'set a distance from the corners for the selector
Public Sub setPaddingSelectionPanel(padding As Float)
	g_PaddingSelectionPanel = padding
	Base_Resize(mBase.Width,mBase.Height)
End Sub
'The text size is automatically adjusted to the space, if the text should not fit on one line
'Default: False
Public Sub getAutoDecreaseTextSize As Boolean
	Return mAutoDecreaseTextSize
End Sub

Public Sub setAutoDecreaseTextSize(DecreaseTextSize As Boolean)
	mAutoDecreaseTextSize = DecreaseTextSize
	Base_Resize(mBase.Width,mBase.Height)
End Sub

Public Sub setShowSeperators(visible As Boolean)
	g_ShowSeperators = visible
	If visible = False Then
		xpnl_seperators_background.RemoveAllViews
	Else
		For i = 0 To xpnl_background.NumberOfViews -1
			CreateSeperator
		Next
		UpdateSeperators
	End If
End Sub
#If B4J
Private Sub xpnl_tab_background_MouseClicked (EventData As MouseEvent)
	TabClick(Sender,False)
End Sub
#Else
Private Sub xpnl_tab_background_Click
	TabClick(Sender,False)
End Sub
#End If

Private Sub SetIconsWithColor(xiv_icon As B4XView,xTab As ASSegmentedTab_Tab,isSelected As Boolean)
	
	If xiv_icon.Visible Then
		
		Dim scale As Float = 1
			#If B4I
		scale = GetDeviceLayoutValues.NonnormalizedScale
			#End If
		
		If isSelected Then
			
			#If B4J 
			xiv_icon.SetBitmap(ChangeColorBasedOnAlphaLevel(xTab.Icon,g_ItemTextProperties.SelectedTextColor).Resize(xiv_icon.Width * scale,xiv_icon.Height * scale,True))
			#Else
			xiv_icon.SetBitmap(xTab.Icon.Resize(xiv_icon.Width * scale,xiv_icon.Height * scale,True))
			TintBmp(xiv_icon,g_ItemTextProperties.SelectedTextColor)
			#End If		
			
			Else
				
			#If B4J 
			xiv_icon.SetBitmap(ChangeColorBasedOnAlphaLevel(xTab.Icon,g_ItemTextProperties.TextColor).Resize(xiv_icon.Width * scale,xiv_icon.Height * scale,True))
			#Else
			xiv_icon.SetBitmap(xTab.Icon.Resize(xiv_icon.Width * scale,xiv_icon.Height * scale,True))
			TintBmp(xiv_icon,g_ItemTextProperties.TextColor)
			#End If
				
		End If
		
	End If
	
End Sub

Private Sub TabClick(xpnl_tab_background As B4XView,isIntern As Boolean)
	For i = 0 To xpnl_background.NumberOfViews -1
		Dim xiv_icon As B4XView = xpnl_background.GetView(i).GetView(1)
		Dim xTab As ASSegmentedTab_Tab = xpnl_background.GetView(i).Tag
		
		If xpnl_background.GetView(i) = xpnl_tab_background Then
			If (xpnl_tab_background.Left <> xpnl_selector.Left) Or isIntern  Then
				g_index = i
				xpnl_background.GetView(i).GetView(0).TextColor = g_ItemTextProperties.SelectedTextColor
				
				SetIconsWithColor(xiv_icon,xTab,True)
				
				TabChanged(i)
			End If
		Else
			xpnl_background.GetView(i).GetView(0).TextColor = g_ItemTextProperties.TextColor
			SetIconsWithColor(xiv_icon,xTab,False)
			
		End If
	Next
	xpnl_selector.SetLayoutAnimated(250,xpnl_tab_background.Left + g_PaddingSelectionPanel,g_PaddingSelectionPanel,xpnl_tab_background.Width - (g_PaddingSelectionPanel*2),xpnl_tab_background.Height - (g_PaddingSelectionPanel*2))'normal
	UpdateSeperators
'	xpnl_selector.SetLayoutAnimated(250,xpnl_tab_background.Left -10dip,0,xpnl_tab_background.Width,xpnl_tab_background.Height)'bounce
'	Sleep(250/2)
'	xpnl_selector.SetLayoutAnimated(250/2,xpnl_tab_background.Left + 10dip,0,xpnl_tab_background.Width,xpnl_tab_background.Height)'bounce
'	Sleep(250/2)
'	xpnl_selector.SetLayoutAnimated(250/2,xpnl_tab_background.Left,0,xpnl_tab_background.Width,xpnl_tab_background.Height)'bounce
End Sub

Public Sub SelectedIndex(index As Int,Duration As Int)
	g_index = index
	xpnl_selector.SetLayoutAnimated(Duration,mBase.Width/xpnl_background.NumberOfViews * index +g_PaddingSelectionPanel,g_PaddingSelectionPanel,xpnl_selector.Width,xpnl_selector.Height)'normal
	TabClick(xpnl_background.GetView(index),True)
End Sub

Public Sub getBase As B4XView
	Return mBase
End Sub
'the child panel of mBase
Public Sub getBackgroundPanel As B4XView
	Return xpnl_background
End Sub
'gets the selection panel - the panel that highlight the selected tab
Public Sub getSelectionPanel As B4XView
	Return xpnl_selector
End Sub

Public Sub getSize As Int
	Return xpnl_background.NumberOfViews
End Sub

Private Sub TabChanged(Index As Int)
	If xui.SubExists(mCallBack,mEventName & "_TabChanged",1) Then
		CallSub2(mCallBack,mEventName & "_TabChanged",Index)
	End If
End Sub

#Region Functions
'https://www.b4x.com/android/forum/threads/fontawesome-to-bitmap.95155/post-603250
Public Sub FontToBitmap (text As String, IsMaterialIcons As Boolean, FontSize As Float, color As Int) As B4XBitmap
	Dim xui As XUI
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0, 0, 32dip, 32dip)
	Dim cvs1 As B4XCanvas
	cvs1.Initialize(p)
	Dim fnt As B4XFont
	If IsMaterialIcons Then fnt = xui.CreateMaterialIcons(FontSize) Else fnt = xui.CreateFontAwesome(FontSize)
	Dim r As B4XRect = cvs1.MeasureText(text, fnt)
	Dim BaseLine As Int = cvs1.TargetRect.CenterY - r.Height / 2 - r.Top
	cvs1.DrawText(text, cvs1.TargetRect.CenterX, BaseLine, fnt, color, "CENTER")
	Dim b As B4XBitmap = cvs1.CreateBitmap
	cvs1.Release
	Return b
End Sub

Private Sub SetCircleClip (pnl As B4XView,radius As Int)'ignore
#if B4J
Dim jo As JavaObject = pnl
Dim shape As JavaObject
Dim cx As Double = pnl.Width
Dim cy As Double = pnl.Height
shape.InitializeNewInstance("javafx.scene.shape.Rectangle", Array(cx, cy))
If radius > 0 Then
	Dim d As Double = radius
	shape.RunMethod("setArcHeight", Array(d))
	shape.RunMethod("setArcWidth", Array(d))
End If
jo.RunMethod("setClip", Array(shape))
#else if B4A
	Dim jo As JavaObject = pnl
	Try
		jo.RunMethod("setClipToOutline", Array(True))
	Catch
		'Log("Only supported on Android 5 and above")
	End Try'ignore
	pnl.SetColorAndBorder(pnl.Color,0,0,radius)
	#Else If B4I
	Dim NaObj As NativeObject = pnl
	Dim BorderWidth As Float = NaObj.GetField("layer").GetField("borderWidth").AsNumber
	' *** Get border color ***
	Dim noMe As NativeObject = Me
	Dim BorderUIColor As Int = noMe.UIColorToColor (noMe.RunMethod ("borderColor:", Array (pnl)))
	pnl.SetColorAndBorder(pnl.Color,BorderWidth,BorderUIColor,radius)
#end if
End Sub

#If B4A OR B4I
Private Sub TintBmp(img As ImageView, color As Int)
	'If m_ColorIcons = True Then
	#If B4I
	Dim NaObj As NativeObject = Me
	NaObj.RunMethod("BmpColor::",Array(img,NaObj.ColorToUIColor(color)))
	#Else if B4J
	If color = 0 Then
		Dim jiv As JavaObject = img
		jiv.RunMethod("setClip",Array(Null))
		jiv.RunMethod("setEffect", Array(Null))
		Return
	End If
	Dim fx As JFX
	color = fx.Colors.To32Bit(fx.Colors.rgb(GetARGB(color)(1),GetARGB(color)(2),GetARGB(color)(3)))
	Dim monochrome,effect,mode,tint As JavaObject
	monochrome.InitializeNewInstance("javafx.scene.effect.ColorAdjust", Null)
	monochrome.RunMethod("setSaturation", Array(-1.0))
	effect.InitializeNewInstance("javafx.scene.effect.Blend",Array(mode.InitializeStatic("javafx.scene.effect.BlendMode").GetField("SCREEN"),monochrome,tint.InitializeNewInstance("javafx.scene.effect.ColorInput",Array(0.0,0.0,img.PrefWidth,img.PrefHeight,fx.Colors.From32Bit(color)))))
	Dim jiv As JavaObject = img
	Dim imgt As ImageView
	imgt.Initialize("")
	imgt.SetImage(img.GetImage)
	imgt.SetSize(img.PrefWidth,img.PrefHeight)
	jiv.RunMethod("setClip",Array(imgt))
	jiv.RunMethod("setEffect", Array(effect))
	
	#Else If B4A
		Dim jo As JavaObject=img
		jo.RunMethod("setImageBitmap",Array(img.Bitmap))
		'jo.RunMethod("setColorFilter",Array(Colors.Transparent))
		jo.RunMethod("setColorFilter",Array(Colors.rgb(GetARGB(color)(1),GetARGB(color)(2),GetARGB(color)(3))))
	
	#End If
	'End If
	
End Sub
#End If

#If B4J
Sub ChangeColorBasedOnAlphaLevel(bmp As B4XBitmap, NewColor As Int) As B4XBitmap
	'If m_ColorIcons = True Then
		Dim bc As BitmapCreator
		bc.Initialize(bmp.Width, bmp.Height)
		bc.CopyPixelsFromBitmap(bmp)
		Dim a1, a2 As ARGBColor
		bc.ColorToARGB(NewColor, a1)
		For y = 0 To bc.mHeight - 1
			For x = 0 To bc.mWidth - 1
				bc.GetARGB(x, y, a2)
				If a2.a > 0 Then
					a2.r = a1.r
					a2.g = a1.g
					a2.b = a1.b
					bc.SetARGB(x, y, a2)
				End If
			Next
		Next
		Return bc.Bitmap
'	Else
'		Return bmp
'	End If
End Sub
#end If

#If OBJC
- (void)BmpColor: (UIImageView*) theImageView :(UIColor*) Color{
theImageView.image = [theImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
[theImageView setTintColor:Color];
}
#end if

#End Region

#If OBJC
- (UIColor *) borderColor: (UIView *) view { return [[UIColor alloc] initWithCGColor: view.layer.borderColor]; }
#End If

'int ot argb
Private Sub GetARGB(Color As Int) As Int()'ignore
	Private res(4) As Int
	res(0) = Bit.UnsignedShiftRight(Bit.And(Color, 0xff000000), 24)
	res(1) = Bit.UnsignedShiftRight(Bit.And(Color, 0xff0000), 16)
	res(2) = Bit.UnsignedShiftRight(Bit.And(Color, 0xff00), 8)
	res(3) = Bit.And(Color, 0xff)
	Return res
End Sub

Private Sub MeasureTextWidth(Text As String, Font1 As B4XFont) As Int
#If B4A
    Private bmp As Bitmap
    bmp.InitializeMutable(2dip, 2dip)
    Private cvs As Canvas
    cvs.Initialize2(bmp)
    Return cvs.MeasureStringWidth(Text, Font1.ToNativeFont, Font1.Size)
#Else If B4i
	Return Text.MeasureWidth(Font1.ToNativeFont)
#Else If B4J
    Dim jo As JavaObject
    jo.InitializeNewInstance("javafx.scene.text.Text", Array(Text))
    jo.RunMethod("setFont",Array(Font1.ToNativeFont))
    jo.RunMethod("setLineSpacing",Array(0.0))
    jo.RunMethod("setWrappingWidth",Array(0.0))
    Dim Bounds As JavaObject = jo.RunMethod("getLayoutBounds",Null)
    Return Bounds.RunMethod("getWidth",Null)
#End If
End Sub

Public Sub CreateASSegmentedTab_SeperatorProperties (Color As Int, Width As Float, HeightPercentage As Int, CornerRadius As Float) As ASSegmentedTab_SeperatorProperties
	Dim t1 As ASSegmentedTab_SeperatorProperties
	t1.Initialize
	t1.Color = Color
	t1.Width = Width
	t1.HeightPercentage = HeightPercentage
	t1.CornerRadius = CornerRadius
	Return t1
End Sub

Public Sub CreateASSegmentedTab_Tab (Text As String, Icon As B4XBitmap, Value As Object, ItemTextProperties As ASSegmentedTab_ItemTextProperties) As ASSegmentedTab_Tab
	Dim t1 As ASSegmentedTab_Tab
	t1.Initialize
	t1.Text = Text
	t1.Icon = Icon
	t1.Value = Value
	t1.ItemTextProperties = ItemTextProperties
	Return t1
End Sub

Public Sub CreateASSegmentedTab_ItemTextProperties (TextColor As Int, SelectedTextColor As Int, TextFont As B4XFont, TextAlignment_Vertical As String, TextAlignment_Horizontal As String, BackgroundColor As Int) As ASSegmentedTab_ItemTextProperties
	Dim t1 As ASSegmentedTab_ItemTextProperties
	t1.Initialize
	t1.TextColor = TextColor
	t1.SelectedTextColor = SelectedTextColor
	t1.TextFont = TextFont
	t1.TextAlignment_Vertical = TextAlignment_Vertical
	t1.TextAlignment_Horizontal = TextAlignment_Horizontal
	t1.BackgroundColor = BackgroundColor
	Return t1
End Sub