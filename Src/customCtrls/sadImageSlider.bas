B4J=true
Group=Controls
ModulesStructureVersion=1
Type=Class
Version=6
@EndOfDesignText@
'----------------------------------------------------------------------------------------------------------------
 ' ImageSlider v1.2
 ' June-2025, added SwipeUp Event
'
'Original -----------------------------------------------------------------------------------------------------
'ImageSlider v1.11
'https://www.b4x.com/android/forum/threads/b4x-xui-imageslider.87128/#content
#DesignerProperty: Key: AnimationDuration, DisplayName: Animation Duration (ms), FieldType: Int, DefaultValue: 500
#DesignerProperty: Key: CacheSize, DisplayName: Image Cache Size, FieldType: Int, DefaultValue: 5
#DesignerProperty: Key: AnimationType, DisplayName: Animation Type, FieldType: String, DefaultValue: Horizontal, List: Vertical|Horizontal|Fade
#DesignerProperty: Key: ShowIndicators, DisplayName: Show Indicators, FieldType: Boolean, DefaultValue: True
#Event: GetImage (Index As Int) As ResumableSub
#Event: SwipeUp
Sub Class_Globals
	Public tmrShowTimer As Timer = Null
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Private mBase As B4XView
	Private xui As XUI
	Private CurrentPanel, NextPanel As B4XView
	Private panels As List
	Private CurrentIndex As Int 
	Private CachedImages As List
	Public AnimationDuration As Int 'v1.2
	Private CacheSize As Int
	Type ImageSliderImage (bmp As B4XBitmap, index As Int)
	Private TaskIndex As Int = 0 
	Private mNumberOfImages As Int
	Public AnimationType As String
	Public WindowBase As B4XView
	Private MousePressedX  As Float
	Private MousePressedY As Float 'v1.2
	Private ShowIndicators As Boolean
	Private IndicatorsPanel As B4XView
	Private IndicatorsCVS As B4XCanvas
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
	CachedImages.Initialize
End Sub

Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	'Base.As(B4XView).RemoveAllViews
	If Props.IsInitialized = False Then Props.Initialize
	mBase = Base
	WindowBase = xui.CreatePanel("WindowBase")
	mBase.AddView(WindowBase, 0, 0, 0, 0)
	AnimationDuration = Props.GetDefault("AnimationDuration",700)
	CacheSize = Props.GetDefault("CacheSize",3)
	AnimationType = Props.GetDefault("AnimationType","Fade")
  	CurrentPanel = xui.CreatePanel("pnl")
	NextPanel = xui.CreatePanel("pnl")
	ShowIndicators = Props.GetDefault("ShowIndicators", True)
	panels = Array(CurrentPanel, NextPanel)
	WindowBase.AddView(CurrentPanel, 0, 0, 0, 0)
	WindowBase.AddView(NextPanel, 0, 0, 0, 0)
	Dim iv1, iv2 As ImageView
	'Dim iv1, iv2 As lmB4XImageViewX
	iv1.Initialize("")
	iv2.Initialize("")
	CurrentPanel.AddView(iv1, 0, 0, 0, 0)
	NextPanel.AddView(iv2, 0, 0, 0, 0)
	If ShowIndicators Then
		IndicatorsPanel = xui.CreatePanel("")
		WindowBase.AddView(IndicatorsPanel, 0, 0, 2dip, 2dip)
		IndicatorsCVS.Initialize(IndicatorsPanel)
	End If
	Base_Resize(mBase.Width, mBase.Height)
End Sub


Public Sub Base_Resize (Width As Double, Height As Double)
	WindowBase.SetLayoutAnimated(0, 0, 0, Width, Height)
	For Each p As B4XView In panels
		p.SetLayoutAnimated(0, 0, 0, Width, Height)
		p.GetView(0).SetLayoutAnimated(0, 0, 0, Width, Height)
	Next
	CachedImages.Clear 'clear the images cache as the sizes are no longer correct
	If ShowIndicators Then
		IndicatorsPanel.SetLayoutAnimated(0, 0, 0, WindowBase.Width, 50dip)
		IndicatorsCVS.Resize(IndicatorsPanel.Width, IndicatorsPanel.Height)
		DrawIndicators
	End If
End Sub

Private Sub DrawIndicators
	If ShowIndicators = False Then Return
	IndicatorsCVS.ClearRect(IndicatorsCVS.TargetRect)
	Dim clr As Int
	For i = 0 To mNumberOfImages - 1
		If CurrentIndex = i Then clr = 0xFFC80000 Else clr = 0xFF7A7A7A
		IndicatorsCVS.DrawCircle(IndicatorsCVS.TargetRect.CenterX + (-(mNumberOfImages - 1) / 2 + i) * 30dip, 25dip, 3dip, clr, True, 0)
	Next
	IndicatorsCVS.Invalidate
End Sub

Private Sub ShowImage (bmp As B4XBitmap, MovingToNext As Boolean)
	Try
		NextPanel.GetView(0).SetBitmap(bmp)
		NextPanel.GetView(0).SetLayoutAnimated(0, WindowBase.Width / 2 - bmp.Width / 2, _
		WindowBase.Height / 2 - bmp.Height / 2, bmp.Width, bmp.Height)
		NextPanel.Visible = True
		#if debug
		Log(AnimationType)
		#end if
		Select AnimationType
			Case "Vertical"
				Dim top As Int
				If MovingToNext Then top = -NextPanel.Height Else top = NextPanel.Height
				NextPanel.SetLayoutAnimated(0, 0, top, NextPanel.Width, NextPanel.Height)
				NextPanel.SetLayoutAnimated(AnimationDuration, 0, 0, NextPanel.Width, NextPanel.Height)
				CurrentPanel.SetLayoutAnimated(AnimationDuration, 0, -top, CurrentPanel.Width, CurrentPanel.Height)
			Case "Horizontal"
				Dim left As Int
				If MovingToNext Then left = NextPanel.Width Else left = -NextPanel.Width
				NextPanel.SetLayoutAnimated(0, left, 0, NextPanel.Width, NextPanel.Height)
				NextPanel.SetLayoutAnimated(AnimationDuration, 0, 0, NextPanel.Width, NextPanel.Height)
				CurrentPanel.SetLayoutAnimated(AnimationDuration, -left, 0, CurrentPanel.Width, CurrentPanel.Height)
			Case "Fade"
				NextPanel.Visible = False
				NextPanel.SetLayoutAnimated(0, left, 0, NextPanel.Width, NextPanel.Height)
				NextPanel.SetVisibleAnimated(AnimationDuration, True)
				CurrentPanel.SetVisibleAnimated(AnimationDuration, False)
		End Select
		Dim p As B4XView = CurrentPanel
		CurrentPanel = NextPanel
		NextPanel = p
		DrawIndicators
	Catch
		Log(LastException)
	End Try
	
End Sub

Public Sub NextImage
	TaskIndex = TaskIndex + 1
	Dim MyTask As Int = TaskIndex
	CurrentIndex = (CurrentIndex + 1) Mod mNumberOfImages
	Wait For (GetImage(CurrentIndex)) Complete (Result As ImageSliderImage)
	If MyTask <> TaskIndex Or Result.IsInitialized = False Then Return
	ShowImage(Result.bmp, True)
	Sleep(0)
	If CurrentIndex < (mNumberOfImages - 1) Then GetImage(CurrentIndex + 1)
End Sub

Public Sub PrevImage
	TaskIndex = TaskIndex + 1
	Dim MyTask As Int = TaskIndex
	CurrentIndex = (CurrentIndex - 1 + mNumberOfImages) Mod mNumberOfImages
	Wait For (GetImage(CurrentIndex)) Complete (Result As ImageSliderImage)
	If MyTask <> TaskIndex Or Result.IsInitialized = False Then Return
	ShowImage(Result.bmp, False)
	Sleep(0)
	If CurrentIndex > 0 Then GetImage(CurrentIndex - 1)
End Sub

Private Sub GetImage(index As Int) As ResumableSub
	For Each ii As ImageSliderImage In CachedImages
		If ii.index = index Then
			CachedImages.RemoveAt(CachedImages.IndexOf(ii))
			CachedImages.Add(ii)
			Return ii
		End If
	Next
	Dim rs As ResumableSub = CallSub2(mCallBack, mEventName & "_GetImage", index)
	Dim ii As ImageSliderImage
	If rs.IsInitialized = False Then Return ii
	Wait For (rs) Complete (bmp As B4XBitmap)
	ii.Initialize
	ii.bmp = bmp
	ii.index = index
	CachedImages.Add(ii)
	Do While CachedImages.Size > CacheSize
		CachedImages.RemoveAt(0)
	Loop
	Return ii
End Sub

Private Sub WindowBase_Touch (Action As Int, X As Float, Y As Float)
	If Action = WindowBase.TOUCH_ACTION_DOWN Then
		MousePressedX = X
		MousePressedY = Y 'v1.2
	Else If Action = WindowBase.TOUCH_ACTION_UP Then
		If X > MousePressedX + 50dip Then
			If tmrShowTimer <> Null Then tmrShowTimer.Enabled = False	'v1.2
			PrevImage
			If tmrShowTimer <> Null Then tmrShowTimer.Enabled = True 'v1.2
		Else if X < MousePressedX - 50dip Then
			If tmrShowTimer <> Null Then tmrShowTimer.Enabled = False 'v1.2
			NextImage
			If tmrShowTimer <> Null Then tmrShowTimer.Enabled = True 'v1.2
		Else If Y < MousePressedY - 60dip Then 'v1.2
			Swipe_up
		End If
	End If
End Sub

Private Sub Swipe_up 'v1.2
	If SubExists(mCallBack, mEventName & "_SwipeUp") Then
		CallSub(mCallBack, mEventName & "_SwipeUp")
	End If
End Sub


Public Sub getNumberOfImages As Int
	Return mNumberOfImages
End Sub

Public Sub setNumberOfImages (i As Int)
	mNumberOfImages = i
	DrawIndicators
End Sub


